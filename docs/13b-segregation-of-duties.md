---
title: Segregation of Duties - Conflict of Interest Prevention
part: 5
section: Advanced Authorization
difficulty: Advanced
estimated_reading_time: 35
estimated_lab_time: N/A
prerequisites:
  - 04-privileged-access-management.md
  - 13a-policy-based-access-control.md
learning_objectives:
  - Understand segregation of duties (SoD) concepts
  - Identify SoD conflicts
  - Design SoD policies
  - Implement SoD controls in identity systems
  - Audit SoD compliance
---

# Segregation of Duties: Conflict of Interest Prevention

## Introduction

Fraud often requires multiple steps: initiate purchase order, approve purchase order, receive goods, approve invoice. If the same person performs all steps, they can commit fraud undetected. Segregation of Duties (SoD) prevents this by requiring multiple people: one person initiates, another approves, another reconciles. This document explains SoD concepts, common conflicts, implementation patterns, and compliance requirements.

**Learning Objectives:**
- Understand segregation of duties principles
- Identify and map SoD conflicts
- Design SoD policies in identity systems
- Implement SoD controls
- Audit and enforce SoD compliance

## SoD Core Principle

**Incompatible duties:** No single user should have both permissions if together they enable fraud or error

**Examples:**
- User cannot both initiate and approve transactions
- User cannot both reconcile accounts and approve payments
- User cannot both create users and assign permissions
- User cannot both authorize purchases and receive goods

## Classic SoD Conflicts

### Finance and Accounting

| Conflict | Why | SoD Control |
|----------|-----|-----------|
| Create AND Approve invoice | Can approve own invoices | Separate roles |
| Post journal entry AND Reconcile | Can hide adjustments | Separate users |
| Approve payment AND Receive goods | Can approve fraudulent payments | Separate approval chain |
| Access master files AND Perform transactions | Can manipulate accounts | Separate access |
| Reconcile AND Post adjustments | Can hide discrepancies | Independent review |

### IT and Systems

| Conflict | Why | SoD Control |
|----------|-----|-----------|
| Create user AND Grant permissions | Can create admin without oversight | Approval workflow |
| Deploy code AND Approve change | Can deploy without review | Code review required |
| Access production AND Modify configuration | Can change without audit trail | Separate responsibilities |
| Modify audit logs AND Perform actions | Can cover up unauthorized actions | Immutable logs |
| Generate report AND Access data | Can selectively exclude data | Independent reporting |

### Procurement

| Conflict | Why | SoD Control |
|----------|-----|-----------|
| Create PO AND Receive goods | Can order without authorization | Purchase approval |
| Approve PO AND Receive goods | Can approve then receive own shipment | Independent receiving |
| Approve AND Pay invoices | Can pay fraudulent invoices | Three-way match |
| Select vendor AND Approve purchase | Can favor specific vendor | Competitive bidding |
| Negotiate AND Execute contract | Can negotiate hidden terms | Legal review |

## SoD Implementation Approaches

### Approach 1: Role-Based SoD

**Define incompatible role pairs:**

```yaml
Incompatible Roles:
  - [AccountsPayable_Approver, AccountsPayable_Clerk]
  - [Auditor, Finance]
  - [SecurityAdmin, ApplicationDeveloper]
  - [CodeReviewer, CodeMerger]
```

**Rule:** User cannot hold both roles

**Implementation:**
```
Identity system: If user has Role A, prevent assignment of Role B
```

### Approach 2: Function-Based SoD

**Define incompatible functions:**

```yaml
Incompatible Functions:
  - ["CreateUser", "GrantPermission"]
  - ["ApprovePayment", "ReceiveGoods"]
  - ["DeployCode", "ApproveDeployment"]
  - ["ReconcileAccounts", "PostAdjustment"]
```

**Rule:** User cannot perform both functions

**Implementation:**
```javascript
function checkSoDCompliance(user, action) {
  const incompatibilityMatrix = {
    "CreateUser": ["GrantPermission", "DeleteUser"],
    "ApprovePayment": ["ReceiveGoods", "SelectVendor"],
    "DeployCode": ["ApproveDeployment", "ModifyAuditLogs"]
  };
  
  const userFunctions = getUserFunctions(user);
  const blocked = incompatibilityMatrix[action] || [];
  
  for (let fn of blocked) {
    if (userFunctions.includes(fn)) {
      return { allow: false, reason: `Conflict: ${action} incompatible with ${fn}` };
    }
  }
  
  return { allow: true };
}
```

### Approach 3: Transaction-Based SoD

**Control within single transaction:**

```yaml
Purchase Order Approval Flow:
  Step 1: Initiator (any user) - Create PO
  Step 2: Manager (requester's manager) - Approve amount
  Step 3: Procurement (different from initiator/approver) - Order
  Step 4: Receiver (different from step 3) - Receive goods
  Step 5: Accountant (different from approver) - Process invoice
  Step 6: Finance Manager (different from accountant) - Final approval
```

**Implementation:**
```yaml
Workflow:
  - Step: CreatePO
    Actor: Requester
    Next: ApprovePO
    
  - Step: ApprovePO
    Actor: [Manager, NOT Requester]
    Next: ProcessOrder
    
  - Step: ProcessOrder
    Actor: [Procurement, NOT ApprovalActor]
    Next: ReceiveGoods
    
  - Step: ReceiveGoods
    Actor: [Receiver, NOT ApprovalActor, NOT ProcurementActor]
    Next: ProcessInvoice
```

### Approach 4: Compensating Controls

**When SoD not possible, add monitoring:**

```yaml
SoD Conflict: System Administrator can modify audit logs
  Problem: Can hide unauthorized actions
  Compensating Control: Centralized immutable audit log
                        Real-time alerting on log access
                        Monthly external audit
                        Segregated audit log system
```

## SoD Policy Examples

### Finance SoD Policy

```rego
package accounting

# User cannot both create and approve invoices
deny {
  input.user.functions contains "CreateInvoice"
  input.user.functions contains "ApproveInvoice"
  input.action == "ApproveInvoice"
}

# User cannot reconcile and post adjustments
deny {
  input.user.functions contains "ReconcileAccounts"
  input.user.functions contains "PostAdjustment"
  input.action == "PostAdjustment"
}

# Payment approver must differ from PO approver
deny {
  input.user.approvedPO == input.transaction.po_id
  input.action == "ApprovePayment"
}

# Auditor cannot access transaction systems
deny {
  input.user.role == "Auditor"
  input.resource.type == "FinancialTransaction"
  input.action in ["Create", "Modify", "Delete"]
}
```

### IT SoD Policy

```rego
package systems

# Cannot create user and grant admin role
deny {
  input.action == "GrantAdminRole"
  input.target_user.created_by == input.user.id
}

# Cannot review and merge own code
deny {
  input.action == "MergeCode"
  contains(input.reviewers, input.user.id)
}

# Cannot deploy and approve deployment
deny {
  input.user.deployments contains input.deployment.id
  input.action == "ApproveDeployment"
}

# Cannot modify audit logs
deny {
  input.user.role contains "SystemAdmin"
  input.action == "ModifyAuditLog"
}
```

## SoD Conflict Matrix

**Build authorization matrix showing incompatible roles:**

|  | Approver | Clerk | Auditor | Treasurer | Admin |
|---|----------|-------|---------|-----------|-------|
| **Approver** | ✓ | ✗ | ✗ | ✗ | ✗ |
| **Clerk** | ✗ | ✓ | ✗ | ✗ | ✗ |
| **Auditor** | ✗ | ✗ | ✓ | ✗ | ✗ |
| **Treasurer** | ✗ | ✗ | ✗ | ✓ | ✗ |
| **Admin** | ✗ | ✗ | ✗ | ✗ | ✓ |

**Legend:**
- ✓ = Can be held together
- ✗ = Conflict, cannot be held together

## SoD Compliance and Auditing

### SoD Audit Queries

**Find role conflicts (KQL):**
```kql
let incompatible_roles = datatable(role1:string, role2:string)
[
  "ApprovalAdmin", "TransactionClerk",
  "Auditor", "Finance",
  "SecurityAdmin", "Developer"
];

IdentityRoleAssignments
| mv-expand role = Roles
| join kind=inner (
    IdentityRoleAssignments
    | mv-expand role = Roles
  ) on UserId
| where ((role1 == role and role == role2) or (role1 == role and role == role2))
| project UserId, ConflictingRoles = strcat(role, ", ", role)
| distinct UserId, ConflictingRoles
```

**Find transaction conflicts (KQL):**
```kql
let po_approvals = ProcurementTransactions
| where TransactionType == "PO_Approval"
| project ApprovedBy, POId;

let invoice_payments = ProcurementTransactions
| where TransactionType == "Invoice_Payment"
| project ApprovedBy, POId;

po_approvals
| join kind=inner invoice_payments on POId
| where ApprovedBy1 == ApprovedBy
| project POId, Person = ApprovedBy, ConflictMessage = "Approved PO and Payment"
```

### SoD Remediation

**Process:**
1. **Identify conflicts** - Audit active role assignments and recent transactions
2. **Assess risk** - Is each conflict actually problematic?
3. **Remediate** - Remove one role or add compensating control
4. **Document** - Record decision and control

**Example:**
```
Conflict Found: User Jane holds both "AccountsPayable_Approver" and "AccountsPayable_Clerk"
Risk: Jane can approve own invoices

Remediation Options:
  A) Remove "Clerk" role (reduces automation)
  B) Add independent audit of Jane's approvals (compensating control)
  C) Move Jane to one functional area

Decision: Option B (quarterly audit of Jane's approvals)
Control: Monthly exception report of Jane's approvals reviewed by CFO
Responsibility: CFO reviews third Friday of month
Effective: 2024-04-01
```

## SoD in Compliance Frameworks

### HIPAA SoD Requirements
- Segregation of user and system administrator roles
- Separation of duties for access approval
- Audit trail protection

### PCI DSS SoD Requirements
- Separate users for different duties
- Multiple people for authorization
- Segregation of developer, tester, admin roles

### SOC 2 SoD Requirements
- Design policies preventing fraud
- Multiple approval authorities
- Segregation of incompatible functions

### ISO 27001 SoD Requirements
- Segregation of duties in security-relevant functions
- Dual control where appropriate
- Supervisory controls

## Technology Support for SoD

### IAM System Capabilities

**Native support:**
- Azure AD: Role incompatibility rules
- Okta: Conflict of Interest reports
- SAP IDM: SoD conflict detection
- Deloitte Cloud IAM: Policy-based SoD

**Third-party SoD platforms:**
- Certent (Formerly Deloitte)
- SailPoint (IdentityGovernance)
- Oracle Identity Management
- IBM Identity Governance

### SoD Reporting

**Standard reports:**
1. **Role Conflict Report** - Users with incompatible roles
2. **Transaction Conflict Report** - Same user with conflicting functions in recent transactions
3. **Exception Report** - Approved SoD exceptions and compensating controls
4. **Remediation Status** - Outstanding conflicts and resolution plans

## Best Practices

1. **Map Your Conflicts** - Document all incompatible function pairs
2. **Start with Finance** - Finance has clearest SoD needs (PCI/SOX required)
3. **Build Incrementally** - Implement high-risk conflicts first
4. **Automate Detection** - Continuous monitoring for violations
5. **Enable Exceptions** - Legitimate exceptions with approval and compensating controls
6. **Document Controls** - Maintain clear policies and control specifications
7. **Audit Regularly** - Quarterly SoD compliance reviews
8. **Train Staff** - Staff understand why SoD matters and their role
9. **Monitor Compensating Controls** - Verify compensating controls are actually working
10. **Incident Response** - Clear process when conflict detected

## FAQ

**Q: Can a user ever hold two incompatible roles?**

A: Rarely, only with executive approval and strong compensating controls. Document why exception approved.

**Q: How often should we audit SoD?**

A: Continuously if possible (real-time alerting). Minimum quarterly audit, monthly for high-risk areas.

**Q: What if our business model requires conflicting duties?**

A: Implement compensating controls (independent monitoring, real-time alerting, immutable audit logs, bonding/insurance).

**Q: How do we handle temporary conflicts (vacation, emergency)?**

A: Approve temporary delegation, set expiration date, require secondary review of all actions, document incident.

**Q: Do service accounts need SoD controls?**

A: Yes. Service accounts can commit fraud. Apply same principles to service-to-service access.

## Next Steps

1. Identify high-risk business processes requiring SoD
2. Map incompatible functions for each process
3. Build SoD conflict matrix for your organization
4. Implement in IAM system with automated detection
5. Audit for existing conflicts, remediate
6. Establish ongoing SoD compliance monitoring
7. Document SoD governance process
8. Train staff on SoD responsibilities

Segregation of duties prevents fraud and errors. Built SoD early into your access control design.
