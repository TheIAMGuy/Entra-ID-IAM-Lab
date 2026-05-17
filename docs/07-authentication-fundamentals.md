---
title: Authentication Fundamentals - Verifying Identity
part: 2
section: Authentication & Security
difficulty: Foundation
estimated_reading_time: 40
estimated_lab_time: 60
prerequisites:
  - 00-iam-landscape-overview.md
  - 01-environment-setup.md
learning_objectives:
  - Understand the difference between authentication and authorization
  - Learn the four authentication factors (something you know, have, are, do)
  - Understand multi-factor authentication (MFA) and why it matters
  - Know Entra ID authentication capabilities and implementation patterns
---

# Authentication Fundamentals: Verifying Identity

## Introduction

Authentication is the process of proving that someone is who they claim to be. It's the foundation of all identity security. Without strong authentication, everything else in your IAM system becomes vulnerable—because if you can't verify identity, you can't trust any access decision that follows.

This document covers the fundamentals of authentication: what it is, why it matters, the different factors that make it strong, and how Microsoft Entra ID implements authentication across your organization.

**Learning Objectives:**
- Understand authentication vs. authorization (different concepts, often confused)
- Learn the four authentication factors and how they work
- Understand multi-factor authentication and risk-based authentication
- Know Entra ID's authentication capabilities and deployment patterns
- Learn authentication best practices and security considerations

**Estimated Reading Time:** 40 minutes

**Estimated Lab Time:** 60 minutes (hands-on MFA configuration)

**Prerequisites:**
- [IAM Landscape Overview](./00-iam-landscape-overview.md) — Understand identity domains
- [Environment Setup & Prerequisites](./01-environment-setup.md) — Have an Entra ID tenant ready

## Section 1: Authentication vs. Authorization

Before diving into authentication methods, we need to clarify a common confusion: **authentication** and **authorization** are different concepts that work together.

**Authentication** answers the question: *"Are you who you claim to be?"* It's the process of verifying identity. When you log into your bank's website with your username and password, you're authenticating. The bank verifies your identity by checking if your password matches what they have on file.

**Authorization** answers the question: *"What can you access?"* Once authenticated, authorization determines what resources you're allowed to use. After you log into your bank's website, authorization controls whether you can view your checking account, access your savings account, or perform transfers.

**Real-World Example:**
Imagine you're trying to board an airplane:
- **Authentication:** The security officer checks your passport and boarding pass to verify you are who you claim to be
- **Authorization:** The boarding pass determines which flight you can board and what seat is assigned

In identity management:
- **Authentication** happens first: "Prove you're John Smith"
- **Authorization** happens second: "Here's what John Smith can access"

This document focuses on authentication. Once you're authenticated, systems use authorization (access control) to determine what you can do. That's covered in Parts 1, 3, and 5.

**Key Point:** You cannot have strong authorization without strong authentication. If you can't prove someone's identity reliably, access control decisions based on that identity are meaningless.

## Section 2: The Four Authentication Factors

Authentication is based on factors—pieces of evidence that prove identity. There are four categories of factors:

### Factor 1: Something You Know

**Definition:** Information only you should know.

**Common examples:**
- Password
- PIN
- Security question answers
- Pattern unlock (swipe pattern on phone)

**Strengths:**
- Low cost to implement
- Works with any device (no special hardware needed)
- Users are familiar with passwords

**Weaknesses:**
- Passwords are often weak (123456, password, qwerty)
- Users reuse passwords across multiple services
- Passwords can be guessed, brute-forced, or stolen
- Users forget passwords frequently
- Vulnerable to phishing (attacker tricks you into revealing your password)

**Entra ID Implementation:** Password authentication is the baseline in Entra ID. All user accounts require a password.

### Factor 2: Something You Have

**Definition:** A physical or virtual device only you possess.

**Common examples:**
- Mobile phone (receives text message or authentication app notification)
- Hardware security key (FIDO2 key, physical device)
- Smartcard (chip-based card for physical access and authentication)
- One-time password (OTP) token (small device generating time-based codes)

**Strengths:**
- Much harder to compromise than passwords
- Attacker needs physical access to your device
- Can't be guessed or brute-forced
- Very resistant to phishing (device must be present)

**Weaknesses:**
- Requires having the device with you
- Can be lost or stolen
- Cost (hardware keys, smartcards)
- Users may not have consistent access to devices

**Entra ID Implementation:** Entra ID supports multiple "something you have" factors:
- Mobile phone (via Microsoft Authenticator app)
- Mobile phone (via SMS text message)
- Mobile phone (via phone call)
- Hardware security keys (FIDO2 keys)

### Factor 3: Something You Are

**Definition:** Your biological or behavioral characteristics.

**Common examples:**
- Fingerprint
- Facial recognition
- Iris/retina scan
- Voice recognition
- Behavioral patterns (typing speed, mouse movement)

**Strengths:**
- Impossible to forget (unlike passwords)
- Impossible to guess (unlike passwords)
- Very difficult to spoof or forge (especially modern biometrics)
- User-friendly (no need to remember anything)
- Nearly impossible to phish (attacker can't trick you into giving biometric data)

**Weaknesses:**
- Privacy concerns (storing biometric data)
- Requires specialized hardware (fingerprint reader, camera)
- Not 100% accurate (false positives, false negatives)
- Some users uncomfortable with biometrics
- Cost of biometric hardware

**Entra ID Implementation:** Entra ID integrates with device-based biometrics:
- Windows Hello for Business (facial recognition, fingerprint on Windows devices)
- Mobile device biometrics (fingerprint, face recognition on iPhones/Android)
- FIDO2 keys with biometric capability

### Factor 4: Something You Do

**Definition:** Actions or behaviors unique to you.

**Common examples:**
- Geographic location (where you're accessing from)
- Device used (known vs. unknown device)
- Time of access (accessing at 3 AM when you normally work 9-5)
- Behavioral anomalies (login from impossible location in short time)
- Risk level (unusual access pattern)

**Strengths:**
- Invisible to the user (no action required)
- Adapts to legitimate behavior changes
- Can detect account compromise quickly

**Weaknesses:**
- Can have false positives (legitimate behavior looks suspicious)
- Requires data collection and analytics
- Users may not understand why they're challenged
- Cannot be the only factor (not sufficient alone)

**Entra ID Implementation:** Entra ID uses behavioral factors through:
- Conditional Access policies (context-based access decisions)
- Identity Protection (risk detection and response)
- Sign-in risk scoring (assesses likelihood of account compromise)

## Section 3: Multi-Factor Authentication (MFA) and Strong Authentication

**Multi-Factor Authentication (MFA)** requires you to prove your identity using **two or more different factors** from different categories (not two factors from the same category).

**Why MFA Matters:**

A password alone is insufficient for security. Here's why:
- **Phishing:** Attackers trick you into giving them your password. With MFA, they have your password but can't log in without your second factor
- **Password breaches:** If a service is hacked and passwords leaked, attackers still can't access your account without the second factor
- **Weak passwords:** Users often choose weak passwords; even if guessed, MFA blocks the attacker
- **Credential stuffing:** Attackers use leaked passwords from other services to try your account; MFA blocks them

**Real-World Impact:**

Microsoft research shows:
- **Without MFA:** Account compromise is possible with just a password
- **With MFA:** Account compromise is blocked 99.9% of the time, even if password is stolen

**Examples of Strong MFA:**

✅ **Strong (Two Different Factors):**
- Password + phone approval (something you know + something you have)
- Password + fingerprint (something you know + something you are)
- Password + location check (something you know + something you do)

❌ **Weak (Not Real MFA):**
- Password + security question (both are "something you know")
- Password + password recovery question (both are "something you know")

**Entra ID MFA Capabilities:**

Entra ID supports multiple MFA methods:
1. **Microsoft Authenticator app** — Notifications on your phone (something you have + something you do)
2. **SMS text message** — Code sent via text (something you have)
3. **Phone call** — Automated voice call with code (something you have)
4. **Hardware security key** — FIDO2 key (something you have)
5. **Windows Hello for Business** — Facial recognition on Windows (something you are)
6. **Mobile biometrics** — Fingerprint or face on mobile devices (something you are)

### Risk-Based Authentication

Modern authentication systems go beyond simple MFA. **Risk-based authentication** adapts authentication strength based on risk factors.

**How it works:**

The system evaluates risk during login:
- **Low risk:** Normal user, expected location, known device, expected time
- **Medium risk:** Unusual location, unfamiliar device, unusual time
- **High risk:** Impossible geography, suspicious behavior, account compromise signals

**Response:**

- **Low risk:** Password alone may be sufficient
- **Medium risk:** MFA required
- **High risk:** MFA + additional verification or access blocked

**Real Example:**

You normally log in from your office in New York during business hours. One day:
- **Scenario 1:** You log in from home on Saturday afternoon
  - Risk: Medium (unusual location and time)
  - Response: System requires MFA
- **Scenario 2:** You log in from Tokyo at 2 AM, then see a login from New York 5 minutes later
  - Risk: High (impossible geography)
  - Response: System blocks access; requires security review

Risk-based authentication provides better security without constantly bothering users. We cover this in detail in [Part 2c: Adaptive Authentication](./07c-adaptive-authentication.md).

## Section 4: Hands-On Lab - Configure MFA in Entra ID

**Objective:** Configure multi-factor authentication for a test user and verify it works

**Time:** 60 minutes

**Prerequisites:**
- Entra ID tenant access (free tier acceptable)
- A test user account created
- Access to a mobile device (for testing Authenticator app)
- [Environment Setup document](./01-environment-setup.md) completed

### Lab Steps

**Step 1: Install Microsoft Authenticator App (5 minutes)**

1. On your mobile device, go to app store:
   - iOS: Apple App Store
   - Android: Google Play Store
2. Search for "Microsoft Authenticator"
3. Install the official Microsoft app
4. Launch the app

**Step 2: Register Authenticator for Your Account (10 minutes)**

1. Go to [https://myaccount.microsoft.com](https://myaccount.microsoft.com)
2. Log in with your test user account
3. Navigate to **Security info** (left menu)
4. Click **Add sign-in method**
5. Select **Authenticator app**
6. Click **Add**
7. Your phone will show a setup code
8. On your mobile device:
   - Open Microsoft Authenticator app
   - Tap **+** to add account
   - Select **Work or school account**
   - Scan the QR code on your computer screen
9. Confirm the account appears in your app

**Expected Result:**
- Authenticator app shows your account
- Account displays "Multifactor authentication"
- Status shows "Activated"

### Step 3: Test MFA Login (10 minutes)

1. In a different browser or incognito window
2. Go to [https://portal.azure.com](https://portal.azure.com)
3. Log in with your test account username
4. After entering password, you'll be prompted:
   - **"How do you want to sign in?"**
   - Multiple options appear (Authenticator app, SMS, phone call)
5. Select **Authenticator app**
6. On your mobile device:
   - You receive a notification in Microsoft Authenticator
   - Notification shows: "Sign in request"
   - Approve the request
7. Back on your computer: You're logged in

**Expected Result:**
- You received the MFA prompt after password
- Mobile approval was required to complete login
- You successfully logged in with MFA

### Step 4: Test Password Alone Fails (5 minutes)

This demonstrates why MFA matters:

1. Disable Authenticator temporarily (in real scenarios, attacker wouldn't have this)
2. Log out of Azure portal
3. Log back in with just password (without using Authenticator)

**What happens:** You're blocked at MFA step (can't proceed without second factor)

**Real-world implication:** Even if attacker has your password, they cannot log in without your mobile device.

### Step 5: Try SMS Alternative (10 minutes)

**Important:** MFA should support multiple methods (user loses phone, battery dies, etc.)

1. Go back to [https://myaccount.microsoft.com](https://myaccount.microsoft.com)
2. Go to **Security info**
3. Click **Add sign-in method**
4. Select **Phone number**
5. Select **Text me a code**
6. Enter your mobile phone number
7. Receive and verify the text code
8. Confirm SMS is added

**Test it:**
1. Log out of Azure portal
2. Log in again, this time select **Text me a code** instead of Authenticator app
3. Receive SMS with code
4. Enter code to complete login

**Expected Result:**
- You received SMS code
- Entered code completed MFA
- Both Authenticator app and SMS work as MFA methods

### Troubleshooting

| Issue | Solution |
|-------|----------|
| Authenticator app won't install | Ensure device has iOS 11+ or Android 6.0+ |
| QR code won't scan | Try typing account manually in Authenticator app |
| SMS code doesn't arrive | Verify phone number is correct; try calling instead |
| Still can't log in | Clear browser cache; try incognito window |
| Forgot Authenticator code | Wait 30 seconds for new code to generate |

## Section 5: Authentication Best Practices

### Best Practice 1: Use MFA Everywhere

**Standard:** Require MFA for all users, especially:
- Administrators
- Users accessing sensitive data
- Users with privileged roles
- Remote workers

**Entra ID Implementation:**
```powershell
# LANGUAGE: PowerShell

# Require MFA for all users in a group
$group = Get-MgGroup -Filter "displayName eq 'All Users'"
$users = Get-MgGroupMember -GroupId $group.Id

# Assign MFA registration requirement
Update-MgIdentityAuthenticationMethod -UserId $user.Id -Properties @{
  "isRegistrationRequired" = $true
}

# EXPECTED OUTPUT:
# User is now required to register MFA on next login

# EXPLANATION: This enforces MFA registration for selected users
```

### Best Practice 2: Support Multiple MFA Methods

Don't rely on a single MFA method:
- What if user loses phone?
- What if SMS service fails?
- What if biometric reader breaks?

**Solution:** Support multiple factors:
- Authenticator app (primary)
- SMS backup
- Phone call backup
- Hardware key (for high-security scenarios)

### Best Practice 3: Consider Risk-Based MFA

Not every login needs the same security level. Use risk-based authentication:
- **Low-risk login:** Password alone (familiar location, device, time)
- **Medium-risk login:** MFA required (unusual location or device)
- **High-risk login:** Blocked or requires additional verification

This balances security with usability.

### Best Practice 4: Educate Users on Phishing

MFA is not bulletproof. Attackers can:
- Trick users into approving malicious requests
- Perform "MFA fatigue" attacks (repeated approvals until user clicks yes)
- Use social engineering to steal MFA tokens

Educate users:
- "Approve requests only if you're actively logging in"
- "If you don't recognize the login request, deny it"
- "Microsoft will never ask for your password via email"

### Best Practice 5: Monitor Authentication Events

Log and monitor:
- Failed authentication attempts
- MFA denials (user denied the approval)
- Unusual authentication locations or times

**Entra ID provides:**
- Sign-in logs (all login attempts)
- Audit logs (all authentication events)
- Risk detections (suspicious authentication patterns)

## Compliance & Standards

**NIST Cybersecurity Framework 2.0:**
- **Protect (P):** Authentication is a core protective control
- **Detect (D):** Monitoring authentication attempts detects breaches

**ISO 27001:2022:**
- **Annex A.9.2:** Secure access to user terminal equipment
- **Annex A.9.4:** Access management for application and information systems

**Gartner IAM Framework:**
- **Access Management:** Authentication is the foundation
- **Identity Verification & Intelligence:** Risk-based authentication improves verification

**SANS Top 25:**
- **CWE-521:** Weak password requirements (mitigated with MFA)
- **CWE-287:** Improper authentication (proper MFA prevents)

## Related Documents

**Prerequisites (read first):**
- [IAM Landscape Overview](./00-iam-landscape-overview.md) — Understand identity domains
- [Environment Setup](./01-environment-setup.md) — Prepare your Entra ID tenant

**Build on this knowledge:**
- [Multi-Factor Authentication (MFA)](./07a-multi-factor-authentication.md) — Deep dive into MFA methods and implementation
- [Passwordless Authentication](./07b-passwordless-authentication.md) — Go beyond passwords
- [Adaptive Authentication](./07c-adaptive-authentication.md) — Risk-based, context-aware authentication
- [Identity Risk Detection](./08-identity-risk-detection.md) — Detect compromised accounts

**Cross-references:**
- [Identity Provisioning: Joiner](./02-identity-provisioning-joiner.md) — New users need authentication setup
- [Access Control Overview](./03-group-based-access-control.md) — Authentication precedes authorization

## Further Reading

**Microsoft Official Documentation:**
- [Entra ID Authentication Methods](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-methods) — All supported methods
- [Plan Your Passwordless Deployment](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-passwordless) — Moving beyond passwords
- [Configure MFA in Entra ID](https://learn.microsoft.com/en-us/entra/identity/authentication/tutorial-enable-azure-mfa) — Step-by-step setup guide

**Industry Standards:**
- [NIST SP 800-63B](https://pages.nist.gov/800-63-3/sp800-63b.html) — Authentication and lifecycle management
- [FIDO Alliance](https://fidoalliance.org/) — Standards for passwordless authentication

**External Resources:**
- Microsoft Security Blog on Authentication — Latest threat intelligence
- "The 2023 State of Password and Authentication" report — Industry trends
- OWASP Authentication Cheat Sheet — Security best practices

## FAQ

**Q: Is MFA really necessary if I have a strong password?**

A: Yes. Even strong passwords can be compromised through phishing, credential stuffing, or breaches. MFA blocks attackers even with your password. Industry data shows MFA blocks 99.9% of account compromise attempts.

**Q: What's the difference between MFA and 2FA?**

A: They're often used interchangeably, but technically 2FA (two-factor authentication) is a specific type of MFA that uses exactly two factors. MFA can use two, three, or more factors. In practice, organizations use the terms similarly.

**Q: Does MFA slow down login?**

A: Slightly (5-10 seconds), but modern MFA using Authenticator app is fast. Users click "approve" on their phone, done. This small delay is worth the security benefit.

**Q: Can I use the same MFA method for multiple accounts?**

A: Yes. One Authenticator app on your phone can have multiple work accounts, personal accounts, etc. This is convenient but means losing your phone impacts all accounts (good backup is important).

**Q: What happens if I lose my phone?**

A: This is why backup authentication methods are critical. If you have SMS set up, you can use SMS to log in, then register a new device. Best practice: Have at least 2 MFA methods registered.

**Q: Is biometric authentication more secure than password + MFA?**

A: Different security model. Windows Hello (biometric) is very secure for device unlock. Authenticator MFA is secure for application access. Combining both (password + biometric Authenticator approval) is strongest.

## Next Steps

Now that you understand authentication fundamentals:

1. **If you're an IT Administrator:** Read [MFA Implementation](./07a-multi-factor-authentication.md) to deploy MFA in your organization
2. **If you want passwordless:** Read [Passwordless Authentication](./07b-passwordless-authentication.md) for beyond-password approaches
3. **If you want smarter security:** Read [Adaptive Authentication](./07c-adaptive-authentication.md) for risk-based decisions
4. **If you're implementing access control:** Continue to [Access Control Overview](./03-group-based-access-control.md) to control what authenticated users can access

Authentication is the foundation. Everything else in IAM depends on knowing, with high confidence, who the user really is.
