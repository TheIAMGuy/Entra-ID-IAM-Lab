---
title: Multi-Factor Authentication - Implementation & Best Practices
section: Authentication & Security
difficulty: Intermediate
estimated_reading_time: 45
estimated_lab_time: 75
prerequisites:
  - ../PHASE-1-FREE-TIER/01-environment-setup.md
learning_objectives:
  - Understand MFA methods and their security characteristics
  - Configure MFA policies in Microsoft Entra ID
  - Implement adaptive MFA based on risk
  - Plan MFA rollout and user adoption strategies
  - Troubleshoot common MFA deployment challenges
---

# Multi-Factor Authentication: Implementation & Best Practices

## Microsoft's Mandatory MFA Enforcement

Microsoft is enforcing mandatory MFA for Azure sign-ins in two phases. This is not a requirement for every Microsoft 365 sign-in.

- **Phase 1 (from October 2024):** Accounts signing in to the Azure portal, Microsoft Entra admin center and Microsoft Intune admin center need MFA for any create, read, update or delete operation. Enforcement for the Microsoft 365 admin center began in February 2025.
- **Phase 2 (from October 1, 2025):** Accounts using Azure CLI, Azure PowerShell, the Azure mobile app, infrastructure-as-code tools and REST API endpoints need MFA for create, update and delete operations. Read operations do not.
- **Postponement:** Global Administrators could postpone Phase 1 until September 30, 2025 and Phase 2 until July 1, 2026. Check your own tenant's status in the Azure portal, because those dates have now passed.
- **Stronger methods:** Passwordless sign-in and passkeys (FIDO2) already satisfy the requirement. Security defaults or a Conditional Access policy also satisfy it.

See [Mandatory multifactor authentication for Azure and admin portals](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-mandatory-multifactor-authentication) for the current scope and how to confirm enforcement in your tenant.

---

## Introduction

Multi-factor authentication (MFA) is no longer optional—it's essential. According to [Microsoft security research](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-mandatory-multifactor-authentication), MFA can block more than 99.2% of account compromise attacks. Yet many organizations struggle with rollout: users resist, help desk tickets spike, and deployments stall. This document shows you how to implement MFA strategically, minimize friction, and sustain adoption, while meeting Microsoft's mandatory MFA enforcement.

**Learning Objectives:**
- Understand the full spectrum of MFA methods (app-based, SMS, biometric, hardware tokens)
- Configure MFA policies in Microsoft Entra ID with different enforcement levels
- Implement Conditional Access to enforce MFA based on risk
- Plan phased MFA rollout to minimize disruption
- Address common adoption challenges and troubleshoot issues

## MFA Methods: Strengths and Implementation

MFA encompasses multiple authentication methods, each with different security profiles, user experience characteristics, and deployment complexity. Organizations typically implement a portfolio of methods to balance security, usability, and cost.

### Time-Based One-Time Passwords (TOTP)

Time-based one-time passwords (TOTP) generate six-digit codes that change every 30 seconds. Users install an authenticator app (Microsoft Authenticator, Google Authenticator, Duo Mobile) on their phone and enter the code when prompted. TOTP requires no backend integration beyond Entra ID—the algorithm is standard across all apps.

**Strengths:** Cost-free for users, works offline, no SMS infrastructure needed, no SIM swap exposure. **Weaknesses:** Users must manually enter codes (friction), codes expire after 30 seconds, and codes can be phished and replayed in real time, so TOTP is not phishing-resistant.

**Implementation:** Verification codes come from the Microsoft Authenticator app or from other OATH TOTP apps registered as software OATH tokens. Manage which methods are available in **Entra ID → Authentication methods → Policies**. Users register at their Security info page and scan a QR code. Entra ID validates the code at sign-in.

### SMS and Phone Call

SMS sends a one-time code via text message; phone call uses voice to communicate the code. Both are human-readable and require no app installation, making them accessible to all users. SMS is cheaper than phone calls.

**Strengths:** No app installation required, familiar to all users, universally available. **Weaknesses:** SMS is intercepted through SIM swap attacks, phone calls can be intercepted or spoofed, SMS delivery can be delayed, and the method is being retired (see below).

**Implementation:** SMS and phone call are configured under Entra ID MFA settings. Users register a phone number during setup. When MFA is triggered, Entra ID initiates an SMS delivery or outbound call.

**Security Note:** Microsoft no longer positions SMS and voice as secure authentication methods. Microsoft-provided SMS and voice delivery is scheduled to be retired on **February 1, 2027** for most users (July 1, 2027 for Global Administrators and external users), after which users whose only MFA method is SMS or voice must register a passkey to keep signing in. From September 1, 2026, passkeys become the default experience. Plan to move users to Microsoft Authenticator or passkeys. See [Passkeys by default and retirement of Microsoft-provided SMS and voice authentication](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-sms-voice-retirement).

### Push Notifications to Mobile Apps

Push notifications are convenient for users. When a user attempts to sign in, a notification appears on their registered device. Microsoft Authenticator push notifications use **number matching**: the sign-in page shows a number, and the user enters it in the app to approve. Users can't opt out of number matching, which protects against MFA fatigue attacks where an attacker spams approval requests.

**Strengths:** No codes to type, fast, stronger than SMS or voice, and number matching resists accidental or fatigue-driven approvals. **Weaknesses:** Requires a smartphone, the app and a data connection, notifications can be missed if the phone is on silent, and push is still phishable by a real-time attacker proxy, so it is not phishing-resistant.

**Implementation:** Push notifications are the default mode in Microsoft Authenticator. Users install Authenticator, register at Security info, and respond to in-app prompts during sign-in. Admins control the method in the Authentication methods policy.

### Biometric Authentication

Biometrics (fingerprint, facial recognition) are not a standalone Entra ID method. They unlock a device-bound credential: for example, Microsoft Authenticator or a passkey asks the user for a biometric or PIN on the device before approving a sign-in, and Windows Hello for Business uses a PIN or biometric to unlock a key stored on the device.

**Strengths:** Fast, convenient, and the biometric never leaves the device. **Weaknesses:** Requires a modern device, sensors can fail, and the protection depends on the underlying credential (passkey or Windows Hello is phishing-resistant; a push approval is not).

**Implementation:** Use passkeys (FIDO2), Windows Hello for Business, or passkeys in Microsoft Authenticator. Enable them in the Authentication methods policy and register them at Security info.

### Hardware Security Keys (Passkeys / FIDO2)

Hardware security keys (FIDO2 USB, NFC or Bluetooth tokens) are physical devices that users plug into computers or tap to phones. They use cryptographic algorithms to prove device possession. FIDO2 keys are phishing-resistant—the key only authenticates to the correct domain.

**Strengths:** Phishing-resistant (highest security), works on any device via USB/NFC, no codes or notifications. **Weaknesses:** Hardware cost, users must carry keys, and a lost key needs a recovery process (for example a Temporary Access Pass).

**Implementation:** Microsoft Entra ID supports passkeys (FIDO2) on security keys, in Microsoft Authenticator, and as synced passkeys. Enable the Passkey (FIDO2) method in the Authentication methods policy, then users register in Security info. During sign-in, users insert or tap the key when prompted.

### Passwordless Phone Sign-In

Microsoft Authenticator supports passwordless phone sign-in: the user is shown a number on the sign-in page, selects it in the app, and approves with biometric or PIN. No password is needed.

**Strengths:** No password to steal or reuse, number matching and device unlock built in. **Weaknesses:** Requires the Authenticator app and device PIN or biometric, and it is not phishing-resistant the way passkeys are.

**Implementation:** In the Microsoft Authenticator method of the Authentication methods policy, set the authentication mode to allow passwordless. Users register during setup, then replace password entry with Authenticator approval.

## Configuring MFA in Microsoft Entra ID

Entra ID offers three levels of MFA enforcement, each with different scope and administration:

### Method 1: Per-User MFA (Legacy)

Per-user MFA enforces MFA on individual users, not policies. Each user is manually enabled or disabled by administrators. This approach is inflexible and doesn't scale. Microsoft advises against changing per-user states unless your licences don't include Conditional Access and you don't want to use security defaults, and against combining per-user MFA with Conditional Access policies.

**Limitation:** No conditional enforcement, no exception mechanisms, all-or-nothing per user. Not recommended for new deployments.

### Method 2: Conditional Access Policies

Conditional Access (recommended) enforces MFA based on conditions: user group, device status, location, sign-in risk, application, etc. Administrators define policies like "Require MFA for all remote sign-ins" or "Require MFA for admin users."

**Policy Example:**
- **If:** User is in the IT Admin group AND sign-in is from outside corporate network
- **Then:** Require MFA AND require device compliance

**Configuration Steps:**

1. In the Microsoft Entra admin center, navigate to **Entra ID → Conditional Access → Policies**
2. Click "New policy"
3. **Assignments:**
   - Select users/groups (e.g., guests or external users, with emergency access accounts excluded)
   - Select cloud apps (e.g., Microsoft 365, custom SaaS)
   - Select conditions (location, device, risk level)
4. **Access controls:**
   - Grant → "Require MFA"
   - Optional: Require compliant device
   - Optional: Require Microsoft Entra hybrid joined device
5. **Session controls** (optional):
   - Sign-in frequency
   - Persistent browser session
   - Use app enforced restrictions (Exchange Online and SharePoint Online)
6. Enable policy and test

**Advantage:** Granular, scalable, exception-friendly (can exclude users/groups).

### Method 3: Security Defaults

Security defaults are preconfigured settings available to every tenant at no extra cost. They require all users to register for MFA, require administrators to do MFA, prompt other users for MFA when necessary, block legacy authentication, and protect privileged activities such as Azure portal access. Enable them for organizations without Conditional Access licensing.

**Limitations:** On or off only, no granular conditions, no custom exclusions (only Microsoft Entra Connect sync accounts are excluded), and users can only register using the Microsoft Authenticator notification option. Security defaults can't be on at the same time as Conditional Access policies, and you can't turn them on while Conditional Access policies exist. See [Security defaults in Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/fundamentals/security-defaults).

## Adaptive MFA Based on Risk

Risk-based MFA requires MFA only when sign-in risk is detected. This balances security and usability: low-risk sign-ins proceed without MFA; high-risk sign-ins require stronger authentication.

**Risk Factors Detected by Entra ID:**
- **Atypical travel:** Two sign-ins from locations too far apart for the elapsed time
- **Unfamiliar sign-in properties:** Properties the user hasn't recently used
- **Leaked credentials:** User's credentials found in a breach (a user-risk detection)
- **Anonymous IP address:** Sign-in from Tor or an anonymous VPN
- **Malicious IP address:** Sign-in from an IP address with known malicious activity

Most risk detections need Microsoft Entra ID P2. See [What are risk detections?](https://learn.microsoft.com/en-us/entra/id-protection/concept-identity-protection-risks).

**Conditional Access Policy for Risk:**

1. Create policy: "Require MFA for high-risk sign-ins"
2. **Conditions:** Sign-in risk = High
3. **Grant:** Require MFA
4. Enable and test

**Result:** Users with low-risk sign-ins proceed to apps without MFA; high-risk sign-ins trigger MFA challenge.

## Hands-On Lab: Implementing MFA with Conditional Access

**Estimated Time:** 75 minutes

**Prerequisites:** Microsoft Entra ID tenant with admin access, test users, Conditional Access licensing (Entra ID P1 or higher), and at least one external guest account for the in-scope test

**Lab Objectives:**
- Configure MFA methods in Entra ID
- Create a Conditional Access policy requiring MFA
- Test MFA for different user scenarios

### Step 1: Enable MFA Methods in Security Info (10 minutes)

1. Sign in to Entra ID admin center (entra.microsoft.com)
2. Navigate to **Identity → Users → All users**
3. Select a test user (or sign in as test user)
4. Go to **Security info** (or visit myaccount.microsoft.com/security-info)
5. Click **"Add sign-in method"**
6. Choose **Microsoft Authenticator app**
7. Follow prompts to:
   - Download Microsoft Authenticator on your phone
   - Scan QR code with Authenticator
   - Approve a test notification
8. Verify success message: "Your authenticator app has been successfully set up"

**Expected Output:**
```
Microsoft Authenticator registration complete
Phone: <your device>
Status: Approved for sign-in notifications and password reset
```

### Step 2: Create a Conditional Access Policy (20 minutes)

1. In the Microsoft Entra admin center, go to **Entra ID → Conditional Access → Policies**
2. Click **"+ New policy"**
3. **Name:** "MFA for Guest Users"
4. **Assignments:**
   - **Users:** Select "Guest users"
   - **Cloud apps:** Select "All cloud apps"
   - **Conditions:** Leave default (no exclusions)
5. **Access controls:**
   - **Grant:** Check "Require MFA"
6. **Session controls:** Leave default
7. **Enable policy:** Toggle to "On"
8. Click **Create**

**Expected Output:**
```
Policy created successfully
Name: MFA for Guest Users
Status: On
Last modified: <current timestamp>
```

### Step 3: Test MFA for In-Scope User (20 minutes)

1. Open a private browser window
2. Navigate to https://portal.azure.com
3. Sign in with a guest user account (should trigger MFA requirement)
4. When prompted "More information required," click **"Set up an authenticator app"**
5. Follow on-screen prompts to register Authenticator (if not already done)
6. Complete authentication using Authenticator approval notification
7. Verify you can access Entra ID admin center

**Expected Output:**
```
Sign-in successful
User: guest@yourorganization.com
MFA Status: Verified
Session: Active
```

### Step 4: Test MFA for Out-of-Scope User (15 minutes)

1. In same private browser, sign out
2. Sign in with a user NOT in the "Guest users" group
3. Verify you can sign in WITHOUT MFA requirement
4. Check sign-in logs in Entra ID: **Entra ID → Monitoring & health → Sign-in logs**
5. Filter by the user and open the sign-in. The **Authentication requirement** shows "Single-factor authentication" and the policy shows as not applied.

**Expected Output:**
```
Sign-in log entry
User: <non-guest user>
Result: Success
MFA requirement: Not met
Status: Allowed (not in policy scope)
```

### Step 5: Verify Policy Compliance (10 minutes)

1. In the Microsoft Entra admin center, go to **Entra ID → Conditional Access → Policies**
2. Click on "MFA for Guest Users" policy
3. Review **Insights and recommendations:**
   - **Users affected:** Count of guest users
   - **Sign-in impact:** Percentage required MFA
4. Go to **Audit logs** to see policy application
5. Filter by policy name "MFA for Guest Users"

**Expected Output:**
```
Policy: MFA for Guest Users
Users affected: <number>
Policies requiring MFA: 1 of 1
Last evaluation: <timestamp>
Success rate: <illustrative value>
```

### Troubleshooting Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| "MFA required but no methods registered" | User hasn't set up Authenticator | Have user register in Security Info |
| "Authenticator code rejected" | Code from a previous 30-second window, or the phone clock is wrong | Enter the new code shown, and check the device time is set automatically |
| "Push notification not received" | Phone offline or app not installed | Have the user use a verification code from the app or another registered method |
| "Policy not enforcing MFA" | User excluded from policy or policy disabled | Verify policy is "On" and user is in-scope |
| "Can't access Security Info page" | Browser cookies blocked or incognito mode | Clear cookies or use normal browser mode |

## MFA Rollout Strategy

Successful MFA rollout follows a phased approach that minimizes disruption:

### Phase 1: Pilot (Weeks 1-4)
- Target: IT team and early adopters
- Scope: 10-20% of organization
- Configuration: Optional MFA (recommended, not required)
- Communication: Send detailed guides; offer training sessions
- Monitoring: Collect feedback; identify blockers

### Phase 2: Gradual Enforcement (Weeks 5-12)
- Target: High-risk users (admins, finance, executives)
- Scope: 50% of organization
- Configuration: Required MFA via Conditional Access policy
- Grace period: 30 days warning before enforcement
- Support: Dedicated help desk for MFA issues

### Phase 3: Full Rollout (Weeks 13-16)
- Target: All users
- Scope: 100% of organization
- Configuration: Universal MFA requirement
- Exceptions: Service accounts, shared accounts (use alternative auth)
- Monitoring: Track compliance; provide ongoing support

### Phase 4: Optimization (Ongoing)
- Monitor adoption metrics
- Adjust policies based on real-world usage
- Implement adaptive MFA for better UX
- Retire legacy methods (SMS-only)

## Best Practices for MFA Deployment

**1. Provide Multiple Methods:** Users lose phones. Register at least two methods per user, and favour Microsoft Authenticator and passkeys over SMS and voice.

**2. Implement Progressive Enrollment:** Don't require all methods at once. Allow users to start with the Authenticator app and add a passkey or second method later.

**3. Use Risk-Based Enforcement:** Require MFA only when risk is detected, not for all sign-ins. This reduces friction while maintaining security.

**4. Educate Users Before Rollout:** Confusion drives resistance. Conduct training sessions, distribute guides, and answer questions before enforcement.

**5. Monitor and Support:** Track MFA adoption metrics. Provide dedicated help desk support during rollout. Address blockers quickly.

**6. Plan for Service Accounts:** Service accounts and shared accounts can't use interactive MFA. Plan alternatives (managed identities, service principals with certificates).

**7. Combine with Conditional Access:** MFA alone is insufficient. Pair MFA with device compliance, location, and risk policies for comprehensive protection.

**8. Test Thoroughly Before Rollout:** Pilot MFA with IT team first. Identify issues in controlled environment before broad deployment.

**9. Have Backup Methods:** Users lose phones, apps crash, networks fail. Ensure users register more than one method, and plan recovery with a Temporary Access Pass issued by an administrator or Microsoft Entra account recovery.

**10. Communicate Ongoing:** Regular communications about MFA benefits, new features, and troubleshooting tips maintain momentum and adoption.

## Compliance & Standards Alignment

MFA is a common control in security frameworks, but wording and numbering change between versions, so verify against the current standard before citing it.

- **NIST CSF 2.0:** Identity management, authentication and access control sit under the Protect function (category PR.AA).
- **ISO/IEC 27001:2022:** Annex A controls on authentication information and secure authentication (5.17, 8.5) and privileged access rights (8.2).
- **PCI DSS v4.0.1:** Requirement 8 covers identifying and authenticating users, including MFA for access into the cardholder data environment. PCI DSS v3.2.1 has been retired.
- **HIPAA Security Rule:** Requires person or entity authentication (45 CFR 164.312(d)) and does not name MFA specifically.
- **GDPR:** Article 32 requires appropriate technical measures for security of processing. MFA is a common way to meet it, not a stated requirement.

## Related Documents

**Hands-on labs:**
- [Lab 01 — Environment Setup](../PHASE-1-FREE-TIER/01-environment-setup.md)
- [Lab 07a — Configure TOTP-Based MFA](07a-configure-totp-mfa.md)
- [Lab 07b — Authenticator App Push MFA](07b-enable-authenticator-push-mfa.md)
- [Lab 07c — Conditional Access Policy](07c-conditional-access-policy.md)

**Next:**
- [Adaptive Authentication guide](guide-adaptive-authentication.md) — risk-based Conditional Access

## Further Reading

**Microsoft Learn:**
- [MFA in Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-mfa-howitworks)
- [Conditional Access Policies](https://learn.microsoft.com/en-us/entra/identity/conditional-access/overview)
- [Microsoft Authenticator App Guide](https://learn.microsoft.com/en-us/entra/identity/authentication/user-help-auth-app-overview)

**Industry Standards:**
- [NIST SP 800-63: Digital Identity Guidelines](https://pages.nist.gov/800-63-4/)
- [OWASP: Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)

**Microsoft Learn:**
- [Mandatory multifactor authentication for Azure and admin portals](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-mandatory-multifactor-authentication)
- [Plan a Microsoft Entra multifactor authentication deployment](https://learn.microsoft.com/en-us/entra/identity/authentication/howto-mfa-getstarted)

## FAQ

**Q: Should we use SMS for MFA?**

A: Avoid it where you can. Microsoft recommends moving away from SMS and voice, and Microsoft-provided SMS and voice delivery is being retired from February 1, 2027. Use Microsoft Authenticator or passkeys, and treat SMS as a temporary fallback only.

**Q: How do we handle users who don't have smartphones?**

A: Use hardware security keys (passkeys) or Windows Hello for Business. Phone-based methods are being retired, so a telephony provider is a last resort. Have a help desk process to verify identity before granting exceptions.

**Q: Can we require MFA without Conditional Access?**

A: Yes. Security defaults are free and per-user MFA is available, though Microsoft discourages per-user MFA when Conditional Access is an option. Conditional Access (Entra ID P1) provides granular control and is the recommended approach.

**Q: How do we handle MFA for service accounts?**

A: Service accounts can't respond to interactive MFA prompts. Use alternatives: managed identities, service principals with certificates, or automation accounts that don't require interactive auth.

**Q: What if a user loses their registered phone?**

A: Users should register more than one method. Entra ID work accounts don't have backup codes. If a user loses every method, an administrator can issue a Temporary Access Pass or reset their methods after verifying identity, or the user can use Microsoft Entra account recovery where enabled.

**Q: Does MFA work with all SaaS applications?**

A: MFA applies to apps that sign in through Entra ID using modern authentication. Legacy authentication protocols can't do MFA, so block them with Conditional Access (or security defaults) and move apps to modern authentication.

## Next Steps

1. Audit your current MFA deployment
2. Identify users without MFA registered
3. Create Conditional Access policies for high-risk groups
4. Plan phased rollout (pilot, gradual, full)
5. Establish help desk support for MFA issues
6. Monitor adoption and adjust policies monthly

MFA is not a one-time implementation—it's an ongoing program. Start with pilot, measure adoption, adjust based on feedback, and scale gradually. Set a measurable adoption target and track it.
