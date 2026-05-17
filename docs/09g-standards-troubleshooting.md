---
title: Standards Troubleshooting & Advanced Topics
part: 3
section: Standards & Protocols
difficulty: Advanced
estimated_reading_time: 40
estimated_lab_time: 30
prerequisites:
  - 09-identity-standards-overview.md
  - 09a-saml-single-sign-on.md
  - 09b-oauth-and-openid-connect.md
learning_objectives:
  - Troubleshoot common authentication failures across standards
  - Debug and resolve SAML, OAuth, and OIDC issues
  - Use debugging tools to inspect authentication flows
  - Understand cross-standard scenarios
  - Monitor and alert on authentication problems
---

# Standards Troubleshooting & Advanced Topics

## Introduction

Authentication failures impact user productivity and security. Understanding how to diagnose and resolve issues across SAML, OAuth, and OIDC standards is critical for operations. This document provides troubleshooting frameworks, common issues, debugging tools, and monitoring strategies for identity standards implementations.

**Learning Objectives:**
- Diagnose authentication failures across standards
- Use debugging tools to inspect protocol flows
- Troubleshoot common SAML, OAuth, and OIDC issues
- Monitor authentication health
- Escalate issues effectively

## Troubleshooting Frameworks

### Step 1: Identify the Standard

First, identify which standard is failing:

**SAML symptoms:**
- "SAML response validation failed"
- Redirect loops on login
- Applications using XML assertion

**OAuth/OIDC symptoms:**
- "invalid_client"
- "unauthorized_client"
- Authorization code not exchanged

**SCIM symptoms:**
- Users not provisioning
- "Invalid SCIM endpoint"
- Attribute mapping errors

### Step 2: Check Audit Logs

**Entra ID Audit Logs:**
1. Go to Entra ID → Audit logs
2. Filter by:
   - User: affected user
   - Application: failing app
   - Result: Failure only
3. Review error message (contains specific reason)

**Application Logs:**
- Check application's authentication logs
- Look for protocol errors or assertion validation failures
- Cross-reference with Entra ID logs by timestamp

### Step 3: Validate Configuration

**SAML:**
- Verify ACS URL matches exactly
- Check signing certificate validity
- Validate Entity ID matches

**OAuth/OIDC:**
- Verify redirect URI matches exactly
- Check application ID is correct
- Validate scopes are appropriate

### Step 4: Test in Isolation

- Test single user with non-production environment
- Rule out user-specific issues
- Verify configuration without users involved

## Common Issues and Solutions

### SAML Issues

| Issue | Diagnosis | Solution |
|-------|-----------|----------|
| "SAML response not valid" | Certificate issue | Re-download Entra ID certificate, ensure it's current |
| "Wrong NameID" | Identifier mapping incorrect | Verify Entra ID's NameID format matches app's expectation |
| "Assertion expired" | Clock skew between systems | Check server time sync (must be within 5 minutes) |
| "Invalid audience" | Entity ID mismatch | Verify Entra ID Entity ID matches app's configured value |
| "Invalid ACS URL" | Redirect URL changed | Update ACS URL in both Entra ID and app |
| "Infinite redirect loop" | Circular reference | Check if app redirects back to Entra ID on every request |

### OAuth/OIDC Issues

| Issue | Diagnosis | Solution |
|-------|-----------|----------|
| "invalid_client" | Client ID or secret wrong | Verify client ID and secret in app config |
| "unauthorized_client" | App not authorized for scopes | Grant admin consent or check app permissions |
| "Redirect URI mismatch" | Registered URI doesn't match | Ensure redirect URI is exactly the same (case-sensitive) |
| "Scope not granted" | Required scope not in token | Request scope in auth request or grant consent |
| "Token expired" | Access token lifetime exceeded | Use refresh token to get new access token |
| "Invalid signature" | Token tampered or wrong issuer | Use Entra ID's public key to validate, not custom key |

### SCIM Issues

| Issue | Diagnosis | Solution |
|-------|-----------|----------|
| "Test connection failed" | Endpoint or token invalid | Verify SCIM endpoint and token with app vendor |
| "User not created" | Scope filtering blocking user | Check that user matches provisioning scope |
| "Attributes not mapping" | Field names incorrect | Verify attribute names match app's schema |
| "401 Unauthorized" | Token expired or invalid | Regenerate and update SCIM token |

## Debugging Tools

### SAML Debugging

**1. SAML Validators (Online)**
- Copy SAML response from browser
- Paste in https://www.samltool.com/validate.php
- View decoded assertion

**2. Browser Developer Tools**
```
F12 → Network tab → Clear → Attempt login
Look for POST to ACS endpoint
Request body contains SAMLResponse parameter
Right-click → Copy value
Decode with SAML tool
```

**3. Logs**
```
Entra ID: Audit logs → Filter by app/user
App: Application logs (format varies)
Cross-reference timestamps between logs
```

### OAuth/OIDC Debugging

**1. JWT Debugger**
- Copy ID token or access token
- Paste in https://jwt.io/
- View claims in payload

**2. OIDC Provider Discovery**
- Visit https://login.microsoftonline.com/{tenant}/.well-known/openid-configuration
- Verify endpoints (token, authorization, userinfo)

**3. Logs**
```
Entra ID: Audit logs → Filter by app
App: Check OAuth logs for authorization attempts
Look for specific error codes (invalid_client, scope_mismatch)
```

### SCIM Debugging

**1. Provisioning Logs**
- Entra ID: Provisioning → Logs
- Filter by status (failure)
- Review error details

**2. API Testing**
```
curl -H "Authorization: Bearer {token}" \
  https://app.example.com/scim/v2/Users
```

## Monitoring Authentication Health

### Key Metrics

1. **Sign-in Success Rate:** Target 99%+
   - Alert if < 95% for any hour

2. **Standard-Specific Rates:**
   - SAML: Track ACS request success
   - OAuth/OIDC: Track authorization code exchanges
   - SCIM: Track successful provisioning operations

3. **Failed Authentication Trends:**
   - Alert if failures spike (suggests compromise or misconfiguration)
   - Investigate root cause

### KQL Queries (Azure Monitor)

```kusto
// SAML ACS failures
SigninLogs
| where AppDisplayName == "Salesforce"
| where Status.errorCode != "0"
| summarize count() by errorCode
| order by count_ desc

// OAuth token issues
SigninLogs
| where AuthenticationProtocol == "OAUTH2"
| where Status.errorCode != "0"
| summarize count() by Status.failureReason
```

### Alerts to Configure

- **Failed Sign-Ins for Production App:** > 10 failures in 5 minutes
- **SAML Certificate Expiring:** < 30 days to expiry
- **Provisioning Failures:** > 5 failures in provisioning job
- **Unusual Sign-In Patterns:** Geographic anomalies, time-of-day shifts

## Cross-Standard Scenarios

### Hybrid: SAML + OAuth

Some apps support both SAML (for sign-in) and OAuth (for API access):

```
User signs in: SAML flow
User accesses API: OAuth token required
App requests OAuth scopes: Authorization code flow
User authorizes: Consent screen
App gets access token: Can call Microsoft Graph
```

**Configuration:** Enable both SAML and OAuth in Entra ID app registration.

### Federation: Multi-Organization SAML

Partner organizations federate via SAML:

```
Partner user signs into your app
  → Redirected to your Entra ID
  → You redirect to partner's IdP (via SAML)
  → Partner authenticates user
  → Partner sends SAML assertion back
  → You validate and allow access
```

**Configuration:** SAML metadata federation between organizations.

## Escalation Path

When troubleshooting fails:

1. **Gather Information:**
   - Affected users and apps
   - Error messages (exact text)
   - Audit logs (screenshots)
   - Timeline (when started)

2. **Contact Vendor:**
   - For SaaS app issues: Contact app vendor support
   - Provide audit logs and error details
   - Mention standard (SAML, OAuth, SCIM)

3. **Contact Microsoft:**
   - For Entra ID issues: Submit support request
   - Provide audit logs, application ID, issue details
   - Include reproduction steps

## Compliance & Standards

Troubleshooting is part of operational compliance:
- **HIPAA:** Audit access failures monthly
- **PCI DSS:** Alert on authentication failures
- **SOC 2:** Document investigation procedures

## Related Documents

**Prerequisites:**
- All standards documents (09, 09a-09f)

**Next Steps:**
- [Audit & Compliance](./06b-governance-workflows.md) - Audit logging
- [Identity Risk Detection](./08-identity-risk-detection.md) - Threat detection

## FAQ

**Q: How quickly should we respond to authentication failures?**

A: Production auth failures should be investigated within 15 minutes, resolved within 1 hour.

**Q: Should we log all failed authentications?**

A: Yes. Set retention per compliance requirements (typically 90 days). Alert on spikes.

**Q: How do we handle vendor debugging requests?**

A: Provide audit logs (sanitized of sensitive data), error messages, and reproduction steps. Never share secrets or tokens.

## Next Steps

1. Set up monitoring dashboards for authentication health
2. Configure alerts for critical thresholds
3. Document troubleshooting procedures
4. Train support team on debugging tools
5. Review authentication logs weekly

Robust troubleshooting reduces mean time to recovery (MTTR) and improves user experience.
