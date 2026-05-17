---
title: Service Mesh Identity - Istio and Linkerd mTLS
part: 6
section: Cloud-Native Workload Identity
difficulty: Advanced
estimated_reading_time: 35
estimated_lab_time: 45
prerequisites:
  - 14-spiffe-spire-implementation.md
learning_objectives:
  - Understand service mesh identity concepts
  - Implement mTLS in Istio and Linkerd
  - Configure automated certificate management
  - Enable zero-trust networking in Kubernetes
  - Monitor and troubleshoot service mesh identity
---

# Service Mesh Identity: Istio and Linkerd mTLS

## Introduction

Service meshes (Istio, Linkerd) automatically encrypt communication between microservices using mutual TLS (mTLS) with automatically managed certificates. Instead of applications managing TLS, the mesh handles it: issuing certificates to workloads, rotating them, verifying peer identities. This document explains service mesh identity, mTLS implementation, and zero-trust networking.

**Learning Objectives:**
- Understand service mesh identity concepts
- Implement mTLS in Istio and Linkerd
- Configure PeerAuthentication policies
- Establish zero-trust service-to-service communication
- Monitor identity and certificate operations

## Service Mesh Identity Fundamentals

### What the Mesh Does

**Before Service Mesh:**
```
Service A → (plaintext) → Service B
  Problem: No encryption, no verification, no identity proof
```

**With Service Mesh (mTLS enabled):**
```
Service A → Envoy Sidecar A
  ↓ (mTLS with certificate)
Envoy Sidecar B → Service B
  - A and B authenticate each other
  - Communication encrypted
  - Certificate rotated automatically
  - Identity enforced via policy
```

### Identity in Service Mesh

**Workload Identity = Service Account + Pod**

```
Service Account: payment-service
Pod: payment-service-abc123xyz
Namespace: payment

SPIFFE ID: spiffe://cluster.local/ns/payment/sa/payment-service
Certificate Common Name: payment-service.payment.svc.cluster.local
```

## Istio Service Mesh Identity

### Istio Identity Model

**Istio uses SPIFFE identities automatically:**

```
Every pod gets:
  - SPIFFE ID: spiffe://cluster.local/ns/{namespace}/sa/{serviceaccount}
  - X.509 certificate (SVID)
  - mTLS enabled by default
```

### Enable mTLS Globally

**Create PeerAuthentication policy (enforce mTLS everywhere):**

```yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: istio-system
spec:
  mtls:
    mode: STRICT  # Require mTLS from all clients
```

**Modes:**
- `STRICT` - Require mTLS (reject plaintext)
- `PERMISSIVE` - Accept both mTLS and plaintext (transition mode)
- `DISABLE` - No mTLS

### PeerAuthentication Examples

**Enforce mTLS for entire namespace:**

```yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: payment-mtls
  namespace: payment
spec:
  mtls:
    mode: STRICT
```

**Enforce mTLS per workload:**

```yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: payment-service-mtls
  namespace: payment
spec:
  mtls:
    mode: STRICT
  selector:
    matchLabels:
      app: payment-service
```

### Istio Certificate Management

**Automatic Certificate Issuance:**
```
1. Pod starts
2. Istio Agent (in sidecar) requests certificate from Istio CA
3. Istio CA verifies pod identity (Kubernetes service account)
4. CA issues X.509 certificate (1-hour TTL)
5. Pod uses certificate for mTLS
6. Certificate auto-rotated before expiry
```

**Certificate Rotation Flow:**
```
Hour 0: Certificate issued (expires 1:00)
Hour 0:50: Istio Agent requests new cert
Hour 0:50: New cert issued (expires 1:50)
Hour 1: Old cert expires, pod using new cert
Hour 1:50: Cycle repeats
```

### Verify mTLS Status

**Check if mTLS enabled:**

```bash
# Get PeerAuthentication policies
kubectl get peerauthentication -A

# Check pod has certificate
kubectl exec -it {pod} -c istio-proxy -- \
  ls -la /etc/istio/certs/

# Verify certificate details
kubectl exec -it {pod} -c istio-proxy -- \
  openssl x509 -in /etc/istio/certs/cert-chain.pem -text
```

**Check Envoy configuration:**

```bash
# Access Envoy admin interface
kubectl port-forward {pod} 15000:15000

# Check active mTLS connections
curl localhost:15000/clusters | grep ssl
```

## Linkerd Service Mesh Identity

### Linkerd Identity Model

**Linkerd uses SPIFFE-compatible identities:**

```
Service Account: inventory-service
Namespace: inventory
Trust Domain: linkerd.io

Identity: inventory-service.inventory.linkerd.svc.cluster.local
```

### Enable mTLS in Linkerd

**Install with automatic mTLS (enabled by default):**

```bash
linkerd install | kubectl apply -f -
```

**Verify mTLS enabled:**

```bash
linkerd check
```

**Monitor mTLS traffic:**

```bash
linkerd viz install | kubectl apply -f -
linkerd viz dashboard  # View mTLS status in dashboard
```

### Linkerd Policy Enforcement

**Create authorization policy (who can call what):**

```yaml
apiVersion: policy.linkerd.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: payment-authorize
  namespace: payment
spec:
  targetRef:
    group: core
    kind: Service
    name: payment-service
  rules:
  - from:
    - principalName: inventory-service.inventory.linkerd.svc.cluster.local
    to:
    - httpRoute:
      - method: POST
        path: /pay
```

## Zero-Trust Service-to-Service

### Zero-Trust Principles (Service Mesh)

**Assume Breach:** Never trust by default
```
Every service request requires:
  1. Service identity (SPIFFE certificate)
  2. Encrypted connection (mTLS)
  3. Policy check (AuthorizationPolicy)
```

### Implementing Zero-Trust

**Step 1: Enable mTLS Globally**

```yaml
# Istio
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: istio-system
spec:
  mtls:
    mode: STRICT
```

**Step 2: Deny All by Default**

```yaml
# Istio AuthorizationPolicy
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: deny-all
  namespace: istio-system
spec: {}  # Empty spec = deny all
---
# Allow specific paths
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: allow-payment
  namespace: payment
spec:
  rules:
  - from:
    - source:
        principals:
        - cluster.local/ns/inventory/sa/inventory-service
    to:
    - operation:
        methods: [POST]
        paths: ["/pay*"]
```

**Step 3: Verify Only Expected Traffic Flows**

```bash
# Monitor denied connections
kubectl logs -n istio-system -l app=istiod | grep denied

# Check metrics
kubectl logs {pod} -c istio-proxy | grep upstream_rq_denied
```

## Certificate Troubleshooting

| Issue | Diagnosis | Solution |
|-------|-----------|----------|
| **mTLS not working** | `curl` fails with SSL error | Check PeerAuthentication mode (STRICT vs PERMISSIVE) |
| **Certificate expired** | Service errors | Check CA certificate, restart istiod |
| **High latency with mTLS** | Certificate rotation overhead | Increase certificate TTL if acceptable |
| **Certificate verification fails** | Trust bundle mismatch | Verify Istio CA root certificate |
| **Cannot call plaintext service** | Service not in mesh | Either enable service, or allow PERMISSIVE mode |

## Monitoring Service Mesh Identity

**Prometheus metrics (Istio):**
```
# Certificate issuance rate
rate(citadel_secret_controller_secret_generation_duration_seconds_count[1m])

# mTLS connection rate
envoy_listener_ssl_socket_factory[downstream_tls_from_downstream_peername]
```

**Dashboards:**
```
Grafana → Istio Workload Dashboard
  - mTLS traffic percentage
  - Certificate lifetime remaining
  - Connection errors
  - Authentication failures
```

## Best Practices

1. **Enforce mTLS** - Set `mode: STRICT` globally after testing
2. **Automatic Rotation** - Let mesh handle certificate rotation
3. **Authorization Policies** - Define explicit allow policies
4. **Mutual TLS** - Both client and server authenticate
5. **Monitor Certificates** - Alert on near-expiry, rotation failures
6. **Test in Permissive** - Use `PERMISSIVE` during rollout, switch to `STRICT` when ready
7. **Exclude External Services** - Configure mesh to allow plaintext to external APIs if needed
8. **Use Service Accounts** - Ensure each workload has distinct service account

## Related Documents

**Prerequisites:**
- [SPIFFE/SPIRE](./14-spiffe-spire-implementation.md) - Identity standard
- [Container Workload Identity](./14b-container-workload-identity.md) - Kubernetes identity patterns

**Next Steps:**
- [Secrets Management](./15b-secrets-management.md) - Certificate storage and rotation
- [Identity Governance](./17a-identity-governance-administration.md) - Policy compliance

## FAQ

**Q: Do we need to change application code for mTLS?**

A: No. Service mesh handles it transparently. Applications don't know about TLS.

**Q: What's the performance impact of mTLS?**

A: Minimal. Encryption done in Envoy sidecar (native code), typically <1% CPU overhead.

**Q: Can we use service mesh without external PKI?**

A: Yes. Istio has built-in CA (istiod). For external PKI, use Vault integration.

**Q: How do we roll out service mesh gradually?**

A: Start with `PERMISSIVE` mode, monitor, then switch to `STRICT`.

## Next Steps

1. Deploy service mesh (Istio or Linkerd)
2. Enable mTLS globally
3. Create authorization policies
4. Test with PERMISSIVE mode
5. Switch to STRICT after validation
6. Monitor metrics and logs
7. Plan certificate rotation strategy

Service mesh enables zero-trust networking at scale with minimal application changes.
