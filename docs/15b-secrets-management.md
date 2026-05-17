---
title: Secrets Management - Secure Credential Storage and Rotation
part: 6
section: Cloud-Native Workload Identity
difficulty: Intermediate
estimated_reading_time: 35
estimated_lab_time: 45
prerequisites:
  - 11a-workload-identity.md
  - 15-managed-identities.md
learning_objectives:
  - Understand secrets management concepts
  - Implement Azure Key Vault for secrets
  - Configure secret rotation and versioning
  - Integrate secrets into applications
  - Audit and monitor secret access
---

# Secrets Management: Secure Credential Storage and Rotation

## Introduction

Secrets are credentials needed by applications: database passwords, API keys, connection strings. Secrets differ from identities (certificates, tokens) in that they're long-lived and typically not rotated automatically. Poor secrets management leads to hardcoded passwords in code, unrotated credentials, and breaches from stolen secrets. This document explains secrets management best practices, Azure Key Vault implementation, and secret lifecycle.

**Learning Objectives:**
- Understand secrets vs. identities
- Implement centralized secrets management
- Configure secret rotation
- Integrate secrets into applications
- Audit and monitor secret access

## Secrets vs. Identities

| Aspect | Secret | Identity |
|--------|--------|----------|
| **Type** | Password, API key, connection string | Certificate, JWT token, OIDC token |
| **Lifetime** | Long (6-12 months) | Short (1 hour typical) |
| **Generation** | Human creates | System auto-generates |
| **Rotation** | Manual or scheduled | Automatic, frequent |
| **Usage** | Application stores and uses | System exchanges and verifies |
| **Scope** | Often broad access | Fine-grained, short-lived |
| **Example** | Database password | Service account certificate |

**Best Practice:** Prefer identities over secrets. Use secrets only when necessary.

## Secrets Management Principles

### 1. Never Store Secrets in Code

**BAD:**
```python
# plaintext.py
PASSWORD = "super_secret_123"
API_KEY = "sk_live_abc123def456"
```

**GOOD:**
```python
# app.py
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

credential = DefaultAzureCredential()
client = SecretClient(vault_url="https://myvault.vault.azure.net/", credential=credential)

password = client.get_secret("database-password").value
```

### 2. Centralized Storage

**All secrets in single location:**
- Azure Key Vault
- HashiCorp Vault
- AWS Secrets Manager
- Not: environment files, config files, code repositories

### 3. Access Control

**Principle of Least Privilege:**
```
Application only accesses secrets it needs
Database password: Only database applications
API key: Only service using that API
```

### 4. Rotation

**Automatic rotation of long-lived secrets:**
- Database passwords: Every 90 days
- API keys: Every 1-2 years or on compromise
- Certificates: Before expiry (handled separately)

### 5. Audit and Monitoring

**Track all secret access:**
- Who accessed what secret
- When it was accessed
- From where
- Success/failure

## Azure Key Vault

### Key Vault Concepts

**Three object types:**

**1. Keys** (for encryption/decryption)
```
Key name: data-encryption-key
Type: RSA-2048 or RSA-4096
Usage: Encrypt/decrypt sensitive data
```

**2. Secrets** (passwords, connection strings, API keys)
```
Secret name: database-password
Value: complex-password-123
Rotation: Automatic every 90 days
```

**3. Certificates** (for TLS/mTLS)
```
Certificate name: app-tls-cert
Type: X.509 self-signed or CA-signed
Expiry: Monitor and auto-renew
```

### Create and Store Secret

**Azure Portal:**
```
Key Vault → Secrets → + Generate/Import
Name: database-password
Value: mySecretValue123
Content Type: password
```

**Azure CLI:**
```bash
az keyvault secret set \
  --vault-name myKeyVault \
  --name database-password \
  --value "mySecurePassword123"
```

**Grant Application Access:**
```bash
# Get application identity object ID
APP_OBJECT_ID=$(az ad app list --display-name myapp --query [0].id -o tsv)

# Grant secret read permission
az keyvault set-policy \
  --name myKeyVault \
  --object-id $APP_OBJECT_ID \
  --secret-permissions get list
```

### Application Access to Secrets

**Node.js Example:**
```javascript
const { SecretClient } = require("@azure/keyvault-secrets");
const { DefaultAzureCredential } = require("@azure/identity");

const credential = new DefaultAzureCredential();
const client = new SecretClient(
  "https://myvault.vault.azure.net",
  credential
);

// Get secret (uses managed identity)
async function getSecret() {
  const secret = await client.getSecret("database-password");
  return secret.value;  // Returns: mySecurePassword123
}

// Connect to database with secret
const password = await getSecret();
const connectionString = `Server=myserver.database.windows.net;Password=${password}`;
```

**Python Example:**
```python
from azure.keyvault.secrets import SecretClient
from azure.identity import DefaultAzureCredential

credential = DefaultAzureCredential()
client = SecretClient(vault_url="https://myvault.vault.azure.net", credential=credential)

# Get secret
secret = client.get_secret("database-password")
password = secret.value

# Use in database connection
import pymssql
conn = pymssql.connect(
    server='myserver.database.windows.net',
    user='admin',
    password=password,
    database='mydb'
)
```

## Secret Rotation

### Automatic Rotation

**Key Vault automates rotation for select secret types:**

**Azure SQL Database:**
```
1. Store current password in Key Vault
2. Key Vault periodically (90-day default):
   - Generates new password
   - Updates Azure SQL with new password
   - Stores new password in Key Vault
   - Rotates old password out
3. Applications always read latest password from Key Vault
```

**Configuration:**
```yaml
Secret: sql-password
Rotation:
  Enabled: true
  Interval: 90 days
  RotationFunction: KeyVaultRotationFunction
```

### Manual Rotation with Automation

**For secrets without built-in rotation:**

```bash
# Lambda/Function App runs on schedule (monthly)
trigger: cron(0 0 1 * * ?)  # Monthly

steps:
1. Get current API key from Key Vault
2. Register new key in third-party system
3. Test new key works
4. Update Key Vault with new key (new version)
5. Wait 24 hours (allow app to sync)
6. Revoke old key in third-party system
```

### Version Management

**Key Vault maintains versions:**

```
Secret: api-key
Version 1: api_key_abc123... (created 2024-01-01)
Version 2: api_key_def456... (created 2024-04-01, active)
Version 3: api_key_ghi789... (created 2024-07-01, active)

Applications reference "latest" and get current version
```

**List versions:**
```bash
az keyvault secret list-versions \
  --vault-name myKeyVault \
  --name api-key
```

## Secret Lifecycle Management

### Secret Creation

```
1. Administrator generates secure secret
2. Stores in Key Vault
3. Grants application access via RBAC
4. Application retrieves at runtime
5. Never cached locally (request on each use or short-lived cache)
```

### Secret Rotation Workflow

```
Week 1-12: Secret in use
  Application reads from Key Vault
  Current version is active

Week 12: Rotation scheduled
  New secret generated
  New version created
  Applications still using old version

Week 13: Gradual transition
  Applications updated to read new version
  Both versions valid for 7 days
  Monitoring for errors

Week 14: Old version deprecated
  Remove old version from Key Vault
  Applications 100% on new version
  Complete rotation
```

### Secret Retirement

```
End of life: Secret no longer needed
  1. Stop issuing new versions
  2. Monitor for usage
  3. After 30 days with no usage: Delete
  4. Archive deleted secret metadata for audit
```

## Secrets in Kubernetes

### Kubernetes Secrets (Basic)

**Create secret:**
```bash
kubectl create secret generic db-secret \
  --from-literal=password=mypassword123 \
  -n myapp
```

**Use in pod:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp
spec:
  containers:
  - name: app
    image: myapp:latest
    env:
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: password
    volumeMounts:
    - name: secret-volume
      mountPath: /var/run/secrets
      readOnly: true
  volumes:
  - name: secret-volume
    secret:
      secretName: db-secret
```

### Better: Key Vault Integration

**Use External Secrets Operator to sync Key Vault → Kubernetes:**

```yaml
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: keyvault-store
spec:
  provider:
    azurekv:
      authSecretRef:
        clientID: my-client-id
      vaultUrl: https://myvault.vault.azure.net
---
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: db-secret
spec:
  secretStoreRef:
    name: keyvault-store
    kind: SecretStore
  target:
    name: db-secret-k8s
    creationPolicy: Owner
  data:
  - secretKey: password
    remoteRef:
      key: database-password
```

**Benefits:**
- Secrets synced from Key Vault to Kubernetes
- Automatic rotation propagated
- Single source of truth (Key Vault)
- Audit trail in Key Vault

## Secrets Monitoring and Audit

### Access Logging

**Track all secret access:**

```
Timestamp: 2024-01-15T14:23:45Z
Operation: Get secret
Secret: database-password
Requestor: payment-app-pod
Status: Success
Source IP: 10.0.1.45
```

**KQL Query:**
```kql
AzureDiagnostics
| where OperationName == "Get secret"
| where SecretName == "database-password"
| project TimeGenerated, OperationName, SecretName, Identity, ResultType
```

### Monitoring and Alerts

**Alert on suspicious activity:**

```
1. Unexpected access time (after hours)
2. Multiple failures (brute force?)
3. Access from unusual location
4. High frequency access (possible compromise)
5. Access to multiple secrets in short time
```

## Best Practices

1. **Never Hardcode** - Always retrieve from secrets manager
2. **Least Privilege** - Grant only needed secret permissions
3. **Encrypt in Transit** - Use HTTPS/TLS for Key Vault communication
4. **Rotate Regularly** - Automate rotation where possible
5. **Audit Access** - Monitor and alert on unusual patterns
6. **Cache Cautiously** - Cache only if safe (short TTL)
7. **Handle Rotation Gracefully** - Application continues when secret version changes
8. **Secure Backup** - Backup secrets in secure location
9. **Monitor Expiry** - Alert before secrets expire
10. **Clean Up** - Delete unused secrets

## Hands-On Lab: Key Vault Secrets

**Estimated Time:** 45 minutes

**Prerequisites:** Azure subscription, permissions to manage Key Vault

**Lab Objectives:**
- Create Key Vault
- Store and retrieve secrets
- Configure access control
- Monitor secret access

### Step 1: Create Key Vault (10 min)

```bash
az keyvault create \
  --name myKeyVault \
  --resource-group myResourceGroup \
  --location eastus
```

### Step 2: Store Secret (5 min)

```bash
az keyvault secret set \
  --vault-name myKeyVault \
  --name db-password \
  --value "SecurePass123!"
```

### Step 3: Grant Access (10 min)

```bash
# Get current user object ID
USER_ID=$(az ad signed-in-user show --query id -o tsv)

# Grant secret permissions
az keyvault set-policy \
  --name myKeyVault \
  --object-id $USER_ID \
  --secret-permissions get list set delete
```

### Step 4: Retrieve Secret (10 min)

```bash
# Via Azure CLI
az keyvault secret show \
  --vault-name myKeyVault \
  --name db-password

# Via Azure Portal
# Key Vault → Secrets → db-password → Show Secret Value
```

### Step 5: Monitor Access (10 min)

```bash
# Check audit logs
az monitor activity-log list \
  --resource-group myResourceGroup \
  --resource-type Microsoft.KeyVault/vaults \
  --resource-name myKeyVault
```

## Related Documents

**Prerequisites:**
- [Workload Identity](./11a-workload-identity.md) - Workload authentication
- [Managed Identities](./15-managed-identities.md) - Azure managed identity

**Next Steps:**
- [Certificate Management](./15c-certificate-management.md) - Certificate lifecycle
- [Identity Governance](./17a-identity-governance-administration.md) - Governance policies

## FAQ

**Q: Should we rotate all secrets?**

A: High-value secrets (database passwords, API keys) should rotate. Certificates auto-rotate.

**Q: How often to rotate secrets?**

A: Recommended: 90 days for passwords, 1-2 years for API keys or upon compromise.

**Q: Can we use same secret for multiple applications?**

A: Not ideal. Each application should have unique secret (per-app access control).

**Q: What if a secret is compromised?**

A: Immediately rotate in Key Vault. Application will get new secret on next read.

## Next Steps

1. Audit current secret storage (code, config files)
2. Migrate secrets to centralized vault
3. Configure access control and rotation
4. Update applications to read from vault
5. Remove secrets from code repositories
6. Monitor and audit secret access
7. Plan rotation strategy per secret

Centralized secrets management prevents breaches from hardcoded credentials.
