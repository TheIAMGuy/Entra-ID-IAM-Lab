---
title: Incident Response - Identity Security Incident Handling
part: 8
section: Compliance & Audit
difficulty: Advanced
estimated_reading_time: 30
estimated_lab_time: N/A
prerequisites:
  - 17-compliance-frameworks-mapping.md
  - 17a-identity-governance-administration.md
  - 08-identity-risk-detection.md
learning_objectives:
  - Understand identity incident types
  - Implement incident detection and alerting
  - Execute incident response playbooks
  - Manage post-incident forensics and remediation
  - Prepare incident communication plans
---

# Incident Response: Identity Security Incident Handling

## Introduction

Identity incidents are security events involving unauthorized access, account compromise, data breach, or policy violation. An attacker compromises a user account and attempts to access production databases. Or a contractor's account isn't disabled after offboarding, and they access customer data. Or bulk password resets suggest an attack. Identity systems must detect these incidents, respond quickly, and prevent recurrence. This document explains incident response process, detection, playbooks, and forensics.

**Learning Objectives:**
- Identify identity incident types and severity
- Implement detection and alerting
- Execute incident response playbooks
- Conduct forensics and investigation
- Develop incident communication plans

## Identity Incident Types

### Incident 1: Account Compromise

**Attacker gains control of legitimate account:**

```
Scenario: Attacker compromises john.smith@company.com (phishing)
  - Attacker obtains password
  - Attacker signs in from attacker IP (Russia)
  - Attacker views sensitive files in OneDrive
  - Attacker sends phishing email to john's contacts

Indicators:
  ✓ Sign-in from unusual location
  ✓ Sign-in at unusual time (3 AM)
  ✓ Multiple failed MFA attempts
  ✓ New device used
  ✓ Password change immediately after
  ✓ New mailbox forwarding rule created

Severity: High (attacker has user access, can exfiltrate data)

Detection Time: Minutes (if alerts enabled)
Incident Window: Hours (before damage escalates)
```

### Incident 2: Privilege Escalation

**User elevates own permissions:**

```
Scenario: Manager Jane grants herself admin role (policy violation)
  - Jane adds herself to admin group
  - Jane creates new service account
  - Jane enables sign-in logging bypass
  - Jane gains admin access

Indicators:
  ✓ User added to high-privilege group
  ✓ Service account created by non-standard user
  ✓ Configuration change to audit settings
  ✓ Impossible travel (NY to London in 30 min)

Severity: Critical (insider threat, system compromise risk)

Detection Time: Real-time (audit log alert)
Incident Window: Minutes (before broad impact)
```

### Incident 3: Mass Data Exfiltration

**Attacker or insider accesses bulk data:**

```
Scenario: Compromised admin account used to export customer database
  - Admin account accessed via VPN (legitimate)
  - Admin runs SQL query: "SELECT * FROM CustomerDatabase"
  - 50,000 customer records exported to external drive
  - Drive removed from office

Indicators:
  ✓ Bulk data query from unusual account
  ✓ Large data transfer to external storage
  ✓ Unusual query pattern (customer data access)
  ✓ Access outside normal business hours

Severity: Critical (GDPR breach, financial impact, reputation damage)

Detection Time: Hours (data transfer may not be real-time visible)
Incident Window: Minutes to hours (before discovery)
```

### Incident 4: Stale Access (Post-Offboarding)

**Departed employee still has access:**

```
Scenario: Contractor John was terminated but account not disabled
  - John's offboarding incomplete
  - John still has VPN access
  - John accesses customer data from home
  - Compliance audit discovers access

Indicators:
  ✓ Access by terminated user
  ✓ VPN connection from home network
  ✓ No sign-in for 60 days, then sudden activity
  ✓ HR system shows termination, AD doesn't

Severity: High (access control failure, compliance violation)

Detection Time: Manual audit (weeks or months)
Incident Window: Unknown (could be weeks)
```

### Incident 5: Brute Force Attack

**Attacker attempts many password guesses:**

```
Scenario: Attacker bulk attempts passwords against user accounts
  - Target: admin@company.com (common account name)
  - Attack: 10,000 password attempts over 24 hours
  - Source: Botnet (multiple IPs)
  - Goal: Compromise admin account

Indicators:
  ✓ Many failed sign-in attempts (same user, different passwords)
  ✓ Multiple IPs attempting same account
  ✓ Failed MFA attempts
  ✓ Attack pattern (systematic, high volume)

Severity: Medium (detected quickly with rate limiting)

Detection Time: Minutes (if alerts enabled)
Incident Window: Hours (before lockout or detection)
```

## Incident Detection and Alerting

### Detection Strategy

**Layered detection approach:**

```
Layer 1: Real-time behavioral analytics
  - Sign-in anomalies (unusual location, time, device, IP)
  - Admin action anomalies (bulk operations, config changes)
  - Data access anomalies (unusual queries, large exports)
  - Alert threshold: High confidence (reduce false positives)

Layer 2: Policy-based detection
  - Policy violation alerts (access outside approval, privilege grant)
  - Compliance violation (terminated user with access)
  - Configuration drift (policy disabled, audit logging off)
  - Alert threshold: Any violation

Layer 3: Threat intelligence
  - IP reputation (known botnet, malicious geolocation)
  - Compromised credential feeds (leaked password databases)
  - Attack signatures (brute force pattern, exploit attempts)
  - Alert threshold: Moderate confidence

Layer 4: Forensic auditing
  - Manual review of access patterns
  - Investigation of suspicious activity
  - Post-incident analysis
  - Trigger: Other alerts or user reports
```

### Alert Configuration

**Example: Account Compromise Alert**

```
Alert Name: Impossible Travel Detected

Condition:
  - User signed in from Location A at Time T1
  - User signed in from Location B at Time T2
  - Distance between A and B > 900 km (500 miles)
  - Time between T1 and T2 < Travel Time required

Example:
  - Sign-in: New York at 10:00 AM
  - Sign-in: London at 11:30 AM (90 minutes later)
  - Travel time required: 7+ hours (by plane)
  - Impossible travel detected

Action: Alert security team, require re-authentication, prompt MFA
```

## Incident Response Playbook

### Phase 1: Detection & Triage (0-15 minutes)

**Alert received → Initial assessment:**

```
Step 1: Alert arrives (automated system or user report)
  Email: "Account Compromise Alert: john.smith@company.com"
  Details: Sign-in from Moscow (Russia), high user risk
  Time: 2024-01-15 03:45 UTC

Step 2: Security operations center (SOC) analyst triages
  Question 1: Is this a legitimate scenario?
    - Is john traveling? (check calendar/HR)
    - Is john using VPN? (check corporate VPN)
    - Is this a known testing event? (check change log)
  
  Question 2: What's the severity?
    - Risk level: High user risk
    - Account sensitivity: Executive (high impact)
    - Data access: Has access to financial systems
    - Severity: HIGH (escalate immediately)

Step 3: Declare incident, engage incident commander
  - Incident ID: INC-2024-001234
  - Severity: HIGH
  - Type: Account Compromise
  - Status: INVESTIGATING
```

### Phase 2: Containment (15-45 minutes)

**Stop immediate damage:**

```
Step 1: Disable account (remove all access immediately)
  Action: john.smith@company.com → Disabled
  Effect: All active sessions terminated, new sign-ins blocked
  Time to execute: <2 minutes
  Communication: Send password reset notification

Step 2: Revoke all active sessions
  Action: Sign out from all devices, all sessions invalidated
  Effect: Attacker loses access
  Time to execute: <1 minute

Step 3: Revoke refresh tokens
  Action: All OAuth/OIDC refresh tokens invalidated
  Effect: Attacker cannot refresh tokens, must re-authenticate
  Time to execute: <1 minute

Step 4: Revoke API keys and service principals
  Action: Review and revoke any API keys/service accounts
  Effect: Attacker cannot use service accounts
  Verification: Check audit logs for any new keys created

Step 5: Reset password (by admin, not user)
  Action: Admin generates temporary password
  Effect: Previous password invalid (even if attacker has it)
  Communication: Contact john via phone, provide temporary password
  Time to execute: <5 minutes
```

### Phase 3: Investigation (45-240 minutes)

**Determine scope of damage:**

```
Step 1: Collect forensics
  - Sign-in logs: All logins in past 30 days (determine entry point)
  - Audit logs: All actions by john in past 30 days
  - Mail logs: All emails sent/received
  - File access logs: All files accessed/modified
  - Data access logs: Database queries, API calls
  - Duration: 30-60 minutes (depending on volume)

Step 2: Analyze timeline
  Timeline:
    2024-01-14 17:00 UTC: Legitimate sign-in (New York)
    2024-01-14 22:00 UTC: Phishing email received (credential theft)
    2024-01-15 03:45 UTC: Attacker sign-in (Moscow)
    2024-01-15 03:47 UTC: View OneDrive (suspicious files accessed)
    2024-01-15 03:52 UTC: Email forwarding rule created
    2024-01-15 04:00 UTC: Alert triggered (impossible travel)
  
  Determination: Entry point = phishing email around 2024-01-14 22:00

Step 3: Assess damage
  Questions:
    - What data was accessed? (onedrive files, emails)
    - What data was exfiltrated? (none visible in logs)
    - What modifications were made? (email forwarding rule)
    - What access was granted? (none)
  
  Damage Assessment: Low-to-medium (limited data access, no persistence)

Step 4: Identify if other accounts compromised
  Check: 
    - Do other users show similar anomalies?
    - Are other executives targeted?
    - Does phishing email indicate broader campaign?
  Result: No other accounts compromised (targeted attack)
```

### Phase 4: Eradication (240-480 minutes)

**Remove attacker persistence, fix vulnerabilities:**

```
Step 1: Revoke suspicious access
  Action: Remove email forwarding rule created by attacker
  Action: Revoke any application permissions granted
  Verification: Check Azure AD audit, mailbox rules

Step 2: Secure all endpoints
  Action: Force password change on all computers john uses
  Action: Scan endpoints for malware
  Action: Update security agent signatures
  Verification: Ensure clean state before john re-enabled

Step 3: Review and strengthen controls
  Action: Enable MFA if not already enabled
  Action: Set up phishing-resistant authentication
  Action: Enable advanced threat protection
  Verification: Test new controls

Step 4: Root cause analysis
  Question: How did phishing succeed?
    - Email filtering didn't catch it
    - User training didn't prevent it
    - MFA could have prevented credential theft (but attacker got password anyway)
  
  Remediation:
    - Improve email filtering rules
    - Enhanced user training on phishing
    - Enable phishing-resistant MFA (FIDO2 keys)
```

### Phase 5: Recovery (480-1440 minutes, 8+ hours)

**Restore normal operations:**

```
Step 1: Re-enable account
  Action: Reset password (john sets new password on next logon)
  Action: Enable account
  Communication: John contacted, informed of incident
  Verification: John confirms password reset successful

Step 2: Communicate with affected parties
  - john: "Your account was compromised, we've secured it"
  - john's contacts: "You may have received phishing from john's account, be cautious"
  - Compliance: Breach notification if data exfiltrated
  - Leadership: Incident summary and response

Step 3: Post-incident review
  Questions:
    - What went well? (alert triggered quickly, response was fast)
    - What could improve? (MFA earlier, email filtering better)
    - What policy changes needed? (stronger authentication by default)
  
  Actions:
    - Update incident response playbook
    - Schedule phishing training
    - Implement stricter email rules
    - Deploy FIDO2 for high-risk users
```

## Incident Response Metrics

### Metrics to Track

```
Detection metrics:
  - Mean time to detect (MTTD): Minutes from incident to alert
  - Alert accuracy: % of alerts that are true incidents (reduce false positives)
  - Alert sensitivity: % of real incidents detected

Response metrics:
  - Mean time to respond (MTTR): Minutes from alert to containment
  - Containment time: Minutes to disable account/stop damage
  - Investigation time: Minutes to understand scope
  
Incident metrics:
  - Incident frequency: Count by type (compromise, escalation, breach)
  - Recurrence rate: % of resolved incidents that recur (indicates weak fix)
  - Severity distribution: % critical, high, medium, low
  
Example dashboard:
  MTTD: 8 minutes (target: <15)
  MTTR: 12 minutes (target: <30)
  Containment: 5 minutes (target: <15)
  Investigation: 45 minutes (target: <2 hours)
  True positive rate: 92% (target: >85%)
```

## Best Practices

1. **Preparation** - Have playbooks ready before incident occurs
2. **Automation** - Automate containment actions (disable account, revoke tokens)
3. **Communication** - Clear escalation path and notification list
4. **Evidence Preservation** - Collect forensics before deletion
5. **Speed** - Time matters; target <30 minutes for containment
6. **Isolation** - Contain incident to affected account/system
7. **Verification** - Confirm fix is effective before declaring resolved
8. **Post-Incident** - Review every incident to improve process
9. **Training** - Regular tabletop exercises and playbook reviews
10. **Alerting** - High-quality alerts (accurate, actionable, low false positives)

## Related Documents

**Prerequisites:**
- [Compliance Frameworks](./17-compliance-frameworks-mapping.md) - Incident reporting requirements
- [Risk Detection](./08-identity-risk-detection.md) - Detection concepts
- [IGA Platforms](./17a-identity-governance-administration.md) - Governance and audit

**Next Steps:**
- [Risk Scoring](./17d-risk-scoring-algorithm.md) - Advanced risk analytics
- [Reporting](./19-identity-reporting-analytics.md) - Post-incident reporting

## FAQ

**Q: Should we pay ransomware demands?**

A: No. FBI guidance: do not pay. Focus on containment, remediation, and prevention.

**Q: How long should we retain incident logs?**

A: Minimum 7 years for compliance. Some frameworks require longer.

**Q: Should we notify law enforcement?**

A: For data breach or criminal activity, yes. Engage legal and compliance teams.

## Next Steps

1. Document incident response playbooks for each incident type
2. Set up automated alerting and containment
3. Conduct incident response tabletop exercises quarterly
4. Review and update playbooks based on real incidents
5. Train security team on playbook execution
6. Establish communication templates for incident notification

Incident response speed determines damage scope and recovery cost.
