---
title: B2C and CIAM - Customer Identity and Access Management
part: 4
section: Hybrid & Cloud Identity
difficulty: Intermediate
estimated_reading_time: 40
estimated_lab_time: 60
prerequisites:
  - 12-b2b-external-identities.md
  - 09b-oauth-and-openid-connect.md
learning_objectives:
  - Understand customer identity vs. employee identity
  - Implement B2C user sign-up and sign-in
  - Configure CIAM policies and journeys
  - Manage customer profile attributes
  - Implement customer consent and privacy controls
---

# B2C and CIAM: Customer Identity and Access Management

## Introduction

Employee identity (B2B) focuses on access control within organizations. Customer identity (B2C) focuses on billions of consumer sign-ups, sign-ins, and user experiences. When you sign into Netflix with your Google account, or create a Spotify account with your email, that's B2C. Customer Identity and Access Management (CIAM) platforms handle the unique requirements: frictionless sign-up, self-service profiles, social identity integration, privacy compliance, and scale. This document explains B2C concepts, Azure AD B2C implementation, and CIAM best practices.

**Learning Objectives:**
- Understand B2C vs. B2B vs. employee identity
- Implement sign-up and sign-in flows in Azure AD B2C
- Configure user attributes and profile management
- Integrate social identity providers
- Manage customer consent and privacy

## B2C vs. B2B vs. Employee Identity

| Aspect | Employee (AAD) | B2B (Guest) | B2C (Customer) |
|--------|---|---|---|
| **Users** | ~1,000-100,000 | ~100-10,000 | Millions+ |
| **Identity Source** | Corporate directory | Partner/personal account | Email signup/social |
| **Authentication** | MFA required | MFA required | Optional MFA |
| **Purpose** | Work access | Partner collaboration | Service consumption |
| **Lifecycle** | 5-10 years | Project duration | Indefinite or event-driven |
| **Privacy** | Internal policy | Contract-based | GDPR/CCPA consent |
| **Self-Service** | Limited | Moderate | Full (profile, preferences) |
| **Example** | John@company.com | partner@vendor.com | john@gmail.com |

## B2C Customer Identity Flows

### Sign-Up Flow
**First-time customer:**
1. Customer visits app → clicks "Sign Up"
2. Enters email or connects with social account (Google, Facebook, etc.)
3. Sets password (if email signup)
4. Completes profile (name, phone, preferences)
5. Agrees to terms and privacy policy
6. Receives confirmation email
7. Confirmed → access granted

### Sign-In Flow
**Returning customer:**
1. Customer visits app → clicks "Sign In"
2. Enters email + password OR uses social login (one-click)
3. MFA optional (if enabled)
4. Issues access token
5. Customer accesses application

### Password Reset Flow
**Forgotten password:**
1. Customer → "Forgot Password?"
2. Enters email address
3. Receives reset link via email
4. Sets new password
5. Can sign in again

### Profile Management Flow
**Self-service profile updates:**
1. Customer logs in
2. Accesses "My Profile" or "Account Settings"
3. Updates attributes: name, phone, address, preferences
4. Changes password
5. Manages linked social accounts (e.g., link Google to existing email account)

## Azure AD B2C

**Managed B2C service provided by Microsoft:**
- Dedicated B2C directory (separate from employee Azure AD)
- Pre-built sign-up/sign-in pages
- Social identity integration (Google, Facebook, LinkedIn, Microsoft Account)
- Custom policies (advanced scenarios)
- User attribute management
- Multi-factor authentication support
- Conditional Access (by country, device, risk)

### B2C Setup Process

**Step 1: Create B2C Directory**
```
Azure Portal → Create resource → Azure AD B2C
Name: contoso-customers
Country/Region: United States
```

**Step 2: Register Application**
```
B2C directory → App registrations → New registration
Name: "My Web App"
Redirect URI: https://myapp.com/signin-callback
Create Client Secret
```

**Step 3: Create User Flow**
```
B2C directory → User flows → New user flow
Type: Sign up and sign in
Name: B2C_1_susi (sign up sign in)
Enable: Email signup, Google, Facebook
Attributes: Email, Display Name, Given Name, Surname
Claims returned: User attributes + email
```

**Step 4: Configure Social Providers**
```
B2C directory → Identity providers → Google
Client ID: (from Google Cloud Console)
Client Secret: (from Google Cloud Console)
Save
```

**Step 5: Integrate into Application**
```javascript
// Using MSAL library
const msalConfig = {
  auth: {
    clientId: "your-client-id",
    authority: "https://contoso-customers.b2clogin.com/contoso-customers.onmicrosoft.com/B2C_1_susi",
    redirectUri: "https://myapp.com/signin-callback"
  }
};

// Trigger sign-in
async function signIn() {
  const response = await msal.loginPopup();
  const userProfile = response.account;
  // App now has user profile and access token
}
```

## User Attributes and Profile Data

### Standard Attributes
- Email
- Display Name
- Given Name / Family Name
- Phone Number
- Street Address / City / State / Postal Code
- Country

### Custom Attributes
**Add custom attributes for your application:**
```
B2C directory → User attributes → New
Name: loyalty_tier
Type: String
Enable: Yes
```

**Then configure in user flow:**
```
User flows → Select flow → User attributes
Check: loyalty_tier
Claims: Include in JWT token
```

**Access in application:**
```javascript
const user = response.account;
console.log(user.idTokenClaims.loyalty_tier); // "gold", "silver", "bronze"
```

## Social Identity Integration

### Integration Models

**Model 1: Social Only**
- Users sign up/sign in exclusively with Google/Facebook
- No password management
- Fastest sign-up (one-click)
- Higher signup conversion
- Limited control over user data

**Model 2: Email + Social Option**
- Primary: email + password signup
- Secondary: social login (link to existing email account)
- More user control
- More complex flow
- Better for privacy-conscious users

**Model 3: Enterprise Federation**
- Partner organizations use their identity provider
- Similar to B2B but for customer organizations
- Use SAML or OpenID Connect federation
- Manage organizational users at scale

### Configuration

**Add Facebook:**
```
B2C directory → Identity providers → Facebook
Facebook App ID: (from Facebook Developers)
Facebook App Secret: (from Facebook Developers)
User attributes to map: Email, Display Name, Photo
```

**Add Google:**
```
B2C directory → Identity providers → Google
Google OAuth Client ID: (from Google Cloud Console)
Google OAuth Client Secret: (from Google Cloud Console)
```

**Add Enterprise (SAML):**
```
B2C directory → Identity providers → SAML/WS-Fed
SAML Metadata URL: (partner's IdP metadata)
User identifier claim: (email or NameID)
```

## Conditional Access for B2C

**Risk-based access policies:**

```
B2C directory → Conditional Access
Policy: "Require MFA for risky sign-ins"
Users: All users
Conditions: Sign-in risk = High
Actions: Require MFA
```

**Restrictions:**
```
Policy: "Block sign-ins from risky countries"
Conditions: Location = High-risk countries
Actions: Block
```

## Privacy and Consent

### GDPR and Privacy Compliance

**B2C customers have rights:**
- Right to know what data you collect
- Right to access their data
- Right to delete their account
- Right to data portability

**Implementation:**
1. **Consent Banner:** Display terms before sign-up
2. **Privacy Policy Link:** Link to full policy
3. **Transparency:** Explain data usage
4. **Access Request:** API to retrieve user data
5. **Deletion:** API to delete account and data

### Consent Policy

**Configure in user flow:**
```
User flows → User attributes → Consent
Display consent: Yes
Before customer enters data
Text: "I agree to privacy policy and terms"
```

### Data Deletion

**API to delete customer:**
```
DELETE https://graph.microsoft.com/v1.0/users/{user-id}
Authorization: Bearer {admin-token}
```

## B2C Hands-On Lab

**Estimated Time:** 60 minutes

**Prerequisites:** Azure subscription with B2C tenant, Google account for federation test

**Lab Objectives:**
- Create B2C directory and application
- Configure sign-up/sign-in flow
- Add social provider (Google)
- Test complete customer journey

### Step 1: Create B2C Directory (15 minutes)

```bash
# Via Azure Portal
1. Create resource → Azure AD B2C
2. Create new B2C tenant
3. Wait for provisioning (5-10 minutes)
4. Link to subscription
5. Switch to B2C directory
```

### Step 2: Register Application (10 minutes)

```
B2C directory → App registrations → New
Name: WebApp-Test
Platform: Web
Redirect URI: http://localhost:3000/signin-callback
Client Secret: Create
```

Record:
- Client ID (Application ID)
- Client Secret
- Tenant ID
- B2C Hostname (e.g., contoso-customers.b2clogin.com)

### Step 3: Create User Flow (15 minutes)

```
B2C directory → User flows → New user flow
Type: Sign up and sign in
Name: B2C_1_susi
Email signup: Enabled
Attributes: Email, Display Name, Given Name, Surname
Claims: All (include in JWT)
Create
```

### Step 4: Configure Google Identity Provider (10 minutes)

```
1. Create Google OAuth credentials:
   - Google Cloud Console → APIs & Services
   - Create OAuth 2.0 client ID (Web application)
   - Authorized redirect: https://yourb2c.b2clogin.com/yourb2c.onmicrosoft.com/oauth2/authresp
   - Copy Client ID and Secret

2. In B2C directory:
   Identity providers → Google
   Client ID: (paste)
   Client Secret: (paste)
   Save
```

### Step 5: Test Sign-Up and Sign-In (10 minutes)

**Test via B2C portal:**
```
User flows → B2C_1_susi → Run now
1. Test Sign-Up: Enter new email, password, name
2. After signup, logged in
3. Log out
4. Test Sign-In: Enter email, password
5. Test Google login: Click Google button
6. Approve permissions
7. Redirected with user profile
```

## B2C Best Practices

1. **Frictionless Sign-Up** - Minimize required fields, single-click social login
2. **Email Verification** - Verify email before full account creation
3. **Password Strength** - Enforce minimum complexity (but not excessive)
4. **Phone Optional** - Don't require phone at signup, offer self-service later
5. **Profile Completeness** - Allow signup without all profile fields, encourage completion later
6. **Progressive Profiling** - Request attributes gradually, not all upfront
7. **Account Linking** - Allow users to link social and email accounts
8. **Password Reset** - Self-service reset, email-based recovery
9. **Session Duration** - Balance security and convenience (~24 hours typical)
10. **Audit Logging** - Track all sign-ups, sign-ins, profile changes
11. **Data Privacy** - Clear privacy policy, data deletion capability
12. **Fraud Prevention** - Monitor suspicious signup patterns (bot, credential stuffing)

## CIAM Comparison

| Platform | B2C Volume | Social Integration | Custom UI | Compliance | Cost |
|----------|---|---|---|---|---|
| **Azure AD B2C** | Millions | Native | Yes | GDPR, HIPAA | Per auth transaction |
| **Okta CIAM** | Millions | Native | Yes | GDPR, HIPAA, SOC 2 | Per MAU |
| **Auth0** | Millions | Native | Yes | GDPR, HIPAA, SOC 2 | Per MAU |
| **Amazon Cognito** | Millions | AWS ecosystem | Limited | GDPR, HIPAA | Per auth transaction |
| **Custom OAuth** | Varies | Possible | Full | Varies | Development cost |

## Compliance & Standards

**B2C Compliance:**
- **GDPR:** Right to access, delete, portability
- **CCPA:** California privacy rights
- **HIPAA:** If handling health data
- **SOC 2:** For service providers managing customer data

## Related Documents

**Prerequisites:**
- [B2B External Identities](./12-b2b-external-identities.md) - Partner identity
- [OAuth and OpenID Connect](./09b-oauth-and-openid-connect.md) - Token standards

**Next Steps:**
- [CIAM Implementation](./18a-delegation.md) - Customer self-service delegation
- [Data Quality Management](./16-data-quality-management.md) - Customer data governance

## FAQ

**Q: What's the difference between B2C and OAuth 2.0?**

A: OAuth 2.0 is the protocol. B2C is a platform using OAuth. You use OAuth as the mechanism.

**Q: Can we use employee Azure AD for B2C?**

A: Not recommended. Use separate B2C directory for scale, GDPR compliance, different governance.

**Q: How do we handle customer data during account deletion?**

A: GDPR requires deletion within 30 days. Configure retention policies, archive before deletion if needed.

**Q: Can customers sign in with company email (identity.company.com)?**

A: Yes. Add as enterprise SAML provider, or use email federation if using partner Azure AD.

**Q: How do we prevent bot signups?**

A: Use CAPTCHA in sign-up form, monitor signup velocity, flag patterns, implement rate limiting.

## Next Steps

1. Evaluate B2C vs. custom OAuth implementation
2. Plan customer identity model (email, social, federation)
3. Configure B2C tenant and basic user flow
4. Integrate social providers
5. Implement consent and privacy controls
6. Test customer sign-up to profile management journey
7. Plan data retention and deletion processes

B2C enables billions of customers to access applications seamlessly. Start with B2C platform (Azure AD B2C, Okta, Auth0) rather than building custom.
