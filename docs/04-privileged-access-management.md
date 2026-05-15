# Step 4 — Privileged Access Management

**Objective:** Assign administrative roles to appropriate users using scoped, least-privilege role assignments.

## Implementation Steps

- Accessed the **Roles and Administrators** section to manage privileged access within the directory.
- Assigned the **User Administrator** role to `Alice (IT)` — delegating user management responsibilities to IT without granting excessive privileges.
- Assigned the **Global Reader** role to `Bob (Finance)` — providing read-only visibility across the directory for oversight purposes without modification rights.
- Verified role assignments from within each user's profile.

## IAM Concepts

**Privileged Access Management (PAM)** — Controlling and scoping elevated access to minimize the blast radius of compromised accounts

**Delegated Administration** — Distributing administrative responsibilities to appropriate teams (IT manages users; Finance has visibility, not control)

**Least Privilege Principle** — No user holds more access than their function requires

> **Design Decision:** Global Administrator was deliberately not assigned to any user. Instead, scoped roles were used — `User Administrator` and `Global Reader` — to reduce attack surface and align with zero-trust access design. In a production environment, Global Admin would be a break-glass account with just-in-time (JIT) access, activated only during emergencies.

| # | Screenshot | Description |
|---|---|---|
| 9 | ![User Admin Role Alice IT](../screenshots/09-user-admin-role-alice-it-assigned.png.png) | User Administrator role assigned to Alice IT |
| 10 | ![Global Reader Role Bob Finance](../screenshots/10-global-reader-role-bob-finance-assigned.png.png) | Global Reader role assigned to Bob Finance |

## Key Takeaway

Administrative roles should be scoped and minimal. Avoid assigning broad roles like Global Administrator; instead, use targeted roles that match specific responsibilities.

## Next Step

Proceed to [Application Access Management](05-application-access-management.md) to provision enterprise applications.
