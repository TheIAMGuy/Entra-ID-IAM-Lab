---
title: Identity Sprawl Management - Unused Account Cleanup
part: 7
section: Data Quality & Operations
difficulty: Intermediate
estimated_reading_time: 25
estimated_lab_time: N/A
prerequisites:
  - 16-data-quality-management.md
  - 01-user-provisioning-joiner.md
learning_objectives:
  - Identify unused and orphaned identities
  - Implement identity cleanup processes
  - Prevent identity sprawl at scale
  - Monitor account lifecycle
  - Manage inactive accounts
---

# Identity Sprawl Management: Unused Account Cleanup

## Introduction

Identity sprawl refers to growth of unused, forgotten, or orphaned identities. A contractor's account remains active 2 years after contract ends. A test account created for development is never deleted. An employee account stays active despite termination. These accounts accumulate access, create compliance violations, and increase breach surface. This document explains identity sprawl, its risks, and remediation.

**Learning Objectives:**
- Identify sources of identity sprawl
- Detect unused and orphaned accounts
- Implement cleanup processes
- Prevent sprawl through governance
- Monitor account lifecycle

## Sources of Identity Sprawl

### Source 1: Failed Offboarding

**Employee leaves but account remains:**

```
Employee termination date: 2022-06-15
Account should disable: 2022-06-15
Actual status today (2024-01-15): Still active (19 months later!)
  Access still: Email, SharePoint, all previous applications
  Risk: Ex-employee could access sensitive data
  Cause: Offboarding ticket never completed by IT
```

**Common cause:** Manual process failure, no accountability, no verification

### Source 2: Test/Temporary Accounts

**Created for testing, never deleted:**

```
Account: test.user@company.com (created 2021-03-01)
Purpose: Load testing for new application
Should be deleted: 2021-03-30
Actual status: Still active (3+ years later)
  Risk: Can be abused, credentials potentially exposed
  Cause: Forgotten, no policy to delete after test period
```

### Source 3: Contractor Accounts

**Contractor agreement ended but account remains:**

```
Contractor: John Doe
Contract period: 2022-01-01 to 2023-12-31
Account disable date: 2023-12-31
Actual status: Still active (1 year later)
  Access: Still has development environment access
  Risk: Contractor could sell access, use for competitive intelligence
  Cause: No contractor offboarding workflow
```

### Source 4: Stale Account Inactivity

**Account never used after creation:**

```
User: new.developer@company.com (created 2023-06-01)
Last sign-in: 2023-06-02 (single sign-in, never returned)
Current status: Still active (7+ months with no use)
  Risk: Compromised account might not be noticed
  Cause: User left before fully onboarding
```

## Identity Sprawl Risk

**Security risk:**
- Unused account = forgotten password = weak password = compromise risk
- Unused account = forgotten MFA setup = authentication bypass
- Unused account = forgotten access cleanup = over-privileged access
- Accumulated unused accounts = larger breach surface

**Compliance risk:**
- Audit finding: "1,000 active accounts, but only 950 current employees"
- Risk assessment: "Organization unable to audit who has access"
- Compliance violation: "Failed to implement access controls (unused accounts)"

**Operational risk:**
- Cost: License costs for unused accounts
- Confusion: Is this real employee or test account?
- Management burden: More accounts to govern

## Identifying Sprawl

### Method 1: Reconciliation

**Compare user sources:**

```
Azure AD: 2,500 active users
HR System: 2,350 active employees
Difference: 150 users

Of the 150:
- 50: Service accounts (legitimate)
- 30: Contractors (need date check)
- 40: Test accounts (should delete)
- 20: Orphaned (no match in HR, should delete)
- 10: Unknown (need investigation)
```

### Method 2: Inactivity Analysis

**Track last sign-in:**

```
Users by last sign-in:
- Last 30 days: 2,200 users (88%) - Active
- 31-90 days: 100 users (4%) - Moderately active
- 91-365 days: 150 users (6%) - Inactive, should check
- 1+ years: 50 users (2%) - Definitely inactive, delete candidates
```

### Method 3: KQL Query

**Find stale accounts:**

```kql
SignInLogs
| where TimeGenerated > ago(365d)
| summarize LastSignIn = max(TimeGenerated) by UserId
| where LastSignIn < ago(180d)  // No sign-in in 6 months
| project UserId, DaysSinceLastSignIn = (now() - LastSignIn) / 1d
```

## Cleanup Process

### Step 1: Identification

**Monthly process:**

```
1. Extract all Azure AD users
2. Extract all HR active employees
3. Find discrepancies:
   - Users in AD but not in HR
   - Users in HR but not activated in AD
4. For each discrepancy: Investigate
```

### Step 2: Investigation

**For each candidate account:**

```
Question: Is this account supposed to exist?

Check:
1. Is this a service account? (legitimate, skip)
2. Is this a contractor? (check contract end date)
3. Is this a test account? (check project status)
4. Was this employee terminated? (check HR records)
5. Is account owner still at company? (call them)
```

### Step 3: Remediation

**Based on investigation:**

```
Case 1: Service account
  → Document purpose, add to service account list
  → No action

Case 2: Contractor, contract ended
  → Disable immediately
  → Remove all access
  → Audit for any unauthorized changes

Case 3: Test account
  → Delete (or mark for deletion)
  → Remove all access

Case 4: Orphaned (no match in HR)
  → Disable and quarantine (30-day hold)
  → If not claimed: Delete
  → Audit for any unauthorized activity

Case 5: Employee still at company
  → Update HR records
  → Reactivate if disabled
  → No action needed
```

### Step 4: Verification

**After cleanup:**

```
1. Confirm disabled accounts can't sign in
2. Confirm access removed
3. Send notification to managers: "These accounts were disabled"
4. Audit: No unauthorized access by disabled accounts
```

## Preventing Sprawl

### 1. Contractor Account Lifecycle

**Automated workflow:**

```
Contract start → Create account
  ├─ Duration: Contract end date
  └─ MFA enabled

Mid-contract → Monitor (30 days before end)
  └─ Manager confirms contract continuing

Contract end → Disable automatically
  ├─ All access removed
  ├─ Email forwarding stopped
  ├─ Send offboarding notification
  └─ Quarantine 30 days

Quarantine complete → Delete account
```

### 2. Test Account Expiration

**Policy:**

```
Test accounts expire after 30 days
1. Account created for testing
2. 25-day mark: Email "account expires in 5 days"
3. 30-day mark: Account disabled
4. If still needed: Recreate with new 30-day period
```

### 3. Onboarding Verification

**Confirm account usage:**

```
After onboarding week 1:
- New hire should have signed in
- New hire should have set MFA
- If not: Follow up, provide support

After 30 days:
- If never used: Investigate
- Has company left? Confirm, delete
- Needs support? Provide training
```

### 4. Regular Audits

**Quarterly:**

```
1. Reconciliation: AD vs. HR
2. Inactivity: Find stale accounts
3. Investigation: Each discrepancy
4. Remediation: Delete unused, disable orphaned
5. Reporting: Show progress on sprawl reduction
```

## Sprawl Metrics

| Metric | Target | Current | Trend |
|--------|--------|---------|-------|
| **Orphaned accounts** | 0 | 20 | ↓ Improving |
| **Test accounts >30 days** | 0 | 5 | ↓ Improving |
| **Contractor accounts past end-date** | 0 | 10 | ↓ Improving |
| **Stale accounts (1+ year no use)** | <1% | 2% | ↓ Improving |
| **Reconciliation success** | 100% | 95% | ↑ Improving |

## Best Practices

1. **Automate Offboarding** - Disable account immediately on termination
2. **Contractor Tracking** - Link account to contract, auto-disable
3. **Test Accounts** - 30-day expiration default
4. **Reconciliation** - Monthly minimum
5. **Monitoring** - Alert on stale accounts quarterly
6. **Verification** - Confirm with manager/owner
7. **Documentation** - Log all cleanup actions
8. **Remediation** - Timely action within 30 days of detection
9. **Enforcement** - Actually delete accounts, not just disable
10. **Compliance** - Audit trail of all actions

## Related Documents

**Prerequisites:**
- [Data Quality](./16-data-quality-management.md) - Data governance
- [Provisioning](./01-user-provisioning-joiner.md) - Account creation

**Next Steps:**
- [Master Data Management](./16b-master-data-management.md) - Data integration
- [Offboarding Process](./06-leaver-offboarding.md) - Deprovisioning details

## FAQ

**Q: Should we delete or disable stale accounts?**

A: Disable first (30-day quarantine), then delete. Allows recovery if mistake.

**Q: What about regulatory record retention?**

A: Retain audit logs, delete account data after retention period (typically 7 years).

**Q: How do we handle appeals ("I still need this account")?**

A: If legitimate, recreate. If appeal after 30 days, require manager approval.

## Next Steps

1. Conduct sprawl audit
2. Identify all stale accounts
3. Develop remediation plan
4. Implement automated cleanup (contractor, test)
5. Establish quarterly reconciliation
6. Monitor sprawl metrics
7. Report progress to management

Identity sprawl cleanup can reduce accounts 5-15%, improving security and compliance.
