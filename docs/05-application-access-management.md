# Step 5 — Application Access Management

**Objective:** Simulate access provisioning for internal business applications using Entra ID Enterprise Applications.

## Implementation Steps

- Created three enterprise applications to simulate internal systems: **HR-App, Finance-App, Sales-App**.
- Assigned users to applications based on their department:
  - `John HR` and `Eve Intern` → HR-App
  - `Bob Finance` → Finance-App
  - `Charlie Sales` → Sales-App
- Reviewed application overview pages to verify assigned users.

## IAM Concepts

**Application Access Management** — Controlling which identities can access which systems

**Single Sign-On (SSO) Foundation** — Entra ID acts as the identity provider for enterprise applications, eliminating the need for separate credentials per app

**Access Provisioning** — Aligning application access to organisational role — users get access to systems relevant to their department

> **Free Tier Note:** Group-based application assignment was not available under the free tier. In a production environment, applications would be assigned to security groups (e.g., HR-Team → HR-App) rather than individual users, ensuring RBAC and access scalability. The correct design approach was maintained throughout; only the implementation method was adapted due to tier constraints.

| # | Screenshot | Description |
|---|---|---|
| 11 | ![HR-App Overview Page](../screenshots/11-hr-app-overview-page.png.png) | HR-App enterprise application overview |
| 12 | ![HR-App Assigned Users](../screenshots/12-hr-app-showing-assigned-users.png.png) | HR-App showing assigned users |
| 13 | ![Multiple Apps User Assignments](../screenshots/13-multiple-apps-user-assignments.png.png) | Multiple enterprise apps with user assignments |

## Key Takeaway

SSO via Entra ID simplifies user management — users authenticate once and gain access to all assigned applications. In production, use group-based assignment to scale access provisioning.

## Next Step

Proceed to [Identity Lifecycle — Mover & Leaver](06-identity-lifecycle-mover-leaver.md) to simulate real-world role changes.
