---
title: Data Quality Management - Identity Data Governance
part: 7
section: Data Quality & Operations
difficulty: Intermediate
estimated_reading_time: 30
estimated_lab_time: N/A
prerequisites:
  - 01-user-provisioning-joiner.md
  - 03-role-based-access-control.md
learning_objectives:
  - Understand identity data quality concepts
  - Identify and remediate data quality issues
  - Implement data governance policies
  - Monitor data quality metrics
  - Design master data management strategy
---

# Data Quality Management: Identity Data Governance

## Introduction

Quality identity data is foundational for access control and compliance. If user records are inaccurate (wrong department, obsolete job title), access control fails. If user email is invalid, notifications don't reach them. Identity data quality encompasses completeness (all fields present), accuracy (values correct), consistency (same data in all systems), and timeliness (current). This document explains identity data quality, governance, and remediation.

**Learning Objectives:**
- Understand identity data quality dimensions
- Identify data quality issues
- Implement remediation workflows
- Monitor and report on data quality
- Design master data strategy

## Data Quality Dimensions

### Completeness

**All required fields populated:**
- ✓ Email address (required for notifications)
- ✓ Department (required for RBAC)
- ✓ Manager (required for approval workflows)
- ✓ Job title (required for access decisions)
- ✓ Cost center (required for chargeback)

**Issues:**
- Missing email: Can't receive MFA challenges, password resets
- Missing department: Can't apply department-based access policies
- Missing manager: Can't route approval requests

**Remediation:**
```
1. Identify records with missing fields
2. Auto-populate from authoritative source (HR system)
3. Escalate to manager if can't auto-populate
4. Block user provisioning until complete
```

### Accuracy

**Values are correct:**
- ✗ user@company.com (typo: should be user@company.com)
- ✗ Department = "Finance" but HR system says "Accounting"
- ✗ Job title = "Analyst" but HR system says "Senior Analyst"

**Issues:**
- Wrong email: User can't reset password
- Wrong department: User gets wrong access
- Stale job title: Used for access decisions, affects compliance

**Remediation:**
```
Implement validation:
1. Email format validation (regex)
2. Manager existence check (manager must exist in system)
3. Department cross-reference (validate against HR list)
4. Job title from authoritative source (HR, not user self-service)
```

### Consistency

**Same data in all systems:**
- Azure AD: userA@company.com
- HR System: userA@company.com
- Email System: userA@company.com
- ✗ Sharepoint: user.a@company.com (inconsistency!)

**Issues:**
- Inconsistent email prevents federation
- Inconsistency prevents deprovisioning (can't match user across systems)
- Compliance audits fail (can't prove access control)

**Remediation:**
```
Source of truth (HR system):
1. HR → Entra ID → SharePoint (single source)
2. Not bidirectional
3. Cross-system reconciliation reports
4. Alert on discrepancies
```

### Timeliness

**Data current as of today:**
- User transferred to new department yesterday: ✗ System shows old department
- User promoted to manager: ✗ System shows old job title
- User divorced, changed name: ✗ System shows old name

**Issues:**
- Delayed updates cause access violations
- Delayed role changes cause over-privileged access
- Delayed deprovisioning leaves access active

**Remediation:**
```
SLA for data updates:
- HR change → Entra ID update: 4 hours
- Entra ID change → downstream systems: 24 hours
- Monitor update latency
- Alert if SLA breached
```

## Common Data Quality Issues

### Issue 1: Duplicate Users

**Symptom:** Same person appears twice

```
User 1: john.smith@company.com (active)
User 2: john.smith@company.com (inactive, old account)
User 3: j.smith@company.com (typo, same person)
```

**Impact:**
- Duplicate access
- Confusion in audit logs
- Failed deprovisioning
- Multiple MFA registrations

**Remediation:**
```
1. Identify duplicates (fuzzy name matching, email domains)
2. Consolidate accounts (migrate permissions to one account)
3. Deactivate and delete duplicate accounts
4. Verify no orphaned access
```

### Issue 2: Orphaned Accounts

**Symptom:** Account active but no corresponding user in HR

```
oldemployee@company.com: Last HR record 3 years ago
contractor-temp@company.com: Contract ended 2 years ago
testaccount@company.com: Test account never cleaned up
```

**Impact:**
- Unauthorized access still active
- Compliance violation
- Audit findings

**Remediation:**
```
Process:
1. Monthly reconciliation: AD users vs. HR active users
2. For each orphaned account:
   - Verify not a service account (legitimate)
   - Confirm employment ended
   - Disable account
   - After 30 days: Delete
```

### Issue 3: Stale Attributes

**Symptom:** User records not updated from HR

```
User: John Smith
Department: "Sales" (hasn't changed in 5 years, unlikely)
Manager: "Mary Johnson" (Mary left company 2 years ago, still listed as manager)
Job Title: "Sales Rep" (old title, no updates from promotions)
```

**Impact:**
- Access policies based on stale data
- Org chart doesn't match reality
- Approval workflows route to wrong people

**Remediation:**
```
1. Periodic audit: Sample 10% of users
2. Verify attributes against HR system
3. Auto-correct from HR when possible
4. Alert for human review (manager left company)
5. SLA: Update within 4 hours of HR change
```

### Issue 4: Naming Inconsistencies

**Symptom:** Names stored in different formats

```
HR System: "John Michael Smith"
Entra ID: "John Smith"
Email: "jsmith@company.com"
Manager name: "j.m.smith"
```

**Impact:**
- Can't match across systems
- Reconciliation fails
- Reports show different names

**Remediation:**
```
Standardization:
1. Define standard format: LastName, FirstName
2. Parse all names into components
3. Normalize across systems
4. Use authoritative source (HR) for truth
```

## Data Quality KPIs

**Metrics to track:**

| Metric | Target | Impact |
|--------|--------|--------|
| **Completeness** | >99% | Users can't access if email missing |
| **Accuracy** | >98% | Access control fails on wrong data |
| **Consistency** | >99.5% | Audit failures, federation issues |
| **Timeliness** | <4 hours | Over/under-provisioned access |
| **Duplicates** | 0% | Security and audit issues |
| **Orphaned accounts** | 0% | Unauthorized access remains |

**Monitoring:**

```
Monthly Data Quality Report:
- Completeness: 99.2% (target: 99%)
- Accuracy: 97.8% (target: 98%) → Investigate why lower
- Consistency: 99.1% (target: 99.5%)
- Timeliness (avg): 2.3 hours (target: <4 hours) → Good
- Duplicates found: 3 (target: 0) → Remediate
- Orphaned accounts: 5 (target: 0) → Disable
```

## Master Data Management Strategy

### Single Source of Truth

**Architecture:**

```
HR System (authoritative)
  ├─ Azure AD (sync from HR)
  ├─ SharePoint (sync from Azure AD)
  ├─ Exchange (sync from Azure AD)
  └─ On-premises AD (if hybrid)

Direction: HR → Entra ID → Downstream
Not bidirectional
```

### Identity Reconciliation

**Monthly process:**

```
1. Extract all users from HR system
2. Compare with Entra ID users
3. Find:
   - New HR users not in Entra ID (provision)
   - Entra ID users not in HR (orphaned, disable)
   - Attribute differences (update from HR)
4. Report and remediate
```

**KQL reconciliation query:**

```kql
let hrUsers = externaldata(
  EmployeeID: string,
  Email: string,
  Department: string,
  Manager: string
) ["https://.../.csv"];

EntraIDUsers
| join kind=fullouter hrUsers on $left.mail == $right.Email
| where isempty(EmployeeID) or isempty(mail)  // Orphaned or new
| project Email, HRStatus = case(isempty(EmployeeID), "NoHRRecord", "OK"),
          EntraIDStatus = case(isempty(mail), "OnlyInHR", "OK"),
          Department, Manager
```

## Best Practices

1. **Single Source of Truth** - HR system is authoritative
2. **Automation** - Auto-sync from HR, don't manual entry
3. **Validation** - Enforce required fields at provisioning
4. **Regular Audits** - Monthly data quality reviews
5. **Reconciliation** - Automated daily reconciliation
6. **Alerting** - Alert on anomalies (duplicates, orphaned)
7. **Timeliness SLA** - 4-hour sync latency, monitor
8. **Documentation** - Data quality policies documented
9. **Remediation Process** - Clear process for issues
10. **Governance** - Identity governance team owns data quality

## Related Documents

**Prerequisites:**
- [Provisioning](./01-user-provisioning-joiner.md) - User creation
- [RBAC](./03-role-based-access-control.md) - Access control using data

**Next Steps:**
- [Identity Sprawl](./16a-identity-sprawl-management.md) - Unused identity cleanup
- [Attribute Management](./16c-attribute-management.md) - Standardized attributes

## FAQ

**Q: How often should we audit data quality?**

A: Monthly minimum. Real-time monitoring for critical data (email, manager).

**Q: What if data conflict with HR and Entra ID?**

A: HR system is source of truth. Update Entra ID to match HR.

**Q: Can users change their own attributes?**

A: Limited. Self-service allowed for phone/address. Job title, department should be read-only (from HR).

## Next Steps

1. Define data quality policy
2. Identify current data quality issues
3. Implement remediation plan
4. Set up monitoring and KPIs
5. Establish governance process
6. Design master data management strategy
7. Plan regular audits

Identity data quality is foundational for security and compliance.
