---
title: Identity Governance Administration - IGA Platforms
section: Compliance & Audit
difficulty: Advanced
estimated_reading_time: 40
estimated_lab_time: N/A
prerequisites:
  - 17a-set-up-access-reviews.md
learning_objectives:
  - Understand Identity Governance Administration (IGA) platforms
  - Understand Microsoft Entra ID Governance and how other IGA platforms compare
  - Implement access reviews and certifications
  - Configure identity analytics
  - Design IGA program structure
---

# Identity Governance Administration: IGA Platforms

## Introduction

Identity Governance Administration (IGA) platforms automate access governance: periodic reviews, certifications, risk scoring, and compliance reporting. Rather than manual spreadsheets, IGA uses technology to determine who has access, whether it's appropriate, and enforce decisions. This document explains IGA concepts, what Microsoft Entra ID Governance provides, how other platforms compare at a high level, and implementation strategies.

**Learning Objectives:**
- Understand IGA platform capabilities
- Compare leading IGA solutions
- Implement access reviews and certifications
- Configure risk and compliance reporting
- Design IGA governance program
- Extend governance to non-human identities (workloads, applications)

## Non-Human Identity (NHI) Governance

Governance programs that only review people leave workloads unreviewed. Service principals, managed identities and application credentials often have standing privileges and no named owner.

**What this means in practice:**
- Include non-human identities in your inventory and in review scope where the platform supports it. In Microsoft Entra, privileged Entra role reviews through Privileged Identity Management can include service principals, which needs Entra ID P2 or Entra ID Governance.
- Give every service principal an owner who can attest that it is still needed.
- Prefer managed identities and workload identity federation over long-lived secrets. See [Workload ID Protection](https://learn.microsoft.com/en-us/entra/id-protection/concept-workload-identity-risk) for the risk detections Microsoft provides for service principals.

This repository does not currently include a workload identity lab.

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

### Risk Scoring (illustrative model)

The scores below show how an IGA platform might rank access for reviewers. The weights are examples, not a Microsoft Entra feature. Entra access reviews instead give reviewers recommendations based on criteria such as last sign-in.

**Example ranking:**

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

## Microsoft Entra ID Governance

Microsoft Entra ID Governance is the IGA capability in Microsoft Entra. It covers four areas.

### Access Reviews

Access reviews let you recertify access on a schedule. You create them in the place that matches the resource:

| What you review | Reviewers can be | Created in |
|-----------------|------------------|-----------|
| Security group and Microsoft 365 group members | Specified reviewers, group owners, self-review | Access reviews |
| Users assigned to an enterprise application | Specified reviewers, self-review | Access reviews |
| Microsoft Entra roles and Azure resource roles | Specified reviewers, self-review | Privileged Identity Management |
| Access package assignments | Specified reviewers, group members, self-review | Entitlement management |

Useful settings:
- **Recurrence:** Weekly, monthly, quarterly or annually
- **Recommendations:** Show reviewers signals such as last sign-in to help them decide
- **Auto apply results:** Remove denied users automatically when the review ends
- **If reviewers don't respond:** No change, remove access, approve access, or take recommendations. Combining *remove access* or *take recommendations* with auto apply can revoke everything if reviewers don't respond, so test first.
- **Limits:** Results can't be applied to groups synced from on-premises Active Directory, to mail-enabled groups, or to users who hold access through nested groups.

Lab 17a walks through creating a review.

### Entitlement Management

Entitlement management bundles access into **access packages** held in **catalogs**. Each package has policies that set who can request it, who approves, how long access lasts, and whether recurring reviews apply. It can also assign access automatically based on user attributes, and it supports **separation of duties checks**: a package can be marked incompatible with another package or a group, so a user who already has one can't request the other.

### Lifecycle Workflows

Lifecycle workflows automate joiner, mover and leaver tasks. A workflow has tasks (for example, send a welcome email, generate a Temporary Access Pass, add or remove groups, disable or delete the account, remove licences) and execution conditions (a trigger such as `employeeHireDate` or `employeeLeaveDateTime`, and a scope). Custom task extensions can call out to Azure Logic Apps for other systems.

### Privileged Identity Management

PIM provides just-in-time, time-bound activation of privileged roles with approval and access reviews. This repository's Lab 04 assigns roles permanently and does not cover PIM.

### Licensing

Access reviews need Entra ID Governance or Entra Suite, and some capabilities work with Entra ID P2. Entitlement management and lifecycle workflows need Entra ID Governance, with some entitlement management capabilities available with P2. See [Microsoft Entra ID Governance licensing fundamentals](https://learn.microsoft.com/en-us/entra/id-governance/licensing-fundamentals).

## Other IGA Platforms

Dedicated IGA vendors such as SailPoint, Saviynt, Okta Identity Governance and ServiceNow compete with or complement Entra ID Governance, particularly where you need connectors to many non-Microsoft systems, deep role mining or policy-based SoD across applications such as SAP.

Typical differences to evaluate:

| Area | Questions to ask |
|------|------------------|
| Connectors | Does the platform have supported connectors for your actual applications? |
| Certifications | Can reviews cover entitlements inside applications, not just group membership? |
| SoD | Are conflicts evaluated across applications, or only within one directory? |
| Fit | Does it integrate with your IdP, HR system and ITSM? |
| Cost | How is it licensed (per identity, per module), and what are implementation costs? |

Features, connector counts and pricing change often. Get current figures from each vendor rather than from this guide.

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
Reviewer notification: "You have 15 items to review by <date>"
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
Signed: [Digital signature], Date: <date>
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
- Review completion rate (set a target)
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
1. Select the IGA approach (for example Entra ID Governance)
2. Configure connectors or provisioning for major systems
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

- [Lab 17a — Set Up Your First Access Review](17a-set-up-access-reviews.md)
- [GRC Integration](guide-grc-integration.md) — risk and compliance management

## FAQ

**Q: How often should we do access reviews?**

A: Match the frequency to the risk and to your compliance requirements. A common pattern is more frequent reviews (for example quarterly) for privileged access and external users, and less frequent (annual) for low-risk access.

**Q: What's the cost of IGA platforms?**

A: It varies widely by vendor, scale and scope, and many vendors don't publish prices. For Microsoft, see the [Microsoft Entra plans and pricing](https://www.microsoft.com/en-us/security/business/microsoft-entra-pricing) page. Ask other vendors for a quote.

**Q: Can we use Excel instead of IGA platform?**

A: For a small environment a documented, repeatable process can work. As scale and audit pressure grow, manual reviews become error-prone and hard to evidence, which is where tooling helps.

**Q: What if reviewer doesn't respond?**

A: Configure the review's escalation and default decision. In Entra access reviews, "If reviewers don't respond" sets the outcome, and fallback reviewers can be specified.

## Next Steps

1. Evaluate IGA platforms
2. Define access review process
3. Pilot with high-risk department
4. Deploy company-wide
5. Configure risk analytics
6. Implement automated remediation
7. Plan quarterly review cycles

IGA automates access governance and produces evidence that access is reviewed and removed when it is no longer needed.
