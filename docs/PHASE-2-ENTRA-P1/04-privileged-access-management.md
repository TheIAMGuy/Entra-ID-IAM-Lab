# Lab 04 — Privileged Access Management

**Objective:** Assign scoped administrative roles to users who need elevated access, following the principle of least privilege.

**Time:** 15–20 minutes  
**Difficulty:** Intermediate  
**Cost:** Free

---

## Before You Start

Ensure you have completed [Lab 03 — Group-Based Access Control](03-group-based-access-control.md). Your five users should be created and assigned to their department groups.

---

## Background

Not all users need the same level of access to the directory itself. Privileged Access Management (PAM) controls who can administer the identity system — and scopes that access as narrowly as possible.

In this lab you will assign two roles:
- **Alice Smith** receives **User Administrator** — she can manage user accounts, appropriate for an IT administrator.
- **Bob Glasgow** receives **Global Reader** — he can read all directory data for governance oversight, but cannot modify anything.

No user will receive **Global Administrator**. In production, Global Admin is a break-glass account — credentials stored in a vault, activated only during emergencies, with all activations logged and alerted.

---

## Role Assignments

| User | Role | Reason |
|---|---|---|
| Alice Smith | User Administrator | IT manages user provisioning — scoped to user management only |
| Bob Glasgow | Global Reader | Finance needs directory visibility for governance — read-only, no modification rights |

---

## Steps

### 1. Navigate to Roles and Administrators

1. In the Android Entra ID, navigate to **Microsoft Entra ID**.
2. In the left sidebar under **Manage**, select **Roles and administrators**.

> **Expected result:** A list of all available directory roles appears. Use the search bar to find specific roles.

---

### 2. Assign User Administrator to Alice Smith

1. In the search bar, type **User Administrator** and select the role.
2. Click **Add assignments**.
3. Search for **Alice Smith**, select her, and click **Add**.

> **Expected result:** Alice Smith appears in the assignments list for the User Administrator role, showing as **Active**.

---

### 3. Assign Global Reader to Bob Glasgow

1. Navigate back to **Roles and administrators** (breadcrumb at the top, or left sidebar).
2. Search for **Global Reader** and select it.
3. Click **Add assignments**.
4. Search for **Bob Glasgow**, select him, and click **Add**.

> **Expected result:** Bob Glasgow appears in the assignments list for the Global Reader role.

---

### 4. Verify Assignments from User Profiles

1. Navigate to **Users** and open **Alice Smith**.
2. In the left sidebar under **Manage**, select **Assigned roles**.
3. Confirm **User Administrator** is listed.
4. Repeat for **Bob Glasgow** — confirm **Global Reader** is listed.

> **Expected result:** Each user shows exactly one assigned role. No other roles should be present.

---

## IAM Concepts

**Privileged Access Management (PAM)** — Privileged accounts are prime targets for attackers. The fewer privileges an account holds, and the more precisely scoped those privileges are, the smaller the blast radius of a compromise.

**Delegated Administration** — IT manages users; Finance has read-only visibility. Each team has exactly what they need for their function — no more. This is least privilege applied to administrative access.

**Least Privilege Principle** — Every account, including administrative accounts, should hold only the permissions required for its specific function. Over-privileged admins are one of the most common root causes of serious security incidents.

> **Design Decision:** Global Administrator was deliberately not assigned. In production, Global Admin is a break-glass account — credentials stored in a secrets vault, activated only during emergencies using just-in-time (JIT) access, with all activations generating alerts. Scoped roles like User Administrator and Global Reader cover the vast majority of day-to-day administrative needs.

---

## Troubleshooting

| Problem | Likely cause | Fix |
|---|---|---|
| "Add assignments" is greyed out | Insufficient permissions on your account | Sign in as Global Administrator |
| Role assignment does not appear after saving | Portal cache | Refresh the page and re-open the role |
| User does not appear in the search when adding an assignment | Search lag | Wait a few seconds and try again |

---

## Next Step

Proceed to [Lab 05 — Application Access Management](05-application-access-management.md) to provision enterprise applications and assign user access.
