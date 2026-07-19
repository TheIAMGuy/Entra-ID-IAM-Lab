---
title: Identity Governance Administration - IGA Platforms
part: 8
section: Compliance & Audit
difficulty: Advanced
estimated_reading_time: 40
estimated_lab_time: N/A
prerequisites:
  - 17-compliance-frameworks-mapping.md
  - 12-identity-governance-administration-process.md
learning_objectives:
  - Understand Identity Governance Administration (IGA) platforms
  - Compare IGA platforms (SailPoint, Okta, ServiceNow)
  - Implement access reviews and certifications
  - Configure identity analytics
  - Design IGA program structure
---

# Identity Governance Administration: IGA Platforms

## Introduction

Identity Governance Administration (IGA) platforms automate access governance: periodic reviews, certifications, risk scoring, and compliance reporting. Rather than manual spreadsheets, IGA uses technology to determine who has access, whether it's appropriate, and enforce decisions. This document explains IGA concepts, major platforms, and implementation strategies.

**Learning Objectives:**
- Understand IGA platform capabilities
- Compare leading IGA solutions
- Implement access reviews and certifications
- Configure risk and compliance reporting
- Design IGA governance program
- Extend governance to non-human identities (workloads, applications)

## ⚠️ Non-Human Identity (NHI) Governance - Emerging Critical Practice

**New in 2024-2025:** Modern IGA must include non-human identities (service principals, managed identities, workload identities, machine credentials). A [2025 Omada survey](https://www.lumos.com/identity-matters/identity-governance/identity-governance-automation) found that governance programs ignoring NHI are "structurally incomplete."

**What this means:**
- Service principals have exploded in scale (thousands per organization)
- Most organizations have 30-50% entitlements in disconnected systems (coverage gap)
- Non-human identity privilege exposure rivals human privilege exposure
- Your governance program MUST include NHI in access reviews, risk scoring, and certifications

**In this Phase 4 context:** When configuring access reviews, include non-human identities: service principals, managed identities, API keys, CI/CD credentials. A complete IGA program reviews humans AND workloads.

---

## IGA Core Concepts

### Access Review (Certification)

**Process:** Manager certifies that subordinate's access is appropriate

```
Quarterly Access Review Flow:
1. Access request sent to manager: "John has these roles"
2. Manager reviews: "Does John need Sales role?" → Yes → Certify
3. Manager reviews: "Does John need HR role?" → No → Remove
4. Manager signs certification: "I reviewed and approve"
5. System removes unapproved access
6. Audit log: Review completed, decisions recorded
```

### Risk Scoring

**Automated algorithm ranks risky access:**

```
Risk Score = User Risk + Role Risk + Anomaly Risk
  User Risk: New hire (higher), contractor (higher), long-tenured (lower)
  Role Risk: Admin (highest), developer (high), analyst (medium), viewer (low)
  Anomaly Risk: Access inconsistent with job title, access rarely used
```

**Risk bands:**
- 0-25: Low risk (routine access)
- 26-50: Medium risk (monitor)
- 51-75: High risk (requires approval)
- 76-100: Critical risk (immediate review required)

### Segregation of Duties (SoD) Conflict Detection

**IGA automatically identifies:**
- User holds both incompatible roles
- User could perform incompatible actions
- Compensating controls (monitoring) are in place

```
Conflict: User is Approver + Clerk
  Risk: Can approve own transactions
  Status: Compensating control (quarterly audit) in place
  Action: Continue monitoring, no action required
```

## IGA Platform Comparison

| Platform | Focus | Connectors | Certifications | Reporting | Cost |
|----------|-------|-----------|---|---|---|
| **SailPoint IdentityIQ** | Enterprise IGA | 500+ | Native | Extensive | $500K+ |
| **Okta Identity Governance** | Cloud IAM + IGA | Cloud-native | Simple | Good | Per-user pricing |
| **ServiceNow Identity** | ITSM + IGA | 100+ | Workflows | Integrated | Enterprise |
| **Deloitte Cloud IAM** | Governance focus | 200+ | Advanced | Compliance-focused | Consulting + platform |
| **Saviynt** | Cloud/hybrid | 300+ | Native | Risk-focused | Mid-market |

### SailPoint IdentityIQ

**Mature, comprehensive IGA platform:**

**Capabilities:**
- 500+ connectors (AD, Azure, Salesforce, SAP, etc.)
- Advanced access reviews (delegated, ad-hoc, scheduled)
- Risk analytics (user risk, role risk, anomalies)
- SoD conflict detection
- Automated remediation workflows
- Compliance reporting (SOX, GDPR, HIPAA)

**Access Review Example:**

```
Review: "Q1 2024 IT Department Access"
Target: All IT department users
Frequency: Quarterly
Reviewers: Department managers
Items per review: 5-10 role assignments
Certification deadline: 14 days
Auto-remediation: Remove non-certified access after 21 days
```

### Okta Identity Governance

**Cloud-native, integrated with Okta:**

**Capabilities:**
- Built-in to Okta platform
- Access reviews (basic to advanced)
- Delegated certifications
- Risk signals from Okta (sign-in risk, device risk)
- Native analytics
- Compliance templates (SOX, GDPR)

**Configuration:**

```yaml
AccessReviewPolicy:
  Name: "Quarterly Okta Access Review"
  Schedule: Every 3 months
  Scope: All Okta application access
  Reviewers: Application owner or manager
  Items: Okta app assignments for each user
  Timeline: 14 days to review
  Enforcement: Remove non-certified access
```

### ServiceNow Identity Governance

**Integrated with ITSM (Service Catalog, Change Management):**

**Capabilities:**
- Access request and provisioning
- Approval workflows
- Access certifications
- Identity analytics
- Integrated with ITSM workflows
- Change management integration

**Common scenarios:**
- Employee onboarding: New hire request → Auto-provision
- Offboarding: Exit process → Auto-deprovision
- Role change: HR update → Recertify access
- Access request: Employee request → Approval → Provision

## Access Review Workflow

### Design Phase

**1. Define scope:**
```
What to review?
- All cloud applications
- High-risk roles (Admin, Finance)
- Contractors (every quarter, employees annually)
- Recent changes (access granted in last 90 days)
```

**2. Define reviewers:**
```
Who reviews?
- Manager → reviews subordinate access
- System owner → reviews who has their system
- Compliance → spot-checks sensitive data
- Auditor → validates completeness
```

**3. Define decision criteria:**
```
Approve if:
- Access matches current job description
- Business justification documented
- User actively uses access
- No conflicts of interest
```

### Execution Phase

**1. Notification:**
```
Reviewer notification: "You have 15 items to review by 2024-01-31"
Includes: User list, current roles, business justification, risk score
```

**2. Review:**
```
For each user:
  [ ] Role: Database Administrator
      - User: John Smith
      - Date assigned: 2023-06-15
      - Business reason: Support production database
      - Risk: High (admin access)
      - Reviewer decision: ☐ Approve ☐ Revoke ☐ Modify
```

**3. Sign-off:**
```
Manager certifies: "I have reviewed the access above.
All listed users require their current access for their job role.
Any access I have marked as Revoke should be removed immediately."
Signed: [Digital signature], Date: 2024-01-28
```

### Enforcement Phase

**1. Remediation:**
```
Post-review:
- Approved access: Continue
- Revoked access: Disable immediately, log audit trail
- Expired or uncertified: Auto-disable after grace period
```

**2. Verification:**
```
- Confirm revoked access removed
- Alert if revocation fails
- Manual escalation if timeout
```

**3. Reporting:**
```
- Review completion rate (target: 100%)
- Access changes (X approvals, Y revocations)
- Risk addressed (Y high-risk roles certified/revoked)
- Compliance: Review completed per policy
```

## Risk Analytics

### Risk Scoring Algorithm

**Combine signals into single risk score:**

```
Risk Score Components:

User Risk (0-30 points):
  + New hire (<6 months): +10
  + Contractor: +15
  + Long-tenured (>5 years): -5
  + Recently reviewed (within 30 days): -3

Role Risk (0-40 points):
  + Admin: +40
  + Developer: +25
  + Auditor: +20
  + Analyst: +10
  + Viewer: 0

Anomaly Risk (0-30 points):
  + Access inconsistent with job title: +15
  + Access rarely used (<5% use): +10
  + Permission elevation unusual: +10
  + After-hours access: +5

Example Score:
  User Risk: New hire +10
  Role Risk: Admin +40
  Anomaly Risk: Admin rarely used +10
  Total: 60 (High risk, requires immediate review)
```

### Risk Dashboard

**Visual representation:**

```
Total Users: 2,500
Risk Distribution:
  Low (0-25): 2,200 users (88%)
  Medium (26-50): 200 users (8%)
  High (51-75): 75 users (3%)
  Critical (76-100): 25 users (1%)

Action Items:
- 25 critical risk users: Review this week
- 75 high risk users: Review this month
- 200 medium risk: Routine quarterly review
```

## IGA Implementation Roadmap

### Phase 1: Foundation (Months 1-3)

```
1. Select IGA platform
2. Configure connectors to major systems
3. Identify users and roles
4. Define access review process
5. First pilot review (IT department)
```

### Phase 2: Expansion (Months 4-6)

```
1. Deploy access reviews company-wide
2. Configure risk analytics
3. Implement SoD conflict detection
4. Set up compliance reporting
5. Train reviewers
```

### Phase 3: Optimization (Months 7-12)

```
1. Automated remediation workflows
2. Delegation and escalation policies
3. Analytics and insights
4. Integration with systems
5. Continuous improvement
```

## Best Practices

1. **Start with high-risk areas** - Compliance-sensitive roles first
2. **Automate reviews** - Scheduled, recurring, not manual
3. **Risk-based prioritization** - Review high-risk access more frequently
4. **Clear criteria** - Reviewers know exactly what to approve
5. **Quick turnaround** - 2-3 week review window, not months
6. **Enforcement** - Actually remove non-certified access
7. **Audit trail** - Every review and decision logged
8. **Training** - Reviewers understand process and criteria
9. **Escalation** - Clear path for unanswered reviews
10. **Continuous improvement** - Metrics show what's working

## Related Documents

**Prerequisites:**
- [Compliance Frameworks](./17-compliance-frameworks-mapping.md) - Compliance requirements
- [RBAC](./03-role-based-access-control.md) - Role-based access structure

**Next Steps:**
- [GRC Integration](./17b-grc-integration.md) - Risk and compliance management
- [Incident Response](./17c-incident-response.md) - Security incident handling

## FAQ

**Q: How often should we do access reviews?**

A: Minimum annually (compliance). Quarterly for high-risk, monthly for critical systems.

**Q: What's the cost of IGA platforms?**

A: $500K-2M+ annually for enterprise (SailPoint), or per-user pricing for cloud (Okta).

**Q: Can we use Excel instead of IGA platform?**

A: Not recommended. Manual process error-prone, audit findings likely. IGA worthwhile investment.

**Q: What if reviewer doesn't respond?**

A: Escalate to manager's manager, then compliance. If timeout, escalate to CISO.

## Next Steps

1. Evaluate IGA platforms
2. Define access review process
3. Pilot with high-risk department
4. Deploy company-wide
5. Configure risk analytics
6. Implement automated remediation
7. Plan quarterly review cycles

IGA automates access governance and dramatically improves compliance.
