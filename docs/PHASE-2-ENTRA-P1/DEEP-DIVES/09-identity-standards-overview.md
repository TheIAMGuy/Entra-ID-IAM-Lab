---
title: Identity Standards & Protocols Overview
part: 3
section: Standards & Protocols
difficulty: Foundation
estimated_reading_time: 40
estimated_lab_time: N/A
prerequisites:
  - 05-sso-and-application-provisioning.md
  - 07-authentication-fundamentals.md
learning_objectives:
  - Understand major identity standards and protocols
  - Learn the differences between SAML, OAuth, and OIDC
  - Understand SCIM for user provisioning
  - Know when to use each standard
  - Understand how standards enable interoperability
---

# Identity Standards & Protocols Overview

## Introduction

Identity management exists in a complex ecosystem of applications, systems, and vendors. Organizations need users to sign in to dozens (or hundreds) of applications: SaaS apps, custom applications, partner systems, legacy on-premises systems. Without standards, each application would need its own identity system, username/password database, and user management process. Standards solve this: SAML, OAuth, OIDC, SCIM, and LDAP are open protocols that allow any application to authenticate users against any identity provider. Microsoft Entra ID implements all major standards, enabling you to authenticate against Entra ID from nearly any system. This document surveys the major standards, explains their purposes, and guides you toward the right standard for each scenario.

**Learning Objectives:**
- Understand the 17 major identity standards and protocols
- Know when to use each standard (SAML vs. OAuth vs. OIDC vs. SCIM)
- Understand protocol flows at a high level
- Learn how standards enable interoperability
- Navigate to detailed standards documentation

## The Landscape of Identity Standards

Modern identity relies on roughly 15-20 standards and protocols. This section maps them by purpose.

### Authentication Standards (User Sign-In)

These standards handle user authentication: proving who you are.

**SAML 2.0 (Security Assertion Markup Language)**
- **Purpose:** Enterprise single sign-on (SSO)
- **Transport:** XML-based assertions, HTTP redirects
- **Best for:** Enterprise applications, traditional SaaS
- **Parties:** Identity Provider (Entra ID), Service Provider (app)
- **Flow:** User logs into Entra ID → redirected to app with SAML assertion → app logs user in

**OAuth 2.0 (Open Authorization)**
- **Purpose:** Delegated authorization (not authentication, though often used for both)
- **Transport:** JSON tokens, HTTP redirects
- **Best for:** Third-party app access to your data
- **Example:** "Allow Slack to access your Google Calendar"
- **Key idea:** User grants app permission without sharing password

**OpenID Connect (OIDC)**
- **Purpose:** Authentication layer on top of OAuth 2.0
- **Transport:** JSON tokens
- **Best for:** Modern web and mobile apps
- **Parties:** Identity Provider, Client app
- **Key difference from OAuth:** OIDC includes identity (who you are), OAuth only includes authorization (what you can do)

### Provisioning Standards (User Creation & Management)

These standards handle user account creation, updates, and removal.

**SCIM (System for Cross-Domain Identity Management)**
- **Purpose:** Automated user provisioning and deprovisioning
- **Transport:** REST API, JSON
- **Best for:** Cloud SaaS applications, connecting multiple systems
- **Flow:** New user hired → HR system updates → SCIM syncs to all connected apps → user accounts auto-created

**LDAP (Lightweight Directory Access Protocol)**
- **Purpose:** Directory services (user lookup, attribute queries)
- **Transport:** Binary protocol over TCP
- **Best for:** On-premises directory synchronization
- **Traditional use:** On-premises user directory (Active Directory is LDAP-based)

### Token Standards (Security & Verification)

These standards define how tokens are created, verified, and used.

**JWT (JSON Web Token)**
- **Purpose:** Stateless security tokens for authentication/authorization
- **Transport:** Base64-encoded JSON
- **Best for:** APIs, microservices, stateless applications
- **Key idea:** Token contains identity and permissions; no server lookup needed

**SAML Assertions**
- **Purpose:** Security assertions in SAML flows
- **Transport:** XML
- **Role:** Carries authentication and attribute information

### Directory & Attribute Standards

**X.500 / X.501 (Distinguished Names)**
- **Purpose:** Standardized user identification and naming
- **Examples:** `CN=John Smith,OU=Finance,DC=contoso,DC=com`

**Schema Standards (LDAP Schema, SCIM Schema)**
- **Purpose:** Define what user attributes exist and how they're named
- **Example:** "user" schema has firstName, lastName, email attributes

### Emerging/Specialized Standards

**FIDO2 (Fast IDentity Online 2)**
- **Purpose:** Passwordless, phishing-resistant authentication
- **Transport:** Cryptographic keys (USB devices, biometric)

**OpenID Connect Federation**
- **Purpose:** Cross-organizational authentication (B2B scenarios)
- **Example:** "Login with your company account" across organizations

**SPIFFE/SPIRE (Secure Production Identity Framework For Everyone)**
- **Purpose:** Machine identity and service-to-service authentication
- **Best for:** Kubernetes, microservices, container environments

## SAML vs. OAuth vs. OIDC: Choosing the Right Standard

This is the most common question: when should I use SAML, OAuth, or OIDC?

### SAML 2.0 (SSO for Enterprise Apps)

**Use SAML when:**
- Traditional enterprise SaaS application (Salesforce, ServiceNow, Workday)
- You need SP-initiated SSO (app initiates login)
- You need strict XML-based assertions with digital signatures
- Application explicitly supports SAML

**Strengths:**
- Proven, stable standard (since 2005)
- Widely supported in enterprise SaaS
- Strong XML-based security

**Weaknesses:**
- XML is verbose (larger messages)
- Complex configuration
- Poor mobile experience (HTTP redirects don't work well on mobile)
- Requires service provider to request Assertion Consumer Service (ACS) endpoint

**Example flow:**
```
User → (clicks login) → SaaS App
  ← (redirects to Entra ID) ←
User → (enters credentials) → Entra ID
  ← (creates SAML assertion, redirects back) ←
User → (presents SAML assertion) → SaaS App
  ← (validates assertion, logs user in) ←
```

### OAuth 2.0 (Delegated Authorization)

**Use OAuth when:**
- Third-party app needs access to your data (not authentication)
- Example: "Allow Slack to read my Google Calendar"
- Mobile app needs API access
- You're building an API and need to control access

**Strengths:**
- Designed for delegation (not identity)
- Mobile-friendly (fewer redirects)
- Simpler than SAML
- Perfect for APIs

**Weaknesses:**
- Not designed for user authentication (doesn't tell you who logged in)
- Requires additional work to get user identity (needs ID token via OIDC)
- Less support in legacy enterprise SaaS

**Example flow:**
```
User → (clicks "Connect to Google") → Third-party app
  ← (redirects to Google) ←
User → (confirms "Allow app to access calendar?") → Google
  ← (returns authorization code) ←
App → (exchanges code for access token) → Google
  ← (grants token) ←
App → (uses token to access calendar) → Google API
```

### OpenID Connect (OIDC) (Modern Web & Mobile)

**Use OIDC when:**
- Modern web app (React, Vue, Angular)
- Mobile app (iOS, Android)
- You need both authentication AND authorization
- Application explicitly supports OpenID Connect

**Strengths:**
- Modern standard (built on OAuth 2.0)
- Perfect for user authentication
- Simpler than SAML
- Excellent mobile support
- JSON instead of XML

**Weaknesses:**
- Newer than SAML (less legacy support)
- Less support in older enterprise SaaS
- Requires understanding of OAuth concepts

**Example flow:**
```
User → (clicks login) → Modern web app
  ← (redirects to Entra ID) ←
User → (enters credentials) → Entra ID
  ← (returns authorization code) ←
App → (exchanges code for ID token + access token) → Entra ID
  ← (grants tokens) ←
App → (user logged in with ID token, can use access token for APIs) →
```

### Decision Matrix

| Scenario | Standard | Reason |
|----------|----------|--------|
| Salesforce, Workday, ServiceNow | SAML | Enterprise SaaS standard |
| Custom web app (React, Vue) | OIDC | Modern web app standard |
| Mobile app (iOS, Android) | OIDC | Mobile-friendly |
| Third-party app needs API access | OAuth | Delegation standard |
| Hybrid (auth + API access) | OIDC + OAuth | OIDC for identity, OAuth for APIs |
| Legacy app (20+ years old) | LDAP or SAML | Limited modern auth support |

## User Provisioning: SCIM vs. LDAP vs. HR Integration

User creation and updates happen through different mechanisms:

**SCIM:** REST API standard for user synchronization
- Cloud-to-cloud (Entra ID → SaaS apps)
- Automated: new user in HR → Entra ID → all SaaS apps
- Best for: Modern cloud applications

**LDAP:** Directory protocol for user lookup
- On-premises-to-cloud (On-premises AD → Entra ID)
- Hybrid identity sync
- Best for: Traditional on-premises environments

**HR Integration:** Direct connection to HR system
- HR system (Workday, SuccessFactors) → Identity system
- Best for: Organizations with modern HR systems

## Token Standards: JWT and Beyond

**JWT (JSON Web Token):**
- Self-contained tokens (no server lookup needed)
- Contains user identity and claims
- Signed with private key (tamper-proof)
- Perfect for APIs and microservices

**SAML Assertions:**
- XML-based tokens
- Assertion consumer service validates
- Heavier weight than JWT but more expressive

**ID Tokens vs. Access Tokens:**
- **ID Token:** Contains user identity (who you are)
- **Access Token:** Contains authorization scopes (what you can do)

## Standards by Use Case

### Scenario 1: Enterprise User Signs Into SaaS

**Best approach:** SAML or OIDC
- SAML: Proven, lots of SaaS support
- OIDC: Modern, mobile-friendly

**Flow:** User → SaaS App → Entra ID (authenticate) → Back to app

### Scenario 2: Automated User Provisioning

**Best approach:** SCIM (cloud), LDAP sync (on-premises)
- SCIM: New user created in Entra ID → automatically created in all provisioned SaaS apps
- Example: New employee → HR system → Entra ID → Slack, Salesforce, Zoom all get account

### Scenario 3: API Access Control

**Best approach:** OAuth 2.0 or JWT
- Third-party app needs to read calendar/email → OAuth
- Microservice-to-microservice → JWT

### Scenario 4: Multi-Organization Federation

**Best approach:** SAML with metadata federation or OIDC with discovery
- Partner company users sign in to your app with their organization's credentials
- Example: Contoso staff sign in using Fabrikam's Entra ID

## Compliance & Standards Alignment

**Standards referenced by compliance frameworks:**

| Standard | NIST | ISO 27001 | PCI DSS | HIPAA | SOC 2 |
|----------|------|-----------|---------|-------|-------|
| SAML 2.0 | ✓ | ✓ | ✓ | ✓ | ✓ |
| OAuth 2.0 | ✓ | ✓ | ○ | ○ | ○ |
| OIDC | ✓ | ✓ | ✓ | ✓ | ✓ |
| SCIM | ✓ | ✓ | ✓ | ✓ | ✓ |
| LDAP | ✓ | ✓ | ✓ | ✓ | ✓ |
| JWT | ✓ | ✓ | ✓ | ✓ | ○ |

All major standards align with compliance frameworks.

## Related Documents

**Prerequisites:**
- [SSO and Application Provisioning](./05-sso-and-application-provisioning.md) - Application integration fundamentals
- [Authentication Fundamentals](./07-authentication-fundamentals.md) - Authentication concepts

**Next Steps:**
- [SAML Single Sign-On](./09a-saml-single-sign-on.md) - SAML protocol deep dive
- [OAuth and OpenID Connect](./09b-oauth-and-openid-connect.md) - OAuth/OIDC implementation
- [SCIM Provisioning](./09c-scim-provisioning.md) - Automated user provisioning
- [LDAP and Directory Services](./09d-ldap-and-directory-services.md) - LDAP protocol
- [JWT Tokens](./09e-jwt-tokens-implementation.md) - JWT token handling

## Further Reading

**Standards Documentation:**
- [SAML 2.0 Specification](https://en.wikipedia.org/wiki/SAML_2.0) (OASIS)
- [OAuth 2.0 Specification](https://tools.ietf.org/html/rfc6749) (IETF RFC 6749)
- [OpenID Connect Core 1.0](https://openid.net/specs/openid-connect-core-1_0.html)
- [SCIM 2.0 Specification](https://tools.ietf.org/html/rfc7643) (IETF)

**Microsoft Implementation Guides:**
- [SAML Protocol in Entra ID](https://learn.microsoft.com/en-us/entra/identity-platform/v2-saml-bearer-assertion)
- [OIDC in Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc)
- [SCIM Provisioning](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/use-scim-to-provision-users-and-groups)

## FAQ

**Q: Which standard should we start with?**

A: If you have legacy enterprise SaaS (Salesforce, ServiceNow): SAML. If you have modern web/mobile apps: OIDC. If you're building an API: OAuth or JWT.

**Q: Can we use multiple standards in the same organization?**

A: Yes, absolutely. Enterprise organizations typically use SAML for traditional SaaS, OIDC for modern apps, SCIM for provisioning, and OAuth for APIs. Different standards serve different purposes.

**Q: Is SAML dying?**

A: SAML is mature and stable, not dying. It remains the standard for enterprise SaaS. OIDC is preferred for new applications, but SAML will remain relevant for decades in enterprise environments.

**Q: What's the difference between authentication and authorization?**

A: Authentication proves who you are (identity). Authorization determines what you can do (permissions). SAML and OIDC handle authentication. OAuth handles authorization. SCIM handles provisioning (creating accounts).

**Q: Should we migrate from SAML to OIDC?**

A: Only if you control both the application and the identity provider. If the SaaS vendor only supports SAML, stay with SAML. If both are supported, OIDC is simpler and more modern.

## Next Steps

1. Audit your applications to identify which standards each supports
2. Plan standards rollout: SAML first (existing SaaS), then OIDC (new apps), then APIs (OAuth/JWT)
3. Read the protocol-specific guides (09a-09f) for implementation
4. Start with SAML and SCIM (most common in enterprises)
5. Gradually add OIDC as you deploy modern applications

Identity standards enable the ecosystem. Master one at a time, then integrate others.
