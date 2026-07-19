---
title: API Security & Authentication Best Practices
part: 3
section: Standards & Protocols
difficulty: Advanced
estimated_reading_time: 35
estimated_lab_time: 45
prerequisites:
  - 09b-oauth-and-openid-connect.md
  - 09e-jwt-tokens-implementation.md
learning_objectives:
  - Implement OAuth 2.0 for API access
  - Secure APIs with token validation
  - Implement rate limiting and abuse detection
  - Design API scopes and permissions
  - Audit and monitor API access
---

# API Security & Authentication Best Practices

## Introduction

Modern applications expose APIs that third-party apps, mobile clients, and partners consume. These APIs must be secured: authenticated (proving who's calling) and authorized (ensuring they can do what they're requesting). OAuth 2.0 and JWT are the standards. This document provides practical guidance for securing APIs in production.

**Learning Objectives:**
- Implement OAuth 2.0 for API access
- Validate tokens in APIs
- Implement rate limiting
- Design secure API scopes
- Monitor and audit API access

## API Authentication Architecture

**Three-Layer Security:**

**Layer 1: Transport Security**
- HTTPS only (TLS 1.2+)
- No HTTP
- Certificate validation

**Layer 2: Authentication**
- OAuth 2.0 tokens
- JWT validation
- Certificate pinning (mobile)

**Layer 3: Authorization**
- Scopes (what can be accessed)
- RBAC (role-based access)
- Resource-level checks

## OAuth 2.0 for APIs

**API Access Flow:**

```
Client App → "Need access to user's calendar" → Entra ID
User → Approves permissions → Entra ID
Entra ID → Issues access token → Client
Client → Includes token in API calls → Calendar API
API → Validates token, grants access → Returns data
```

**Best Practices:**

1. **Request Minimal Scopes:** Only request permissions needed
2. **Validate Scope Claims:** API checks token contains required scope
3. **Use Refresh Tokens:** For long-lived client access
4. **Implement Consent Screens:** Show users what permissions are requested

## Token Validation in APIs

**Checklist for API:**

```
Incoming request with token:
☐ Token format valid (Bearer {token})
☐ Token signature valid (using issuer's key)
☐ Token not expired (exp claim)
☐ Token issued by trusted issuer (iss claim)
☐ Token is for this API (aud claim)
☐ Token contains required scopes
☐ User (sub) is not blocked/suspended
```

**Example validation (Node.js):**

```javascript
const jwt = require('jsonwebtoken');

async function validateToken(req, res, next) {
  const token = req.headers.authorization?.split(' ')[1];
  
  if (!token) return res.status(401).json({ error: 'No token' });
  
  try {
    // Get public key from Entra ID
    const publicKey = await getEntraIdPublicKey();
    
    // Verify
    const decoded = jwt.verify(token, publicKey, {
      audience: 'api://my-api',
      issuer: 'https://sts.windows.net/tenant-id/'
    });
    
    // Check scope
    if (!decoded.scp.includes('calendar.read')) {
      return res.status(403).json({ error: 'Missing scope' });
    }
    
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid token' });
  }
}
```

## Rate Limiting & Abuse Detection

**Rate Limiting:**

```
Per-token rate limits:
- Standard user: 10,000 requests/day, 100/minute
- Service account: 1,000,000 requests/day, 1,000/minute
- Partner: 100,000 requests/day (negotiated)

Track by: token's sub (user) or client ID
Return HTTP 429 when exceeded
Include Retry-After header
```

**Implementation (Express + Redis):**

```javascript
const redis = require('redis');
const rateLimit = require('express-rate-limit');

const client = redis.createClient();

app.use(rateLimit({
  store: new RedisStore({ client }),
  keyGenerator: (req) => req.user.sub, // Rate limit by user ID
  windowMs: 60 * 1000, // 1 minute
  max: 100 // 100 requests per minute
}));
```

**Abuse Detection:**

```
Alert if:
- Sudden spike in requests (2x normal)
- Failed authentication attempts (>10 in 5 min)
- Requests with invalid tokens
- Geographic anomalies (request from unusual location)

Automatic actions:
- Temporary token suspension
- Notify user of suspicious activity
- Require re-authentication
```

## API Scope Design

**Good Scope Design:**

```
Calendar.Read          - Read user's calendar
Calendar.ReadWrite     - Read and modify calendar
Mail.Send              - Send emails
Directory.Read.All     - Read directory (admin only)
User.Read              - Read basic profile
```

**Principles:**

1. **Granular:** Separate read, write, delete
2. **Hierarchical:** calendar.read, calendar.readwrite
3. **Admin-Only:** Restrict sensitive scopes
4. **Time-Limited:** Scopes valid for limited time

## Monitoring & Auditing API Access

**Metrics to Track:**

1. **API Usage:** Requests per app, per scope, per user
2. **Error Rates:** Authentication failures, authorization denials
3. **Token Lifetime:** Average token age before refresh
4. **Abuse Indicators:** Rate limit hits, suspicious patterns

**Audit Trail:**

```
Log every API access:
- User/app making request
- Scope used
- Resource accessed
- Request timestamp
- Response code

Retention: 90+ days
Searchable: By user, app, scope, or date range
```

**KQL Queries (Azure Monitor):**

```kusto
// API usage by app
AppDependencies
| where DependencyName contains "api"
| summarize count() by AppId, OperationName
| order by count_ desc

// Failed authentications
AppDependencies
| where Result == "Failure"
| summarize count() by Client_s
| where count_ > 10
```

## Security Headers for APIs

**HTTP Response Headers:**

```
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
Strict-Transport-Security: max-age=31536000
Cache-Control: no-store
```

## Compliance & Standards

**Standards:**
- **RFC 6750:** Bearer Token Usage (required for APIs)
- **RFC 6819:** OAuth 2.0 Security Considerations

**Compliance:**
- **HIPAA:** Log all API access to health data
- **PCI DSS:** Rate limit and monitor payment APIs
- **SOC 2:** Document API security controls

## Related Documents

**Prerequisites:**
- [OAuth and OpenID Connect](./09b-oauth-and-openid-connect.md) - OAuth fundamentals
- [JWT Tokens](./09e-jwt-tokens-implementation.md) - Token validation

## FAQ

**Q: Should APIs use HTTPS only?**

A: Yes, always. Never HTTP. Use TLS 1.2+.

**Q: How long should access tokens live?**

A: 1-2 hours for user tokens, 1-24 hours for service account tokens.

**Q: What if a token is compromised?**

A: Token is short-lived (1-2 hours). For service accounts, rotate secret immediately.

**Q: Should we log tokens in audit logs?**

A: No, never log full tokens. Log token hash or masked value only.

## Next Steps

1. Implement OAuth 2.0 for all APIs
2. Add token validation to every endpoint
3. Configure rate limiting
4. Set up audit logging
5. Monitor API health and abuse patterns

Secure APIs are the foundation of modern applications.
