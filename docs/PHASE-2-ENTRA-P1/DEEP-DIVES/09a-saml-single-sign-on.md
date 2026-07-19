---
title: SAML Single Sign-On - Enterprise SSO Implementation
part: 3
section: Standards & Protocols
difficulty: Intermediate
estimated_reading_time: 50
estimated_lab_time: 90
prerequisites:
  - 09-identity-standards-overview.md
  - 05-sso-and-application-provisioning.md
learning_objectives:
  - Understand SAML 2.0 protocol and message flows
  - Configure SAML applications in Microsoft Entra ID
  - Implement SP-initiated and IdP-initiated SSO
  - Configure single logout (SLO)
  - Debug SAML authentication issues using logs and tools
---

# SAML Single Sign-On: Enterprise SSO Implementation

## Introduction

SAML 2.0 (Security Assertion Markup Language) is the enterprise standard for single sign-on (SSO). When an employee signs in to Microsoft Entra ID once, they can access dozens of applications without re-entering credentials: Salesforce, ServiceNow, Workday, Slack, and hundreds of others. SAML is the protocol making this seamless experience possible. SAML carries digitally signed assertions (XML documents) that prove identity from the identity provider (Entra ID) to service providers (applications). This document explains SAML protocol flows, how to configure SAML in Entra ID, and how to troubleshoot common SAML issues.

**Learning Objectives:**
- Understand SAML 2.0 protocol fundamentals and message flows
- Configure SAML in Microsoft Entra ID for enterprise applications
- Implement both SP-initiated and IdP-initiated SSO flows
- Configure advanced features (single logout, attribute mapping, conditional access)
- Debug SAML issues using logs and SAML validators

## SAML Protocol Fundamentals

SAML uses XML assertions to communicate identity information. Key concepts:

### SAML Parties

**Identity Provider (IdP):** Issues SAML assertions (Microsoft Entra ID)
**Service Provider (SP):** Consumes SAML assertions and grants access (Salesforce, ServiceNow, etc.)

### SAML Assertion

An XML document digitally signed by Entra ID containing:
- **Subject:** The user being authenticated
- **Conditions:** Validity period and audience restrictions
- **AuthnStatement:** When/how the user was authenticated
- **AttributeStatement:** User attributes (email, department, groups)
- **Signature:** Digital proof the assertion came from Entra ID

### SAML Bindings

Protocol for transmitting assertions:
- **HTTP Redirect:** Assertion in URL query parameter (for authentication requests)
- **HTTP POST:** Assertion in HTML form body (for responses)
- **HTTP Artifact:** Lightweight reference transmitted; actual assertion retrieved server-to-server

### SP-Initiated vs. IdP-Initiated

**SP-Initiated (user clicks login on app):**
1. User visits Salesforce login page
2. User enters email
3. Salesforce redirects to Entra ID with SAML authentication request
4. Entra ID authenticates user, sends SAML assertion back
5. Salesforce validates assertion and logs user in

**IdP-Initiated (user accesses from identity provider):**
1. User signs in to Entra ID
2. Goes to app portal or dashboard
3. Clicks link to Salesforce
4. Entra ID sends SAML assertion directly to Salesforce
5. Salesforce validates and logs user in (no re-entry)

## Configuring SAML in Microsoft Entra ID

### Step 1: Add Application to Entra ID

1. In Entra ID admin center, go to **Enterprise applications**
2. Click **+ New application**
3. Search for app by name (e.g., "Salesforce")
4. If in gallery: Click and add
5. If not in gallery: Create custom application
6. Name the integration (e.g., "Salesforce - Production")

### Step 2: Obtain SAML Configuration Information from App

Application provides configuration details needed:

1. **Entity ID / Application ID URI:** Unique identifier for the app
   - Example: `https://salesforce.com`
2. **Assertion Consumer Service (ACS) URL:** Where Entra ID sends SAML response
   - Example: `https://contoso.salesforce.com/services/saml/acs`
3. **Single Logout Service (SLS) URL:** Where to send logout requests
   - Example: `https://contoso.salesforce.com/services/saml/slo`
4. **NameID format:** How to identify users (usually "Email address")

Check app documentation or contact vendor for these values.

### Step 3: Configure SAML in Entra ID

1. In Entra ID Enterprise application, go to **Single sign-on**
2. Select **SAML**
3. **Section 1: Basic SAML Configuration**
   - **Identifier (Entity ID):** Enter app's Entity ID
   - **Reply URL (ACS):** Enter app's ACS URL
   - **Logout URL (SLS):** Enter app's logout URL
4. **Section 2: User Attributes & Claims**
   - Default claims (Name ID, Email, Groups)
   - Add custom attributes if app requires
5. **Section 3: SAML Signing Certificate**
   - Entra ID auto-generates certificate
   - Download certificate if app needs it
6. **Section 4: Set up [App Name]**
   - Provides Entra ID's metadata XML
   - Download metadata or copy login URL
7. **Save**

### Step 4: Configure Application in App

Provide to app team:
1. **Metadata XML:** Download from Entra ID section 4
2. **OR manually enter:**
   - Entra ID's login URL
   - Entra ID Entity ID
   - Certificate (public key only)
3. **Map attributes:** Tell app where to find name, email in SAML assertion

### Step 5: Test SAML Login

1. In Entra ID, go to Single sign-on page
2. Scroll to "Test single sign-on with [App]"
3. Click "Test"
4. Option A: You're signed in → Click "Sign in as current user" → should log you into app
5. Option B: You're not signed in → Enter credentials → should log you into app
6. Verify you're successfully logged in

**Expected output:** Successful login to application

### Step 6: Deploy to Users

1. Go to **Users and groups**
2. Click **+ Add user/group**
3. Select users or groups who need access
4. Assign role (if app has roles)
5. Click **Assign**

Users can now access app via:
- **SP-initiated:** Clicking app link in app
- **IdP-initiated:** Accessing via Entra ID portal/dashboard
- **Direct link:** Using configured login URL

## Hands-On Lab: Configuring SAML SSO

**Estimated Time:** 90 minutes

**Prerequisites:** Entra ID tenant with admin access, SAML-enabled test application (Salesforce, Okta, custom app)

**Lab Objectives:**
- Configure SAML application in Entra ID
- Test SP-initiated SSO
- Test IdP-initiated SSO
- Review SAML assertion structure

### Step 1: Add Application and Get Configuration (20 minutes)

1. Go to Entra ID → Enterprise applications → + New application
2. Search for "Salesforce" (or your test app)
3. Click result and add it
4. Name: "Salesforce - SSO Test"
5. Once added, go to the app's overview page
6. Click **Single sign-on**
7. Select **SAML** option
8. Review auto-filled configuration
9. Obtain app's SAML metadata:
   - If using Salesforce: Setup → Single Sign-On Settings → Download metadata
   - Check app documentation for SAML configuration

### Step 2: Complete SAML Configuration in Entra ID (20 minutes)

1. In **Basic SAML Configuration:**
   - **Identifier:** `https://login.salesforce.com`
   - **Reply URL:** `https://yourdomain.my.salesforce.com/services/saml/acs`
   - **Logout URL:** `https://yourdomain.my.salesforce.com/services/saml/slo`
2. In **SAML Signing Certificate:**
   - Download certificate (public key)
3. In **Set up Salesforce:**
   - Copy Entra ID's Login URL
   - Copy Entity ID
4. Save configuration

### Step 3: Configure Salesforce (20 minutes)

1. Log into Salesforce as admin
2. Go to **Setup** → **Single Sign-On Settings**
3. Create new SAML SSO configuration:
   - **SAML Enabled:** Check
   - **Entity ID:** `https://sts.windows.net/{tenant-id}`
   - **Identity Provider Login URL:** Paste Entra ID's Login URL
   - **Identity Provider Certificate:** Paste Entra ID's certificate (public key)
   - **NameID Format:** `urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress`
4. Save

### Step 4: Test SP-Initiated Flow (15 minutes)

1. Open new private browser window
2. Go to Salesforce login page
3. Enter test user's email
4. Redirect to Entra ID login
5. Enter credentials
6. Redirect back to Salesforce
7. Verify you're logged in

**Expected Output:**
```
Salesforce login page
Enter email: user@contoso.com
Redirect to Entra ID
Sign-in successful
Redirect back to Salesforce
Dashboard appears
```

### Step 5: Test IdP-Initiated Flow (15 minutes)

1. Sign in to Entra ID admin center
2. Go to **Enterprise applications** → Your Salesforce app
3. Scroll to **Set up [Salesforce]**
4. Find and copy **Login URL** or **Metadata URL**
5. Open that link in new private window
6. Should be logged into Salesforce immediately (if already signed in to Entra ID)

**Expected Output:**
```
Login URL accessed
Entra ID checks authentication
Sends SAML assertion to Salesforce
Salesforce validates and logs in
Dashboard appears
```

### Step 6: Inspect SAML Assertion (20 minutes)

1. Use browser developer tools (F12)
2. Go to **Network** tab
3. Clear network history
4. Perform login flow
5. Look for POST request to Salesforce ACS endpoint
6. Inspect the request body
7. Look for `SAMLResponse` parameter
8. Copy value and decode it:
   - Use online SAML decoder (e.g., https://www.samltool.com/decode.php)
   - Decode and review assertion contents
9. Verify it contains:
   - Subject (user email)
   - NameID (user identification)
   - Conditions (validity period)
   - AuthnStatement (authentication method and time)
   - AttributeStatement (user attributes like email, groups)

**Expected Output:**
```xml
<saml:Assertion>
  <saml:Subject>
    <saml:NameID>user@contoso.com</saml:NameID>
  </saml:Subject>
  <saml:Conditions NotOnOrAfter="...">
  <saml:AuthnStatement>
  <saml:AttributeStatement>
    <saml:Attribute Name="http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress">
      <saml:AttributeValue>user@contoso.com</saml:AttributeValue>
    </saml:Attribute>
  </saml:AttributeStatement>
</saml:Assertion>
```

## Common SAML Issues and Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| "SAML response not valid" | Certificate mismatch or invalid signature | Re-download Entra ID certificate, ensure it's current |
| "Wrong entity ID" | Entra ID Entity ID doesn't match app's expectation | Verify Entra ID Entity ID matches in app configuration |
| "Invalid ACS URL" | Redirect URL doesn't match configured ACS | Verify ACS URL in Basic SAML Configuration |
| "User not found" | NameID mapping incorrect | Verify NameID format matches app (usually email) |
| "Invalid audience" | Conditions audience doesn't match Entity ID | Verify app's Entity ID matches Entra ID configuration |
| "Assertion expired" | Assertion validity period passed | Check server time sync, Entra ID may reject if clocks differ >5 min |

## SAML Certificate Management

SAML certificates expire and must be rotated periodically.

### Certificate Rotation Process

1. **Before expiry:** Entra ID auto-generates new certificate (default ~1-2 years before expiry)
2. **30 days before expiry:** Notification sent to admin
3. **Rotation steps:**
   - Download new certificate from Entra ID
   - Update app's configuration with new certificate
   - Old certificate remains valid during transition (usually 1-2 weeks)
   - Old certificate eventually revoked

### Best Practice

- **Document certificate expiry date** in your change management system
- **Set calendar reminders** for certificate rotation
- **Test certificate rotation** in non-production first
- **Automate certificate updates** if possible (some apps support metadata polling)

## Compliance & Standards Alignment

**NIST Cybersecurity Framework 2.0:**
- **Protect (P):** SAML SSO is identity verification and access control
- **Identify (ID):** SAML assertions identify users

**Standards:**
- **OASIS SAML 2.0:** International open standard for SSO
- **WS-Federation:** Alternative SSO standard (less common)

## Related Documents

**Prerequisites:**
- [Identity Standards Overview](./09-identity-standards-overview.md) - Standards context

**Next Steps:**
- [OAuth and OpenID Connect](./09b-oauth-and-openid-connect.md) - Modern authentication standards
- [SCIM Provisioning](./09c-scim-provisioning.md) - Automated provisioning
- [Application Access Management](./05-sso-and-application-provisioning.md) - Full app integration

## Further Reading

**Microsoft Learn:**
- [SAML Single Sign-On in Entra ID](https://learn.microsoft.com/en-us/entra/identity-platform/v2-saml-bearer-assertion)
- [SAML Protocol Reference](https://learn.microsoft.com/en-us/entra/identity-platform/active-directory-saml-protocol-reference)

**SAML Resources:**
- [OASIS SAML 2.0 Specification](https://en.wikipedia.org/wiki/SAML_2.0)
- [SAML Debugging Tool](https://www.samltool.com/)

## FAQ

**Q: What's the difference between SAML and OAuth?**

A: SAML is for SSO (proving who you are). OAuth is for authorization (what you can access). Use SAML for login, OAuth for API access.

**Q: Do all enterprise apps support SAML?**

A: Most modern SaaS (Salesforce, ServiceNow, Workday, Slack) do. Legacy apps might require LDAP or custom integration. Check app documentation.

**Q: How often do SAML certificates rotate?**

A: Typically every 1-2 years. Entra ID auto-generates new certificate before expiry. You have 1-2 weeks' grace period to update app.

**Q: Can we use SAML for internal applications?**

A: Yes. If your internal web app supports SAML, integrate it with Entra ID. Provides better security and user experience than directory binding.

**Q: What's single logout (SLO)?**

A: When user logs out of app, logout request sent to Entra ID to also log them out there. Optional but recommended.

## Next Steps

1. Audit your enterprise applications to identify SAML support
2. Start with one non-critical app (test environment)
3. Configure SAML following this guide
4. Test both SP-initiated and IdP-initiated flows
5. Document certificate expiry and rotation process
6. Roll out to remaining applications
7. Plan for certificate rotation and monitoring

SAML is the enterprise SSO standard. Master it and your application portfolio becomes integrated and user-friendly.
