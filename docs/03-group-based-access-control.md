# Step 3 — Group-Based Access Control

**Objective:** Organise users into security groups by department to enable scalable, group-based access control.

## Implementation Steps

- Created four security groups: **HR-Team, IT-Team, Finance-Team, Sales-Team**.
- Added each user to their corresponding department group.
- Avoided direct user-to-resource assignment; all access is managed through group membership.
- Verified group membership from within user profiles to confirm correct linkage.

## IAM Concepts

**Role-Based Access Control (RBAC) Foundation** — Groups serve as the access control unit, not individual users

**Least Privilege** — Users receive only the access appropriate to their department and role

**Scalable Access Management** — Adding or removing a user from a group modifies all associated permissions in one action, reducing administrative overhead

> **Design Decision:** Access was intentionally assigned to groups rather than individual users. This is consistent with enterprise IAM best practices — it reduces administrative overhead, improves auditability, and ensures consistent access at scale. When an employee changes departments, you update their group membership (one change) rather than updating dozens of resource permissions individually.

| # | Screenshot | Description |
|---|---|---|
| 6 | ![Groups Page Showing HR-Team Created](../screenshots/06-groups-page-hr-team-created.png.png) | Groups page showing HR-Team created |
| 7 | ![Groups List All Created Groups](../screenshots/07-groups-list-all-created-groups.png.png) | Full groups list showing all department groups |
| 8 | ![HR-Team Members Tab](../screenshots/08-hr-team-members-tab-john-eve.png.png) | HR-Team → Members tab showing John HR and Eve Intern |

## Key Takeaway

Groups are the foundation of scalable IAM. By managing access at the group level, you reduce complexity and improve consistency as your organization grows.

## Next Step

Proceed to [Privileged Access Management](04-privileged-access-management.md) to assign administrative roles.
