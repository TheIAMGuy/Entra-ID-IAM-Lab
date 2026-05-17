---
title: GRC Integration - Governance, Risk, and Compliance Management
part: 8
section: Compliance & Audit
difficulty: Advanced
estimated_reading_time: 30
estimated_lab_time: N/A
prerequisites:
  - 17-compliance-frameworks-mapping.md
  - 17a-identity-governance-administration.md
learning_objectives:
  - Understand GRC platform concepts
  - Integrate identity governance with GRC systems
  - Map compliance requirements to controls
  - Implement risk scoring and heat maps
  - Manage audit and assessment workflows
---

# GRC Integration: Governance, Risk, and Compliance Management

## Introduction

Governance, Risk, and Compliance (GRC) platforms consolidate policy, compliance, and risk management. Instead of disparate spreadsheets, GRC brings together: governance policies (approved by board), risk assessments (enterprise risk), compliance requirements (HIPAA, GDPR, SOX), and controls (technical and operational). This document explains GRC concepts and integration with identity governance.

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
HIPAA Requirement: User access must be controlled
  Mapping: HIPAA 164.308(a)(4) - Identify information access needs
  Control: RBAC (Domain 4)
  Evidence: Role assignments, access review records
  Status: Compliant (verified in last audit)

PCI DSS Requirement: Unique user IDs for accountability
  Mapping: PCI DSS 7.1 - Restrict access to cardholder data
  Control: No shared accounts (Domain 1)
  Evidence: User account audit, enforcement policy
  Status: Compliant
```

## GRC Platforms

### Major Platforms

| Platform | Focus | Connectors | Audit | Reporting |
|----------|-------|-----------|-------|-----------|
| **Archer GRC** | Enterprise GRC | 100+ | Native | Comprehensive |
| **Workiva** | Compliance reporting | 200+ | Integrated | Strong |
| **AuditBoard** | Audit workflows | 50+ | Native | Audit-focused |
| **Deloitte GRC** | Risk & Compliance | Custom | IAM-integrated | Consulting |
| **LogicGate** | Risk & Audit | 100+ | Workflow-based | Good |

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
HIPAA Requirement (164.308(a)(4)):
  "Implement policies and procedures to manage information access"

Identity Controls:
  ✓ Domain 3 (RBAC): Grant access by role
  ✓ Domain 7 (Least Privilege): Remove unnecessary permissions
  ✓ Domain 12 (IGA): Access reviews quarterly
  ✓ Domain 13 (Audit): Log all access

Evidence Gathered:
  - Role definitions (approved by management)
  - Access review reports (quarterly)
  - Audit logs (access granted/revoked)
  - Exception approval process

Compliance Status: COMPLIANT
Verified: Annual audit
Next audit: 2025-03-31
```

### Example: PCI DSS Mapping

```
PCI DSS 8.1:
  "Ensure each individual accessing cardholder data is assigned unique ID"

Identity Controls:
  ✓ Domain 1 (Provisioning): Each user gets unique account
  ✓ Domain 10 (Authentication): MFA required
  ✓ Domain 13 (Audit): Access audit trail

Evidence:
  - User list (no shared accounts)
  - MFA implementation report
  - Sign-in logs

Compliance Status: COMPLIANT
Scope: 50 users with PCI access
Next review: 2024-06-30
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
  ✓ Sign-in logs (6+ months)
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
8. **Audit Trail** - Evidence preserved for 7+ years
9. **Policy Enforcement** - Technical controls for policy compliance
10. **Continuous Improvement** - Use audit findings to improve

## Related Documents

**Prerequisites:**
- [Compliance Frameworks](./17-compliance-frameworks-mapping.md) - Compliance requirements
- [IGA Platforms](./17a-identity-governance-administration.md) - Access governance

**Next Steps:**
- [Incident Response](./17c-incident-response.md) - Security incident handling
- [Risk Scoring](./17d-risk-scoring-algorithm.md) - Advanced risk analytics

## FAQ

**Q: Should we use GRC platform or manage compliance manually?**

A: GRC platform essential at scale (500+ users, multiple frameworks). Automates evidence, improves efficiency.

**Q: How often to conduct audits?**

A: Minimum annually. High-risk areas quarterly. Continuous monitoring for critical controls.

**Q: What's the cost of GRC platforms?**

A: $50K-200K+ annually depending on scale and features.

**Q: Can we use spreadsheets instead?**

A: Not recommended. Error-prone, audit trail weak, evidence fragmented.

## Next Steps

1. Evaluate GRC platforms
2. Map compliance requirements to identity controls
3. Implement control tracking
4. Plan annual audit process
5. Set up automated evidence collection
6. Generate compliance reports
7. Use for executive reporting

GRC platforms consolidate governance, risk, and compliance into data-driven decision-making.
