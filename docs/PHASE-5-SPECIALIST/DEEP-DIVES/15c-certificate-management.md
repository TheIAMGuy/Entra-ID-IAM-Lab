---
title: Certificate Management - Lifecycle and Automation
part: 6
section: Cloud-Native Workload Identity
difficulty: Intermediate
estimated_reading_time: 35
estimated_lab_time: 40
prerequisites:
  - 15-managed-identities.md
  - 15b-secrets-management.md
learning_objectives:
  - Understand certificate lifecycle
  - Implement automated certificate issuance and rotation
  - Configure certificate monitoring and renewal
  - Manage certificate chains and trust
  - Troubleshoot certificate issues
---

# Certificate Management: Lifecycle and Automation

## Introduction

Certificates are identities (unlike secrets which are credentials). A certificate proves "I am payment-service" through cryptographic signing. Certificates expire (typically 1 year for TLS, shorter for workloads). Poor certificate management leads to expired certificates, service outages, and manual rotation burden. Modern systems automate certificate issuance, renewal, and deployment. This document explains certificate lifecycle, automation, and best practices.

**Learning Objectives:**
- Understand certificate lifecycle
- Implement automated certificate issuance and renewal
- Monitor certificate expiration
- Manage certificate chains
- Troubleshoot certificate issues

## Certificate Lifecycle

### Certificate Lifetime

**Typical expiration timelines:**

| Certificate Type | Lifetime | Renewal Trigger |
|---|---|---|
| **TLS (Web)** | 1-3 years | 30 days before expiry |
| **Code Signing** | 2-3 years | 90 days before expiry |
| **Internal (mTLS)** | 1 year | 60 days before expiry |
| **Workload (SPIFFE)** | 1 hour | 50 minutes (auto-rotate) |
| **Device/IoT** | 5 years | 6 months before expiry |

### Renewal Process

**Typical 3-month renewal cycle (for annual certs):**

```
Day 1-273: Certificate active
  - Issued on Day 1
  - Valid until Day 365
  - Application using cert

Day 274: Renewal notice sent
  - Reminder: Certificate expires in 91 days
  - Action: Request new certificate

Day 274-290: Certificate request processing
  - Request submitted to CA
  - CA validates identity
  - New certificate issued
  - New certificate available in vault

Day 291: Transition period starts
  - Application configured with new cert
  - Both old and new cert valid
  - Gradual transition (0% → 100%)

Day 308: Complete transition
  - 100% using new certificate
  - Old certificate still valid until Day 365
  - Can safely revoke if needed

Day 365: Old certificate expires
  - No longer valid
  - Can be archived
```

## Automated Certificate Management

### Let's Encrypt (Free TLS Certificates)

**Automatic certificate issuance and renewal:**

```
1. Domain verification (ACME challenge)
2. Certificate issued (90-day validity)
3. Automated renewal (30 days before expiry)
4. No manual renewal needed
```

**Use certbot for automation:**

```bash
# Install certbot
sudo apt install certbot python3-certbot-nginx

# Get certificate (automated)
sudo certbot certonly \
  --nginx \
  --non-interactive \
  --agree-tos \
  -d example.com

# Auto-renewal every 60 days
sudo certbot renew --quiet
# Add to cron: 0 2 * * * /usr/bin/certbot renew --quiet
```

### Azure Key Vault Certificates

**Automated certificate lifecycle in Key Vault:**

**Auto-renew TLS certificate:**

```bash
az keyvault certificate create \
  --vault-name myKeyVault \
  --name my-tls-cert \
  --policy @cert-policy.json
```

**Certificate Policy (cert-policy.json):**

```json
{
  "issuerParameters": {
    "name": "Self",
    "certificateType": "SelfSigned"
  },
  "keyProperties": {
    "exportable": true,
    "keySize": 2048,
    "keyType": "RSA",
    "reuseKey": true
  },
  "secretProperties": {
    "contentType": "application/x-pkcs12"
  },
  "x509CertificateProperties": {
    "subject": "CN=example.com",
    "validityInMonths": 12,
    "keyUsage": [
      "digitalSignature",
      "keyEncipherment"
    ]
  },
  "lifetimeActions": [
    {
      "action": {
        "actionType": "EmailContacts"
      },
      "trigger": {
        "daysBeforeExpiry": 30
      }
    },
    {
      "action": {
        "actionType": "AutoRenew"
      },
      "trigger": {
        "daysBeforeExpiry": 30
      }
    }
  ]
}
```

**Automatic renewal:**
- 30 days before expiry: Key Vault auto-renews
- New version created
- Applications update to new version
- No downtime

### ACME Protocol (Automated Certificate Management Environment)

**Standard protocol for automated certificate issuance:**

```
Application (certbot) ↔ ACME Server (Let's Encrypt)

1. Application: "I control example.com"
2. ACME: "Prove it by responding to challenge"
3. Application: Creates DNS record / HTTP file
4. ACME: Verifies control
5. Application: "Issue certificate"
6. ACME: Issues certificate
7. Application: Stores in vault
8. Application: Configures renewal in 60 days
```

## Certificate Monitoring

### Monitoring Certificate Expiration

**KQL query to find expiring certificates:**

```kql
AzureDiagnostics
| where OperationName == "CertificateGet"
| where Status == "Success"
| extend ExpiryDate = parse_json(ResultDescription).expires_at
| where ExpiryDate < now() + 30d
| project ResourceId, ExpiryDate, DaysUntilExpiry = (ExpiryDate - now()) / 1d
```

### Alerts

**Alert if certificate expires soon:**

```yaml
AlertRule: Certificate Expiring Soon
Condition: Certificate expiry < 30 days
Severity: Warning

AlertRule: Certificate Expired
Condition: Certificate expiry < 0 days
Severity: Critical (Page on-call engineer)
```

**Implementation (Azure Monitor):**

```bash
az monitor metrics alert create \
  --name cert-expiry-alert \
  --resource-group myResourceGroup \
  --scopes /subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.KeyVault/vaults/myVault \
  --condition "avg 'KeyVaultCertificateExpiry' < 30 days" \
  --action-group on-call
```

## Certificate Chains and Trust

### Certificate Chain

**Trust path from root to leaf:**

```
Root CA (trusted by browsers/OS)
  ↓ signs
Intermediate CA
  ↓ signs
Leaf Certificate (your domain)
  ↓
Client verifies chain:
  1. Leaf signed by Intermediate? ✓
  2. Intermediate signed by Root? ✓
  3. Root is trusted? ✓
  → Certificate valid
```

### Installing Certificate Chains

**Store full chain in application:**

```bash
# Download certificate chain from CA
# Concatenate: leaf + intermediate + root

cat leaf.crt intermediate.crt root.crt > chain.crt

# Store in Key Vault
az keyvault secret set \
  --vault-name myKeyVault \
  --name cert-chain \
  --file chain.crt
```

**Application usage:**

```
TLS Handshake:
1. Client: "I want to talk to example.com"
2. Server: "Here's my leaf certificate + chain"
3. Client: Verifies chain
4. Client: Establishes TLS connection
```

## Certificate Renewal Strategies

### Strategy 1: Hot Renewal (Zero Downtime)

**Maintain both old and new cert during transition:**

```
Hour 0: Deploy new certificate alongside old
  - Application configured for either
  - Load balancer sends to both
  
Hour 1-23: Gradual traffic shift
  - 5% → new cert
  - 25% → new cert
  - 50% → new cert
  - 100% → new cert
  - Monitor for errors

Hour 24: Complete transition
  - All traffic on new cert
  - Keep old cert 7 more days
  - Then retire old cert
```

### Strategy 2: Rolling Restart

**Restart instances with new cert:**

```
Kubernetes Rolling Update:
1. New pod starts with new cert
2. Old pod stops
3. Repeat until all pods have new cert
4. Zero downtime (load balancer routes around restarts)
```

**Configuration:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payment-service
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  template:
    spec:
      containers:
      - name: app
        image: payment:latest
        volumeMounts:
        - name: certs
          mountPath: /var/run/secrets/tls
          readOnly: true
      volumes:
      - name: certs
        secret:
          secretName: app-cert  # Automatically updated by cert manager
```

### Strategy 3: Blue-Green Deployment

**Deploy entirely new environment, switch traffic:**

```
Blue Environment (current):
  - Pods with old certificate
  - Taking all traffic

Green Environment (new):
  - Pods with new certificate
  - Deployed, tested
  - 0% traffic

Cutover:
  - Load balancer switches to green
  - Blue retired
  - Zero downtime, easy rollback
```

## Certificate Tools

### cert-manager (Kubernetes)

**Automates certificate issuance and renewal:**

```bash
# Install cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml

# Create issuer
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: admin@example.com
    privateKeySecretRef:
      name: letsencrypt-key
    solvers:
    - http01:
        ingress:
          class: nginx
EOF

# Create certificate request
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: app-cert
  namespace: default
spec:
  secretName: app-tls-secret
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
  dnsNames:
  - example.com
  - www.example.com
EOF
```

**Result:** Certificate automatically issued and renewed

### HashiCorp Vault

**Centralized secrets and certificate management:**

```bash
# Enable PKI engine
vault secrets enable pki
vault secrets tune -max-lease-ttl=87600h pki

# Configure root CA
vault write -field=certificate pki/root/generate/internal \
  common_name=example.com \
  ttl=87600h > CA_cert.crt

# Issue certificate
vault write pki/issue/example-dot-com \
  common_name=app.example.com \
  ttl=720h
```

## Troubleshooting Certificates

| Issue | Cause | Solution |
|-------|-------|----------|
| **TLS handshake fails** | Certificate not installed | Verify cert in `/etc/ssl/certs/` or Key Vault |
| **Certificate expired** | Renewal failed | Manually issue new cert, update application |
| **Wrong certificate** | Misconfigured path | Verify certificate path, SNI configuration |
| **Certificate chain invalid** | Missing intermediate | Add full chain (leaf + intermediate + root) |
| **Certificate not trusted** | Root CA not in trust store | Install root CA in OS or browser |
| **Renewal not working** | Cert manager pod down | Check cert-manager logs, restart pod |

## Hands-On Lab: Automated Certificate Renewal

**Estimated Time:** 40 minutes

**Prerequisites:** Kubernetes cluster, domain, cert-manager installed

**Lab Objectives:**
- Install cert-manager
- Create ClusterIssuer
- Request certificate with auto-renewal
- Monitor certificate lifecycle

### Step 1: Install cert-manager (5 min)

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml

# Verify installation
kubectl get pods --namespace cert-manager
```

### Step 2: Create Let's Encrypt Issuer (5 min)

```bash
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: your-email@example.com
    privateKeySecretRef:
      name: letsencrypt-key
    solvers:
    - http01:
        ingress:
          class: nginx
EOF
```

### Step 3: Request Certificate (10 min)

```bash
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: demo-cert
  namespace: default
spec:
  secretName: demo-tls-secret
  issuerRef:
    name: letsencrypt-staging
    kind: ClusterIssuer
  dnsNames:
  - example.com
EOF

# Watch certificate request
kubectl describe certificate demo-cert
```

### Step 4: Verify Certificate (10 min)

```bash
# Get secret
kubectl get secret demo-tls-secret -o yaml

# Extract certificate
kubectl get secret demo-tls-secret -o jsonpath='{.data.tls\.crt}' | base64 -d > cert.crt

# Check certificate details
openssl x509 -in cert.crt -text -noout | grep -A 2 "Validity"
```

### Step 5: Monitor Renewal (10 min)

```bash
# Check cert-manager logs
kubectl logs -n cert-manager deployment/cert-manager -f

# Watch for renewal event
kubectl get events --sort-by='.lastTimestamp' | grep demo-cert
```

## Best Practices

1. **Automate Everything** - No manual certificate management
2. **Monitor Expiration** - Alert 30+ days before expiry
3. **Renewal Before Expiry** - Never wait until expiration
4. **Full Chain** - Always include leaf + intermediate + root
5. **Short Validity** - Use shorter-lived certs (1 year or less)
6. **Hot Renewal** - Update certs without service restart
7. **Audit Issuance** - Log all certificate creation and renewal
8. **Secure Key Storage** - Private keys protected (HSM preferred)
9. **Version Control** - Track certificate changes
10. **Test Renewal** - Verify renewal process works before production

## Related Documents

**Prerequisites:**
- [Secrets Management](./15b-secrets-management.md) - Secret storage
- [Managed Identities](./15-managed-identities.md) - Identity concepts

**Next Steps:**
- [Identity Governance](./17a-identity-governance-administration.md) - Policy compliance
- [Audit & Compliance](./06b-governance-workflows.md) - Governance implementation

## FAQ

**Q: How often should we rotate certificates?**

A: Every 1 year for TLS, every 6 months for high-security. Use auto-renewal, don't manually rotate.

**Q: What if a certificate is compromised?**

A: Revoke immediately in CA, issue new cert, update applications within hours.

**Q: Can we use same certificate for multiple domains?**

A: Yes (wildcard `*.example.com`), but separate certs per domain is better for security.

**Q: What's the cost of certificate management?**

A: Free (Let's Encrypt), or ~$50-200/year for commercial CA. Automation essential at scale.

## Next Steps

1. Audit current certificate inventory
2. Identify expiring certificates
3. Implement automated renewal (cert-manager, Vault, etc.)
4. Configure alerts for expiration
5. Test renewal process
6. Deploy to production
7. Monitor renewal success rate

Automated certificate management eliminates outages from expired certs.
