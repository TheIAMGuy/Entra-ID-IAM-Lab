---
title: Managed Identities - Azure Native Workload Identity
part: 6
section: Cloud-Native Workload Identity
difficulty: Intermediate
estimated_reading_time: 40
estimated_lab_time: 60
prerequisites:
  - 11a-workload-identity.md
  - 10-hybrid-identity-architecture.md
learning_objectives:
  - Understand system-assigned vs. user-assigned identities
  - Implement managed identity in Azure
  - Configure RBAC for managed identities
  - Use managed identity in applications
  - Monitor and troubleshoot managed identity
---

# Managed Identities: Azure Native Workload Identity

## Introduction

Managed Identity is Azure's built-in solution for workload authentication. Instead of managing credentials, Azure automatically creates and manages service principals for your resources. Applications access Azure services (storage, databases, Key Vault) using managed identity without storing any credentials in code. This document explains managed identity types, implementation, and best practices in Azure.

**Learning Objectives:**
- Understand system-assigned vs. user-assigned identities
- Enable and configure managed identity
- Assign RBAC roles to managed identities
- Implement in applications and CI/CD
- Troubleshoot managed identity issues

## Managed Identity Types

### System-Assigned Identity

**Characteristics:**
- Created automatically when you enable identity on resource
- One-to-one relationship (resource gets one identity)
- Deleted when resource is deleted
- Can't be shared across resources

**Use cases:**
- Single application needing access
- Application accessing specific resources
- Simple scenarios

**Enable:**
```
Azure Portal → Resource → Identity → Status: On
OR
Azure CLI: az vm update --resource-group myRG --name myVM --assign-identity
```

### User-Assigned Identity

**Characteristics:**
- Created separately as standalone resource
- Can be assigned to multiple resources
- Survives resource deletion
- Can be shared across resources

**Use cases:**
- Multiple applications needing same identity
- Shared permissions across team
- Complex scenarios with delegation

**Create:**
```
Azure Portal → Create → User Assigned Managed Identity
OR
Azure CLI: az identity create --resource-group myRG --name myIdentity
```

## Implementing Managed Identity

### Step 1: Enable on Resource

**Virtual Machine:**
```bash
az vm update --resource-group myRG --name myVM --assign-identity
```

**App Service:**
```bash
az webapp identity assign --resource-group myRG --name myAppService
```

**Container Instance:**
```bash
az container create --resource-group myRG --name myContainer \
  --assign-identity /subscriptions/.../resourceGroups/myRG/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myIdentity
```

### Step 2: Grant RBAC Permissions

```bash
# Get identity principal ID
PRINCIPAL_ID=$(az vm show --resource-group myRG --name myVM \
  --query identity.principalId -o tsv)

# Assign role on resource
az role assignment create \
  --role "Storage Blob Data Contributor" \
  --assignee-object-id $PRINCIPAL_ID \
  --scope /subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Storage/storageAccounts/{account}
```

### Step 3: Use in Application

**Azure SDK automatically uses managed identity:**

```python
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient

# Automatically uses managed identity (no credentials needed)
credential = DefaultAzureCredential()

blob_client = BlobServiceClient(
    account_url='https://mystorageaccount.blob.core.windows.net',
    credential=credential
)

# Access storage with no secrets in code
containers = blob_client.list_containers()
```

**No credentials needed. DefaultAzureCredential automatically uses managed identity.**

## Hands-On Lab: Managed Identity Setup

**Estimated Time:** 60 minutes

**Lab Objectives:**
- Enable managed identity on App Service
- Grant storage access
- Access storage from application

### Step 1: Create App Service with Identity (15 minutes)

```bash
# Create resource group
az group create --name myRG --location eastus

# Create App Service plan
az appservice plan create --resource-group myRG --name myPlan \
  --sku F1 --is-linux

# Create web app with managed identity
az webapp create --resource-group myRG --plan myPlan --name myWebApp \
  --runtime "PYTHON|3.9" --assign-identity
```

### Step 2: Grant Storage Access (15 minutes)

```bash
# Get managed identity principal ID
PRINCIPAL_ID=$(az webapp identity show --resource-group myRG \
  --name myWebApp --query principalId -o tsv)

# Create storage account
az storage account create --resource-group myRG --name mystorageacct \
  --sku Standard_LRS

# Assign role
az role assignment create \
  --role "Storage Blob Data Contributor" \
  --assignee-object-id $PRINCIPAL_ID \
  --scope /subscriptions/$(az account show --query id -o tsv)/resourceGroups/myRG/providers/Microsoft.Storage/storageAccounts/mystorageacct
```

### Step 3: Deploy Application (20 minutes)

```python
# app.py
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient
from flask import Flask

app = Flask(__name__)

# Managed identity credential (no secrets)
credential = DefaultAzureCredential()
blob_service = BlobServiceClient(
    account_url='https://mystorageacct.blob.core.windows.net',
    credential=credential
)

@app.route('/blobs')
def list_blobs():
    container = blob_service.get_container_client('mycontainer')
    blobs = [blob.name for blob in container.list_blobs()]
    return f'Blobs: {blobs}'

if __name__ == '__main__':
    app.run()
```

Deploy to App Service:
```bash
az webapp up --resource-group myRG --name myWebApp --runtime PYTHON:3.9
```

### Step 4: Verify No Secrets (10 minutes)

```bash
# Check application code
cat app.py  # No credentials visible

# Check environment variables
az webapp config appsettings list --resource-group myRG --name myWebApp
# No connection strings or secrets needed
```

## System-Assigned vs. User-Assigned

| Aspect | System-Assigned | User-Assigned |
|--------|-----------------|---------------|
| **Creation** | Automatic | Manual |
| **Lifecycle** | Tied to resource | Independent |
| **Sharing** | Can't share | Can share |
| **Management** | Less control | More control |
| **Cost** | Included | Separate resource |
| **When to use** | Simple, single-use | Complex, multi-use |

## Troubleshooting Managed Identity

| Issue | Cause | Solution |
|-------|-------|----------|
| "No credentials found" | Managed identity not enabled | Enable identity on resource |
| "Access denied" | Missing RBAC role | Grant role to identity principal |
| "Authentication failed" | Wrong credential type | Use DefaultAzureCredential in SDK |
| "Identity not found" | User-assigned identity deleted | Recreate or use system-assigned |
| "Permission denied" | Insufficient role | Add required role (Contributor, Reader, custom) |

## Best Practices

1. **Prefer Managed Identity over secrets** - Always
2. **Use System-Assigned** for simple single-resource access
3. **Use User-Assigned** for multi-resource or shared scenarios
4. **Grant Least Privilege** - Only required roles
5. **Monitor Identity Usage** - Audit logs track all access
6. **Test Managed Identity** before deploying to production
7. **Document Identity** - Which resources use which identity

## Compliance & Standards

**Managed Identity and Compliance:**
- **Zero Trust:** Workload identity is core component
- **Least Privilege:** Grant only necessary roles
- **Audit Trail:** All access logged and auditable

## Related Documents

**Prerequisites:**
- [Workload Identity](./11a-workload-identity.md) - Workload identity concepts
- [Azure RBAC Fundamentals](./03-role-based-access-control.md) - Role-based access

**Next Steps:**
- [Entra Workload Identity](./15a-entra-workload-id.md) - Advanced workload federation
- [Secrets Management](./15b-secrets-management.md) - Key Vault integration

## FAQ

**Q: When should we use managed identity vs. application keys?**

A: Always use managed identity on Azure. Never use hardcoded keys.

**Q: Can managed identity access resources outside Azure?**

A: Limited. Can access Azure resources, APIs with Entra ID. For other resources, use Key Vault.

**Q: How do we rotate managed identity credentials?**

A: Azure handles automatic rotation. No action needed.

**Q: Can we use managed identity in on-premises?**

A: Not directly. For on-premises, use service principals with certificates.

**Q: What's the performance impact of managed identity?**

A: Minimal. Token cached for 1 hour. Typical latency: <100ms.

## Next Steps

1. Audit all Azure resources
2. Enable managed identity on all resources
3. Remove hardcoded credentials
4. Grant minimum RBAC roles
5. Monitor managed identity usage

Managed identity is Azure's answer to workload authentication. Use it everywhere on Azure.
