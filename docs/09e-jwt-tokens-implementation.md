---
title: JWT Token Implementation - Securing APIs with Tokens
part: 3
section: Standards & Protocols
difficulty: Intermediate
estimated_reading_time: 35
estimated_lab_time: 45
prerequisites:
  - 09-identity-standards-overview.md
  - 09b-oauth-and-openid-connect.md
learning_objectives:
  - Understand JWT structure and claims
  - Validate JWT tokens in applications
  - Implement token-based API security
  - Handle token expiration and refresh
  - Troubleshoot JWT issues
---

# JWT Token Implementation: Securing APIs with Tokens

## Introduction

JWT (JSON Web Token) is the standard for stateless authentication in modern APIs. When a user authenticates, Entra ID issues a JWT token containing identity and permission information. The client includes this token in API requests, and the API validates the token signature without querying a database. This stateless approach scales to millions of API calls. This document explains JWT structure, validation, and implementation best practices.

**Learning Objectives:**
- Understand JWT format and components
- Validate JWT tokens in APIs
- Implement token-based authorization
- Handle token lifecycle (expiration, refresh)
- Debug JWT issues

## JWT Structure

JWT consists of three base64-encoded parts separated by dots:

```
eyJhbGciOiJSUzI1NiIsImtpZCI6IktvSE1fXlNVVng1VVVnY3o3QTBkVU5FclBzWmdYZXJ2TDFRCi4gLS1FTkQgQ0VSVElGSUNBVEUtLS0=.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

**Three parts:**

**1. Header:** Algorithm and token type
```json
{
  "alg": "RS256",      // Algorithm (RS256 = RSA + SHA256)
  "typ": "JWT",        // Type
  "kid": "key-id"      // Key ID (which signing key was used)
}
```

**2. Payload:** Claims (identity, permissions)
```json
{
  "aud": "application-id",     // Audience (who this token is for)
  "iss": "https://sts.windows.net/...",  // Issuer
  "iat": 1516239022,           // Issued at
  "exp": 1516242622,           // Expiration
  "sub": "user-id",            // Subject (user ID)
  "name": "John Smith",        // User name
  "email": "john@contoso.com", // Email
  "groups": ["finance", "engineers"],  // Group membership
  "appid": "app-id"            // Authorized app
}
```

**3. Signature:** HMAC or RSA signature
```
HMAC-SHA256(base64(header) + "." + base64(payload), secret)
```

## JWT Validation

When API receives JWT, it must validate:

1. **Signature:** Token signed by trusted issuer (Entra ID)
2. **Audience:** Token is for this application (not another app)
3. **Issuer:** Token issued by trusted issuer
4. **Expiration:** Token hasn't expired
5. **Claims:** Token contains required claims

### Signature Validation

APIs validate signature using issuer's public key:

```javascript
const jwt = require('jsonwebtoken');

// Get Entra ID's public key (from OpenID metadata)
const publicKey = `-----BEGIN CERTIFICATE-----
MIIDXTCCAkWgAwIBAgIJAKc6 ...
-----END CERTIFICATE-----`;

// Verify token
const decoded = jwt.verify(token, publicKey, {
  algorithms: ['RS256'],
  audience: 'my-app-id',
  issuer: 'https://sts.windows.net/tenant-id/'
});

// Token is valid, use decoded claims
console.log(decoded.email, decoded.groups);
```

### Token Validation Checklist

```
☐ Signature valid (token signed by trusted issuer)
☐ Not expired (current time < exp claim)
☐ Correct audience (token's aud == this app)
☐ Correct issuer (token's iss == trusted issuer)
☐ Required claims present (email, groups, etc.)
```

## Implementing Token-Based API Security

Example: Secure REST API that requires authorization:

```javascript
// Node.js with Express and JWT validation

const express = require('express');
const jwt = require('jsonwebtoken');
const axios = require('axios');

const app = express();

// Middleware to validate JWT
app.use(async (req, res, next) => {
  // Get token from Authorization header
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'No token provided' });
  }

  try {
    // Get Entra ID public key
    const response = await axios.get(
      'https://login.microsoftonline.com/common/discovery/v2.0/keys'
    );
    const key = response.data.keys[0];

    // Verify token
    const decoded = jwt.verify(token, key, {
      algorithms: ['RS256'],
      audience: 'my-app-id'
    });

    // Token valid, attach to request
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid token', details: error.message });
  }
});

// Protected endpoint
app.get('/api/profile', (req, res) => {
  res.json({
    user: req.user.email,
    groups: req.user.groups
  });
});

app.listen(3000);
```

## Token Lifecycle: Expiration and Refresh

Access tokens are short-lived (typically 1 hour) for security. Refresh tokens enable long-lived sessions:

**Access Token Lifecycle:**
```
User signs in
  → Entra ID issues access token (1 hour) + refresh token (7-90 days)
  → Access token used to call APIs
  → Access token expires after 1 hour
  → Client uses refresh token to get new access token (no re-login)
  → Refresh token expires after 7-90 days
  → User must sign in again
```

**Token Refresh Flow:**

```javascript
// When access token expires
const newTokens = await axios.post(
  'https://login.microsoftonline.com/tenant-id/oauth2/v2.0/token',
  {
    grant_type: 'refresh_token',
    refresh_token: refreshToken,
    client_id: 'my-app-id',
    client_secret: 'my-secret'
  }
);

// Use new access token
const newAccessToken = newTokens.data.access_token;
```

## Common JWT Issues and Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| "Invalid signature" | Wrong public key or token tampered | Verify using Entra ID's public key (not self-signed) |
| "Token expired" | exp claim < current time | Refresh token using refresh_token grant |
| "Invalid audience" | Token's aud != app's ID | Verify audience in token matches app registration |
| "Missing claim" | Token doesn't contain required claim | Check that app requested scopes that provide claim |
| "Wrong issuer" | Issuer is not trusted Entra ID | Verify issuer URL matches https://sts.windows.net/... |

## JWT Best Practices

1. **Always validate signature** - Never trust unsigned tokens
2. **Use short expiration** - Access tokens should expire in 1-2 hours
3. **Store tokens securely** - Never in localStorage; use httpOnly cookies or secure storage
4. **Refresh tokens safely** - Use refresh tokens with server-side validation
5. **Include minimal claims** - Request only scopes needed, not all possible data
6. **Monitor expiration** - Log token expirations to detect issues
7. **Rotate public keys** - Entra ID rotates keys; cache with TTL, don't hard-code
8. **Validate on every request** - Don't cache validation result

## Compliance & Standards

**Standards:**
- **RFC 7519:** JWT specification
- **IETF:** JWT security considerations

**Compliance:** HIPAA, PCI DSS, SOC 2 all support JWT for API authentication

## Related Documents

**Prerequisites:**
- [OAuth and OpenID Connect](./09b-oauth-and-openid-connect.md) - OAuth/OIDC context
- [Identity Standards Overview](./09-identity-standards-overview.md) - Standards overview

**Next Steps:**
- [Emerging Standards](./09f-emerging-standards.md) - Modern authentication directions

## Further Reading

**JWT Resources:**
- [JWT.io - Token debugger](https://jwt.io/) (paste token to inspect claims)
- [RFC 7519: JSON Web Token](https://tools.ietf.org/html/rfc7519)

**Microsoft Docs:**
- [Access Tokens in Microsoft Identity Platform](https://learn.microsoft.com/en-us/entra/identity-platform/access-tokens)

## FAQ

**Q: Should we use JWT or session cookies?**

A: JWT for APIs (stateless), cookies for web apps (simpler session management). Many apps use both.

**Q: How do we securely store refresh tokens?**

A: Server-side in secure, encrypted storage. Never expose to client if possible.

**Q: Can we extend token lifetime without re-login?**

A: Yes, use refresh tokens. Extend lifetime without requiring user password.

**Q: What if public key rotates?**

A: Download key metadata periodically (cache with TTL). Entra ID rotates keys every 24 hours.

## Next Steps

1. Implement JWT validation in all APIs
2. Set up token refresh mechanism
3. Monitor token expiration issues
4. Implement proper token storage
5. Test token lifecycle scenarios

JWT is the modern API security standard. Master it and your APIs are secure and scalable.
