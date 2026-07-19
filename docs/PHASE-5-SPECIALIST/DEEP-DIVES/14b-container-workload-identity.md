---
title: Container Workload Identity - Docker, Kubernetes, and Container Registries
part: 6
section: Cloud-Native Workload Identity
difficulty: Intermediate
estimated_reading_time: 30
estimated_lab_time: 45
prerequisites:
  - 11a-workload-identity.md
  - 14-spiffe-spire-implementation.md
learning_objectives:
  - Understand container identity concepts
  - Implement workload identity in Kubernetes
  - Secure container registry access
  - Configure pod-to-external service authentication
  - Manage container secrets securely
---

# Container Workload Identity: Docker, Kubernetes, and Container Registries

## Introduction

Containers are ephemeral: created, run briefly, destroyed. Traditional identity management assumes static servers. Container workload identity assigns temporary identities to containers as they start, revokes them as they stop. A payment pod authenticates to the database with a certificate valid only while the pod runs. This document explains container identity patterns, Kubernetes service accounts, and pod-to-service authentication.

**Learning Objectives:**
- Understand container identity concepts
- Implement Kubernetes service accounts
- Configure pod authentication to services
- Secure container registry access
- Manage ephemeral identities at scale

## Container Identity Concepts

### Static vs. Ephemeral Identity

**Static (Traditional VMs):**
```
Server: payment-server-01
Identity: stable IP, hostname, service principal
Lifetime: Years
Credentials: Managed manually
```

**Ephemeral (Containers):**
```
Pod: payment-service-abc123xyz (created dynamically)
Identity: Service account + pod name
Lifetime: Minutes to hours
Credentials: Auto-issued, auto-rotated
```

### Container Identity Sources

**1. Kubernetes Service Account**
- Each pod has service account
- Service account has identity
- Pod inherits identity from service account
- Example: `spiffe://cluster.local/ns/default/sa/payment-service`

**2. Container Image Identity**
- Container image hash identifies workload
- Can verify image hasn't been tampered
- Used in attestation policies

**3. Runtime Identity**
- Pod UID in node
- Container ID
- Network namespace
- Process ID

## Kubernetes Service Accounts

### Service Account Basics

**Default service account:**

```yaml
# Every namespace gets default service account
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
  namespace: default
```

**Create custom service account:**

```bash
kubectl create serviceaccount payment-service -n payment
```

**Assign service account to pod:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: payment-pod
  namespace: payment
spec:
  serviceAccountName: payment-service
  containers:
  - name: payment
    image: payment:latest
```

### Service Account Token

**Kubernetes automatically mounts token in pod:**

```
/var/run/secrets/kubernetes.io/serviceaccount/token
/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
/var/run/secrets/kubernetes.io/serviceaccount/namespace
```

**Token usage (pod authenticates to Kubernetes API):**

```bash
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
curl -H "Authorization: Bearer $TOKEN" \
  https://kubernetes.default.svc.cluster.local/api/v1/namespaces/payment/pods
```

## Pod Authentication Patterns

### Pattern 1: Pod to Kubernetes API

**Scenario:** Payment pod reads payment configs from Kubernetes ConfigMap

```yaml
# RBAC role
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: payment-reader
  namespace: payment
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get", "list"]
---
# Role binding
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: payment-reader-binding
  namespace: payment
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: payment-reader
subjects:
- kind: ServiceAccount
  name: payment-service
  namespace: payment
```

**Pod code (Python):**

```python
from kubernetes import client, config, watch

# Load in-cluster config (uses service account token)
config.load_incluster_config()

# Authenticate to Kubernetes API with pod's service account
v1 = client.CoreV1Api()

# List configmaps (allowed by RBAC)
configmaps = v1.list_namespaced_config_map(namespace='payment')
for cm in configmaps.items:
    print(f"ConfigMap: {cm.metadata.name}")
```

### Pattern 2: Pod to External Service (Azure Database)

**Scenario:** Payment pod connects to Azure SQL Database

**Using Azure Workload Identity (if on AKS):**

```yaml
# 1. Create Azure Managed Identity in Azure
# az identity create --resource-group myRG --name payment-identity

# 2. Grant identity permission to database
# az role assignment create --assignee-principal-id <id> --role "Azure SQL Database Contributor"

# 3. In Kubernetes, annotate service account
apiVersion: v1
kind: ServiceAccount
metadata:
  name: payment-service
  namespace: payment
  annotations:
    azure.workload.identity/client-id: "payment-identity-client-id"
---
# 4. Pod uses managed identity (no secrets)
apiVersion: v1
kind: Pod
metadata:
  name: payment-pod
  namespace: payment
  labels:
    azure.workload.identity/use: "true"
spec:
  serviceAccountName: payment-service
  containers:
  - name: payment
    image: payment:latest
```

**Pod code (C#):**

```csharp
// Use DefaultAzureCredential (automatically uses workload identity)
var credential = new DefaultAzureCredential();

// Connect to database with managed identity
var connectionString = "Server=myserver.database.windows.net;Database=paymentdb;";
using (var connection = new SqlConnection(connectionString))
{
    // Token obtained automatically via workload identity
    var token = credential.GetTokenAsync(
        new TokenRequestContext(new[] { "https://database.windows.net/.default" })
    ).Result;
    
    connection.AccessToken = token.Token;
    connection.Open();
    // Execute queries
}
```

### Pattern 3: Pod to Private Container Registry

**Scenario:** Kubelet pulls container image from private registry

**Create image pull secret:**

```bash
kubectl create secret docker-registry regcred \
  --docker-server=myregistry.azurecr.io \
  --docker-username=username \
  --docker-password=password \
  -n payment
```

**Use in pod spec:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: payment-pod
  namespace: payment
spec:
  containers:
  - name: payment
    image: myregistry.azurecr.io/payment:v1.0
  imagePullSecrets:
  - name: regcred
```

**Better: Use workload identity for registry (no secret):**

```yaml
# Configure service account to pull from registry
apiVersion: v1
kind: ServiceAccount
metadata:
  name: payment-service
  namespace: payment
imagePullSecrets:
- name: registry-identity  # Managed by cluster
```

## Container Image Identity

### Image Hash as Identity

**Every container image has SHA256 hash:**

```
Image: payment:v1.0
Hash: sha256:abc123def456ghi789jkl012mno345

Identity: payment@sha256:abc123def456ghi789jkl012mno345
```

**Policy: Only allow pods from specific image hash**

```yaml
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sAllowedRepos
metadata:
  name: allowed-images
spec:
  parameters:
    repos:
    - "myregistry.azurecr.io/payment@sha256:abc123def456ghi789jkl012mno345"
    - "myregistry.azurecr.io/inventory@sha256:xyz789abc123def456ghi789jkl012"
```

**Binary authorization (verify image not tampered):**

```yaml
apiVersion: binaryauthorization.grafeas.io/v1beta1
kind: Policy
metadata:
  name: bin-authz-policy
spec:
  globalPolicyEvaluationMode: ENABLE
  defaultAdmissionRule:
    requireAttestationsBy:
    - projects/my-project/attestors/prod-attestor
    evaluationMode: REQUIRE_ATTESTATION
```

## Pod-to-Pod Communication

### Using SPIFFE/SPIRE

**Already covered in 14-spiffe-spire-implementation.md:**

```
Pod A (payment-service):
  SPIFFE ID: spiffe://cluster.local/ns/payment/sa/payment-service
  
Pod B (inventory-service):
  SPIFFE ID: spiffe://cluster.local/ns/inventory/sa/inventory-service

Communication:
  Pod A → mTLS cert proving identity → Pod B
  Pod B verifies Pod A's SPIFFE ID → Access granted
```

### Using Service Mesh (Istio/Linkerd)

**Already covered in 14a-service-mesh-identity.md:**

```
Service mesh handles:
  - Identity issuance (certificates)
  - Encryption (mTLS)
  - Verification (identity checks)
  - Authorization policies
```

## Ephemeral Identity Management

### Certificate Rotation

**Pod lifecycle with auto-rotating identity:**

```
Pod Created:
  1. Kubelet starts pod
  2. Service account token mounted
  3. SPIRE Agent or Service Mesh issues certificate
  4. Certificate valid 1 hour

Pod Running:
  50 minutes: Auto-request new certificate
  60 minutes: Old cert expires, new cert active
  70 minutes: Request another cert
  (cycle repeats)

Pod Deleted:
  1. Pod terminated
  2. All its certificates revoked
  3. No residual access
```

### Secret Cleanup

**When pod deleted, clean up secrets:**

```
Pod Lifecycle:
  Created: Mount secret
  Running: Pod uses secret
  Deleted: Secret unmounted, memory zeroed, file deleted
```

**In-memory secret handling:**

```bash
# Mount secret as tmpfs (in-memory, wiped on pod delete)
apiVersion: v1
kind: Pod
metadata:
  name: payment-pod
spec:
  containers:
  - name: payment
    image: payment:latest
    volumeMounts:
    - name: secret-volume
      mountPath: /var/run/secrets/my-app
      readOnly: true
  volumes:
  - name: secret-volume
    secret:
      secretName: payment-secret
      defaultMode: 0600
```

## Hands-On Lab: Pod Authentication

**Estimated Time:** 45 minutes

**Prerequisites:** Kubernetes cluster (minikube, kind, or cloud)

**Lab Objectives:**
- Create service account
- Deploy pod with identity
- Authenticate to Kubernetes API
- Access secret from pod

### Step 1: Create Service Account (5 min)

```bash
kubectl create namespace payment
kubectl create serviceaccount payment-app -n payment
```

### Step 2: Create RBAC Role (10 min)

```bash
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: payment-reader
  namespace: payment
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get"]
EOF

kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: payment-reader-binding
  namespace: payment
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: payment-reader
subjects:
- kind: ServiceAccount
  name: payment-app
  namespace: payment
EOF
```

### Step 3: Create Secret (5 min)

```bash
kubectl create secret generic payment-secret \
  --from-literal=db-password='secret123' \
  -n payment
```

### Step 4: Deploy Pod (10 min)

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: payment-test
  namespace: payment
spec:
  serviceAccountName: payment-app
  containers:
  - name: app
    image: curlimages/curl
    command: ["/bin/sleep", "3600"]
EOF
```

### Step 5: Test Pod Authentication (15 min)

```bash
# Enter pod
kubectl exec -it payment-test -n payment sh

# From inside pod
# Get secret using service account
curl -s -H "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
  https://kubernetes.default.svc.cluster.local/api/v1/namespaces/payment/secrets/payment-secret \
  --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt | jq

# Try unauthorized access (should fail)
curl -s https://kubernetes.default.svc.cluster.local/api/v1/namespaces/payment/pods \
  --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt | jq
```

## Best Practices

1. **Use Service Accounts** - One per application/component
2. **Least Privilege RBAC** - Grant minimum needed permissions
3. **Mount Secrets Read-Only** - Prevent accidental modification
4. **Use tmpfs for Secrets** - Secrets never written to disk
5. **Rotate Certificates** - Let system handle rotation automatically
6. **Monitor Pod Identity** - Audit service account usage
7. **Clean Up Unused Identities** - Delete unused service accounts
8. **Use Workload Identity** - On cloud platforms (Azure/AWS/GCP)

## Related Documents

**Prerequisites:**
- [Workload Identity](./11a-workload-identity.md) - Non-human entity authentication
- [SPIFFE/SPIRE](./14-spiffe-spire-implementation.md) - Workload identity standard

**Next Steps:**
- [Service Mesh Identity](./14a-service-mesh-identity.md) - mTLS in Kubernetes
- [Secrets Management](./15b-secrets-management.md) - Secret lifecycle

## FAQ

**Q: Is service account token always safe?**

A: Token is cryptographically signed by Kubernetes API. Safe when stored securely.

**Q: Can pod authenticate to external services?**

A: Yes. Use workload identity (cloud platforms) or SPIFFE/service mesh.

**Q: What happens to pod credentials when pod is deleted?**

A: Immediately revoked by Kubernetes. No residual access.

**Q: How do we prevent service account token theft?**

A: Encrypt token storage, limit token permissions, monitor token usage.

## Next Steps

1. Design service account strategy
2. Create service accounts per workload
3. Configure RBAC roles and bindings
4. Test pod authentication
5. Monitor service account usage
6. Implement workload identity for external services
7. Plan certificate rotation strategy

Container identity management is fundamental to cloud-native security. Plan early.
