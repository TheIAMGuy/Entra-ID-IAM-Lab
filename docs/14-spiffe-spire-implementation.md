---
title: SPIFFE and SPIRE - Secure Workload Identity at Scale
part: 6
section: Cloud-Native Workload Identity
difficulty: Advanced
estimated_reading_time: 40
estimated_lab_time: 60
prerequisites:
  - 11a-workload-identity.md
  - 14-spiffe-spire-implementation.md
learning_objectives:
  - Understand SPIFFE standard and SPIRE implementation
  - Design SPIFFE-based identity infrastructure
  - Implement workload identity federation
  - Configure SPIFFE for Kubernetes and containerized workloads
  - Manage SPIFFE certificate lifecycle
---

# SPIFFE and SPIRE: Secure Workload Identity at Scale

## Introduction

SPIFFE (Secure Production Identity Framework For Everyone) is a standard for authenticating software workloads at scale. SPIRE (SPIFFE Runtime Environment) is an open-source implementation. Instead of hardcoded API keys, workloads receive short-lived identity certificates from SPIRE. A microservice proves its identity with a certificate, another service verifies the certificate, and access is granted. This document explains SPIFFE concepts, SPIRE implementation, and multi-cloud workload federation.

**Learning Objectives:**
- Understand SPIFFE and SPIRE concepts
- Design SPIFFE identity infrastructure
- Implement SPIRE in Kubernetes
- Configure workload federation
- Manage certificate issuance and rotation

## SPIFFE Concepts

### SPIFFE Identity (SVID)

**SPIFFE Verifiable Identity Document (SVID):**

```
spiffe://company.com/payment-service
```

**Components:**
- Scheme: `spiffe://` (identifies SPIFFE URI)
- Trust Domain: `company.com` (organization/deployment)
- Workload Path: `/payment-service` (microservice identity)

**SVID formats:**
1. **X.509 Certificate SVID** - TLS certificate proving identity
2. **JWT SVID** - Signed token for API calls

### Trust Domain

**Trust Domain:** Uniquely identifies an administrative domain

```
Examples:
  - spiffe://company.com (company's infrastructure)
  - spiffe://aws.company.com (AWS account)
  - spiffe://gcp.company.com (GCP project)
  - spiffe://on-prem.company.com (on-premises infrastructure)
```

**Cross-Trust-Domain Federation:** Multiple trust domains trust each other

```
company.com ←→ partner.com (federates)
microservice@company.com ← authenticates → database@partner.com
```

## SPIRE Architecture

### Core Components

```
SPIRE Server (central authority)
  ├─ Agent (workload node, multiple per cluster)
  │  └─ Workload API (local, /tmp/spire-agent/api.sock)
  │     └─ Workload (container/pod, requests SVID)
  └─ Registration API (registers workloads)
```

**Data flow:**
1. Workload starts, needs identity
2. Workload contacts Agent via Workload API
3. Agent verifies workload identity (container image, PID, network namespace, labels)
4. Agent requests SVID from Server
5. Server issues certificate (X.509 SVID)
6. Agent returns certificate to workload
7. Workload uses certificate for service-to-service authentication

### Registration

**Register workload (associate workload with identity):**

```bash
spire-server entry create \
  --spiffeID spiffe://company.com/payment-service \
  --parentID spiffe://company.com/sa/agent \
  --selector k8s:ns:default \
  --selector k8s:pod-name:payment-* \
  --ttl 3600
```

**Selectors match workloads:**
- `k8s:ns:default` - Kubernetes namespace is "default"
- `k8s:pod-name:payment-*` - Pod name starts with "payment-"
- `k8s:sa:default` - Kubernetes service account is "default"

## SPIRE Implementation in Kubernetes

### Step 1: Install SPIRE Helm Chart

```bash
helm repo add spiffe https://spiffe.io/spire-helm-charts/
helm install spire spiffe/spire \
  --namespace spire-system \
  --create-namespace \
  --set trustDomain=company.com
```

### Step 2: Configure Server

**Create ServerConfig:**

```yaml
apiVersion: spire.spiffe.io/v1beta1
kind: SpireServer
metadata:
  name: spire-server
  namespace: spire-system
spec:
  trustDomain: company.com
  controlPlaneAuth: true
  dataStore:
    type: sql
    connectionString: "postgresql://localhost/spire"
  ca:
    type: memory
```

### Step 3: Register Workloads

**Register payment service:**

```bash
spire-server entry create \
  --spiffeID spiffe://company.com/payment-service \
  --parentID spiffe://company.com/sa/spire-agent \
  --selector k8s:ns:payment \
  --selector k8s:pod-name:payment-service-* \
  --selector k8s:sa:payment-service \
  --ttl 3600
```

**Register inventory service:**

```bash
spire-server entry create \
  --spiffeID spiffe://company.com/inventory-service \
  --parentID spiffe://company.com/sa/spire-agent \
  --selector k8s:ns:inventory \
  --selector k8s:pod-name:inventory-* \
  --selector k8s:sa:inventory-service \
  --ttl 3600
```

### Step 4: Application Integration

**Node.js example using SPIRE:**

```javascript
const grpc = require('@grpc/grpc-js');
const fs = require('fs');

// SPIRE Agent socket path
const AGENT_SOCKET = '/tmp/spire-agent/api.sock';

// Connect to SPIRE Agent
const client = new grpc.Client(
  `unix://${AGENT_SOCKET}`,
  grpc.credentials.createInsecure()
);

// Get X.509 SVID (certificate)
async function getSVID() {
  const request = {
    spiffe_id: 'spiffe://company.com/payment-service'
  };
  
  const response = await client.fetchX509SVID(request);
  
  return {
    cert: response.svids[0].x509_svid,
    key: response.svids[0].x509_svid_key,
    trustBundle: response.svids[0].bundle
  };
}

// Create TLS server with SVID
async function startServer() {
  const svid = await getSVID();
  
  const server = grpc.createServer({
    key: svid.key,
    cert: svid.cert
  });
  
  server.listen('0.0.0.0:5050');
  console.log('Server running with SPIFFE identity');
}

startServer();
```

**Python example:**

```python
import grpc
from pyspiffe import WorkloadApiClient

# Get X.509 SVID from SPIRE Agent
async def get_svid():
    async with WorkloadApiClient() as client:
        svid = await client.fetch_x509_svid()
        return svid

# Create TLS credentials
async def create_grpc_server():
    svid = await get_svid()
    
    credentials = grpc.ssl_channel_credentials(
        root_certificates=svid.trust_bundle,
        certificate_chain=svid.x509_svid,
        private_key=svid.x509_svid_key
    )
    
    server = grpc.server(
        futures.ThreadPoolExecutor(max_workers=10),
        options=[
            ('grpc.ssl_target_name_override', 'inventory-service')
        ]
    )
    
    return server
```

## Multi-Cloud SPIFFE Federation

### Scenario: AWS to GCP Workload Communication

**Architecture:**

```
AWS Trust Domain: spiffe://aws.company.com
  └─ Payment Service: spiffe://aws.company.com/payment

GCP Trust Domain: spiffe://gcp.company.com
  └─ Inventory Service: spiffe://gcp.company.com/inventory

Federation: aws.company.com ←→ gcp.company.com
  Payment Service in AWS can authenticate to Inventory Service in GCP
```

### Federation Setup

**Step 1: Configure Federation in AWS Server**

```bash
spire-server federation add \
  --federateTrustDomain gcp.company.com \
  --endpointAddress 10.1.2.3:8081  # GCP SPIRE Server endpoint
  --bundleEndpointProfile https_spiffe
```

**Step 2: Configure Federation in GCP Server**

```bash
spire-server federation add \
  --federateTrustDomain aws.company.com \
  --endpointAddress 10.0.1.2:8081  # AWS SPIRE Server endpoint
  --bundleEndpointProfile https_spiffe
```

**Step 3: Register Cross-Cloud Workload**

**In AWS:**
```bash
spire-server entry create \
  --spiffeID spiffe://aws.company.com/payment \
  --parentID spiffe://aws.company.com/sa/agent \
  --selector aws:ec2:instance-id:i-1234567890 \
  --federatesWith gcp.company.com
```

**Step 4: Cross-Cloud Communication**

**Payment service (AWS) calling Inventory (GCP):**

```javascript
// Payment service gets its SVID (AWS trust domain)
const paymentSVID = await getSVID('spiffe://aws.company.com/payment');

// Create TLS connection to Inventory (GCP)
// verifyPeer with trust bundle from GCP federation
const credentials = grpc.credentials.createSsl(
  fs.readFileSync('/var/run/spire/bundle.crt'), // GCP trust bundle
  paymentSVID.key,
  paymentSVID.cert
);

const inventoryStub = new InventoryService(
  'inventory-service.gcp.company.com:50051',
  credentials
);

// Call with mTLS using federated identities
const result = await inventoryStub.checkInventory({
  product_id: '12345'
});
```

## SPIFFE Certificate Lifecycle

### Issuance

**Workflow:**
1. Workload requests SVID from Agent (every hour)
2. Agent validates workload (container image, labels, PID)
3. Agent requests new SVID from Server
4. Server verifies Agent identity
5. Server generates X.509 certificate
6. Agent caches certificate
7. Workload uses certificate

### Rotation

**Automatic rotation (default 1 hour TTL):**

```
Hour 0: SVID issued (expires hour 1)
Hour 0:50: Workload requests new SVID (50 minutes before expiry)
Hour 0:50: New SVID issued (expires hour 1:50)
Hour 1: Old SVID expires, workload using new one
```

### Renewal on Expiry

**Graceful handling:**

```
If workload hasn't renewed by expiry:
1. Agent detects expiry
2. Agent requests emergency renewal
3. Server issues new SVID
4. Workload continues with new certificate

This prevents service interruption during high load
```

## Troubleshooting SPIFFE/SPIRE

| Issue | Cause | Solution |
|-------|-------|----------|
| **Workload can't contact Agent** | Agent socket not mounted | Verify `/tmp/spire-agent/api.sock` mounted in container |
| **Authentication fails** | Selectors don't match workload | Verify selectors with `spire-agent diagnostic` |
| **Certificates keep expiring** | Workload not renewing in time | Increase renewal frequency, check Agent health |
| **Federation not working** | Trust bundles not synced | Verify federation endpoint reachable, bundle exchange |
| **High cert issuance latency** | Server overloaded | Scale SPIRE Server, use caching agent |

## SPIFFE/SPIRE Best Practices

1. **Unique Identities** - Each service gets distinct SPIFFE ID
2. **Automatic Rotation** - Let SPIRE rotate certificates automatically
3. **Verification** - Always verify peer SPIFFE ID before trusting connection
4. **Audit** - Log all SVID issuance and verification
5. **Backup Keys** - Protect Server's private key with HSM if possible
6. **Monitoring** - Alert on certificate near-expiry, verification failures
7. **Federation Early** - Plan federation before multi-cloud deployment
8. **No Hard-Coded Secrets** - Replace API keys with SPIFFE identities

## SPIFFE vs. Alternatives

| Approach | Identity | Rotation | Verification | Complexity |
|----------|----------|----------|--------------|-----------|
| **SPIFFE/SPIRE** | X.509 cert | Automatic | mTLS | Medium |
| **Hardcoded API Keys** | Secret | Manual | Token validation | Low |
| **Service Mesh (Istio)** | mTLS | Auto | Automatic | High |
| **Cloud IAM (AWS/GCP)** | Cloud-specific | Auto | Service-specific | Medium |
| **Managed Identities (Azure)** | Azure-specific | Auto | Azure-specific | Low |

## Related Documents

**Prerequisites:**
- [Workload Identity](./11a-workload-identity.md) - Workload identity concepts
- [Machine Identity Management](./11b-machine-identity-management.md) - Certificate-based identity

**Next Steps:**
- [Service Mesh Identity](./14a-service-mesh-identity.md) - Istio/Linkerd with SPIFFE
- [Container Workload Identity](./14b-container-workload-identity.md) - Kubernetes-specific patterns

## FAQ

**Q: When should we use SPIFFE vs. Managed Identities?**

A: SPIFFE for multi-cloud/on-premises. Managed Identities for single-cloud (Azure/AWS/GCP only).

**Q: Can SPIFFE work outside Kubernetes?**

A: Yes. SPIRE works in VMs, bare metal, any infrastructure. Just need SPIRE Agent deployed.

**Q: What's the certificate expiration impact?**

A: With automatic rotation, zero impact. Workloads refresh hourly before expiry.

**Q: How does SPIFFE handle multi-region?**

A: Each region gets SPIRE Server, servers federate. Workloads in each region authenticate locally.

## Next Steps

1. Evaluate SPIFFE/SPIRE for workload identity needs
2. Design SPIFFE trust domain structure
3. Deploy SPIRE in Kubernetes cluster
4. Register initial workloads
5. Integrate applications with WorkloadAPI
6. Test certificate lifecycle and rotation
7. Plan multi-cloud federation if needed

SPIFFE brings zero-trust workload identity to scale. Start with single trust domain, expand to federation.
