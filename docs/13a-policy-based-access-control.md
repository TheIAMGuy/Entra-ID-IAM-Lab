---
title: Policy-Based Access Control - Advanced Authorization Rules
part: 5
section: Advanced Authorization
difficulty: Advanced
estimated_reading_time: 40
estimated_lab_time: 45
prerequisites:
  - 13-fine-grained-authorization.md
  - 04-privileged-access-management.md
learning_objectives:
  - Understand policy-based authorization concepts
  - Design authorization policies
  - Implement policy engines and evaluation
  - Configure context-aware policies
  - Manage policy versioning and conflicts
---

# Policy-Based Access Control: Advanced Authorization Rules

## Introduction

Fine-grained authorization (ABAC) allows rules like "owner can read documents." Policy-based access control (PBAC) extends this to complex, composable rules: "Team member can read non-secret documents created within last 90 days by their department." Policies express authorization as explicit, auditable business rules. Instead of "grant user role X," you define "if conditions A, B, C are met, grant action Y." This document explains policy design, evaluation engines, and implementation patterns.

**Learning Objectives:**
- Understand policy-based authorization concepts
- Design composable authorization policies
- Compare policy evaluation models
- Implement context-aware policies
- Manage policy conflicts and precedence

## Policy-Based vs. RBAC vs. ABAC

| Approach | Model | Example | Complexity | Auditability |
|----------|-------|---------|-----------|--------------|
| **RBAC** | Role → Permissions | "Editor role can edit files" | Low | Medium |
| **ABAC** | Attributes + Rules | "User dept=Finance can access Finance data" | Medium | High |
| **PBAC** | Explicit Policies | "If (user.dept=Finance AND document.owner_dept=Finance AND !document.secret) then allow read" | High | Very High |

## Policy Structure

### Basic Policy Anatomy

```yaml
Policy: "Analyst can read non-secret documents"
Target:
  User:
    - role: Analyst
  Resource:
    - type: Document
    - classification: !Secret
Action: Read
Effect: Allow
```

### Context-Aware Policy

```yaml
Policy: "Analyst can read documents during business hours"
Target:
  User:
    - role: Analyst
  Resource:
    - type: Document
    - classification: Internal
  Environment:
    - time: 09:00-17:00
    - day: Monday-Friday
    - network: Corporate
Action: Read
Effect: Allow
```

### Hierarchical Policy

```yaml
Policy: "Team members can access team resources"
Target:
  User:
    - team_id: ${ resource.team_id }
  Resource:
    - team_owned: true
Action: [Read, Write]
Effect: Allow
Condition: user.active == true AND resource.archived == false
```

## Policy Evaluation Models

### Model 1: Attribute-Based with Conditions

**Evaluation:** Check user attributes against resource attributes and conditions

```javascript
function evaluatePolicy(user, resource, action) {
  // Policy: "User can read document if they own it or are in owner's team"
  
  if (action === 'read') {
    if (user.id === resource.owner_id) {
      return { effect: 'Allow', reason: 'User owns document' };
    }
    
    if (user.team_id === resource.team_id && 
        resource.classification !== 'Secret') {
      return { effect: 'Allow', reason: 'User in team, not secret' };
    }
  }
  
  return { effect: 'Deny', reason: 'No matching policy' };
}
```

### Model 2: Graph-Based (Relationship-Based Access Control)

**Evaluation:** Use relationship graph (user roles, group membership, delegation)

```
Document → owner: Alice
Alice → manager: Bob
Bob → team: Finance
User Charlie → team: Finance

Policy: "If user is in document owner's team, grant read"
Query: Is Charlie in Finance? → Yes → Allow
```

### Model 3: Policy Engine (Centralized)

**Evaluation:** Submit request to policy engine, engine evaluates policies

```
Application: "Can user alice read document doc-123?"
  ↓
Policy Engine (Warrant, Zanzibar, Styra):
  1. Fetch policies for read on Document
  2. Fetch user attributes (alice)
  3. Fetch resource attributes (doc-123)
  4. Evaluate all policies in order
  5. Return: Allow or Deny with reason
  ↓
Application: Access control decision
```

## Policy Language Examples

### Rego (Open Policy Agent - OPA)

```rego
package documents

default allow = false

allow {
  input.user.id == input.document.owner_id
  input.action == "read"
}

allow {
  input.user.team_id == input.document.team_id
  input.document.classification != "Secret"
  input.action == "read"
}

allow {
  input.user.role == "Admin"
  input.action in ["read", "write", "delete"]
}
```

### Cedar (AWS Policy Language)

```cedar
permit (
  principal,
  action,
  resource
)
when {
  principal.id == resource.owner ||
  (principal.team == resource.team &&
   resource.classification != "Secret")
};
```

### XACML (eXtensible Access Control Markup Language)

```xml
<Policy PolicyId="doc_read_policy">
  <Target>
    <AnyOf>
      <AllOf>
        <Match MatchId="string-equal">
          <AttributeValue DataType="string">read</AttributeValue>
          <ActionAttributeDesignator AttributeId="action-id"/>
        </Match>
      </AllOf>
    </AnyOf>
  </Target>
  <Rule Effect="Allow">
    <Condition>
      <Apply FunctionId="string-equal">
        <Apply FunctionId="string-one-and-only">
          <SubjectAttributeDesignator AttributeId="user-id"/>
        </Apply>
        <Apply FunctionId="string-one-and-only">
          <ResourceAttributeDesignator AttributeId="owner-id"/>
        </Apply>
      </Apply>
    </Condition>
  </Rule>
</Policy>
```

## Policy Conflicts and Precedence

### Conflict Scenarios

**Policy A:** "Manager can edit team member's files"
**Policy B:** "Only file owner can edit files"
**Request:** Can manager edit subordinate's file?

### Resolution Strategies

**Strategy 1: Deny Wins (Default Deny)**
```
Evaluation: If ANY policy says Deny, final result is Deny
Result: Manager cannot edit (most secure)
```

**Strategy 2: Allow Wins**
```
Evaluation: If ANY policy says Allow, final result is Allow
Result: Manager can edit (most permissive)
```

**Strategy 3: First Match**
```
Evaluation: Evaluate policies in order, return first match
Result: Depends on policy order
```

**Strategy 4: Explicit Precedence**
```yaml
Policies:
  - id: secure-docs
    priority: 100
    effect: Deny
    condition: document.secret == true
  - id: manager-access
    priority: 50
    effect: Allow
    condition: user.role == manager
Result: Secure-docs (priority 100) evaluated first, Deny wins
```

## Context-Aware Policies

### Time-Based Access

```rego
package hr_payroll

allow {
  input.action == "read_payroll"
  input.user.role == "HR"
  hour := time.now_ns() / 1000000000 % 86400 / 3600
  hour >= 9
  hour < 17
  day := time.now_ns() / 1000000000 % 604800 / 86400
  day >= 0
  day < 5  # Monday-Friday
}
```

### Network-Based Access

```rego
package sensitive_data

allow {
  input.action == "read_financial"
  input.user.role == "Finance"
  input.network.ip_range in ["192.168.1.0/24", "10.0.0.0/8"]
}
```

### Device-Based Access

```rego
package mobile_app

allow {
  input.action == "read"
  input.user.role == "Analyst"
  input.device.is_managed == true
  input.device.os in ["ios", "android"]
  input.device.os_version >= "14.0"
}
```

### Geographic Access

```rego
package geo_restricted

allow {
  input.action == "read_eu_data"
  input.user.region == "EU"
  input.location.country in ["DE", "FR", "IT", "ES", "NL"]
}

deny {
  input.action == "read_eu_data"
  input.location.country not in ["DE", "FR", "IT", "ES", "NL"]
}
```

## Policy Implementation Example

### Scenario: Document Access Control

**Requirements:**
1. Document owner can always read/write
2. Team members can read non-secret documents
3. Executives can read all documents
4. No one can edit secret documents
5. Edits require "during business hours" condition

**Policy Design:**

```yaml
policies:
  - id: "owner-full-access"
    target:
      action: ["read", "write", "delete"]
      principal: ${resource.owner_id}
    effect: "Allow"
    
  - id: "team-read-non-secret"
    target:
      action: ["read"]
      principal:
        team_id: ${resource.team_id}
      resource:
        classification: "!Secret"
    effect: "Allow"
    
  - id: "executive-read-all"
    target:
      action: ["read"]
      principal:
        role: "Executive"
    effect: "Allow"
    
  - id: "block-secret-edits"
    target:
      action: ["write", "delete"]
      resource:
        classification: "Secret"
    effect: "Deny"
    priority: 100  # Highest priority
    
  - id: "business-hours-only-edits"
    target:
      action: ["write"]
      condition:
        time:
          start: "09:00"
          end: "17:00"
          days: ["Mon", "Tue", "Wed", "Thu", "Fri"]
    effect: "Allow"
```

## Policy Tools and Engines

| Tool | Language | Best For | Deployment |
|------|----------|----------|-----------|
| **Open Policy Agent (OPA)** | Rego | Any app, microservices | Sidecar, external |
| **Cedar** | Cedar | AWS services, applications | Library, external |
| **Zanzibar (inspired)** | Custom | Relationship-based | Enterprise scale |
| **Warrant** | Policy as Code | App authorization | SaaS |
| **Styra** | Rego (OPA-based) | Kubernetes, microservices | Kubernetes operator |
| **AWS IAM** | JSON | AWS resources | Native |
| **Azure RBAC + ABAC** | Conditions | Azure resources | Native |

## Hands-On Lab: Policy Engine (OPA)

**Estimated Time:** 45 minutes

**Prerequisites:** Docker, curl

**Lab Objectives:**
- Set up Open Policy Agent
- Define document access policies
- Query policy engine with requests
- Test policy evaluation

### Step 1: Install and Start OPA (10 minutes)

```bash
# Pull OPA Docker image
docker pull openpolicyagent/opa:latest

# Run OPA server
docker run -p 8181:8181 openpolicyagent/opa:latest run --server

# Verify (in another terminal)
curl http://localhost:8181/health
```

### Step 2: Define Policies (10 minutes)

Create `document_policy.rego`:

```rego
package documents

default allow = false

# Owner always allowed
allow {
  input.user.id == input.document.owner_id
}

# Team members can read non-secret
allow {
  input.action == "read"
  input.user.team_id == input.document.team_id
  input.document.classification != "Secret"
}

# Executives can read all
allow {
  input.action == "read"
  input.user.role == "Executive"
}

# No one edits secret documents
deny {
  input.action == "write"
  input.document.classification == "Secret"
}
```

### Step 3: Load Policy (5 minutes)

```bash
curl -X PUT \
  http://localhost:8181/v1/policies/document_policy \
  -H "Content-Type: text/plain" \
  -d @document_policy.rego
```

### Step 4: Test Queries (15 minutes)

**Test 1: Owner access**
```bash
curl -X POST \
  http://localhost:8181/v1/data/documents/allow \
  -H "Content-Type: application/json" \
  -d '{
    "user": {"id": "alice", "role": "Analyst", "team_id": "finance"},
    "document": {"owner_id": "alice", "classification": "Public"},
    "action": "read"
  }'
# Result: true
```

**Test 2: Team member read non-secret**
```bash
curl -X POST \
  http://localhost:8181/v1/data/documents/allow \
  -d '{
    "user": {"id": "bob", "role": "Analyst", "team_id": "finance"},
    "document": {"owner_id": "alice", "classification": "Internal", "team_id": "finance"},
    "action": "read"
  }'
# Result: true
```

**Test 3: Block secret edit**
```bash
curl -X POST \
  http://localhost:8181/v1/data/documents \
  -d '{
    "user": {"id": "alice", "role": "Executive"},
    "document": {"owner_id": "alice", "classification": "Secret"},
    "action": "write"
  }'
# Result: {"allow": false, "deny": true}
```

## Best Practices

1. **Start Simple** - Begin with RBAC, add attributes incrementally
2. **Policy as Code** - Version control, code review, deployment pipeline
3. **Clear Precedence** - Document explicit conflict resolution
4. **Testable** - Unit test policies with representative cases
5. **Auditable** - Log all policy evaluations with reasoning
6. **Performance** - Cache policy evaluation results
7. **Versioning** - Version policies, migrate slowly
8. **Context Rich** - Include all relevant context (user, resource, environment, time)

## Compliance & Standards

**Policy-Based Control and Compliance:**
- **Zero Trust:** Policies enforce per-request authentication/authorization
- **Least Privilege:** Policies grant minimum required permissions
- **Audit Trail:** All policy decisions logged
- **NIST:** ABAC recommended for complex authorization

## Related Documents

**Prerequisites:**
- [Fine-Grained Authorization](./13-fine-grained-authorization.md) - ABAC concepts
- [Privileged Access Management](./04-privileged-access-management.md) - Privileged policies

**Next Steps:**
- [Segregation of Duties](./13b-segregation-of-duties.md) - Conflict of interest prevention
- [Identity Governance](./17a-identity-governance-administration.md) - Policy compliance

## FAQ

**Q: When should we use policy-based vs. RBAC?**

A: RBAC for organizational hierarchy (simple). PBAC for resource-specific access (complex). Often use both.

**Q: What's the performance impact of policy evaluation?**

A: Depends on complexity. Simple policies: <10ms. Complex: 50-500ms. Cache decisions where possible.

**Q: Can we change policies without redeploying?**

A: Yes. Load policies dynamically. Change takes effect immediately (no app restart).

**Q: How do we prevent policy conflicts?**

A: Test suite, versioning, explicit precedence, approval process for policy changes.

## Next Steps

1. Identify authorization scenarios that RBAC can't handle
2. Document business rules as policies
3. Choose policy language (Rego, Cedar, custom)
4. Implement policy evaluation engine
5. Test policies thoroughly
6. Deploy incrementally, monitor decisions
7. Iterate based on audit logs

Policy-based access control enables sophisticated authorization. Start with clear requirements and simple policies.
