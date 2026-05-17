---
title: Entra Workload Identity Federation - OIDC Token Exchange
part: 6
section: Cloud-Native Workload Identity
difficulty: Advanced
estimated_reading_time: 35
estimated_lab_time: 50
prerequisites:
  - 11a-workload-identity.md
  - 09b-oauth-and-openid-connect.md
learning_objectives:
  - Understand workload identity federation concepts
  - Implement OIDC token exchange in Entra ID
  - Configure federation for GitHub Actions
  - Federate identities across cloud platforms
  - Secure workload authentication without secrets
---

# Entra Workload Identity Federation: OIDC Token Exchange

## Introduction

Workload identity federation enables applications (GitHub Actions, CI/CD pipelines, external cloud workloads) to authenticate to Entra ID and Azure without storing secrets. Instead, the application exchanges its identity token (from its platform, e.g., GitHub) for an Azure access token. Example: GitHub Actions can access Azure resources by proving it's running a specific repository, without storing Azure credentials. This document explains OIDC federation and implementation in Entra ID.

**Learning Objectives:**
- Understand OIDC token exchange for workload identity
- Configure workload identity federation in Entra ID
- Implement GitHub Actions to Azure federation
- Enable cross-cloud workload authentication
- Eliminate long-lived secrets from CI/CD

## Workload Identity Federation Concepts

### The Problem: Long-Lived Secrets in CI/CD

**Traditional approach:**
```
GitHub Actions ← Azure Service Principal credentials (secret + password)
  Problem: Secret in GitHub secrets, never rotates, exposed forever if leaked
```

**Federation approach:**
```
GitHub Actions ← GitHub issues OIDC token (short-lived, valid 5 minutes)
  ↓
Entra ID exchanges token ← "Are you really GitHub Actions for this repo?"
  ↓
If verified: issues Azure access token
  ↓
GitHub Actions uses Azure token (valid 1 hour, auto-rotates)
```

### OIDC Token Exchange Flow

**Step 1: CI/CD Platform Issues Token**
```
GitHub Actions: "I'm running job abc123 in repo owner/repo"
Token format: JWT signed by GitHub
Subject: repo:owner/repo:ref:refs/heads/main
Audience: https://iam.googleapis.com/locations/global/workloadIdentityPools/github
Expiry: 5 minutes
```

**Step 2: Application Exchanges Token**
```
Application → Entra ID:
  "Here's my GitHub token, can I get an Azure token?"
  
Entra ID:
  1. Verify token signature (using GitHub public key)
  2. Check subject matches allowed repository
  3. Issue Azure access token
```

**Step 3: Application Uses Access Token**
```
Application → Azure service:
  Uses access token for resource access
  No secrets stored
```

## Entra ID Workload Identity Federation Setup

### Step 1: Create Service Principal

```bash
# Create service principal for CI/CD
az ad sp create-for-rbac \
  --display-name "github-actions-sp" \
  --output json
```

Record:
- `appId` (client ID)
- `objectId` (principal object ID)

### Step 2: Create Federated Credential

**For GitHub Actions:**

```bash
az identity federated-credential create \
  --name github-repo \
  --identity-name github-actions-sp \
  --resource-group myResourceGroup \
  --issuer https://token.actions.githubusercontent.com \
  --subject repo:owner/repo:ref:refs/heads/main
```

**Breaking down the subject:**
- `repo:owner/repo` - GitHub repository
- `ref:refs/heads/main` - Branch (main only)
- OR `ref:refs/heads/*` - All branches
- OR `environment:production` - Specific environment

### Step 3: Grant Azure Roles

```bash
# Grant Contributor role on resource group
az role assignment create \
  --role Contributor \
  --assignee-object-id {objectId} \
  --scope /subscriptions/{subscription}/resourceGroups/{rg}
```

### Step 4: GitHub Actions Workflow

**Use OIDC token exchange (no secrets!):**

```yaml
name: Deploy to Azure

on:
  push:
    branches: [main]

permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Azure login
      uses: azure/login@v1
      with:
        client-id: ${{ secrets.AZURE_CLIENT_ID }}  # No secret, just public ID
        tenant-id: ${{ secrets.AZURE_TENANT_ID }}  # No secret, just public ID
        subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}  # No secret
    
    - name: Deploy resources
      run: |
        az group create --name myRG --location eastus
        az storage account create \
          --name mystorageacct \
          --resource-group myRG
```

**Explanation:**
- GitHub Actions automatically gets OIDC token (signed by GitHub)
- `azure/login` action exchanges GitHub token for Azure access token
- Token valid only for this GitHub repo, this branch, this run
- No secrets stored, no rotation needed

## OIDC Token Exchange Detailed Flow

**Request:**
```http
POST /oauth2/v2.0/token
Content-Type: application/x-www-form-urlencoded

grant_type=urn:ietf:params:oauth:grant-type:token-exchange
&client_id=12345678-1234-1234-1234-123456789012
&subject_token={github-oidc-token}
&subject_token_type=urn:ietf:params:oauth:token-type:jwt
&requested_token_use=access_token
&assertion=
```

**Response:**
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "https://management.azure.com/.default"
}
```

## Multi-Cloud Federation

### Scenario: Kubernetes to AWS and Azure

**Kubernetes Pod (running in EKS):**
```
Pod has OIDC token (from EKS cluster)
Token format:
  Issuer: https://oidc.eks.us-east-1.amazonaws.com/id/EXAMPLEID
  Subject: system:serviceaccount:default:payment-service
  Audience: sts.amazonaws.com, sts.azure.com
```

**Configure Federation in Both Clouds:**

**In AWS (IAM):**
```bash
aws iam create-open-id-connect-provider \
  --url https://oidc.eks.us-east-1.amazonaws.com/id/EXAMPLEID \
  --client-id-list sts.amazonaws.com

aws iam create-role \
  --role-name eks-payment-role \
  --assume-role-policy-document file://trust-policy.json
```

**In Azure:**
```bash
az identity federated-credential create \
  --name eks-payment \
  --identity-name payment-identity \
  --issuer https://oidc.eks.us-east-1.amazonaws.com/id/EXAMPLEID \
  --subject system:serviceaccount:default:payment-service
```

**Pod authenticates to both clouds:**

```python
# AWS using EKS OIDC
sts_client = boto3.client('sts')
assume_role_response = sts_client.assume_role_with_web_identity(
    RoleArn='arn:aws:iam::123456789012:role/eks-payment-role',
    RoleSessionName='payment-session',
    WebIdentityToken=open('/var/run/secrets/eks.amazonaws.com/serviceaccount/token').read()
)
aws_credentials = assume_role_response['Credentials']

# Azure using Entra federation
azure_credential = ClientAssertionCredential(
    tenant_id='tenant-id',
    client_id='client-id',
    assertion=open('/var/run/secrets/eks.amazonaws.com/serviceaccount/token').read()
)
```

## Supported OIDC Providers

| Provider | Supported | Subject Claims |
|----------|-----------|---|
| **GitHub Actions** | ✓ | `repo:org/repo:*`, `repo:org/repo:environment:*`, `repo:org/repo:ref:*` |
| **Google Cloud** | ✓ | `principalSet://goog/subject/{subject}` |
| **AWS** | ✓ | `arn:aws:iam::{account}:role/{role}` |
| **Kubernetes** | ✓ | `system:serviceaccount:{namespace}:{sa}` |
| **GitLab CI** | ✓ | `project_path:{group}/{project}:ref_type:branch:ref:main` |
| **Terraform Cloud** | ✓ | `organization:{org}:project:{project}:run_phase:plan` |

## Hands-On Lab: GitHub Actions to Azure

**Estimated Time:** 50 minutes

**Prerequisites:** Azure subscription, GitHub repository, permissions to manage service principals

**Lab Objectives:**
- Create federated credential
- Configure GitHub Actions workflow
- Deploy to Azure without storing secrets

### Step 1: Create Service Principal and Federated Credential (15 min)

```bash
# Create service principal
SP_JSON=$(az ad sp create-for-rbac \
  --display-name "github-actions-test" \
  --output json)

OBJECT_ID=$(echo $SP_JSON | jq -r '.id')
APP_ID=$(echo $SP_JSON | jq -r '.appId')
TENANT_ID=$(echo $SP_JSON | jq -r '.tenant')

# Grant Contributor role
az role assignment create \
  --role Contributor \
  --assignee-object-id $OBJECT_ID

# Create federated credential
az identity federated-credential create \
  --name github-repo \
  --identity-name github-actions-test \
  --resource-group {your-rg} \
  --issuer https://token.actions.githubusercontent.com \
  --subject repo:YOUR_ORG/YOUR_REPO:ref:refs/heads/main

# Store for GitHub Secrets
echo "AZURE_CLIENT_ID=$APP_ID"
echo "AZURE_TENANT_ID=$TENANT_ID"
echo "AZURE_SUBSCRIPTION_ID=$(az account show --query id -o tsv)"
```

### Step 2: Store in GitHub Secrets (5 min)

**In GitHub repository:**
```
Settings → Secrets → New repository secret
AZURE_CLIENT_ID: (paste value)
AZURE_TENANT_ID: (paste value)
AZURE_SUBSCRIPTION_ID: (paste value)
```

### Step 3: Create GitHub Actions Workflow (15 min)

**Create `.github/workflows/deploy.yml`:**

```yaml
name: Deploy to Azure with OIDC

on:
  push:
    branches: [main]

permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Azure login via OIDC
      uses: azure/login@v1
      with:
        client-id: ${{ secrets.AZURE_CLIENT_ID }}
        tenant-id: ${{ secrets.AZURE_TENANT_ID }}
        subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
    
    - name: Deploy resources
      run: |
        az group create \
          --name myTestRG \
          --location eastus
        
        az resource list \
          --resource-group myTestRG
```

### Step 4: Test Workflow (15 min)

**Trigger workflow:**
```
Push to main branch OR manually trigger from GitHub Actions
```

**Monitor:**
```
GitHub → Actions → Latest workflow run
Should show successful login without any secrets
```

**Verify in Azure:**
```bash
az audit log show --start-time 2024-01-01 \
  | grep "github-actions-test"
# Should show login and resource creation
```

## Best Practices

1. **No Stored Secrets** - OIDC federation eliminates secret storage
2. **Narrow Scopes** - Limit token to specific branch, environment, or repository
3. **Short Expiration** - Tokens valid 5 minutes, require frequent exchange
4. **Audit Logging** - All OIDC exchanges logged in Azure
5. **Least Privilege Roles** - Grant minimum required Azure role
6. **Environment-Specific Credentials** - Different service principals for dev/staging/prod
7. **Rotate Certificates** - OIDC providers rotate signing keys automatically
8. **Monitor Token Exchange** - Alert on unusual patterns

## Compliance & Standards

**Federation and Compliance:**
- **Zero Trust:** No stored secrets, verification per request
- **Principle of Least Privilege:** Token valid only for specific workload
- **Audit Trail:** All exchanges logged
- **PCI DSS/HIPAA:** Federation recommended over API keys

## Related Documents

**Prerequisites:**
- [Workload Identity](./11a-workload-identity.md) - Workload authentication concepts
- [OAuth and OpenID Connect](./09b-oauth-and-openid-connect.md) - OIDC protocol details

**Next Steps:**
- [Secrets Management](./15b-secrets-management.md) - Secret lifecycle and storage
- [Certificate Management](./15c-certificate-management.md) - Certificate handling

## FAQ

**Q: Is OIDC federation secure?**

A: Yes. Tokens are signed, short-lived, and verified cryptographically.

**Q: Can we use federation for all CI/CD?**

A: Yes. GitHub, GitLab, and other platforms support OIDC federation.

**Q: What if our OIDC provider is compromised?**

A: Attacker can get access token but not credentials. Damage limited by token expiration and RBAC scope.

**Q: How do we rotate tokens with federation?**

A: Automatic. New tokens exchanged hourly. No manual rotation needed.

## Next Steps

1. Evaluate federation vs. secret storage
2. Create service principals for CI/CD workloads
3. Configure federated credentials
4. Update CI/CD workflows to use federation
5. Remove stored secrets
6. Monitor federation logs
7. Plan per-environment federation strategy

Workload identity federation is the modern approach to CI/CD authentication. Eliminate secrets from pipelines.
