---
title: GRC Integration - Governance, Risk, and Compliance Management
section: Compliance & Audit
difficulty: Advanced
estimated_reading_time: 30
estimated_lab_time: N/A
prerequisites:
  - guide-identity-governance-administration.md
learning_objectives:
  - Understand GRC platform concepts
  - Integrate identity governance with GRC systems
  - Map compliance requirements to controls
  - Implement risk scoring and heat maps
  - Manage audit and assessment workflows
---

# GRC Integration: Governance, Risk, and Compliance Management

## Introduction

Governance, Risk, and Compliance (GRC) platforms consolidate policy, compliance, and risk management. Instead of disparate spreadsheets, GRC brings together: governance policies (approved by board), risk assessments (enterprise risk), compliance requirements (HIPAA, GDPR, SOX), and controls (technical and operational). This document explains GRC concepts and how identity governance feeds them. The examples are illustrative; adapt them to your own policies and the current text of each standard.

**Learning Objectives:**
- Understand GRC platform capabilities
- Map compliance requirements to identity controls
- Implement risk scoring
- Manage audit workflows
- Report on compliance status

## GRC Concepts

### Governance

**Policies approved and enforced:**

```
Board-approved policies:
  - Access Control Policy
  - Password Policy
  - Data Classification Policy
  - Incident Response Policy

Each policy:
  - Approved by: Board/Executive committee
  - Effective date: When it takes effect
  - Controls: How it's enforced (technical or process)
  - Audit: How we verify compliance
```

### Risk

**Enterprise risks identified and managed:**

```
Risk: Unauthorized data access
  Likelihood: Medium (2/5)
  Impact: High (4/5)
  Risk Score: 8/25 (Medium risk)
  Control: Access reviews quarterly
  Owner: CISO
  Status: Monitored

Risk: Identity sprawl (unused accounts)
  Likelihood: High (4/5)
  Impact: Medium (3/5)
  Risk Score: 12/25 (Medium-High risk)
  Control: Monthly account reconciliation
  Owner: IAM team
  Status: In progress (remediation underway)
```

### Compliance

**Regulatory requirements mapped to controls:**

```
HIPAA Requirement: Manage who can access electronic PHI
  Mapping: HIPAA Security Rule 164.308(a)(4) - Information access management
  Control: Group-based RBAC (Lab 03)
  Evidence: Role assignments, access review records
  Status: <assessed by your auditor>

PCI DSS Requirement: Unique user IDs for accountability
  Mapping: PCI DSS v4.0.1 Requirement 8.2.1 - Unique ID for each user
  Control: No shared accounts, individual provisioning (Lab 02)
  Evidence: User account audit, enforcement policy
  Status: <assessed by your auditor>
```

## GRC Platforms

### Major Platforms

Common GRC platforms include Archer, ServiceNow GRC, Workiva, AuditBoard and LogicGate. Compare them on:

| Area | Questions to ask |
|------|------------------|
| Fit | Does it support the frameworks you must report against? |
| Integration | Can it ingest evidence from your identity platform (for example via Microsoft Graph, exports or Log Analytics)? |
| Audit workflow | Does it support evidence requests, testing and issue tracking? |
| Cost | How is it licensed, and what does implementation cost? |

Features, integrations and pricing change often. Get current details from each vendor.

### ServiceNow GRC Module

**Common enterprise choice:**

```
ServiceNow ITSM
  ├─ GRC Module (on top)
  │   ├─ Policy Management
  │   ├─ Risk Register
  │   ├─ Compliance Tracking
  │   └─ Audit Workflows
  └─ Integration
      ├─ Identity Governance (pull users, roles)
      ├─ Incident Management (risk events)
      └─ Change Management (compliance changes)
```

**Workflow:**

```
1. Policy management: Define access control policy
2. Compliance mapping: Map to HIPAA/PCI/SOX requirements
3. Control identification: Access reviews = control for compliance
4. Assessment: Quarterly access reviews (evidence gathering)
5. Reporting: Compliance report for audit
```

## Mapping Identity Controls to Compliance

### Example: HIPAA Compliance Mapping

```
HIPAA Security Rule 164.308(a)(4) - Information access management

Identity Controls:
  ✓ Group-based RBAC (Lab 03): Grant access by group
  ✓ Privileged roles (Lab 04): Scoped administrative roles
  ✓ Access reviews (Lab 17a): Recurring recertification
  ✓ Audit logs (Lab 07): Record access changes

Evidence Gathered:
  - Role definitions (approved by management)
  - Access review reports (quarterly)
  - Audit logs (access granted/revoked)
  - Exception approval process

Compliance Status: <assessed by your auditor>
```

### Example: PCI DSS Mapping

```
PCI DSS v4.0.1 Requirement 8 - Identify users and authenticate access

Identity Controls:
  ✓ Provisioning (Lab 02): Each user gets a unique account
  ✓ Authentication (Labs 07a-07d): MFA and Conditional Access
  ✓ Audit logs (Lab 07): Access audit trail

Evidence:
  - User list (no shared accounts)
  - MFA implementation report
  - Sign-in logs

Compliance Status: <assessed by your auditor>
Scope: <users with access to the cardholder data environment>
```

## Risk Scoring

### Risk Calculation

**Combine likelihood × impact:**

```
Risk = Likelihood (1-5) × Impact (1-5)

Risk Categories:
  1-5: Low risk
  6-12: Medium risk
  13-18: High risk
  19-25: Critical risk
```

### Identity-Specific Risks

```
Risk: Admin account compromise
  Likelihood: Medium (3) - Harder to compromise
  Impact: Extreme (5) - Admin can access everything
  Score: 15 (High risk)
  Control: MFA required, conditional access, monitoring
  Owner: CISO
  
Risk: Contractor account forgotten after exit
  Likelihood: High (4) - No systematic offboarding
  Impact: Medium (3) - Former employee could access data
  Score: 12 (Medium-High risk)
  Control: Contractor management system, 30-day auto-disable
  Owner: HR + IAM
  
Risk: Duplicate accounts
  Likelihood: Medium (3) - Manual provisioning errors
  Impact: Low (2) - Duplicate access, audit confusion
  Score: 6 (Medium risk)
  Control: Automated provisioning, monthly reconciliation
  Owner: IAM
```

### Risk Heat Map

**Visual representation of risks:**

```
                Low Impact    Medium Impact    High Impact
Low Likelihood      ✓              ✓              ⚠️
                  (1-5)          (6-10)          (11-15)
                 Green           Yellow          Orange

Medium Likelihood   ✓              ⚠️             ⚠️⚠️
                  (3-6)          (9-15)          (15-25)
                 Green           Yellow          Red

High Likelihood     ⚠️             ⚠️⚠️            ⚠️⚠️⚠️
                  (4-12)         (12-20)         (20-25)
                 Yellow           Red            Critical
```

## Audit Workflows

### Annual Audit Process

```
Q1: Planning & Scoping
  - Auditor defines audit scope
  - Identifies systems and processes to audit
  - Creates audit plan
  - Assigns questionnaires to business owners

Q2: Testing & Evidence Gathering
  - Business owners complete questionnaires
  - Auditor runs control tests
  - Reviews access reviews (quarterly evidence)
  - Tests access audit logs
  - Verifies policy enforcement

Q3: Analysis & Reporting
  - Auditor summarizes findings
  - Identifies control gaps or deviations
  - Risk-rates findings (low, medium, high)
  - Proposes remediation
  - Issues audit report

Q4: Remediation & Close
  - Management responds to findings
  - Execute remediation plans
  - Auditor verifies closure
  - Audit complete until next year
```

### Audit Evidence from Identity Systems

**What auditors need:**

Microsoft Entra keeps audit and sign-in logs for 7 days on Free tenants and 30 days on P1 and P2. If your retention requirement is longer, export the logs with diagnostic settings to a storage account, Log Analytics workspace or SIEM. See [Microsoft Entra data retention](https://learn.microsoft.com/en-us/entra/identity/monitoring-health/reference-reports-data-retention).

```
Access Control Evidence:
  ✓ Role definitions
  ✓ Role assignment reports (who has what)
  ✓ Access review reports (quarterly)
  ✓ Access removal records (revoked access)
  ✓ Exception approvals (with business justification)

Authentication Evidence:
  ✓ MFA enforcement policy
  ✓ MFA adoption metrics (% of users)
  ✓ Failed authentication logs
  ✓ Conditional access policies

Audit Trail Evidence:
  ✓ User creation/deletion logs
  ✓ Role assignment/removal logs
  ✓ Sign-in logs (retained per your policy; see note below)
  ✓ Admin action logs
  ✓ Policy change logs
```

## GRC-IAM Integration

### Data Flow

```
IAM System (Source of Truth)
  ├─ Users and roles
  ├─ Access reviews
  └─ Audit logs
  
  ↓ (Daily sync)
  
GRC Platform
  ├─ Compliance tracking
  ├─ Evidence repository
  ├─ Risk scoring
  └─ Audit workflows
  
  ↓ (Pull for audit)
  
Audit Report
  ├─ Compliance status
  ├─ Evidence summary
  └─ Findings & recommendations
```

### Integration Points

```
1. User Sync: IAM → GRC (daily)
   GRC knows who is currently active
   
2. Role Sync: IAM → GRC (daily)
   GRC knows current role assignments
   
3. Access Reviews: IGA → GRC (monthly)
   Stores access review evidence
   
4. Audit Logs: IAM → GRC (nightly)
   Long-term storage for audit trail
   
5. Risk Scoring: GRC ← IAM data
   Calculate risk based on access patterns
```

## Best Practices

1. **Integrated Governance** - Policies flow from governance to controls
2. **Evidence Automation** - Collect evidence automatically, not manual
3. **Risk-Driven Prioritization** - Focus on high-risk areas
4. **Control Mapping** - Clear link between compliance requirement and control
5. **Regular Assessment** - Annual minimum, quarterly reviews
6. **Remediation Tracking** - Monitor closure of findings
7. **Executive Reporting** - Heat maps and dashboards for leadership
8. **Audit Trail** - Keep evidence for as long as your regulations and policies require
9. **Policy Enforcement** - Technical controls for policy compliance
10. **Continuous Improvement** - Use audit findings to improve

## Related Documents

- [Identity Governance Administration guide](guide-identity-governance-administration.md)
- [Lab 17a — Set Up Your First Access Review](17a-set-up-access-reviews.md)
- [Lab 07 — Audit Logging & Monitoring](../PHASE-3-ENTRA-P2/07-audit-logging-monitoring.md)

## FAQ

**Q: Should we use GRC platform or manage compliance manually?**

A: It depends on scale and how many frameworks you report against. A small program can start with documented controls and exported evidence. Tooling pays off as the number of controls, systems and audits grows.

**Q: How often to conduct audits?**

A: Minimum annually. High-risk areas quarterly. Continuous monitoring for critical controls.

**Q: What's the cost of GRC platforms?**

A: It varies widely by vendor and scope. Ask vendors for a quote.

**Q: Can we use spreadsheets instead?**

A: You can for a small scope, but evidence is easy to lose and hard to keep consistent. Keep a clear owner, version control and dated exports if you do.

## Next Steps

1. Evaluate GRC platforms
2. Map compliance requirements to identity controls
3. Implement control tracking
4. Plan annual audit process
5. Set up automated evidence collection
6. Generate compliance reports
7. Use for executive reporting

GRC platforms consolidate governance, risk, and compliance into data-driven decision-making.
