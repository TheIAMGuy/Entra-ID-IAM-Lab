---
title: Master Data Management - Identity Data Integration
part: 7
section: Data Quality & Operations
difficulty: Advanced
estimated_reading_time: 30
estimated_lab_time: N/A
prerequisites:
  - 16-data-quality-management.md
  - 09d-ldap-and-directory-services.md
learning_objectives:
  - Understand master data management (MDM) concepts
  - Design single source of truth architecture
  - Implement data integration and synchronization
  - Manage reference data (departments, locations, cost centers)
  - Monitor data quality across systems
---

# Master Data Management: Identity Data Integration

## Introduction

Master Data Management (MDM) establishes a single source of truth for identity data. HR system creates employees. That data synchronizes to Azure AD, then to applications (email, SharePoint, Salesforce, etc.). If HR data is source of truth, all systems stay consistent. Without MDM, data diverges: one system says "John is in Finance," another says "Sales." This document explains MDM concepts, architecture, and implementation.

**Learning Objectives:**
- Understand MDM principles
- Design single source of truth
- Implement data synchronization
- Manage reference data
- Monitor data consistency

## MDM Architecture

### Concept: Single Source of Truth

**Trusted Data Source:**

```
HR System (Source of Truth)
  ├─ Authority: All employee data
  ├─ Truth: Final decision point
  ├─ Data: Email, name, department, manager, job title
  └─ Read-only to applications (no direct edits)

Synchronized Systems:
  ├─ Azure AD (replicate HR data)
  ├─ Exchange (email from AD)
  ├─ SharePoint (email from AD)
  └─ Salesforce (sync via middleware)

Direction: HR → AD → Downstream (unidirectional)
Not bidirectional (no data flowing back to HR)
```

### Domains and Reference Data

**Reference data that needs consistency:**

```
Departments:
  HR System: ["Sales", "Engineering", "Finance", "Operations"]
  AD: Same list (sync from HR)
  Apps: Use AD list
  → Single source: HR system

Locations:
  HR System: ["New York", "San Francisco", "London", "Tokyo"]
  AD: Same list
  Apps: Use AD list
  → Single source: HR system

Cost Centers:
  HR System: ["10001-Sales", "10002-Engineering", ...]
  Apps: Access via AD attributes
  → Single source: HR system
```

## MDM Implementation Approaches

### Approach 1: Hub-and-Spoke (Centralized)

```
HR System (Hub)
  ├─ Azure AD Connect (spoke) - sync users
  ├─ Salesforce (spoke) - sync via connector
  ├─ ServiceNow (spoke) - sync via connector
  └─ SAP (spoke) - sync via connector

Direction: HR Hub broadcasts to all spokes
All updates synchronized within 4 hours
```

**Advantages:**
- Simple, easy to understand
- Single source of truth clear
- Easy to troubleshoot

**Disadvantages:**
- HR system becomes critical (outage affects everyone)
- Latency: 4-hour sync delay
- Limited transformation (data must match)

### Approach 2: Cloud Hub (Modern)

```
HR System → Azure AD (Hub) → All Applications
  
Benefits:
- Cloud platform (reliable, redundant)
- Real-time synchronization
- Transformation capability (HR → AD format)
- Conditional synchronization (filter users)
```

**Example: Azure AD Cloud Sync**

```
HR System:
  - Employee: john.smith@company.com
  - Department: Sales
  - Manager: mary.johnson@company.com

Azure AD Cloud Sync:
  - Fetch from HR API
  - Transform: Map HR fields to AD schema
  - Create/update user in Azure AD
  - Sync downstream apps (Exchange, SharePoint, etc.)

Timeline: 5-15 minutes end-to-end
```

### Approach 3: Identity Fabric (Advanced)

```
Multiple sources → Unified identity fabric → All applications

Sources:
  ├─ HR System (employees)
  ├─ Contractor Management (contractors)
  ├─ Active Directory (legacy)
  └─ API (customer identities)

Unified Fabric:
  - Reconciles across sources
  - Single view of identity
  - Smart matching (handles duplicates)
  - Policy-driven synchronization

Destinations:
  ├─ Azure AD
  ├─ Applications
  ├─ Analytics
  └─ Audit
```

## Data Synchronization Patterns

### Pattern 1: Real-Time Sync

**HR change → Immediate update across systems**

```
HR System:
1. John's department changed: Sales → Engineering
2. Trigger: Notification (webhook or API)

Azure AD:
1. Receive notification
2. Fetch updated data
3. Update AD user (department = Engineering)
4. Propagate downstream

Timeline: 5-30 seconds
```

### Pattern 2: Scheduled Sync

**Periodic synchronization (every hour, daily, etc.)**

```
Configuration:
  Frequency: Every 4 hours
  Window: 12:00, 4:00, 8:00, etc.

Process:
1. Azure AD Cloud Sync Agent wakes up
2. Queries HR System for all changes since last sync
3. Identifies: New users, deleted users, updated attributes
4. Applies changes to Azure AD
5. Logs all changes

Timeline: 4-hour sync window, up to 4 hours delay
```

### Pattern 3: Event-Driven Sync

**Sync triggered by specific events**

```
Events:
  - New hire created → Immediate provision
  - Termination date reached → Immediate disable
  - Department change → Sync within 1 hour
  - Phone change → Sync within 4 hours

Advantage: High-priority changes fast, others batched
```

## Reference Data Management

### Reference Data in MDM

**Data that categorizes or organizes identities:**

```
Department Reference:
  ID: 101
  Name: Sales
  Manager: Mary Johnson
  Cost Center: 10001
  Location: New York

Users reference this:
  John Smith → Department: 101 (Sales)
  Jane Doe → Department: 101 (Sales)

Change Process:
  1. Update Department reference in HR
  2. All users with that department updated automatically
  3. No individual user updates needed
```

### Managing Reference Data

**Process:**

```
1. Identify reference data items
   - Departments, locations, cost centers, job titles, org levels

2. Establish ownership
   - Departments: HR owns
   - Locations: Facilities owns
   - Cost Centers: Finance owns

3. Define synchronization
   - Source system (HR for departments)
   - Frequency (daily)
   - Downstream targets (AD, apps)

4. Monitor changes
   - Alert if reference data out of sync
   - Verify completeness

5. Update process
   - Change owner notifies sync system
   - Sync propagates within SLA
```

## Data Quality in MDM

### Completeness

**All required attributes populated:**

```
HR System: email (required for all users)
  ✓ 99.5% of users have email
  ✗ 0.5% missing (investigate)

Azure AD: department (required for RBAC)
  ✓ 98% have department
  ✗ 2% missing (sync issue or HR issue)
```

### Accuracy

**Values are correct:**

```
HR System:
  john.smith@company.com

Azure AD:
  ✓ john.smith@company.com (correct)
  OR
  ✗ john.smth@company.com (typo, inaccuracy)

Resolution: Verify in HR, correct at source, resync
```

### Consistency

**Same data in all systems:**

```
HR System: john.smith@company.com, Department: Sales
Azure AD: john.smith@company.com, Department: Sales
Salesforce: john.smith@company.com, Department: Sales
→ Consistent ✓

If inconsistent:
HR: Sales
AD: Finance
→ AD is stale, needs resync
```

### Timeliness

**Data current as of today:**

```
HR System: John changed to Finance yesterday
Azure AD: Still shows Sales (stale, not synced yet)

SLA: Should update within 4 hours
Status: Within SLA (updated 2 hours later) ✓
```

## MDM Monitoring

### Sync Status

**Monitor synchronization health:**

```
Last Sync: 2024-01-15 14:30 UTC
Status: Success
Records synced: 2,500 users, 150 updates
Time taken: 8 minutes

Failures: 0
Warnings: 2 (check logs)

Next scheduled: 2024-01-15 18:30 UTC
```

### Data Quality Scorecard

| Metric | Source | Target | Status |
|--------|--------|--------|--------|
| **Completeness (email)** | HR 99.5% | AD 99.5% | ✓ Aligned |
| **Accuracy (department)** | HR 98% | AD 97.5% | ⚠️ Slight divergence |
| **Consistency** | HR=AD=Salesforce | HR=AD, AD≠SF (SF lag) | ⚠️ Salesforce behind |
| **Timeliness** | <4 hours | Latest sync 2h | ✓ On track |

### Alerts

**Alert on problems:**

```
Alert: Sync failure
  - No successful sync in 8 hours
  - Action: Check Azure AD Cloud Sync Agent
  - Escalate: Contact Azure support

Alert: Data divergence
  - 50+ users have department mismatch (HR vs AD)
  - Action: Force resync
  - Investigate: Sync logic issue?

Alert: Completeness below threshold
  - Email missing for 2% of users (target: <1%)
  - Action: Investigation in HR, remediation
  - SLA: 24 hours to resolve
```

## Best Practices

1. **Single Source** - One authoritative system per data type
2. **Unidirectional** - Data flows one direction, not bidirectional
3. **Automated Sync** - Scheduled or event-driven, not manual
4. **Transformation** - Map source format to target format
5. **Monitoring** - Real-time alerts on sync issues
6. **Reconciliation** - Regular audits (weekly/monthly)
7. **SLAs** - Define acceptable sync latency
8. **Backup/Recovery** - Plan for sync failures
9. **Documentation** - Clear mapping of data sources and flows
10. **Governance** - Ownership and accountability for data quality

## Related Documents

**Prerequisites:**
- [Data Quality](./16-data-quality-management.md) - Quality dimensions
- [LDAP and Directory Services](./09d-ldap-and-directory-services.md) - Sync mechanics

**Next Steps:**
- [Attribute Management](./16c-attribute-management.md) - Standardized attributes
- [SCIM Provisioning](./09c-scim-provisioning.md) - Cloud provisioning protocol

## FAQ

**Q: What if HR system is down?**

A: Cloud sync caches data, uses last known good state. Continues with cached data.

**Q: Can we sync bi-directionally?**

A: Not recommended. Causes conflicts and data loss. Keep unidirectional.

**Q: How long to implement MDM?**

A: Simple: 1-3 months. Complex multi-source: 6-12 months.

**Q: What if systems don't support integration?**

A: Use middleware (MuleSoft, Boomi) or custom API.

## Next Steps

1. Audit current system integrations
2. Identify source of truth for each data type
3. Design synchronization strategy
4. Implement cloud sync (or MDM platform)
5. Monitor data quality
6. Establish reconciliation process
7. Plan for new system additions

Master data management ensures identity data consistency across enterprise.
