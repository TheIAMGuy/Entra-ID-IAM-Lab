# Group Naming Convention Template

Use this template to standardize group naming across your Entra ID tenant.

## Format

```
[Department]-[Function]-[Type]-[Owner]
```

### Components

| Component | Example | Notes |
|-----------|---------|-------|
| **Department** | FIN, IT, HR, MKT | 3-letter abbreviation |
| **Function** | Accounting, Support, Admin | Primary business function |
| **Type** | TEAM (M365), ROLE (RBAC), APP (Application) | Clear ownership |
| **Owner** | Initials or team name | Who maintains this group |

## Examples

**Security Group (RBAC):**
- `FIN-Accounting-ROLE-G1` — Finance department accounting role
- `IT-Helpdesk-ROLE-G1` — IT helpdesk access group
- `HR-Payroll-ROLE-G1` — HR payroll administrators

**Application Access:**
- `APP-Salesforce-TEAM-IT` — Salesforce app access, managed by IT
- `APP-ServiceNow-ROLE-IT` — ServiceNow role-based access
- `APP-Teams-TEAM-Collab` — Teams collaboration groups

**Department Teams:**
- `FIN-Team-TEAM-Controller` — Finance team members
- `MKT-Campaign-TEAM-Director` — Marketing campaign team

## Implementation

1. Communicate this standard to all tenant owners
2. Create a reference document in your wiki/documentation
3. Use as a requirement in your access request process
4. Audit existing groups quarterly for compliance

## Alternative Format (If You Prefer)

```
[Type]-[Department]-[Function]-[RoleLevel]
```

Example: `ROLE-FIN-Accounting-Senior` or `TEAM-IT-Support-L2`

---

Choose **one format** and apply consistently across your tenant.
