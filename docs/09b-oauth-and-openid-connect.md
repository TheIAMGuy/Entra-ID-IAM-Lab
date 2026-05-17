---
title: OAuth 2.0 and OpenID Connect - Modern Authentication Protocols
part: 3
section: Standards & Protocols
difficulty: Intermediate
estimated_reading_time: 50
estimated_lab_time: 75
prerequisites:
  - 09-identity-standards-overview.md
  - 07-authentication-fundamentals.md
learning_objectives:
  - Understand OAuth 2.0 protocol and authorization flows
  - Understand OpenID Connect (OIDC) for authentication
  - Know when to use OAuth vs. OIDC
  - Implement authorization code flow (most common)
  - Understand scopes and consent
  - Configure OAuth applications in Microsoft Entra ID
---

# OAuth 2.0 and OpenID Connect: Modern Authentication Protocols

## Introduction

OAuth 2.0 and OpenID Connect (OIDC) are the standards powering modern web and mobile applications. Every time you "Sign in with Google" or "Sign in with Microsoft," you're using OAuth + OIDC. OAuth handles authorization (delegated access), OIDC adds the identity layer on top. Understanding these protocols is essential for modern application architecture. This document explains OAuth and OIDC fundamentals, protocol flows, and implementation in Microsoft Entra ID.

**Learning Objectives:**
- Understand OAuth 2.0 authorization flows
- Understand OpenID Connect for user authentication
- Know the differences and when to use each
- Implement authorization code flow (web apps)
- Understand scopes, consent, and token management
- Configure OAuth/OIDC applications in Entra ID

## OAuth 2.0 Fundamentals

OAuth is NOT an authentication protocol; it's an authorization protocol. It answers "What can you access?" not "Who are you?"

### OAuth Problem It Solves

**Before OAuth:** User gives third-party app their Google/Facebook password. App stores password. App can access everything user can access. Privacy nightmare and security risk.

**With OAuth:** User never gives password to third-party app. Instead, user authorizes the app at Google/Facebook, gets a token, gives token to app. App can only access what user authorized. User can revoke access anytime without changing password.

### OAuth 2.0 Parties

**Resource Owner:** The user who owns the data (you)
**Authorization Server:** Issues tokens when user approves (Entra ID, Google, Facebook)
**Client:** The application requesting access (Slack, third-party app)
**Resource Server:** The API containing user data (Office 365 API, Google Calendar API)

### OAuth 2.0 Flow (Authorization Code)

This is the most common flow for web applications:

```
User → (clicks "Connect to Google") → Third-party app
  ← (redirects to Google) ←
User → (signs in, approves permissions) → Google (Authorization Server)
  ← (returns authorization code) ←
App → (exchanged code for access token) → Google
  ← (grants access token) ←
App → (uses token to access calendar) → Google API
  ← (returns calendar data) ←
User ← (calendar displayed in app) ←
```

**Key points:**
- User sees authorization server (Google)
- User explicitly approves what app can access
- App gets token (not password)
- Token has limited scope and lifetime
- User can revoke access anytime

## OpenID Connect (OIDC) Fundamentals

OpenID Connect is an identity layer on top of OAuth 2.0. It adds user authentication (who you are) to OAuth's authorization (what you can access).

### OIDC Problem It Solves

OAuth doesn't tell you who the user is. You need an **ID Token** in addition to access token.

**ID Token:** Contains user identity information (name, email, user ID)
**Access Token:** Contains authorization scope (what user can access)

### OIDC vs. OAuth

| Aspect | OAuth 2.0 | OIDC |
|--------|-----------|------|
| **Purpose** | Authorization (what you can access) | Authentication + Authorization |
| **Token types** | Access token | Access token + ID token |
| **What you know** | What user can access | Who the user is + what they can access |
| **Best for** | API access, delegation | User login, authentication |
| **Use with...** | APIs, service accounts | Web apps, mobile apps, user sign-in |

### OIDC Flow

```
User → (clicks login) → Web app
  ← (redirects to Entra ID) ←
User → (signs in) → Entra ID
  ← (returns authorization code) ←
App → (exchanges code for tokens) → Entra ID
  ← (grants ID token + access token) ←
App → (reads ID token) → identifies user
App → (uses access token) → (can call APIs on behalf of user)
```

**ID Token contains (JWT format):**
```json
{
  "aud": "my-app-id",
  "iss": "https://login.microsoftonline.com/...",
  "iat": 1234567890,
  "exp": 1234567890,
  "sub": "user-id",
  "name": "John Smith",
  "email": "john@contoso.com",
  "oid": "object-id",
  "tid": "tenant-id"
}
```

## Scopes and Permissions

Scopes define what an application can access. User approves scopes explicitly.

### Common Scopes

```
openid          - Basic OpenID (required for authentication)
profile         - User's name, picture
email           - User's email address
offline_access  - Refresh tokens (long-lived access)

Microsoft Graph:
User.Read              - Read basic user profile
Calendar.Read          - Read user's calendar
Mail.Send              - Send emails on behalf of user
Directory.Read.All     - Read entire directory (admin only)
```

### Incremental Consent

Apps can request additional scopes later. First login requests minimal scopes, subsequent actions request additional scopes as needed.

**Example:**
```
First login: Request openid, profile, email
Later: "Allow to access your calendar?" → Requests Calendar.Read scope
Later: "Allow to send emails?" → Requests Mail.Send scope
```

## Configuring OAuth/OIDC in Microsoft Entra ID

### Step 1: Register Application

1. In Entra ID, go to **App registrations**
2. Click **+ New registration**
3. **Name:** My Application
4. **Supported account types:** Choose based on audience
   - Single tenant (this organization only)
   - Multi-tenant (any organization)
   - Personal Microsoft accounts only
5. **Redirect URI:** Where to return after login
   - Example: `https://localhost:3000/auth/callback` (development)
   - Example: `https://myapp.com/auth/callback` (production)
6. Click **Register**

### Step 2: Configure Application Credentials

1. Go to **Certificates & secrets**
2. Click **+ New client secret**
3. **Description:** "API secret for web app"
4. **Expires:** Choose expiration (6-12 months recommended)
5. Click **Add**
6. **Copy the secret value immediately** (won't be visible again)

**Note:** For public clients (mobile, SPA), use certificates instead of secrets for better security.

### Step 3: Configure Redirect URIs

1. Go to **Authentication**
2. Add **Redirect URIs:**
   - Development: `http://localhost:3000/callback`
   - Production: `https://myapp.com/callback`
3. Configure **Advanced settings:**
   - **Allow public client flows:** Enable if needed for mobile/SPA
4. Save

### Step 4: Configure API Permissions

1. Go to **API permissions**
2. Click **+ Add a permission**
3. Select **Microsoft Graph**
4. Select **Delegated permissions** (for user-based access)
   - User.Read (read basic profile)
   - Calendar.Read (read calendar)
   - Mail.Send (send emails)
5. Click **Add permissions**
6. Click **Grant admin consent** (if you're admin)

### Step 5: Implement in Application Code

Example with Node.js and express:

```javascript
// Install required packages:
// npm install passport passport-oauth2 microsoft-identity-web

const { PublicClientApplication } = require('@azure/msal-node');

const config = {
  auth: {
    clientId: "application-id",
    authority: "https://login.microsoftonline.com/common",
    clientSecret: "your-secret-here"
  }
};

const pca = new PublicClientApplication(config);

// Authorization code flow
app.post('/auth/callback', async (req, res) => {
  const tokenRequest = {
    code: req.body.code,
    scopes: ["user.read"],
    redirectUri: "https://myapp.com/auth/callback",
  };

  try {
    const response = await pca.acquireTokenByCode(tokenRequest);
    // Use accessToken to call APIs
    // User info is in response.account
  } catch (error) {
    console.error("Token acquisition failed:", error);
  }
});
```

## Hands-On Lab: Implementing OAuth/OIDC

**Estimated Time:** 75 minutes

**Prerequisites:** Entra ID tenant, Node.js or Python environment

**Lab Objectives:**
- Register application in Entra ID
- Implement authorization code flow
- Test token acquisition
- Inspect ID token contents

### Step 1: Register Application in Entra ID (15 minutes)

1. Go to Entra ID → App registrations → New registration
2. **Name:** OAuth OIDC Test App
3. **Redirect URI:** `http://localhost:3000/auth/callback`
4. **Register**
5. Copy **Application ID** and **Directory ID** (tenant ID)
6. Go to **Certificates & secrets**
7. Create **New client secret** with 6-month expiration
8. Copy secret value

**Expected Output:**
```
Application registered successfully
Application ID: [guid]
Tenant ID: [guid]
Client secret: [secret-value]
Redirect URI: http://localhost:3000/auth/callback
```

### Step 2: Configure API Permissions (10 minutes)

1. Go to app's **API permissions**
2. Click **Add a permission**
3. Select **Microsoft Graph**
4. **Delegated permissions:**
   - Search for "User.Read"
   - Check User.Read
5. **Add permissions**
6. **Grant admin consent** (if admin)

**Expected Output:**
```
Permissions configured:
- Microsoft Graph: User.Read (delegated)
Admin consent: Granted
```

### Step 3: Implement Authorization Code Flow (30 minutes)

Create Node.js application:

```javascript
// app.js
const express = require('express');
const axios = require('axios');
const session = require('express-session');

const app = express();
app.use(session({ secret: 'secret', resave: false, saveUninitialized: true }));

const config = {
  clientId: 'YOUR_APP_ID',
  clientSecret: 'YOUR_CLIENT_SECRET',
  tenantId: 'YOUR_TENANT_ID',
  redirectUri: 'http://localhost:3000/auth/callback'
};

// Step 1: Redirect to Entra ID for login
app.get('/login', (req, res) => {
  const authUrl = 
    `https://login.microsoftonline.com/${config.tenantId}/oauth2/v2.0/authorize?` +
    `client_id=${config.clientId}&` +
    `redirect_uri=${encodeURIComponent(config.redirectUri)}&` +
    `response_type=code&` +
    `scope=${encodeURIComponent('openid profile email User.Read')}&` +
    `response_mode=query`;
  
  res.redirect(authUrl);
});

// Step 2: Handle callback and exchange code for token
app.get('/auth/callback', async (req, res) => {
  const code = req.query.code;
  
  try {
    // Exchange code for token
    const tokenResponse = await axios.post(
      `https://login.microsoftonline.com/${config.tenantId}/oauth2/v2.0/token`,
      {
        client_id: config.clientId,
        client_secret: config.clientSecret,
        code: code,
        redirect_uri: config.redirectUri,
        grant_type: 'authorization_code',
        scope: 'User.Read'
      }
    );

    const { access_token, id_token } = tokenResponse.data;
    
    // Decode ID token (in production, validate signature)
    const parts = id_token.split('.');
    const payload = JSON.parse(Buffer.from(parts[1], 'base64').toString());
    
    // Store tokens in session
    req.session.user = payload;
    req.session.accessToken = access_token;
    
    res.redirect('/profile');
  } catch (error) {
    console.error('Token exchange failed:', error);
    res.status(500).send('Authentication failed');
  }
});

// Step 3: Display user profile
app.get('/profile', (req, res) => {
  if (!req.session.user) {
    return res.redirect('/login');
  }
  
  const user = req.session.user;
  res.send(`
    <h1>Welcome ${user.name}</h1>
    <p>Email: ${user.email}</p>
    <p>User ID: ${user.sub}</p>
    <a href="/logout">Logout</a>
  `);
});

app.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
  console.log('Visit http://localhost:3000/login to start');
});
```

### Step 4: Test the Flow (15 minutes)

1. Run: `node app.js`
2. Visit: `http://localhost:3000/login`
3. Redirected to Entra ID login
4. Enter credentials
5. Approve permissions (if prompted)
6. Redirected back to `/profile`
7. Display shows your profile information

**Expected Output:**
```
Welcome John Smith
Email: john@contoso.com
User ID: [object-id]
[Logout button]
```

### Step 5: Inspect ID Token (10 minutes)

1. In browser console (F12)
2. View network traffic
3. Find POST to `/token` endpoint
4. Copy ID token from response
5. Use online JWT decoder: https://jwt.io/
6. Paste token and view claims

**Expected Output:**
```json
{
  "header": {
    "alg": "RS256",
    "typ": "JWT",
    "kid": "..."
  },
  "payload": {
    "aud": "your-app-id",
    "iss": "https://login.microsoftonline.com/your-tenant-id/v2.0",
    "iat": 1234567890,
    "exp": 1234567890,
    "sub": "user-object-id",
    "name": "John Smith",
    "email": "john@contoso.com",
    "oid": "user-id",
    "tid": "tenant-id"
  },
  "signature": "..."
}
```

## OAuth/OIDC Security Best Practices

1. **Always validate ID token signature** (in production)
2. **Use HTTPS** (never HTTP for production)
3. **Store tokens securely** (never in localStorage; use secure cookies)
4. **Use short-lived tokens** (access token ~1 hour)
5. **Implement refresh tokens** for long-lived sessions
6. **Request minimal scopes** (principle of least privilege)
7. **Use PKCE** (Proof Key for Code Exchange) for SPAs and mobile apps
8. **Never expose client secret** (server-side only)

## Compliance & Standards Alignment

**Standards:**
- **RFC 6749:** OAuth 2.0 Authorization Framework
- **RFC 6750:** OAuth 2.0 Bearer Token Usage
- **OpenID Connect Core 1.0**

**Compliance:**
- NIST: OAuth recommended for API access
- HIPAA, PCI DSS, SOC 2: OAuth/OIDC acceptable

## Related Documents

**Prerequisites:**
- [Identity Standards Overview](./09-identity-standards-overview.md) - Standards context
- [Authentication Fundamentals](./07-authentication-fundamentals.md) - Auth basics

**Next Steps:**
- [SCIM Provisioning](./09c-scim-provisioning.md) - Automated provisioning
- [JWT Tokens](./09e-jwt-tokens-implementation.md) - Token implementation

## Further Reading

**Official Specifications:**
- [RFC 6749: OAuth 2.0 Authorization Framework](https://tools.ietf.org/html/rfc6749)
- [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html)

**Microsoft Documentation:**
- [OAuth 2.0 in Microsoft Identity Platform](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-auth-code-flow)
- [OIDC Implementation](https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc)

## FAQ

**Q: Should we use OAuth or OIDC?**

A: Use OIDC for user authentication (web/mobile apps). Use OAuth for API access or delegation. Most modern apps use OIDC + OAuth together.

**Q: What's the difference between access token and ID token?**

A: ID token identifies the user. Access token authorizes API access. Request both: `scope=openid profile User.Read`.

**Q: How long are tokens valid?**

A: Access tokens: 1 hour (short-lived). ID tokens: 1 hour. Refresh tokens: days/weeks (long-lived). Configure based on security needs.

**Q: Can we use OAuth for desktop applications?**

A: Yes, with Authorization Code + PKCE flow. Recommended for modern desktop apps.

**Q: Is client secret required?**

A: For server-side apps: yes. For browser-based SPA or mobile: no (use PKCE instead). Never expose secrets in client-side code.

## Next Steps

1. Register your application in Entra ID
2. Implement authorization code flow
3. Request appropriate scopes
4. Validate tokens in your application
5. Implement logout (revoke tokens)
6. Test refresh token flow for long-lived sessions

OAuth 2.0 and OIDC are the modern standards. Master them for secure, user-friendly authentication.
