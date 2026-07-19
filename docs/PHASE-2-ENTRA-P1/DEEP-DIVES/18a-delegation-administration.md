---
title: Delegation Administration - Manager Self-Service and Authority Delegation
part: 9
section: Operations & Administration
difficulty: Intermediate
estimated_reading_time: 25
estimated_lab_time: 30
prerequisites:
  - 03-role-based-access-control.md
  - 18-self-service-portal.md
learning_objectives:
  - Understand delegation concepts
  - Implement manager approval workflows
  - Configure delegated administration
  - Manage delegation scopes and limits
  - Monitor delegation activities
---

# Delegation Administration: Manager Self-Service and Authority Delegation

## Introduction

Delegation transfers authority from central IT to distributed administrators. Instead of IT approving all access requests, managers approve for their teams. Instead of IT resetting all passwords, users reset themselves. Delegation scales identity management: with 5,000 users, 50 managers approving requests scales better than 5 IT admins. This document explains delegation concepts, patterns, and implementation.

**Learning Objectives:**
- Understand delegation models
- Implement manager approval workflows
- Configure delegated admin roles
- Manage delegation scope and limits
- Monitor and audit delegated actions

## Delegation Models

### Model 1: Manager Approvals

**Manager approves team member requests:**

```
Access Request Flow:
  Employee requests access
    ↓
  System routes to manager
    ↓
  Manager reviews and approves/denies
    ↓
  Automatic provisioning on approval
```

**Process:**

```
1. John (employee) requests access to database
2. System finds John's manager (Mary)
3. Mary gets notification: "John requested database access"
4. Mary reviews: "Does John need database access for his job?"
5. Mary clicks "Approve"
6. System auto-provisions access
7. John notified: "Access approved, available now"

Benefits:
  ✓ Manager knows job requirements best
  ✓ Faster approval (manager responds in 1 hour vs. IT in 3 days)
  ✓ IT doesn't become bottleneck
```

### Model 2: Group Owners

**Application owner approves group membership requests:**

```
Group: Finance-Reports (access to finance dashboards)
Owner: Finance Director (John Smith)

Request flow:
  User requests to join group
    ↓
  Group owner (John) approves
    ↓
  User added to group
    ↓
  Automatic access granted
```

**Scenario:**

```
Employee: "I need finance report access for my new project"
System: Routes to group owner (Finance Director John Smith)
John: Reviews request, approves (knows if legitimate)
System: Adds employee to group, access granted
```

### Model 3: Delegated Admin Roles

**Manager can perform admin tasks for their team:**

```
Manager Role: Team Admin
Permissions:
  ✓ Reset password for team members
  ✓ Unlock accounts
  ✓ Manage group membership
  ✗ Cannot modify manager field (prevent privilege escalation)
  ✗ Cannot grant admin role
  ✗ Cannot view salaries
```

**Implementation:**

```
Azure AD role: User Administrator (delegated to managers)
Scope: Limited to direct reports only
Can do: Reset password, update profile (except sensitive fields)
Cannot do: Grant admin roles, modify HR data
```

## Manager Approval Workflows

### Workflow: Access Request Approval

**End-to-end manager approval:**

```
Day 1, 9:00 AM:
  Employee John submits access request
  System: "Need Finance Database for Q1 closing"
  Manager: Mary receives email: "John requesting access"

Day 1, 2:00 PM:
  Mary reviews: "Yes, John needs this for Q1"
  Mary clicks: Approve
  
Day 1, 2:05 PM:
  System: Provisions access (auto if policy allows)
  John: Email "Access approved, database login ready"
  IT: No involvement needed

Efficiency:
  Traditional: 3-5 days (IT ticket, approval, provisioning)
  Delegated: 5 hours (manager approves, auto-provisioning)
  Savings: 2-3 days faster
```

### Implementation: Approval Notification

**Manager receives clear request:**

```
Subject: Approve Access Request - John Smith requesting Database Access

From: Identity Management System
To: mary.johnson@company.com

John Smith (john.smith@company.com)
Department: Finance
Manager: Mary Johnson

Request: Access to Finance Database
Business Reason: "Q1 financial closing - need daily access to check balances"
Date Requested: 2024-01-15 09:30 AM
Requested By: Self-service portal

Approval Deadline: 2024-01-18 (3 days)

Actions:
[✓ Approve] [✗ Deny] [? Request More Info]

Optional: Add comment (e.g., "Remember to remove after Q1 closing")
```

### Escalation for Timeout

**If manager doesn't respond:**

```
Timeline:
  Day 1: Request created
  Day 3: No response, reminder sent
  Day 4: No response, escalate to manager's manager
  Day 5: No response from manager's manager, auto-deny with notification

Both: "Request timed out, please resubmit if still needed"
```

## Delegated Administration Roles

### Azure AD Delegated Roles

**Built-in roles for delegation:**

```
User Administrator (Delegated)
  Scope: Direct reports only
  Permissions:
    ✓ Reset passwords
    ✓ Unlock accounts
    ✓ Update phone, address
    ✗ Grant roles
    ✗ Modify email
    
Groups Administrator
  Scope: Specific groups (e.g., "Sales Group")
  Permissions:
    ✓ Add/remove group members
    ✓ Manage group settings
    ✗ Delete group
    ✗ Manage other groups
    
Application Administrator (Delegated)
  Scope: Specific applications
  Permissions:
    ✓ Grant app access
    ✓ Reset app credentials
    ✓ Configure app assignments
    ✗ Grant admin roles
    ✗ Change app owner
```

### Custom Delegated Role

**Build role with specific permissions:**

```yaml
Role: Team Manager - Limited Admin
Scope: Direct reports only
Permissions:
  - microsoft.directory/users/passwords/update
  - microsoft.directory/users/unlock/action
  - microsoft.directory/groupMembers/create
  - microsoft.directory/groupMembers/delete

Restrictions:
  - Cannot modify: email, department, manager, cost center
  - Cannot grant roles
  - Cannot access sensitive attributes
```

## Delegation Boundaries and Controls

### Scope Limitations

**Manager can only manage their own team:**

```
Mary Johnson (Sales Manager)
  Can manage: Sales team members (John, Jane, Bob)
  Cannot manage: Engineering team (different manager)
  Cannot manage: Finance team (different manager)

System prevents:
  ✗ Mary adding herself to admin group
  ✗ Mary resetting password for non-direct report
  ✗ Mary granting admin role to anyone
```

### Approval Limits

**Set approval thresholds:**

```
Policy: "Managers can approve low-risk access"
  Low-risk access: Read-only applications
  Medium-risk access: Write-access applications
  High-risk access: Admin access, production databases

Permissions:
  Manager: Can approve low-risk
  Director: Can approve medium-risk
  CISO: Must approve high-risk
```

## Delegation Monitoring

### Audit Trail

**Track all delegated actions:**

```
Audit Log Entry:
  Timestamp: 2024-01-15 14:30 UTC
  Delegated Admin: Mary Johnson (Sales Manager)
  Action: Reset password
  Target User: John Smith
  Scope: Direct report (authorized)
  Result: Success
  
Audit Entry:
  Timestamp: 2024-01-16 09:15 UTC
  Delegated Admin: Bob Lee (Engineering Manager)
  Action: Reset password
  Target User: Jane Doe
  Scope: NOT direct report (unauthorized attempt)
  Result: Blocked, security alert sent
```

### Monitoring Metrics

```
Monthly Delegation Report:
  Manager approvals processed: 450
  Approval time (avg): 4 hours
  Timeout rate: 2% (target: <5%)
  Denied requests: 5%
  
Delegated admin actions: 200
  - Password resets: 150
  - Account unlocks: 40
  - Group membership changes: 10
  
Violations detected: 1 (manager tried to grant admin role, blocked)
```

## Best Practices

1. **Clear Scope** - Define exactly what delegated admins can do
2. **Direct Reports** - Restrict to direct reports only (prevent lateral access)
3. **Audit Everything** - Log all delegated actions
4. **Training** - Managers understand policies and use portal
5. **Approval SLA** - Define response time requirement
6. **Escalation** - Clear path if manager doesn't respond
7. **Monitoring** - Alert on policy violations
8. **Rotation** - Periodically audit delegation appropriateness
9. **Revocation** - Remove delegation if manager leaves
10. **Self-Service** - Enable delegation, don't require IT involvement

## Hands-On Lab: Delegated Approval

**Estimated Time:** 30 minutes

**Prerequisites:** Azure AD tenant, 2 test users (manager + employee)

**Lab Objectives:**
- Create approval workflow
- Delegate manager approval authority
- Test approval flow
- Audit delegation logs

### Step 1: Create Test Users (5 min)

```bash
# Create manager user
az ad user create \
  --display-name "Mary Johnson" \
  --user-principal-name mary.johnson@company.onmicrosoft.com \
  --password-policy-password-history 3

# Create employee user
az ad user create \
  --display-name "John Smith" \
  --user-principal-name john.smith@company.onmicrosoft.com
```

### Step 2: Set Manager Relationship (5 min)

```bash
# Set John's manager to Mary
az ad user update \
  --id john.smith@company.onmicrosoft.com \
  --manager-id mary.johnson@company.onmicrosoft.com
```

### Step 3: Configure Approval Routing (10 min)

```
Access Management → Approval Settings
  Require approval for access requests: Yes
  Approval routing: Manager (from manager field)
  Approval timeout: 3 days
  Escalate to: Manager's manager
```

### Step 4: Test Flow (10 min)

**As employee (John):**
- Request access to application
- Submit through self-service portal

**As manager (Mary):**
- Check approval inbox
- Review request
- Approve/deny

**Verify:**
- If approved: John gets access
- If denied: John notified, request closed
```

## Related Documents

**Prerequisites:**
- [RBAC](./03-role-based-access-control.md) - Role-based structure
- [Self-Service Portal](./18-self-service-portal.md) - User portal

**Next Steps:**
- [Provisioning Automation](./18b-provisioning-automation.md) - Workflow automation
- [IGA Platforms](./17a-identity-governance-administration.md) - Advanced governance

## FAQ

**Q: How do we prevent abuse of delegated permissions?**

A: Audit all actions, alert on policy violations, periodically review delegation scope.

**Q: What if manager is unavailable (vacation)?**

A: Set delegation to manager's manager or secondary approver during absence.

**Q: Can we delegate to non-managers?**

A: Possible but risky. Recommend manager-only delegation for governance.

**Q: How do we revoke delegation?**

A: Remove from delegated admin role. Remove manager field from users.

## Next Steps

1. Identify suitable delegated admin roles
2. Train managers on responsibilities
3. Configure delegation scope and limits
4. Implement approval workflows
5. Monitor and audit delegated actions
6. Adjust based on feedback and metrics

Delegation scales identity management and improves user experience.
