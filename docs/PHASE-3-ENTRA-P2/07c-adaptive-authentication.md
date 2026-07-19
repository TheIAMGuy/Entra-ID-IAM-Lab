---
title: Adaptive Authentication - Risk-Based Access Control
part: 2
section: Authentication & Security
difficulty: Intermediate
estimated_reading_time: 45
estimated_lab_time: 90
prerequisites:
  - 07-authentication-fundamentals.md
  - 07a-multi-factor-authentication.md
  - 08-identity-risk-detection.md
learning_objectives:
  - Understand risk signals and how they inform authentication decisions
  - Implement risk-based Conditional Access policies
  - Configure step-up authentication for elevated operations
  - Monitor and tune adaptive authentication policies
  - Balance security and user experience through adaptive controls
---

# Adaptive Authentication: Risk-Based Access Control

## Introduction

Static authentication treats all sign-in attempts equally: either password alone, or always require MFA. But reality is more nuanced. A sign-in from your home office at 9 AM on a familiar device is inherently different from a sign-in from an unknown country at 2 AM on an unfamiliar device. Adaptive authentication makes this distinction by evaluating risk signals and requiring stronger authentication only when necessary. This approach improves both security and user experience: legitimate users face fewer friction points while attackers face escalating challenges. This document explains how to architect adaptive authentication and deploy it at enterprise scale.

**Learning Objectives:**
- Understand risk signals (device risk, user risk, sign-in risk, workload risk)
- Implement risk-based Conditional Access policies
- Configure step-up authentication for sensitive operations
- Monitor and optimize adaptive authentication policies
- Design fallback mechanisms for edge cases

## Risk Signals in Adaptive Authentication

Adaptive authentication evaluates multiple signals before deciding how much authentication is required. These signals include user behavior, device health, location, and historical patterns.

### User Risk Signal

User risk indicates whether an account has been compromised. Signals include:

- **Leaked credentials:** User's password found in breach databases (Dark Web monitoring)
- **Anonymous IP:** Sign-in from Tor, VPN, or proxy
- **Impossible travel:** User signed in from location A, then location B too quickly for travel
- **Malware-linked IP:** Sign-in from IP known to distribute malware
- **Suspicious activity:** Bulk modifications to account, unusual API calls
- **Suspicious sign-in:** Pattern different from baseline (new device, unusual time, etc.)

User risk is continuous: Microsoft's threat intelligence evaluates accounts 24/7.

### Sign-In Risk Signal

Sign-in risk indicates whether a particular sign-in attempt is legitimate. Signals include:

- **Anonymous IP:** VPN, Tor, proxy (not inherently malicious, but unusual)
- **Atypical travel:** Geographically impossible or unusual pattern
- **Unfamiliar properties:** Device, browser, or OS different from baseline
- **Malware-infected device:** Device flagged by Microsoft Defender
- **Suspicious credentials:** Abnormal password entry pattern or velocity
- **Old threat intelligence:** IP linked to past attacks

Sign-in risk is evaluated in real-time as the user attempts to authenticate.

### Device Risk Signal

Device risk indicates whether the device itself is trustworthy. Signals include:

- **Device compliance:** Device meets your security policies (encryption, antivirus, OS version, firewall)
- **Device threat level:** Microsoft Defender reports malware, risky apps, or vulnerabilities
- **Mobile threats:** iOS/Android device has jailbreak/rooting, suspicious apps
- **Unmanaged device:** Device not enrolled in Mobile Device Management

Device risk is especially important for privileged access and sensitive data.

### Workload Risk Signal

For service-to-service authentication (not user interactive), workload risk evaluates:

- **Certificate validity:** Workload identity certificate is valid and not revoked
- **IP reputation:** Service's source IP has history of abuse
- **Credential age:** Workload credentials are recently rotated
- **Anomalous API usage:** Service calling APIs with atypical patterns

## Implementing Risk-Based Conditional Access

Risk-based Conditional Access enforces authentication requirements based on these signals. Administrators define policies like "If user risk is high, require MFA" or "If device isn't compliant, require device compliance."

### Risk Level Definitions

Microsoft Entra ID evaluates risk on three levels:

| Risk Level | User Risk | Sign-In Risk | Action |
|-----------|-----------|--------------|--------|
| **Low** | Normal behavior, no signals | Familiar device, normal location, baseline pattern | Allow access (no additional auth) |
| **Medium** | Some suspicious signals, or unknown location | VPN detected, atypical property, minor anomaly | Require MFA |
| **High** | Multiple signals or leaked credentials | Malware-linked IP, impossible travel, major anomaly | Require MFA + device compliance |

### Policy Pattern 1: Require MFA for High User Risk

```
IF user risk = High
THEN require MFA AND session control
```

This policy protects compromised accounts. High user risk means credentials are leaked or account behavior is severely atypical.

**Configuration:**
1. In Entra ID, go to **Protection → Conditional Access**
2. Create policy: **"MFA for high user risk"**
3. **Conditions:** User risk = High
4. **Grant:** Require MFA
5. **Session:** Require session re-auth every 1 hour
6. Enable and test

**Result:** If user's credentials were found in a breach, they're prompted for MFA at next sign-in.

### Policy Pattern 2: Require MFA for High Sign-In Risk

```
IF sign-in risk = High
THEN require MFA
```

This policy protects against active attacks on legitimate accounts.

**Configuration:**
1. Create policy: **"MFA for high sign-in risk"**
2. **Conditions:** Sign-in risk = High
3. **Grant:** Require MFA
4. **Session:** Default (no special session control needed)
5. Enable and test

**Result:** Attacker attempts sign-in from malware-linked IP → MFA required → attacker can't bypass.

### Policy Pattern 3: Block High-Risk, Non-Compliant Access

```
IF sign-in risk = High AND device not compliant
THEN block access
```

This is the strictest control: block entirely unless risk is resolved.

**Configuration:**
1. Create policy: **"Block high-risk non-compliant access"**
2. **Assignments:** Sensitive user group (finance, executives, admins)
3. **Conditions:** Sign-in risk = High
4. **Grant:** Require device compliance
5. **Session:** Default
6. **Block access if not compliant** (toggle on)
7. Enable and test

**Result:** High-risk sign-in on non-compliant device → automatically denied.

### Policy Pattern 4: Require Step-Up Auth for Sensitive Operations

Step-up authentication requires additional proof when users attempt high-value operations (admin tasks, data access, privilege elevation).

```
IF user attempts admin operation OR accesses sensitive data
THEN require fresh MFA
```

**Configuration:**
1. Create policy: **"Step-up MFA for admin operations"**
2. **Assignments:** All users
3. **Cloud apps:** Microsoft Graph API (admin operations)
4. **Conditions:** Application = "Microsoft Graph"
5. **Grant:** Require MFA
6. **Session:** Require re-auth (fresh token) - set to 15 minutes
7. Enable and test

**Result:** User signs in normally (MFA not required if low-risk), then attempts to modify admin settings → must re-authenticate with MFA.

## Hands-On Lab: Configuring Adaptive Authentication

**Estimated Time:** 90 minutes

**Prerequisites:** Entra ID tenant with Premium P2 license, test users, Conditional Access access

**Lab Objectives:**
- Create user risk-based Conditional Access policy
- Create sign-in risk-based policy
- Test policies with high-risk simulation
- Monitor policy impact via logs

### Step 1: Create User Risk Policy (20 minutes)

1. In Entra ID admin center, go to **Protection → Conditional Access**
2. Click **+ New policy**
3. **Name:** "Block high user risk"
4. **Assignments:**
   - **Users:** Select "All users"
5. **Conditions:**
   - **User risk:** Select "High"
6. **Access controls:**
   - **Grant:** Select "Require multi-factor authentication"
7. **Session controls:** Leave default
8. **Enable policy:** Toggle to "On"
9. Click **Create**

**Expected Output:**
```
Policy created successfully
Name: Block high user risk
Status: On
Scope: All users
Condition: User risk = High
Action: Require MFA
```

### Step 2: Create Sign-In Risk Policy (20 minutes)

1. Create new policy: **"Require MFA for high sign-in risk"**
2. **Assignments:**
   - **Users:** All users
3. **Conditions:**
   - **Sign-in risk:** Select "High"
4. **Access controls:**
   - **Grant:** Require MFA
5. **Session:** Default
6. Enable policy

**Expected Output:**
```
Policy created successfully
Name: Require MFA for high sign-in risk
Status: On
Sign-in risk trigger: High
Enforcement: MFA required
```

### Step 3: Test Policies with Risk Simulation (30 minutes)

For testing, use Entra ID's risk injection feature or real-world simulation:

**Option A: Simulate High User Risk**
1. Go to **Protection → Identity Protection → User risk policy**
2. Ensure your test user's password has been disclosed (simulate)
3. Trigger password reset flow
4. Sign in with test user
5. Observe: MFA required due to "high user risk"

**Option B: Simulate High Sign-In Risk (requires compatible IP)**
1. Use a VPN or proxy to establish sign-in from unusual location
2. Sign in with test user
3. Observe: Entra ID detects anonymous IP
4. If risk rises to "high," MFA is required

**Expected Output:**
```
Sign-in attempt from unusual location
Risk level: High (Anonymous IP detected)
MFA requirement: Triggered
User prompted for MFA method
```

### Step 4: Review Policy Impact via Conditional Access Insights (20 minutes)

1. In Entra ID, go to **Protection → Conditional Access**
2. Click on each policy (User Risk, Sign-In Risk)
3. Review **Insights** tab:
   - Users affected
   - Policy impact (what percentage of sign-ins are affected)
   - Frequently failing scenarios
4. Go to **Audit logs** to see policy applications
5. Filter by "Policy applied" to see event log

**Expected Output:**
```
Policy Insights:
- Users affected: 50 (of 100 total)
- Sign-ins requiring MFA: 5% of total volume
- Common trigger: Anonymous IP
- Impact: Low friction (mostly legitimate VPN users)
```

### Step 5: Create Step-Up Auth Policy for Admin Roles (20 minutes)

1. Create new policy: **"Step-up MFA for role assignment"**
2. **Assignments:**
   - **Users:** All users
   - **Cloud apps:** Select Microsoft Graph
3. **Conditions:** None (applies to all admin operations)
4. **Access controls:**
   - **Grant:** Require MFA
   - **Session:** Set "Sign-in frequency" = 15 minutes
5. Enable policy

**Expected Output:**
```
Policy created: Step-up MFA for role assignment
Scope: All users attempting Microsoft Graph admin APIs
Action: Fresh MFA required every 15 minutes
Result: Admin tasks require re-authentication
```

## Balancing Security and User Experience

Adaptive authentication is only effective if policies are tuned to minimize false positives (legitimate users being blocked) while catching genuine attacks.

### Monitoring and Tuning

1. **Week 1-2:** Deploy policies in "Report-only" mode
   - Policies evaluate but don't block/require additional auth
   - Monitor impact via logs
   - Identify false positive patterns
2. **Week 3-4:** Move to enforcement with high-risk users only
   - Apply policies to IT team first
   - Gather feedback
   - Adjust sensitivity
3. **Week 5+:** Gradual rollout to all users
   - Monitor continuously
   - Adjust policies monthly based on trends

### Common Tuning Patterns

**Pattern: Users triggering MFA too frequently (false positives)**

- **Cause:** VPN users detected as anonymous IP
- **Solution:** Exclude corporate VPN IPs from "anonymous IP" risk signal
- **Implementation:** Create exception policy: "If sign-in from corporate IP, don't flag as anonymous"

**Pattern: Service accounts showing high workload risk**

- **Cause:** Service account activity differs from user baseline
- **Solution:** Create separate policies for workload identities
- **Implementation:** Exclude service accounts from user risk policies

**Pattern: Legitimate high-risk activity blocked**

- **Cause:** User traveling internationally triggers impossible travel
- **Solution:** Use "Report-only" mode for executives
- **Implementation:** Create policy: "Executives = report-only"

## Compliance & Standards Alignment

**NIST Cybersecurity Framework 2.0:**
- **Protect (P):** Adaptive authentication adapts protection to real-time risk
- **Detect (D):** Risk signals detect anomalous behavior in real-time

**ISO 27001:2022:**
- **A.9.2.1:** Adaptive MFA satisfies "user authentication" with risk assessment
- **A.12.4.1:** Security monitoring via risk detection

**Gartner IAM Framework:**
- **Access Management:** Adaptive auth is the modern approach to access control
- **IVIP:** Risk signals come from identity intelligence platform

**Standards Recommending Adaptive Auth:**
- **NIST SP 800-63-3:** Risk-based authentication strengthens security
- **HIPAA:** MFA required for healthcare; adaptive MFA is accepted method

## Related Documents

**Prerequisites:**
- [Authentication Fundamentals](./07-authentication-fundamentals.md) - Core concepts
- [Multi-Factor Authentication](./07a-multi-factor-authentication.md) - MFA implementation
- [Identity Risk Detection](./08-identity-risk-detection.md) - Risk signal details

**Next Steps:**
- [Identity Risk Detection](./08-identity-risk-detection.md) - Understand risk signals in depth
- [Conditional Access Policies](./09-identity-standards-overview.md) - Advanced policy design
- [Zero Trust Identity Architecture](./08b-zero-trust-identity-architecture.md) - Zero Trust foundation

## Further Reading

**Microsoft Learn:**
- [Conditional Access: User Risk](https://learn.microsoft.com/en-us/entra/identity/conditional-access/concept-conditional-access-policy-common)
- [Identity Protection: Risk Detection](https://learn.microsoft.com/en-us/entra/id-protection/concept-identity-protection-risks)
- [Step-Up Authentication](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-authentication-strengths)

**Industry Resources:**
- [OWASP: Adaptive Authentication](https://owasp.org/www-project-web-security-testing-guide/)
- [Gartner: Adaptive Authentication Best Practices](https://www.gartner.com)

## FAQ

**Q: How often are risk signals updated?**

A: Real-time for sign-in risk (evaluated at each login). User risk is evaluated continuously (24/7 background monitoring). Policy enforcement is immediate upon policy deployment.

**Q: What if a user legitimately triggers high sign-in risk (traveling)?**

A: Adaptive policies should have exceptions. Create policy: "Executives = report-only" or "Trusted travel locations = lower risk threshold." Plan for this in policy design.

**Q: Can we combine user risk and sign-in risk in one policy?**

A: Yes. Create policy: "IF (user risk = High OR sign-in risk = High) THEN require MFA." This provides defense-in-depth.

**Q: Does adaptive auth replace device compliance policies?**

A: No. Use both: Risk-based policies enforce MFA dynamically; device compliance policies ensure devices meet minimum security standards. Together they provide comprehensive protection.

**Q: How do we handle service accounts with adaptive auth?**

A: Exclude service accounts from user risk policies (service accounts naturally have atypical patterns). Implement separate workload identity policies based on certificate validity and API usage patterns.

## Next Steps

1. Enable Identity Protection in your tenant
2. Monitor baseline risk signal patterns for 1 week
3. Create pilot policies for IT team (report-only first)
4. Gradually move policies to enforcement
5. Monitor logs weekly and adjust policies
6. Roll out company-wide after 4 weeks of successful pilot
7. Review and optimize policies monthly

Adaptive authentication is a continuous process of learning patterns and refining policies. Start with low-risk groups, measure impact, and scale gradually.
