# Step 2 — Identity Provisioning — Joiner

**Objective:** Simulate the onboarding of employees across departments by creating user accounts with structured identity attributes.

## Implementation Steps

- Created multiple users representing employees across four departments: **HR, IT, Finance, and Sales**.
- Assigned identity attributes to each user — including `Department` and `Job Title` — to establish a structured organisational identity base.
- Users exist in the directory without access to any resources at this stage, reflecting the principle that identity and access are managed separately.

## IAM Concepts

**Identity Provisioning** — Creating digital identities for new employees (the "Joiner" phase of JML)

**Attribute-Based Identity Management** — Enriching profiles with metadata (department, job title, location) used to drive access decisions downstream

**Identity Lifecycle Management (Joiner)** — The first phase of the JML (Joiner-Mover-Leaver) identity lifecycle

| # | Screenshot | Description |
|---|---|---|
| 3 | ![User List Showing John HR](../screenshots/03-user-list-showing-john-hr.png.png) | User list showing John HR — first provisioned user |
| 4 | ![Users List All Created Users](../screenshots/04-users-list-all-created-users.png.png) | Full users list showing all created users across departments |
| 5 | ![Inside User Profile Page](../screenshots/05-inside-user-profile-page.png.png) | Inside a user profile — identity attributes visible |

## Key Takeaway

Users now exist as digital identities, but have no access to resources yet. Access will be granted through group membership and role assignments in subsequent steps. This separation of identity and access is a foundational IAM principle.

## Next Step

Proceed to [Group-Based Access Control](03-group-based-access-control.md) to organize users into groups and implement RBAC.
