# Lab 06 — Identity Lifecycle — Mover & Leaver

**Objective:** Simulate two real-world identity lifecycle events — an internal department transfer (Mover) and an employee departure (Leaver) — updating all associated access in the correct sequence.

**Time:** 25–35 minutes  
**Difficulty:** Intermediate  
**Cost:** Free

---

## Before You Start

Ensure you have completed [Lab 05 — Application Access Management](05-application-access-management.md). All five users should be created, assigned to groups, and assigned to their respective applications.

---

## Background

The **Mover** and **Leaver** phases complete the Joiner-Mover-Leaver (JML) lifecycle begun in Lab 02.

- **Mover:** An employee changes roles or departments. All three layers of their access — attributes, group membership, and application assignments — must be updated. Leaving old access in place creates **access creep** (also called privilege accumulation), a common IAM failure.

- **Leaver:** An employee leaves the organisation. Their account must be disabled immediately — this revokes authentication access across all systems simultaneously. Cleanup of groups and applications follows. The account is disabled, not deleted, to preserve the audit trail.

In this lab:
- **John HR** transfers from HR to Finance
- **Eve Intern** is offboarded at the end of her internship

---

## Part A — Mover: John HR Transfers to Finance

### A1. Update Identity Attributes

1. Navigate to **Microsoft Entra ID** → **Users**.
2. Open **John HR**.
3. Click **Edit properties**.
4. Update:
   - **Department:** Finance
   - **Job title:** Finance Coordinator
5. Click **Save**.

> **Expected result:** John HR's profile shows Department: Finance and Job title: Finance Coordinator.

---

### A2. Remove John from HR-Team

1. In John HR's profile, under **Manage**, select **Groups**.
2. Select **HR-Team** from the list.
3. Click **Remove** and confirm.

> **Expected result:** HR-Team no longer appears in John HR's group membership list.

---

### A3. Add John to Finance-Team

1. Navigate to **Groups** → **Finance-Team**.
2. Under **Manage**, select **Members** → **Add members**.
3. Search for **John HR**, select him, and click **Select**.

> **Expected result:** Finance-Team's Members list shows Bob Finance and John HR.

---

### A4. Remove John from HR-App

1. Navigate to **Enterprise applications** → **HR-App**.
2. Under **Manage**, select **Users and groups**.
3. Select **John HR** and click **Remove**. Confirm.

> **Expected result:** John HR no longer appears in HR-App's user list.

---

### A5. Add John to Finance-App

1. Navigate to **Enterprise applications** → **Finance-App**.
2. Under **Manage**, select **Users and groups** → **Add user/group**.
3. Search for **John HR**, select him, and click **Assign**.

> **Expected result:** Finance-App's user list shows Bob Finance and John HR.

---

### A6. Verify John's Complete Access State

After completing A1–A5, John's access profile should be:

| Layer | Before | After |
|---|---|---|
| Department attribute | HR | Finance |
| Group membership | HR-Team | Finance-Team |
| Application access | HR-App | Finance-App |

> **Key principle:** All three layers must be updated. Missing any one creates access inconsistency and audit inaccuracy — John could retain HR access while working in Finance, which violates least privilege and creates a compliance issue.

---

## Part B — Leaver: Eve Intern Offboarding

### B1. Disable Eve's Account

1. Navigate to **Microsoft Entra ID** → **Users**.
2. Open **Eve Intern**.
3. Click **Edit properties**.
4. Set **Account enabled** to **No**.
5. Click **Save**.

> **Expected result:** Eve's profile shows Account enabled: No. She can no longer authenticate to any service in the tenant. This takes effect on the next authentication request — any active sessions expire on the next token refresh.

---

### B2. Remove Eve from All Groups

1. In Eve Intern's profile, under **Manage**, select **Groups**.
2. Select **HR-Team** and click **Remove**. Confirm.

> **Expected result:** Eve Intern has no group memberships remaining.

---

### B3. Remove Eve's Application Access

1. Navigate to **Enterprise applications** → **HR-App**.
2. Under **Manage**, select **Users and groups**.
3. Select **Eve Intern** and click **Remove**. Confirm.

> **Expected result:** Eve Intern does not appear in any application's user assignment list.

---

### B4. Why Disable Rather Than Delete?

The account is **disabled, not deleted**. This is intentional:

- Deleting an account removes the identity record, breaking audit log traceability.
- Disabling immediately revokes authentication while preserving the full history of what the account did, what it accessed, and when changes were made.
- Compliance frameworks (SOC 2, ISO 27001, GDPR) typically require identity records to be retained for a defined period after offboarding — commonly one to seven years.

In production, the disabled account remains in the directory for the retention period defined in your organisation's data retention policy, then is permanently deleted.

---

## IAM Concepts

**Access Re-Provisioning (Mover)** — The correct sequence is: remove old access first, then grant new access. Granting new access before removing old access creates a window where the user holds both — a least privilege violation.

**Immediate Access Revocation (Leaver)** — Disabling the account is the fastest and most reliable way to revoke all access simultaneously. It is more reliable than removing individual group memberships or application assignments, which can be missed.

**Audit Preservation** — The disabled account serves as a forensic record. If a security incident is later linked to this user's period of access, the account history must be queryable. Deletion before a retention period expires may constitute a compliance failure.

---

## Troubleshooting

| Problem | Likely cause | Fix |
|---|---|---|
| "Remove" button is greyed out in Groups | Insufficient permissions | Sign in as Global Administrator |
| Account enabled toggle is not visible | Portal UI layout variation | Look for "Block sign in" as an equivalent option |
| Eve still appears in application list after removal | Portal cache | Refresh the page and verify again |

---

## Next Step

Proceed to [Lab 07 — Audit Logging & Monitoring](07-audit-logging-monitoring.md) to review the audit trail of all changes made throughout the lab.
