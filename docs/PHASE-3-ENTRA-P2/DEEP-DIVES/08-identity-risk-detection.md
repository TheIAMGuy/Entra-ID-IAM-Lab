---
title: Identity Risk Detection - Detecting & Responding to Threats
part: 2
section: Authentication & Security
difficulty: Intermediate
estimated_reading_time: 50
estimated_lab_time: 60
prerequisites:
  - 07-authentication-fundamentals.md
  - 07a-multi-factor-authentication.md
learning_objectives:
  - Understand identity risk detection capabilities and threat signals
  - Configure risk detection policies in Microsoft Entra ID
  - Respond to detected identity risks with automated remediation
  - Implement investigation workflows for risky sign-ins
  - Monitor risk detection metrics and false positive rates
---

# Identity Risk Detection: Detecting & Responding to Threats

## Introduction

Compromise happens—attackers obtain passwords, credentials leak in breaches, SIM swaps occur. The question isn't whether your organization will face threats, but how quickly you'll detect and respond to them. Identity risk detection is the early warning system for account compromise. When Microsoft detects that one of your users' passwords was found in a breach, that's risk detection. When a user signs in from a location impossible to reach in the time since their last login, that's risk detection. When malware-infected devices attempt to access corporate resources, that's risk detection. Microsoft Entra ID evaluates millions of signals 24/7, learns what "normal" looks like for each user, and alerts you to abnormalities. This document explains how to configure detection policies, respond to risks, and integrate risk data into your overall security program.

**Learning Objectives:**
- Understand the types of identity risks Entra ID detects
- Configure risk detection policies (user risk, sign-in risk, workload risk)
- Implement automated remediation for detected risks
- Create investigation and response workflows
- Monitor risk metrics and optimize detection tuning

## Types of Identity Risks

Entra ID detects three types of identity risks: user risk, sign-in risk, and workload risk. Each indicates a different type of threat.

### User Risk Signals

User risk indicates the probability that an account has been compromised. High user risk means something happened that suggests account takeover:

**Leaked Credentials:** The user's password was found in a data breach. Microsoft uses dark web monitoring, password leak databases, and threat intelligence to detect this. When Microsoft discovers your users' passwords in public breaches, it automatically marks them as high user risk.

**Anonymous IP:** Sign-in from a Tor exit node, VPN, or proxy. While not inherently malicious (many legitimate users use VPNs), anonymous IP is a risk factor and is combined with other signals.

**Impossible Travel:** User signed in from Location A, then Location B too quickly for physical travel. For example: User signs in from New York at 1 PM, then from London at 2 PM (flight time is 7+ hours). This suggests credential theft or token compromise.

**Malware-Linked IP:** Sign-in from an IP address known to distribute malware or be controlled by botnets. This is high-confidence risk.

**Suspicious Activity (Risky Sign-In Properties):** Password was entered in an atypical pattern or velocity (rapid succession, unusual entry speed). This suggests automated attack or stolen credentials being tested.

**Old Threat Intelligence:** User's account has been mentioned in historical threat intelligence feeds, government advisories, or law enforcement alerts.

### Sign-In Risk Signals

Sign-in risk is the probability that a specific sign-in attempt is illegitimate. It's evaluated at the moment of authentication:

**Anonymous IP:** VPN, Tor, proxy detected. Same as user risk but evaluated per-login.

**Atypical Travel:** Geographically unusual sign-in. Similar to "impossible travel" but also includes unusual countries or patterns for the user.

**Unfamiliar Properties:** Device, browser, OS, or location differs significantly from user's baseline. Machine learning identifies when properties deviate from normal.

**Malware-Infected Device:** Windows Defender flags the device as malware-infected. Risk inherited from device health.

**Suspicious Credentials:** Password entry pattern or velocity is unusual.

**Leaked Credentials:** User's password was disclosed in breach and is being used in this sign-in.

**Token Compromise Risk:** Access token or refresh token appears to be compromised (token detected in dark web, anomalous token usage patterns).

### Workload Risk Signals

For service-to-service authentication (not human-interactive), workload risk evaluates:

**Certificate Expiry:** Workload identity certificate is expired or expiring soon.

**Anomalous API Usage:** Service is calling APIs with atypical frequency, permissions, or patterns (e.g., accessing sensitive APIs it normally never uses).

**Risky IP:** Service is authenticating from a new or suspicious IP.

**Compromised Credentials:** Service principal credentials were detected in a breach.

**Old Certificate:** Service is using a certificate that hasn't been rotated in years (weak key rotation practice).

## Configuring Risk Detection Policies

Entra ID provides three policies for responding to detected risks: user risk policy, sign-in risk policy, and workload risk policy.

### User Risk Policy

User risk policy specifies what happens when a user's account shows signs of compromise:

```
IF user risk = High OR Medium
THEN require password reset AND require MFA
```

**Configuration:**

1. In Entra ID admin center, go to **Protection → Identity Protection → User risk policy**
2. **User risk level:** Select "High"
3. **Access:** Select "Require secure password change"
4. Toggle **Enforce policy: On**
5. Save

**Result:** When a user's password is detected in a breach, they're forced to change their password at next sign-in and must use MFA.

### Sign-In Risk Policy

Sign-in risk policy specifies what happens when a suspicious sign-in is detected:

```
IF sign-in risk = High OR Medium
THEN require MFA
```

**Configuration:**

1. Go to **Protection → Identity Protection → Sign-in risk policy**
2. **Sign-in risk level:** Select "High and above"
3. **Access:** Select "Require multi-factor authentication"
4. Toggle **Enforce policy: On**
5. Save

**Result:** When suspicious sign-in is detected, MFA is required.

### Workload Risk Policy

Workload risk policy protects service-to-service authentication:

```
IF workload risk = High
THEN block access (or require certificate refresh)
```

**Configuration:**

1. Go to **Protection → Identity Protection → Workload identity risk** (if available in your tenant)
2. **Risk level:** Select "High"
3. **Access:** Select "Block access" or "Require credential rotation"
4. Enable policy
5. Save

**Result:** Service principals showing high risk are blocked until credentials are rotated or investigation clears them.

## Risk Remediation and Investigation

When a risk is detected, Entra ID can automatically remediate (require password reset, force MFA, block access) or notify admins for investigation.

### Automated Remediation

User risk policy can automatically reset passwords:

1. User's credentials leak in a breach
2. Microsoft detects leak and raises user risk to "High"
3. User risk policy triggers automatically
4. At next sign-in, user is required to change password
5. User is required to use MFA
6. After password reset and MFA, risk is cleared

**Advantage:** No admin intervention needed, immediate response to threats.

**Disadvantage:** Can disrupt user workflows (forced password reset mid-day).

### Manual Investigation

Admins can review risky sign-ins and investigate before taking action:

1. In Entra ID, go to **Protection → Identity Protection → Risky sign-ins**
2. Review list of flagged sign-ins
3. For each sign-in, examine:
   - User account
   - Time and location
   - Device and browser information
   - Risk factors detected
4. Decision: "Confirm compromise" or "Dismiss"
   - **Confirm:** User account is compromised. Mark user as high risk.
   - **Dismiss:** False positive. Clear risk and adjust detection tuning.
5. Take action: Require password reset, disable account, investigate further

### Investigation Workflow

1. Alert: Admin receives notification of high-risk sign-in
2. Context: Review sign-in details and user context
   - Is this user known to travel?
   - Does this location match their job?
   - Is this device new or unusual?
3. Interview: Contact user to confirm or deny sign-in
   - "Did you sign in from London at 2 PM?"
   - User: "No, I was in New York all day"
   - **Verdict: Compromise confirmed**
4. Action: Immediately reset password, force MFA, review recent access
5. Follow-up: Check logs for unauthorized access, data exfiltration

## Hands-On Lab: Configuring Risk Detection and Investigation

**Estimated Time:** 60 minutes

**Prerequisites:** Entra ID Premium P2 tenant, Identity Protection enabled, test user

**Lab Objectives:**
- Enable risk detection policies
- Simulate risky sign-in
- Review risk signals in logs
- Demonstrate remediation workflow

### Step 1: Enable Identity Protection (10 minutes)

1. In Entra ID admin center, go to **Protection → Identity Protection**
2. Verify status: "Identity Protection enabled"
3. Go to **User risk policy**
   - Confirm "Enforce policy" is **On**
   - Risk level set to "High and above"
4. Go to **Sign-in risk policy**
   - Confirm "Enforce policy" is **On**
   - Risk level set to "High and above"

**Expected Output:**
```
Identity Protection Status: Enabled
User risk policy: Active
Sign-in risk policy: Active
Detections: Monitoring for risks 24/7
```

### Step 2: Review Risk Detection Dashboard (15 minutes)

1. Go to **Protection → Identity Protection → Overview**
2. Examine **Risk detections** dashboard:
   - Total detections (past 30 days)
   - Risk types breakdown (leaked credentials, impossible travel, etc.)
   - Users at risk
   - Sign-ins at risk
3. Go to **Risky sign-ins** tab
4. Review recent sign-ins flagged as risky:
   - Risk level (high, medium, low)
   - Risk factors detected
   - User account
   - Location and device
5. Go to **Risky users** tab
6. Review users currently flagged as high risk:
   - Risk detection type
   - Last risk activity
   - Risk level (high/medium)

**Expected Output:**
```
Risk Detections Summary (Past 30 Days):
- Leaked credentials: 3 detections
- Impossible travel: 1 detection
- Anonymous IP: 5 detections
- Unfamiliar sign-in properties: 2 detections
Total high-risk users: 5
Total high-risk sign-ins: 8
```

### Step 3: Simulate Risky Sign-In (20 minutes)

To simulate a risky sign-in, use one of these approaches:

**Approach A: VPN-Based Simulation**
1. Connect to VPN or use proxy
2. Sign in as test user from unusual location (IP differs from normal)
3. Entra ID detects "anonymous IP"
4. If risk rises to high, MFA required

**Approach B: Credential Breach Simulation** (for admin users only)
1. Use Azure CLI to flag test user as compromised:
   ```
   PowerShell: Get-MgRiskyUser -Filter "displayName eq 'Test User'"
   Set-MgRiskyUser -RiskyUserId <user-id> -IsCompromised $true
   ```
2. Go to **Risky users** and observe test user listed
3. Test user now shows as high risk

**Expected Output:**
```
Risky User Detected:
- User: Test User
- Risk type: Leaked credentials
- Risk level: High
- Remediation: Requires password reset + MFA at next sign-in
- Detection time: 2026-05-17 14:32:15
```

### Step 4: Investigate and Respond to Risk (15 minutes)

1. Go to **Protection → Identity Protection → Risky users**
2. Select a user flagged as high risk
3. Review details:
   - Risk type (leaked credentials, suspicious activity, etc.)
   - Last risk activity date
   - Associated risky sign-ins
4. Click **History** to see trend over time
5. Take action:
   - Option A: **Confirm compromise** (force password reset)
     - Click "Confirm as compromised"
     - User must reset password at next sign-in
   - Option B: **Dismiss** (false positive)
     - Click "Dismiss user risk"
     - Clear risk and adjust detection sensitivity
6. Send user notification if policy enforces it

**Expected Output:**
```
Risk Investigation:
User: test@organization.com
Risk type: Leaked credentials
Evidence: Password found in Dark Web breach
Action taken: Compromise confirmed
Remediation: Forced password reset triggered
User notification: Sent
Follow-up: Monitor for 7 days for re-compromise
```

### Step 5: Monitor Risk Metrics in Audit Logs (10 minutes)

1. Go to **Audit logs**
2. Filter by "Risk Detection" or "User Risk Updated"
3. Review entries:
   - User
   - Risk type detected
   - Risk level
   - Remediation action taken
4. Example entry: "User risk for john@contoso.com raised to High due to leaked credentials"
5. Go to **Conditional Access → Audit logs**
6. Filter by "Risk detection enforcement"
7. Observe how risk policies applied to recent sign-ins

**Expected Output:**
```
Audit Log Entry:
Category: Identity Protection
Activity: User Risk Detected
User: test@organization.com
Risk type: Leaked Credentials
Timestamp: 2026-05-17 14:32:15
Policy applied: User Risk Policy
Result: Password reset required
```

## Responding to Identity Risks at Scale

For organizations managing thousands of risky accounts, implement a workflow:

### Weekly Risk Review

1. **Monday morning:** Review high-risk users (dashboard)
2. **Classify:** Legitimate user travel (dismiss) vs. likely compromise (investigate)
3. **Investigate:** Contact users: "Did you sign in from X location?"
4. **Remediate:** Force password reset for confirmed compromises
5. **Document:** Log investigation findings in security system

### Automated Remediation for Confirmed Threats

1. User risk policy automatically requires password reset
2. If password isn't reset within 7 days, disable account
3. Security team investigates account, re-enables after cleanup
4. User must set new password + register MFA

### Integration with SIEM

Export risk detection data to SIEM for correlation with other security events:

```
PowerShell: Get-MgRiskyDetection -All | Export-Csv risky-detections.csv
# Then import into SIEM for correlation with endpoint detection, network logs
```

## Compliance & Standards Alignment

**NIST Cybersecurity Framework 2.0:**
- **Detect (D):** Risk detection is core detection function
- **Respond (R):** Automated remediation is response capability

**ISO 27001:2022:**
- **A.12.4.1:** Detection and monitoring of security events
- **A.12.6.1:** Management of technical vulnerabilities (includes compromise detection)

**Gartner IAM Framework:**
- **IVIP (Identity Verification & Intelligence Platform):** Risk detection is IVIP function
- **Detect:** Continuous risk monitoring and anomaly detection

**Standards Mandating Risk Detection:**
- **HIPAA:** Monitoring and detection of unauthorized access
- **PCI DSS:** Continuous monitoring for fraud (including identity-based)
- **SOC 2:** Detection of security incidents

## Related Documents

**Prerequisites:**
- [Authentication Fundamentals](./07-authentication-fundamentals.md) - Authentication basics
- [Multi-Factor Authentication](./07a-multi-factor-authentication.md) - MFA implementation
- [Adaptive Authentication](./07c-adaptive-authentication.md) - Using risk for auth decisions

**Next Steps:**
- [Insider Threat Management](./08a-insider-threat-management.md) - Managing insider risks
- [Zero Trust Identity Architecture](./08b-zero-trust-identity-architecture.md) - Continuous verification
- [Identity Governance & Administration](./06b-governance-workflows.md) - Remediation at scale

## Further Reading

**Microsoft Learn:**
- [Identity Protection: Risk Detections](https://learn.microsoft.com/en-us/entra/id-protection/concept-identity-protection-risks)
- [User Risk and Sign-In Risk Policies](https://learn.microsoft.com/en-us/entra/id-protection/concept-identity-protection-policies)
- [Risky Users Investigation](https://learn.microsoft.com/en-us/entra/id-protection/howto-identity-protection-investigate-risk)

**Industry Standards:**
- [NIST SP 800-61: Incident Handling](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-61rev2.pdf)
- [OWASP: Anomaly Detection](https://cheatsheetseries.owasp.org/)

**Security Research:**
- [Microsoft: Dark Web Monitoring](https://www.microsoft.com/security/blog)
- [Compromised Credentials Intelligence](https://www.microsoft.com/security/blog)

## FAQ

**Q: How often are risk detections updated?**

A: Real-time for sign-in risk. User risk is evaluated continuously (24/7). Leak detection is near-real-time (within hours of Microsoft discovering a breach).

**Q: Can we exclude trusted users from risk detection?**

A: Yes, with caveats. You can create exceptions in Conditional Access policies (e.g., "Don't require MFA for CFO even if high sign-in risk detected"), but user risk policy should apply to all users equally. Exceptions weaken detection.

**Q: What's the false positive rate?**

A: Modern detection is highly accurate (>98% true positive rate). Common false positives: Users who travel frequently, legitimate VPN usage. Monitor and adjust sensitivity in policies.

**Q: If a user is marked high risk, can they still sign in?**

A: Yes, if the policy is "Require MFA" or "Require password reset." User can prove identity through MFA or reset password. Only "Block" policies prevent access entirely (rare).

**Q: How do we handle compromised service accounts?**

A: Workload risk policies can block high-risk service accounts. Rotate service account credentials (certificates, keys) as quickly as possible. Implement token-based auth with short-lived tokens.

**Q: Is risk detection a replacement for other security tools?**

A: No. Risk detection is one layer of defense. Combine it with device compliance, network segmentation, SIEM monitoring, and endpoint detection/response for comprehensive security.

## Next Steps

1. Ensure Identity Protection is enabled in your tenant
2. Review risk policies and adjust sensitivity
3. Set up weekly risk review process
4. Create incident response workflow for confirmed compromises
5. Integrate risk detection into SIEM if you have one
6. Monitor false positive rate and adjust tuning

Identity risk detection is proactive security: detect threats before they cause harm. Start monitoring today.
