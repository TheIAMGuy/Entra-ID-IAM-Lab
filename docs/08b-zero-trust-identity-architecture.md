---
title: Zero Trust Identity Architecture - Never Trust, Always Verify
part: 2
section: Authentication & Security
difficulty: Advanced
estimated_reading_time: 50
estimated_lab_time: 90
prerequisites:
  - 07-authentication-fundamentals.md
  - 07c-adaptive-authentication.md
  - 08-identity-risk-detection.md
learning_objectives:
  - Understand Zero Trust principles and assumptions
  - Design Zero Trust identity architecture
  - Implement continuous verification and least privilege
  - Configure Zero Trust policies in Microsoft Entra ID
  - Measure and assess Zero Trust maturity
---

# Zero Trust Identity Architecture: Never Trust, Always Verify

## Introduction

Traditional security operated on a "perimeter defense" model: verify users at the network edge (VPN, firewall), then trust them implicitly inside. Cloud, remote work, and sophisticated attacks have made this model obsolete. Modern adversaries bypass perimeters through compromised credentials, phishing, and lateral movement. Zero Trust inverts the assumption: trust nothing and no one by default. Every request—whether from inside or outside the network, from a user or a service—must prove its identity and trustworthiness. Zero Trust principles are foundational to modern identity security. This document explains Zero Trust, its identity-specific implementation, and how to architect systems around "never trust, always verify."

**Learning Objectives:**
- Understand Zero Trust principles and guiding assumptions
- Implement continuous verification for users and devices
- Design least privilege access controls
- Configure Zero Trust policies in Microsoft Entra ID
- Assess and improve Zero Trust maturity

## Zero Trust Core Principles

Zero Trust rests on seven core principles that challenge traditional security assumptions.

### Principle 1: Assume Breach

Assume your environment is already compromised. Design systems and policies assuming attackers are inside. This shifts focus from "keep attackers out" to "detect and contain attackers quickly."

**Implication for identity:** Implement detection, not just prevention. Assume passwords leak. Assume devices are compromised. Assume tokens are stolen. Build layers to detect these breaches quickly.

### Principle 2: Verify Explicitly

All access decisions must be based on explicit verification, never implicit trust. Verify identity, device health, risk level, and business justification before granting access.

**Implication:** Conditional Access policies that verify identity, device compliance, user risk, sign-in risk, and location. No implicit trust based on network location.

### Principle 3: Least Privilege Access

Users and services should have the minimum permissions required to do their job. Every permission is justified and time-limited.

**Implication:** Role-based access with attribute-based refinement. Just-in-time elevation for privileged tasks. Continuous access reviews. Removal of unused permissions.

### Principle 4: Secure Every Device

Every device accessing resources must meet minimum security standards and be verified. No exceptions for "trusted" devices.

**Implication:** Device compliance policies. Device risk assessment. Conditional enforcement of MFA and encryption based on device health.

### Principle 5: Protect Data and Services

Micro-segmentation ensures that even if an attacker compromises one area, they can't freely move laterally. Encryption protects data at rest and in transit.

**Implication:** Data classification and access controls. Encryption for all sensitive data. Service-to-service authentication with short-lived tokens.

### Principle 6: Monitor and Validate Trust

Continuously monitor behavior, detect anomalies, and revoke trust when conditions change. Trust is dynamic, not static.

**Implication:** Behavioral analytics, anomaly detection, risk-based enforcement. Continuous policy evaluation, not once-at-login.

### Principle 7: Authenticate and Authorize Everywhere

Every access request—user login, API call, service-to-service communication, device health check—requires authentication and authorization.

**Implication:** MFA for all users. Service principals for APIs. Device health certificates. Zero trust for internal and external traffic equally.

## Zero Trust Identity Architecture

Zero Trust identity architecture consists of three layers working together.

### Layer 1: Authentication Layer

Verify identity through multiple factors:

- **Primary authentication:** Password (deprecated in Zero Trust; replaced with passwordless)
- **Secondary authentication:** MFA or passwordless
- **Device authentication:** Device certificate proving device identity
- **Service authentication:** Service principal or managed identity proving service identity

### Layer 2: Continuous Verification Layer

Continuously verify trustworthiness:

- **Risk assessment:** User risk, sign-in risk, device risk
- **Device health:** Compliance with device policies
- **Behavioral analysis:** Anomaly detection
- **Conditional access:** Real-time policy enforcement based on context

### Layer 3: Authorization & Access Control Layer

Grant minimum required permissions:

- **Least privilege:** Attribute-based access, just-in-time elevation
- **Time-limited access:** Permissions expire; renewal requires re-verification
- **Service-to-service:** API authentication with short-lived tokens
- **Data access:** Classification-based access controls

## Implementing Zero Trust in Microsoft Entra ID

### Step 1: Establish Zero Trust Baseline Policies

Baseline policies should enforce for all users:

```
Policy 1: Require MFA for all users
- Condition: All users, all cloud apps
- Action: Require MFA
- Exception: None (or service accounts with alternative auth)

Policy 2: Block legacy authentication
- Condition: All legacy auth protocols (Basic, NTLM, Digest)
- Action: Block
- Result: Only modern auth with MFA works

Policy 3: Require compliant devices
- Condition: High-sensitivity apps, privileged access
- Action: Require device compliance (MDM enrolled, encryption on)
- Exception: None (require device upgrade if needed)

Policy 4: Require Windows 11 / macOS latest
- Condition: Executive and IT admin access
- Action: Require OS version >= Windows 11 21H2
- Result: Ensure all admins use latest security patches
```

### Step 2: Implement Least Privilege Access

Least privilege ensures users have only necessary permissions:

```
Example: Finance user access
- User role: Financial Analyst
- Default permissions: Read access to current-year budget
- Elevated permissions: Quarterly reconciliation role (30-day activation)
  - When activated: Can modify current-year budget
  - Expires after: 30 days or end of quarter (whichever first)
  - Requires: Approval from Finance Manager + MFA
  - Logs: All changes audited
```

**Configuration:**
1. In Entra ID, go to **Governance → Privileged Identity Management**
2. Define roles: Finance Manager, Finance Analyst, Finance Auditor
3. Set Finance Analyst default role (read-only)
4. Configure Quarterly Reconciliation role as eligible (requires activation)
5. Set activation requirements: Approval + MFA
6. Users request elevation when needed, approval flows through manager

### Step 3: Implement Continuous Verification

Continuous verification policies enforce trustworthiness continuously, not just at login:

```
Policy 5: Re-verify on sensitive operations
- Condition: Access to sensitive data (HR, Financial, Medical)
- Action: Require fresh MFA (15-minute re-auth window)
- Result: User must prove identity again for each sensitive access

Policy 6: Enforce device compliance continuously
- Condition: Access to confidential data
- Action: Require device compliance check every 1 hour
- Result: If device becomes non-compliant, access denied immediately

Policy 7: Block impossible travel
- Condition: Sign-in from location impossible to reach since last sign-in
- Action: Require MFA + step-up authentication
- Result: Compromised account can't silently move geographically
```

### Step 4: Monitor and Audit

Implement comprehensive audit logging:

```
Audit everything:
- User authentication attempts (success, failure, MFA type)
- Authorization decisions (access granted, denied, reason)
- Device health changes
- Permission changes (who, what, when, why)
- Sensitive data access (HR files, financial records, customer PII)
- Failed Conditional Access policies (what policy failed, why)
```

**Configuration:**
1. Enable comprehensive audit logging
2. Export logs to SIEM for analysis
3. Create alerts for Zero Trust policy violations
4. Review logs weekly for anomalies

## Hands-On Lab: Implementing Zero Trust Identity Policies

**Estimated Time:** 90 minutes

**Prerequisites:** Entra ID Premium P2, admin access, test users and groups

**Lab Objectives:**
- Create baseline Zero Trust policies
- Implement least privilege with PIM
- Test continuous verification
- Monitor policy compliance

### Step 1: Create Baseline MFA Policy (20 minutes)

1. In Entra ID, go to **Protection → Conditional Access**
2. Create policy: **"Zero Trust: Require MFA for all"**
3. **Assignments:**
   - Users: All users
   - Cloud apps: All cloud apps
   - Conditions: None (applies universally)
4. **Grant:** Require MFA
5. **Session:** Default
6. **Enable:** On
7. Test with a non-admin user account

**Expected Output:**
```
Policy created: Zero Trust: Require MFA for all
Status: On
Scope: All users
Result: All sign-ins require MFA
Test user must use MFA to access cloud apps
```

### Step 2: Block Legacy Authentication (15 minutes)

1. Create new policy: **"Zero Trust: Block legacy authentication"**
2. **Conditions:**
   - Legacy authentication clients: All
3. **Grant:** Block
4. **Enable:** On
5. Test by attempting to sign in with SMTP, IMAP, or POP3

**Expected Output:**
```
Policy created: Block legacy authentication
Status: On
Result: Modern auth only (OAuth 2.0, SAML, OIDC)
Legacy auth (SMTP, IMAP, Basic) rejected
```

### Step 3: Enforce Device Compliance (20 minutes)

1. Create policy: **"Zero Trust: Require compliant devices"**
2. **Assignments:**
   - Users: IT admins group
   - Cloud apps: Azure Portal, Microsoft 365 admin
3. **Grant:** Require device to be marked as compliant
4. **Device compliance check:** Require encryption, antivirus, OS version
5. **Enable:** On
6. Test:
   - Sign in from compliant device (should succeed)
   - Try from non-compliant device (should fail or require remediation)

**Expected Output:**
```
Policy created: Require compliant devices
Scope: IT admin sign-in to Azure Portal
Status: On
Test result:
- Compliant device: Access granted
- Non-compliant device: Remediation required (install required updates)
```

### Step 4: Implement Least Privilege with PIM (20 minutes)

1. In **Governance → Privileged Identity Management**
2. Go to **Roles**
3. Select a sensitive role (Global Admin, Exchange Admin)
4. Click **Eligible assignments** (not permanent)
5. Assign a test user as "Eligible" (not "Active")
6. Set:
   - Requires approval: Yes
   - Approver: Your account
   - Activation window: 4 hours
   - Requires MFA to activate: Yes
7. Test as regular user:
   - User signs in
   - Requests role activation
   - Approval flows to manager
   - After approval, user gets temporary elevated permissions
   - Permissions auto-expire after 4 hours

**Expected Output:**
```
PIM role configured: Global Admin
Assignment type: Eligible (not permanent)
Activation requires: Approval + MFA
Duration: 4 hours
Audit: All activations logged
Test user can request but cannot auto-elevate
```

### Step 5: Configure Step-Up Authentication (15 minutes)

1. Create policy: **"Zero Trust: Step-up for sensitive data"**
2. **Assignments:**
   - Users: All users
   - Cloud apps: SharePoint (or sensitivity label policies)
   - Conditions: Access to files marked "Confidential"
3. **Grant:** Require MFA
4. **Session:** Set sign-in frequency = 15 minutes
5. **Enable:** On
6. Test:
   - Access public data (no MFA required)
   - Access confidential data (MFA required again)

**Expected Output:**
```
Policy created: Step-up authentication
Scope: Confidential file access
Result:
- Public file access: No additional auth needed
- Confidential file access: Fresh MFA required
- 15-minute window: MFA remains valid for that duration
```

### Step 6: Monitor Zero Trust Compliance (10 minutes)

1. In Conditional Access, go to **Insights**
2. Review:
   - Policies enforced (count and coverage)
   - Users affected
   - Success vs. failure rates
   - Common policy violations
3. Create a dashboard showing:
   - % of sign-ins requiring MFA
   - % of sign-ins from compliant devices
   - % of sensitive data access requiring step-up
4. Set alert for policy violations exceeding threshold

**Expected Output:**
```
Zero Trust Compliance Dashboard:
- MFA adoption: 85% of users using MFA
- Device compliance: 92% of device sign-ins from compliant devices
- Legacy auth blocked: 100% (zero legacy auth attempts successful)
- Privilege elevation: 15 activations in past week (all approved)
- Policy violations: 3 blocked sign-ins (high risk + non-compliant)
Status: Compliant with Zero Trust baseline
```

## Assessing Zero Trust Maturity

Zero Trust maturity progresses through stages:

| Maturity Level | Characteristics | IAM Controls |
|---|---|---|
| **1 - Initial** | Perimeter-based security, implicit trust inside | Passwords, occasional MFA |
| **2 - Repeatable** | Basic MFA, device enrollment | MFA deployment, device compliance baseline |
| **3 - Defined** | Conditional Access, continuous verification | Risk-based policies, step-up auth, device health |
| **4 - Advanced** | Adaptive auth, micro-segmentation, API security | Zero Trust for all workloads, service-to-service Zero Trust |
| **5 - Optimized** | AI-driven threat detection, autonomous response | Predictive risk, automated remediation, ML-based policies |

Most enterprises progress from 2 → 3 over 12-18 months, then 3 → 4 over 24+ months.

## Compliance & Standards Alignment

**NIST Cybersecurity Framework 2.0:**
- **Govern (G):** Zero Trust governance and policy framework
- **Protect (P):** Zero Trust protections (MFA, device compliance, segmentation)
- **Detect (D):** Continuous monitoring for Zero Trust verification

**Microsoft Zero Trust Guidance:**
- [Microsoft Zero Trust Implementation Guide](https://learn.microsoft.com/security/zero-trust/)
- Enterprise-grade guidance aligned with NIST principles

## Related Documents

**Prerequisites:**
- [Adaptive Authentication](./07c-adaptive-authentication.md) - Risk-based auth
- [Identity Risk Detection](./08-identity-risk-detection.md) - Threat detection
- [Conditional Access Policies](./09-identity-standards-overview.md) - Policy implementation

**Next Steps:**
- [Application Access Management](./05-sso-and-application-provisioning.md) - Zero Trust app access
- [Privileged Identity Management](./04-privileged-access-management.md) - Zero Trust privilege

## Further Reading

**Microsoft Resources:**
- [Microsoft Zero Trust Architecture](https://learn.microsoft.com/security/zero-trust/)
- [NIST SP 800-207: Zero Trust Architecture](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-207.pdf)

## FAQ

**Q: Does Zero Trust mean no trust at all?**

A: No. Zero Trust means "verification before trust" not "eternal distrust." You verify once (authenticate), then conditionally trust based on verified attributes. Trust is revoked if verification fails.

**Q: Is Zero Trust appropriate for all organizations?**

A: Most organizations of 500+ people benefit from Zero Trust. Smaller organizations may focus on fundamentals first (MFA, device compliance). Start with baseline policies and progress gradually.

**Q: Does Zero Trust break user experience?**

A: If implemented poorly, yes. If implemented intelligently (adaptive policies, risk-based enforcement), experience is minimal. Most users don't notice Zero Trust when tuned correctly.

**Q: Can legacy systems work in Zero Trust?**

A: Legacy systems should be segmented or modernized. Some can use network isolation + device compliance. Plan modernization for systems that can't support modern auth.

## Next Steps

1. Establish Zero Trust baseline policies (MFA, legacy blocking, device compliance)
2. Implement least privilege for high-risk roles (executives, IT admin)
3. Configure step-up authentication for sensitive data
4. Monitor and tune to minimize false positives
5. Extend Zero Trust to service-to-service authentication
6. Assess maturity quarterly and plan next phase

Zero Trust is not a destination but a continuous journey. Start with baseline policies, measure progress, and extend to more areas over time.
