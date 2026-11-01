---
title: Adaptive Authentication - Risk-Based Access Control
section: Authentication & Security
difficulty: Intermediate
estimated_reading_time: 45
estimated_lab_time: 90
prerequisites:
  - guide-multi-factor-authentication.md
  - 07c-conditional-access-policy.md
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

User risk is the probability that an identity is compromised. Microsoft Entra ID Protection calculates it from user risk detections and from risky sign-ins. Examples:

- **Leaked credentials:** The user's valid credentials were found in a breach or public source. This detection is always high risk.
- **Microsoft Entra threat intelligence:** Activity consistent with known attack patterns.
- **Admin confirmed user compromised:** An administrator selected **Confirm user compromised**.
- **Risky sign-ins:** Sign-in risk detections on the account also raise user risk.

User risk persists until it is remediated, for example by a secure password change, or dismissed by an administrator.

### Sign-In Risk Signal

Sign-in risk is the probability that a particular authentication request isn't from the identity owner. It is evaluated during each sign-in, with some detections processed offline afterwards. Examples:

- **Anonymous IP address:** Tor or an anonymous VPN
- **Atypical travel:** Sign-ins from distant locations that don't fit the user's pattern
- **Unfamiliar sign-in properties:** Properties the user hasn't recently used
- **Malicious IP address:** An IP address with known malicious activity
- **Password spray:** A successful sign-in following a spray attack
- **Suspicious MFA authentication approval:** Unfamiliar properties around an MFA approval, which can indicate a phishing or social engineering attack

Most detections require Microsoft Entra ID P2. Anonymous IP address and Microsoft Entra threat intelligence are available without P2, and tenants without P2 see other detections only as "Additional risk detected". See [What are risk detections?](https://learn.microsoft.com/en-us/entra/id-protection/concept-identity-protection-risks).

### Device Signal

Device state isn't an ID Protection risk detection, but Conditional Access can use it as a condition or grant control:

- **Device compliance:** The device is marked compliant by Intune (encryption, OS version, and other policies)
- **Microsoft Entra hybrid joined:** The device is joined to both on-premises Active Directory and Entra ID
- **Device filters:** Policies can include or exclude devices by attribute

Defender for Endpoint risk can feed compliance through Intune. Device state matters most for privileged access and sensitive data.

### Workload Risk Signal

For service principals and applications (not interactive users), Workload ID Protection detects:

- **Suspicious sign-ins:** Sign-in properties or patterns unusual for the service principal
- **Leaked credentials:** Service principal credentials found in a public source
- **Anomalous service principal activity:** Unusual administrative behaviour
- **Suspicious API traffic:** Abnormal Graph API traffic or directory enumeration
- **Malicious or suspicious application:** Applications flagged for violating terms of service

Full risk details and risk-based access controls need Workload Identities Premium. Managed identities are not currently in scope. See [Securing workload identities](https://learn.microsoft.com/en-us/entra/id-protection/concept-workload-identity-risk).

## Implementing Risk-Based Conditional Access

Risk-based Conditional Access enforces authentication requirements based on these signals. Administrators define policies like "If user risk is high, require MFA" or "If device isn't compliant, require device compliance."

### Risk Level Definitions

ID Protection reports user risk and sign-in risk as **low**, **medium** or **high**. Microsoft's recommended starting points are:

| Risk type | Suggested threshold | Suggested control |
|-----------|--------------------|-------------------|
| Sign-in risk | Medium and High | Require multifactor authentication (an authentication strength of Multifactor authentication) |
| User risk | High | Require secure password change (after MFA), or block |

The thresholds are a trade-off between security and user friction, and the right values differ by organisation. See [Choosing acceptable risk levels](https://learn.microsoft.com/en-us/entra/id-protection/howto-identity-protection-configure-risk-policies#choosing-acceptable-risk-levels).

Do not combine a sign-in risk condition and a user risk condition in the same policy. Create separate policies for each.

### Policy Pattern 1: Require Password Change for High User Risk

```
IF user risk = High
THEN require MFA AND require password change
```

This policy protects compromised accounts. High user risk means credentials are leaked or the account behaves in a severely atypical way. A secure password change remediates the risk automatically.

**Configuration:**
1. In the Microsoft Entra admin center, go to **Entra ID → Conditional Access → Policies**
2. Create policy: **"Require password change for high user risk"**
3. **Conditions:** User risk = High
4. **Grant:** Require authentication strength (Multifactor authentication) and Require password change
5. **Session:** Sign-in frequency = Every time
6. Create in **Report-only**, review the results, then enable

**Result:** A user whose credentials were leaked must complete MFA and then change their password at next sign-in.

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

### Policy Pattern 3: Block High-Risk Sign-Ins for Sensitive Users

```
IF sign-in risk = High AND user is in a sensitive group
THEN block access
```

This is the strictest control: block access until an administrator investigates. Use it for a small, sensitive group, because a block gives the user no way to self-remediate.

**Configuration:**
1. Create policy: **"Block high sign-in risk for sensitive users"**
2. **Assignments:** Sensitive user group (finance, executives, admins), excluding emergency access accounts
3. **Conditions:** Sign-in risk = High
4. **Grant:** Block access
5. Create in **Report-only**, review the results, then enable

**Result:** A high-risk sign-in by a sensitive user is denied and appears in the sign-in logs.

### Policy Pattern 4: Require Step-Up Authentication for Sensitive Operations

Step-up authentication requires stronger proof when users reach high-value resources or actions.

```
IF user accesses Microsoft admin portals OR a protected resource
THEN require MFA
```

**Configuration:**
1. Create policy: **"Require MFA for admin portals"**
2. **Assignments:** All users (or admin roles), excluding emergency access accounts
3. **Target resources:** Select **Microsoft Admin Portals**
4. **Grant:** Require authentication strength (Multifactor authentication)
5. **Session:** Sign-in frequency (a time value in hours, or Every time)
6. Create in Report-only, review the results, then enable

For finer control inside an application, use a **Conditional Access authentication context**. You publish a context, attach a policy to it, and apps or SharePoint sensitivity labels trigger a step-up when the user reaches the protected action. Privileged Identity Management can also require an authentication context on role activation. See [Conditional Access authentication context](https://learn.microsoft.com/en-us/entra/identity-platform/developer-guide-conditional-access-authentication-context).

## Hands-On Lab: Configuring Adaptive Authentication

**Estimated Time:** 90 minutes

**Prerequisites:** Entra ID tenant with Premium P2 license, test users, Conditional Access Administrator role, and at least one test user registered for MFA (a risk policy can only prompt a user who is already registered)

**Lab Objectives:**
- Create user risk-based Conditional Access policy
- Create sign-in risk-based policy
- Test policies with high-risk simulation
- Monitor policy impact via logs

### Step 1: Create User Risk Policy (20 minutes)

1. In the Microsoft Entra admin center, go to **Entra ID → Conditional Access → Policies**
2. Click **+ New policy**
3. **Name:** "Require password change for high user risk"
4. **Assignments:**
   - **Users:** Select "All users"
5. **Conditions:**
   - **User risk:** Select "High"
6. **Access controls:**
   - **Grant:** Select "Require password change" (this also requires MFA first)
7. **Session controls:** Leave default
8. **Enable policy:** Set to "Report-only" first, then move to "On" after reviewing the results
9. Click **Create**

**Expected Output:**
```
Policy created successfully
Name: Require password change for high user risk
Status: Report-only
Scope: All users
Condition: User risk = High
Action: Require password change
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
1. Go to **Protection → ID Protection → Risky users**
2. Select the test user and choose **Confirm user compromised**. This sets the user's risk to High. Use a test account only.
3. Sign in with the test user
4. Observe: the policy requires MFA and then a secure password change due to "high user risk"

**Option B: Simulate Sign-In Risk (anonymous IP)**
1. Using the Tor Browser, go to https://myapps.microsoft.com and sign in with a test account
2. The sign-in appears in the risk reports within 10–15 minutes
3. Observe: ID Protection records an Anonymous IP address detection
4. A policy set to the risk level of that detection prompts for MFA. Other detections can't be simulated safely. See [Simulate risk detections](https://learn.microsoft.com/en-us/entra/id-protection/howto-identity-protection-simulate-risk).

**Expected Output:**
```
Sign-in attempt from unusual location
Risk level: High (Anonymous IP detected)
MFA requirement: Triggered
User prompted for MFA method
```

### Step 4: Review Policy Impact via Conditional Access Insights (20 minutes)

1. In the Microsoft Entra admin center, go to **Entra ID → Conditional Access → Policies**
2. Open each policy (User Risk, Sign-In Risk) and review the report-only results or the impact analysis workbook
3. Review **Insights** tab:
   - Users affected
   - Policy impact (what percentage of sign-ins are affected)
   - Frequently failing scenarios
4. Go to **Audit logs** to see policy applications
5. Filter by "Policy applied" to see event log

**Expected Output (illustrative):**
```
Policy Insights:
- Users affected: 50 (of 100 total)
- Sign-ins requiring MFA: 5% of total volume
- Common trigger: Anonymous IP
- Impact: Low friction (mostly legitimate VPN users)
```

### Step 5: Create Step-Up Auth Policy for Admin Portals (20 minutes)

1. Create new policy: **"Require MFA for admin portals"**
2. **Assignments:**
   - **Users:** Select your admin test group, exclude emergency access accounts
   - **Target resources:** Select **Microsoft Admin Portals**
3. **Conditions:** None
4. **Access controls:**
   - **Grant:** Require authentication strength (Multifactor authentication)
   - **Session:** Set **Sign-in frequency** to 1 hour
5. Set the policy to **Report-only**, review it, then enable

**Expected Output (illustrative):**
```
Policy created: Require MFA for admin portals
Scope: Admin test group signing in to Microsoft admin portals
Action: MFA required, reauthentication after 1 hour
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
- **Solution:** Define your VPN and office IP ranges as named locations and mark them as trusted
- **Implementation:** **Entra ID → Conditional Access → Named locations → New location → Mark as trusted location.** Sign-ins from trusted locations improve ID Protection's risk accuracy and reduce false positives

**Pattern: Service accounts showing high workload risk**

- **Cause:** Service account activity differs from user baseline
- **Solution:** Use Conditional Access for workload identities, and replace user accounts used as service accounts with service principals or managed identities
- **Implementation:** Exclude service accounts from user-scoped risk policies

**Pattern: Legitimate high-risk activity blocked**

- **Cause:** User traveling internationally triggers impossible travel
- **Solution:** Let users self-remediate with MFA, and have administrators review the risky sign-in. If the travel was legitimate, mark the sign-in as safe in ID Protection
- **Implementation:** Use a risk policy that requires MFA at medium and high sign-in risk, so travelling users prove who they are instead of being blocked

## Compliance & Standards Alignment

Risk-based access supports the detection and access-control aspects of common frameworks. Verify wording against the current standard before citing it.

- **NIST CSF 2.0:** Authentication and access control (PR.AA) and continuous monitoring (DE.CM)
- **ISO/IEC 27001:2022:** Secure authentication (8.5) and monitoring activities (8.16)
- **Zero Trust:** "Verify explicitly" using signals such as user risk, sign-in risk, device state and location

## Related Documents

- [Multi-Factor Authentication guide](guide-multi-factor-authentication.md)
- [Lab 07c — Conditional Access Policy](07c-conditional-access-policy.md)
- [Lab 07d — Risk-Based Conditional Access](07d-risk-based-conditional-access.md)

## Further Reading

**Microsoft Learn:**
- [Risk-based access policies](https://learn.microsoft.com/en-us/entra/id-protection/concept-identity-protection-policies)
- [Configure and enable risk policies](https://learn.microsoft.com/en-us/entra/id-protection/howto-identity-protection-configure-risk-policies)
- [Identity Protection: Risk Detection](https://learn.microsoft.com/en-us/entra/id-protection/concept-identity-protection-risks)
- [Conditional Access authentication context](https://learn.microsoft.com/en-us/entra/identity-platform/developer-guide-conditional-access-authentication-context)


## FAQ

**Q: How often are risk signals updated?**

A: Real-time detections run at each sign-in, and offline detections can raise risk afterwards. Risk feedback and remediation can take time to process. Test policy changes in report-only mode first.

**Q: What if a user legitimately triggers high sign-in risk (traveling)?**

A: Require MFA at medium and high sign-in risk so the user can self-remediate, and mark legitimate sign-ins as safe in ID Protection. Avoid blanket exceptions, because they leave the most targeted accounts unprotected.

**Q: Can we combine user risk and sign-in risk in one policy?**

A: Not in one policy. Microsoft advises against combining the two risk conditions in the same Conditional Access policy. Create one policy for sign-in risk and a separate one for user risk.

**Q: Does adaptive auth replace device compliance policies?**

A: No. Use both: Risk-based policies enforce MFA dynamically; device compliance policies ensure devices meet minimum security standards. Together they provide comprehensive protection.

**Q: How do we handle service accounts with adaptive auth?**

A: Calls from service principals aren't blocked by user-scoped policies. Replace user accounts used as service accounts with service principals or managed identities, and use Conditional Access for workload identities (Workload Identities Premium) to target service principals.

## Next Steps

1. Enable Identity Protection in your tenant
2. Monitor baseline risk signal patterns before enforcing
3. Create pilot policies for IT team (report-only first)
4. Gradually move policies to enforcement
5. Monitor logs weekly and adjust policies
6. Roll out company-wide after a successful pilot
7. Review and optimize policies regularly

Adaptive authentication is a continuous process of learning patterns and refining policies. Start with low-risk groups, measure impact, and scale gradually.
