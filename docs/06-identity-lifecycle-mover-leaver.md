# Step 6 — Identity Lifecycle — Mover & Leaver

**Objective:** Simulate real-world identity lifecycle changes — an internal transfer and an employee departure.

## Mover — Internal Transfer (John HR → Finance)

- Updated `John HR`'s department attribute and job title to reflect a transfer from HR to Finance.
- Removed John from the **HR-Team** group and added him to the **Finance-Team** group.
- Removed access from **HR-App** and granted access to **Finance-App**.
- All three layers of access — attributes, group membership, and application access — were updated in sequence.

### IAM Concepts

**Identity Lifecycle Management (Mover)** — Re-provisioning access to match a changed role

**Access Re-Provisioning** — Ensuring old access is removed before new access is granted (clean transitions)

**RBAC Adjustment** — Access changes flow from the role change, not from manual decisions

## Leaver — Employee Offboarding (Eve Intern)

- Disabled `Eve Intern`'s user account by setting **Account Enabled → No**, immediately revoking authentication access.
- Removed Eve from all group memberships and revoked application access.
- Account was disabled rather than deleted to preserve the audit trail for compliance purposes.

### IAM Concepts

**Leaver Process / Access Revocation** — Disabling access on departure

**Access Cleanup / Security Hygiene** — Removing residual group and app access to prevent shadow access

**Audit Preservation** — Disabling (not deleting) maintains the identity record for compliance review and historical investigation

> **JML Summary:** This step simulated the complete Joiner-Mover-Leaver lifecycle — from initial provisioning (Step 2), through an internal role change with full access re-alignment (this step - Mover), to secure offboarding with complete access revocation and audit record preservation (this step - Leaver).

| # | Screenshot | Description |
|---|---|---|
| 14 | ![Updated John Profile Dept Job Title](../screenshots/14-updated-john-profile-department-job-title.png.png) | John HR's profile updated with new department and job title |
| 15 | ![Updated Group Membership John Finance-Team](../screenshots/15-updated-group-membership-john-finance-team.png.png) | Group membership updated — John moved to Finance-Team |
| 16 | ![Finance-App Showing John Added](../screenshots/16-finance-app-showing-john-added.png.png) | Finance-App showing John added after role change |
| 17 | ![User Profile Disabled Eve](../screenshots/17-user-profile-showing-disabled-account-eve.png.png) | Eve Intern's account — disabled (Account Enabled: No) |

## Key Takeaway

The JML lifecycle ensures that access follows role changes automatically. When an employee leaves, disabling the account immediately revokes all access while preserving the audit history for compliance.

## Next Step

Proceed to [Audit Logging & Monitoring](07-audit-logging-monitoring.md) to verify traceability of all changes.
