---
title: Attribute Management - Standardized Identity Attributes
part: 7
section: Data Quality & Operations
difficulty: Intermediate
estimated_reading_time: 25
estimated_lab_time: N/A
prerequisites:
  - 16-data-quality-management.md
  - 03-role-based-access-control.md
learning_objectives:
  - Understand attribute standardization
  - Design attribute schemas
  - Implement attribute governance
  - Use attributes for access control (ABAC)
  - Manage attribute lifecycle
---

# Attribute Management: Standardized Identity Attributes

## Introduction

Attributes are identity properties: email, department, job title, location, cost center, security clearance. Consistent attributes enable access control: "Users in Finance department can access Finance database." Without standardization, attributes diverge: one system says "Sales," another says "Sales Department," another says "SALES." This document explains attribute standardization and governance.

**Learning Objectives:**
- Design standardized attribute schema
- Implement attribute governance
- Use attributes for access control
- Manage attribute lifecycle
- Monitor attribute quality

## Attribute Categories

### Core Identity Attributes

**Essential for all users:**

```
Email: john.smith@company.com
  - Unique identifier
  - Used for notifications, sign-in
  - Required: Yes
  - Mutable: No (change requires admin)

Display Name: John Smith
  - Human-readable name
  - Used in UI, email
  - Required: Yes
  - Mutable: Self-service

First Name: John, Last Name: Smith
  - Components of display name
  - Used for sorting, searching
  - Required: Yes
  - Mutable: Self-service

User Principal Name (UPN): john.smith@company.com
  - Unique in tenant
  - Format: firstname.lastname@domain.com
  - Required: Yes
  - Mutable: No
```

### Organizational Attributes

**Used for RBAC and governance:**

```
Department: Sales
  - Org unit
  - Used for: Access control, cost allocation, org chart
  - Values: ["Sales", "Engineering", "Finance", "Operations", "HR"]
  - Source: HR system (read-only)
  - Required: Yes

Job Title: Senior Sales Manager
  - Role description
  - Used for: Title-based access, org chart
  - Source: HR system (read-only)
  - Required: Yes

Manager: mary.johnson@company.com
  - Direct manager
  - Used for: Approval routing, org hierarchy
  - Source: HR system (read-only)
  - Required: Yes (except executives)

Cost Center: 10001
  - Financial allocation
  - Used for: Cost tracking, resource allocation
  - Source: HR system (read-only)
  - Required: Yes
```

### Location and Environment Attributes

**Used for conditional access and resource location:**

```
Office Location: New York
  - Physical location
  - Used for: Network access, resource allocation
  - Values: ["New York", "San Francisco", "London", "Tokyo"]
  - Source: HR system
  - Required: No

Country: USA
  - Country of work
  - Used for: GDPR compliance, data residency
  - Source: HR system
  - Required: Yes

Time Zone: America/New_York
  - Time zone for notifications, scheduling
  - User-managed (self-service)
  - Required: No
```

### Security and Compliance Attributes

**Used for access control and compliance:**

```
Security Clearance: Top Secret
  - Clearance level (if applicable)
  - Used for: Access to classified systems
  - Values: ["None", "Secret", "Top Secret"]
  - Source: Security team (manual assignment)
  - Required: Only if applicable

Data Classification: Level 2
  - Max data sensitivity user can access
  - Used for: DLP, access control
  - Values: ["1-Public", "2-Internal", "3-Confidential", "4-Secret"]
  - Source: Manager approval, compliance team
  - Required: Yes

Compliance Status: Trained
  - Compliance status (training completion)
  - Used for: Conditional access enforcement
  - Values: ["Trained", "Not-Trained", "Expired"]
  - Source: Learning management system
  - Required: Yes
```

## Attribute Schema Design

### Define Standard Schema

**Standardized attributes across organization:**

```yaml
UserAttributeSchema:
  CoreIdentity:
    - Email (unique, required)
    - DisplayName (required)
    - GivenName (required)
    - Surname (required)
    
  Organization:
    - Department (required, from HR)
    - JobTitle (required, from HR)
    - Manager (required, from HR)
    - CostCenter (required, from HR)
    - DirectReports (calculated)
    
  Location:
    - OfficeLocation (required, from HR)
    - Country (required, from HR)
    - TimeZone (optional, user-set)
    
  Security:
    - SecurityClearance (if applicable)
    - MaxDataClassification (required)
    - ComplianceStatus (required)
    
  UserManaged:
    - Phone (optional)
    - MobilePhone (optional)
    - Address (optional)
    - PreferredLanguage (optional)
```

### Mapping Between Systems

**How attributes map from source to destination:**

```
HR System → Azure AD → Applications

HR: Department = "Sales"
  ↓ (Azure AD Cloud Sync)
AD: Department = "Sales", OU = "cn=Sales,ou=Users..."
  ↓ (SCIM sync)
Salesforce: Department = "Sales" (same field)
  ↓
Application rule: If Department="Sales", grant SalesforceAccess role
```

## Attribute Governance

### Ownership and Authority

**Each attribute has an owner:**

```
Attribute: Department
  Owner: HR (Human Resources)
  Authority: Final decision point (where truth lives)
  Who can change: HR only, via system
  Who can view: All (non-sensitive)
  SLA: Update within 4 hours of HR change
  Audit: Tracked in HR system

Attribute: Manager
  Owner: HR
  Authority: HR system (from org chart)
  Who can change: HR only (org change)
  SLA: Update same day as org change
  Audit: Change logged in HR

Attribute: TimeZone
  Owner: User
  Authority: User self-service
  Who can change: User themselves
  Who can view: Applications needing time zone
  Audit: Not critical to log
```

### Lifecycle Management

**Process for attribute changes:**

```
Add New Attribute:
1. Business justification: Why is this attribute needed?
2. Schema design: What values? Required? Mutable?
3. Source mapping: Where does it come from?
4. Downstream impact: What systems use it?
5. Implementation: Add to schema, populate retroactively
6. Validation: Audit quality after 30 days

Deprecate Attribute:
1. Identify all uses (systems, policies, access rules)
2. Migrate systems to alternative attribute
3. Set deprecation date (60 days notice)
4. Remove from schema on deprecation date
5. Audit: Confirm no orphaned rules

Change Value (reference data):
1. Document change: "Sales" → "Commercial Sales"
2. Sync to all systems
3. Update access rules (if names in rules)
4. Communicate to stakeholders
5. Audit: Confirm propagation
```

## Using Attributes for Access Control

### ABAC Example: Database Access

**Grant access based on attributes:**

```
Policy: Finance users can access Finance database
Condition: user.department == "Finance"
Action: Grant access to FinanceDB

Implementation in SQL Server:
CREATE ROLE FinanceDB_Access
GRANT SELECT, INSERT, UPDATE ON FinanceDB TO FinanceDB_Access
EXEC sp_adduser 'john.smith@company.com'  -- IF department=Finance
```

### Attribute-Based Conditional Access (Azure AD)

**Require MFA based on attributes:**

```yaml
ConditionalAccessPolicy:
  Name: "MFA for high-risk users"
  Conditions:
    Users:
      - Include: All
      - Exclude: (none)
    Apps: All cloud apps
    Risk:
      UserRisk: High
  Grant:
    - Require MFA
    
# OR attribute-based

ConditionalAccessPolicy:
  Name: "Block low-security users"
  Conditions:
    Users:
      - Include: (users where complianceStatus != "Trained")
    Apps: Sensitive applications
  Grant:
    - Block access
    - Message: "Please complete compliance training"
```

## Attribute Quality Monitoring

### Metrics

```
Completeness:
  Department: 99.5% (target: 100%)
  Manager: 98% (target: 100%, <1% for executives is OK)
  Email: 100% ✓
  
Accuracy:
  Department valid values: 98% (some misspellings)
  Manager exists: 99% (some invalid manager references)
  
Timeliness:
  Department update SLA: 4 hours
  Average update: 2.5 hours ✓
  % within SLA: 95% (target: 99%)
```

### Audit Query (KQL)

```kql
let ValidDepartments = datatable(dept:string) [
  "Sales", "Engineering", "Finance", "Operations", "HR"
];

Users
| where department not in (ValidDepartments)
| project UserEmail, CurrentDept = department, Issue = "Invalid department"
```

## Best Practices

1. **Standardize** - Consistent naming and values across organization
2. **Centralize** - Single source for each attribute
3. **Document** - Clear schema, ownership, governance
4. **Validate** - Enforce valid values at entry point
5. **Audit** - Track all changes, who changed what
6. **Align** - Map attributes consistently across systems
7. **Govern** - Clear process for adds, changes, deprecations
8. **Monitor** - Quality metrics and alerts
9. **Educate** - Train admins on attribute standards
10. **Automate** - Sync from source, don't manual entry

## Related Documents

**Prerequisites:**
- [Data Quality](./16-data-quality-management.md) - Quality dimensions
- [RBAC](./03-role-based-access-control.md) - Access control using attributes

**Next Steps:**
- [Fine-Grained Authorization](./13-fine-grained-authorization.md) - ABAC using attributes
- [Conditional Access](./08-identity-risk-detection.md) - CA policies using attributes

## FAQ

**Q: Should we create custom attributes?**

A: Use standard attributes first. Create custom only if standard doesn't fit and widely needed.

**Q: Can users modify their own attributes?**

A: Self-service for non-critical (phone, time zone). Read-only for HR-sourced (department, manager).

**Q: What if an attribute is stale?**

A: If source-controlled (HR): Fix in HR, resync. If user-managed: Send reminder to update.

## Next Steps

1. Design attribute schema
2. Define ownership for each attribute
3. Implement in Azure AD
4. Synchronize from HR
5. Document governance process
6. Monitor quality metrics
7. Use attributes for access control rules

Standardized attributes enable both data quality and sophisticated access control.
