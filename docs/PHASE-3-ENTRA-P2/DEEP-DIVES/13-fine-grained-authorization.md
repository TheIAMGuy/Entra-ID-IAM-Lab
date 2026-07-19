---
title: Fine-Grained Authorization - Resource-Level Access Control
part: 5
section: Advanced Authorization
difficulty: Advanced
estimated_reading_time: 40
estimated_lab_time: 60
prerequisites:
  - 03-role-based-access-control.md
  - 04-privileged-access-management.md
learning_objectives:
  - Understand fine-grained authorization (FGA) concepts
  - Implement resource-level access control
  - Use attribute-based access control (ABAC)
  - Design authorization policies
  - Understand FGA tools and approaches
---

# Fine-Grained Authorization: Resource-Level Access Control

## Introduction

Role-based access control (RBAC) is too coarse for many scenarios. A marketing manager can access all marketing files, but should access only their campaigns, not competitors' campaigns. Fine-grained authorization (FGA) enables permission at resource-level: "User can access only documents they created" or "User can access projects their team owns." This document explains FGA concepts, patterns, and implementation approaches.

**Learning Objectives:**
- Understand fine-grained authorization concepts
- Implement resource-level access control
- Use attribute-based access control (ABAC)
- Design FGA policies
- Compare FGA approaches and tools

## FGA Concepts

### RBAC Limitations

**RBAC (role-based):**
```
User → Role: "Analyst"
Role → Permissions: Read Reports, Write Reports
Result: User can read AND write ALL reports
```

**Problem:** Can't restrict user to specific reports.

### ABAC (Attribute-Based Access Control)

**ABAC (attribute-based):**
```
User → Attributes: team=Finance, role=Analyst, level=3
Resource → Attributes: owner=Finance, classification=Public
Policy: "If user.team == resource.owner, grant access"
Result: User can access only Finance resources
```

**Advantages:**
- More flexible than RBAC
- Scale to thousands of resources
- Reduce policy management overhead
- Support complex scenarios

### FGA Patterns

**Pattern 1: Owner-Based Access**
```
User can access resources they own
Example: "John can access documents John created"
Implementation: Check user.id == resource.owner_id
```

**Pattern 2: Team-Based Access**
```
User can access resources their team owns
Example: "Finance team can access Finance documents"
Implementation: Check user.team == resource.team
```

**Pattern 3: Hierarchy-Based Access**
```
Manager can access team member's resources
Example: "John's manager can access John's files"
Implementation: Check user.id == resource.owner_manager
```

**Pattern 4: Classification-Based Access**
```
Access determined by data sensitivity level
Example: "Level 3 analyst can access Level 1-3 docs"
Implementation: Check user.level >= resource.sensitivity_level
```

## ABAC Implementation Approaches

### Approach 1: Application-Level ABAC

**Logic in application code:**

```javascript
// Express.js middleware
async function checkAccess(req, res, next) {
  const resource = await getResource(req.params.id);
  const user = req.user;

  // Check ownership
  if (resource.owner_id === user.id) {
    return next(); // Allowed
  }

  // Check team
  if (resource.team_id === user.team_id) {
    return next(); // Allowed
  }

  // Check hierarchy (user is owner's manager)
  if (user.id === resource.owner.manager_id) {
    return next(); // Allowed
  }

  res.status(403).json({ error: 'Insufficient permissions' });
}
```

**Advantages:** Flexible, specific to app logic
**Disadvantages:** Distributed policy logic, hard to audit, not reusable

### Approach 2: Policy Engine (Centralized)

**Third-party FGA engine (Warrant, Osso, Auth0 FGA):**

```
Application asks policy engine:
"Can user 123 read document 456?"

Policy Engine evaluates:
- User attributes (team, level, role)
- Resource attributes (owner, team, classification)
- Policies (rules like "owner can read own resources")

Response: "Yes" or "No"
```

**Advantages:** Centralized, auditable, reusable across apps
**Disadvantages:** External dependency, latency, cost

### Approach 3: Azure Attribute-Based Access Control (ABAC)

**Azure RBAC + conditions:**

```
Role: "Virtual Machine Contributor"
+ Condition: "If resource.location == user.location AND
             resource.environment == user.authorized_environment"
Result: User can only manage VMs in their location/env
```

**Configuration:**

```
1. Create custom role
2. Add conditions:
   - If resource.microsoft.aad_group[...] contains user.id
   - If resource.microsoft.aad_principal[...] contains user.groupId
   - If resource.environment matches user.authorized_envs
3. Assign to user
4. Azure enforces conditions at access time
```

## Designing FGA Policies

**Policy Design Process:**

1. **Identify Resources:**
   - Documents, files, projects, users, data

2. **Identify Relationships:**
   - Ownership, team membership, hierarchy
   - Shared resources, delegated access

3. **Define Access Rules:**
   - Owner can do X
   - Team member can do Y
   - Manager can do Z

4. **Model as Attributes:**
   - User: owner_id, team_id, manager_id, role, level
   - Resource: owner_id, team_id, classification, environment

5. **Implement Policies:**
   - Code, policy engine, or Azure ABAC
   - Test with edge cases

## Hands-On Lab: Implementing ABAC

**Estimated Time:** 60 minutes

**Lab Objectives:**
- Design ABAC policy
- Implement attribute-based checks
- Test access control

### Step 1: Define Resource Attributes (10 minutes)

Create sample resource:

```json
{
  "id": "doc-123",
  "title": "Q3 Financial Report",
  "owner_id": "user-456",
  "team": "Finance",
  "classification": "Internal",
  "shared_with": ["user-789"],
  "created_at": "2024-01-15"
}
```

### Step 2: Define User Attributes (10 minutes)

Create sample users:

```json
User 1: owner
{
  "id": "user-456",
  "name": "John",
  "team": "Finance",
  "role": "Analyst",
  "level": 3,
  "manager_id": null
}

User 2: team member
{
  "id": "user-789",
  "name": "Jane",
  "team": "Finance",
  "role": "Analyst",
  "level": 2,
  "manager_id": "user-456"
}

User 3: other team
{
  "id": "user-999",
  "name": "Bob",
  "team": "Marketing",
  "role": "Manager",
  "level": 3,
  "manager_id": null
}
```

### Step 3: Define Policies (15 minutes)

```
Rule 1: Owner can read/write own resources
  Condition: user.id == resource.owner_id
  Action: Allow read, write

Rule 2: Team member can read team resources
  Condition: user.team == resource.team AND
             resource.classification != "Secret"
  Action: Allow read

Rule 3: Manager can read/write team member resources
  Condition: user.id == resource.owner.manager_id
  Action: Allow read, write

Rule 4: Explicitly shared users can read
  Condition: user.id in resource.shared_with
  Action: Allow read
```

### Step 4: Implement Access Control (15 minutes)

```javascript
function canAccess(user, resource, action) {
  // Rule 1: Owner
  if (user.id === resource.owner_id &&
      (action === 'read' || action === 'write')) {
    return true;
  }

  // Rule 2: Team member
  if (user.team === resource.team &&
      resource.classification !== 'Secret' &&
      action === 'read') {
    return true;
  }

  // Rule 3: Manager
  const owner = getUser(resource.owner_id);
  if (user.id === owner.manager_id &&
      (action === 'read' || action === 'write')) {
    return true;
  }

  // Rule 4: Explicitly shared
  if (resource.shared_with.includes(user.id) &&
      action === 'read') {
    return true;
  }

  return false;
}

// Test
console.log(canAccess(user1, doc123, 'read'));   // true (owner)
console.log(canAccess(user2, doc123, 'read'));   // true (team member)
console.log(canAccess(user2, doc123, 'write'));  // false (not owner/manager)
console.log(canAccess(user3, doc123, 'read'));   // false (different team)
```

### Step 5: Test Edge Cases (10 minutes)

```
☐ Owner reads own resource
☐ Team member reads team resource
☐ Manager reads subordinate's resource
☐ Explicitly shared user reads resource
☐ User from different team can't read
☐ Non-owner can't write resource
```

## FGA Tools and Services

| Tool | Approach | Best For |
|------|----------|----------|
| **Warrant** | Policy engine | Any app, any language |
| **Auth0 FGA** | Policy engine | Auth0 users |
| **Google Zanzibar** | Graph-based | Complex relationships |
| **Azure ABAC** | Conditions | Azure resources |
| **Custom Code** | Application-level | Simple rules, specific app |

## Compliance & Standards

**Standards Supporting FGA:**
- **ABAC in NIST 800-62-3:** Recommended for complex authorization
- **Attribute-Based Access in ISO 27001:** Supported
- **Zero Trust:** FGA is core component

## FAQ

**Q: When should we use FGA vs. RBAC?**

A: RBAC for organizational hierarchy. FGA for resource-specific access. Use both together.

**Q: Is FGA slower than RBAC?**

A: FGA requires more checks but modern systems handle it. Cache decisions when possible.

**Q: Should FGA logic be in app or centralized?**

A: Centralized (policy engine) scales better. Application logic works for simple rules.

## Next Steps

1. Map resource-access relationships
2. Design ABAC policies
3. Choose implementation approach
4. Test access control thoroughly
5. Monitor for unauthorized access

Fine-grained authorization unlocks powerful, scalable access control.
