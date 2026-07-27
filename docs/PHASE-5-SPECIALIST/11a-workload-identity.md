---
title: Workload Identity - Service Authentication in the Cloud
part: 4
section: Hybrid & Cloud Identity
difficulty: Advanced
estimated_reading_time: 40
estimated_lab_time: 60
prerequisites:
  - 09b-oauth-and-openid-connect.md
  - 11-multi-cloud-identity.md
learning_objectives:
  - Understand workload identity concepts
  - Implement service principal authentication
  - Configure managed identities for Azure resources
  - Design service-to-service communication
  - Secure workload authentication at scale
---

# Workload Identity: Service Authentication in the Cloud

## Introduction

Workload identity is authentication for non-human entities: services, applications, microservices, CI/CD pipelines, and cloud-native workloads. Traditional authentication uses long-lived credentials (API keys, passwords) stored in application code or config files. Modern workload identity provides short-lived tokens issued by cloud platforms, eliminating the need for stored secrets. This document explains workload identity concepts and implementation in Entra ID.

**Learning Objectives:**
- Understand workload identity and non-human authentication
- Implement service principals for applications
- Use managed identities for cloud resources
- Configure service-to-service authentication
- Eliminate long-lived secrets from applications

## Workload Identity Concepts

### The Problem with Long-Lived Secrets

**Traditional approach:**
```
Application needs to access database
  → Admin creates API key
  → Key stored in config file
  → Key has no expiration (or long expiration)
  → Key exposed in code repository or breach
  → Key compromises database indefinitely
```

**Problems:**
- Secrets in code/config files (insecure)
- No automatic rotation
- Difficult to audit secret usage
- Compromise affects everything indefinitely

### Modern Workload Identity Approach

**Entra ID Workload Identity:**
```
Application (running in Kubernetes/Azure)
  ↓ (requests credential)
Managed Identity / Service Principal
  ↓ (Entra ID issues short-lived token)
Token valid for 1 hour
  ↓ (application uses token)
Access resource (database, API, storage)
  ↓ (resource verifies token, grants access)
Data returned
  ↓ (1 hour later, token expires)
Application requests new token (repeat)
```

**Benefits:**
- No secrets in code
- Automatic rotation (hourly)
- Tokens verified cryptographically
- Fine-grained permissions
- Full audit trail

## Workload Identity Models

### ⭐ Model 0: Workload Identity Federation (RECOMMENDED - Modern Approach)

**Workload Identity Federation** (OIDC) is the newest and most secure approach for non-Azure workloads. Instead of storing secrets, your workload exchanges an external identity token (from GitHub, GitLab, Google Cloud) for an Entra ID token. **No secrets stored anywhere.**

**Use cases:**
- GitHub Actions CI/CD pipelines
- GitLab CI/CD deployments
- Google Cloud workloads
- On-premises services with OIDC support
- Multi-cloud environments

**Why choose this:** [Microsoft recommends federation as the best practice](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation) to eliminate credential management entirely. If your workload supports OIDC (GitHub, GitLab, Google, etc.), use federation instead of secrets.

**Implementation outline:**
```
1. Configure OIDC issuer in external system (GitHub, GitLab)
2. Create service principal in Entra ID
3. Set up federation trust (issuer + subject audience)
4. Workload exchanges external token for Entra ID token
5. No secrets stored; automatic token rotation
```

---

### Model 1: Service Principal (Application Registration)

Service Principal represents an application that needs cloud access. **Use this only if federation is not available.**

**Use cases:**
- Web application accessing database
- API calling Microsoft Graph
- Daemon job processing files
- Third-party SaaS (without OIDC support)

**Implementation:**

```
1. Create service principal in Entra ID
   Name: "Finance Reporting App"
   Client ID: guid
   Tenant ID: guid

2. Create credential (AVOID: Long-lived secrets discouraged)
   ⭐ RECOMMENDED: Certificate (auto-rotated)
   ❌ LEGACY: Secret (long-lived, must be rotated manually)

3. Grant permissions (API permissions, Azure RBAC)
   Example: Read access to Finance database

4. Application uses credentials to request token
   Token valid 1 hour, auto-renewed
```

**⚠️ Note:** Secrets without federation are being phased out. If the workload supports OIDC, migrate to Workload Identity Federation instead.

### Model 2: Managed Identity (Azure Resources)

Managed Identity is Azure's built-in workload identity for Azure resources.

**Use cases:**
- Virtual machine accessing storage
- App Service accessing database
- Function app calling Key Vault
- Container in Azure Container Instances

**Implementation:**

```
1. Enable managed identity on Azure resource
   VM → Managed Identity → Enable
   App Service → Identity → Enable

2. Azure automatically creates service principal
   No manual credential creation needed

3. Assign RBAC role to managed identity
   Example: "Blob Data Reader" on storage account

4. Application requests token (local endpoint)
   No credentials needed in application
```

**Major advantage:** No credentials in code, automatically rotated, no exposure.

## Implementing Managed Identity

### Step 1: Enable on Azure Resource

**Virtual Machine:**
```
Entra ID admin center → VM → Identity → Status: On
System-assigned identity auto-created
```

**App Service:**
```
Entra ID admin center → App Service → Identity → Status: On
Managed identity enabled
```

**Container:**
```
Azure CLI: az container create --assign-identity
```

### Step 2: Assign RBAC Role

```
Resource → Access Control (IAM) → + Add → Add role assignment
Role: Storage Blob Data Reader
Assign to: Managed Identity
Members: Select your VM/App Service
```

### Step 3: Request Token in Application

**Node.js Example:**

```javascript
const { DefaultAzureCredential } = require('@azure/identity');
const { BlobServiceClient } = require('@azure/storage-blob');

// Automatically uses managed identity (no credentials needed)
const credential = new DefaultAzureCredential();

const blobClient = new BlobServiceClient(
  'https://mystorageaccount.blob.core.windows.net',
  credential
);

// Access storage using managed identity token
const containers = blobClient.listContainers();
```

**Python Example:**

```python
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient

# Automatically uses managed identity
credential = DefaultAzureCredential()

blob_service_client = BlobServiceClient(
    account_url='https://mystorageaccount.blob.core.windows.net',
    credential=credential
)

# Access storage
containers = blob_service_client.list_containers()
```

## Service Principal with Certificate

For applications not on Azure:

```
1. Create service principal
2. Upload X.509 certificate
3. Application uses certificate to request token
4. Certificate auto-rotates (certificate binding)
5. No secret in code
```

## Hands-On Lab: Managed Identity

**Estimated Time:** 60 minutes

**Prerequisites:** Azure subscription, VM or App Service

**Lab Objectives:**
- Enable managed identity
- Grant permissions
- Access Azure resource securely

### Step 1: Create VM with Managed Identity (15 minutes)

```bash
az vm create \
  --resource-group myResourceGroup \
  --name myVM \
  --image UbuntuLTS \
  --assign-identity
```

### Step 2: Grant Storage Access (10 minutes)

```bash
# Get managed identity principal ID
PRINCIPAL_ID=$(az vm show --resource-group myResourceGroup \
  --name myVM --query identity.principalId -o tsv)

# Assign role
az role assignment create \
  --role "Storage Blob Data Reader" \
  --assignee-object-id $PRINCIPAL_ID \
  --scope /subscriptions/{subscription}/resourceGroups/{rg}/providers/Microsoft.Storage/storageAccounts/{account}
```

### Step 3: Access Storage from VM (20 minutes)

SSH into VM:

```bash
# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# List blobs using managed identity (no credentials needed)
az storage blob list \
  --account-name mystorageaccount \
  --container-name mycontainer
```

### Step 4: Verify No Secrets (15 minutes)

```bash
# Check no secrets in environment
env | grep -i secret  # Should be empty
env | grep -i password  # Should be empty

# Check token was used
az account show  # Confirms authenticated via managed identity
```

## Best Practices

1. **Use Managed Identity** (not service principal credentials) when on Azure
2. **Use Certificates** (not secrets) for service principals
3. **Rotate Credentials** every 1-2 years
4. **Principle of Least Privilege** - grant minimal permissions needed
5. **Monitor Access** - audit all workload authentication
6. **Use RBAC** not shared keys for Azure resources
7. **Store Credentials in Vault** - never in code or config files

## Compliance & Standards

**Standards Supporting Workload Identity:**
- **Zero Trust:** Workload identity is core component
- **NIST 800-53:** Recommends non-human authentication
- **PCI DSS:** Requires secure credential management

## Related Documents

**Prerequisites:**
- [OAuth and OpenID Connect](./09b-oauth-and-openid-connect.md) - Token concepts
- [Multi-Cloud Identity](./11-multi-cloud-identity.md) - Cross-cloud context

**Next Steps:**
- [Machine Identity](./11b-machine-identity.md) - Non-cloud workloads
- [Managed Identities](./15-managed-identities.md) - Azure-specific details

## FAQ

**Q: Should we use managed identity or service principal?**

A: If on Azure, managed identity (automatic). If not on Azure, service principal with certificate.

**Q: How often are tokens rotated?**

A: Tokens auto-refresh hourly. Underlying credential (certificate) rotates annually.

**Q: Can we use passwords/secrets for workloads?**

A: Not recommended. Use certificates or managed identity. Secrets should be last resort.

**Q: How do we handle multi-cloud workload identity?**

A: Use SPIFFE/SPIRE (see workload identity standards). Each cloud issues tokens.

## Next Steps

1. Audit workloads using hardcoded credentials
2. Identify Azure workloads for managed identity
3. Implement managed identity migration plan
4. Move non-Azure workloads to certificate-based service principals
5. Eliminate all hardcoded secrets from applications

Workload identity is the modern approach to service authentication. Eliminate secrets from code.
