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
- **Alice IT** receives **User Administrator** — she can manage user accounts, appropriate for an IT administrator.
- **Bob Finance** receives **Global Reader** — he can read all directory data for governance oversight, but cannot modify anything.

No user will receive **Global Administrator**. In production, Global Admin is a break-glass account — credentials stored in a vault, activated only during emergencies, with all activations logged and alerted.

---

## Role Assignments

| User | Role | Reason |
|---|---|---|
| Alice IT | User Administrator | IT manages user provisioning — scoped to user management only |
| Bob Finance | Global Reader | Finance needs directory visibility for governance — read-only, no modification rights |

---

## Steps

### 1. Navigate to Roles and Administrators

1. In the Azure Portal, navigate to **Microsoft Entra ID**.
2. In the left sidebar under **Manage**, select **Roles and administrators**.

> **Expected result:** A list of all available directory roles appears. Use the search bar to find specific roles.

⚠️ **Note:** As of May 2026, "Roles and administrators" is in the left sidebar under **Manage**. The Azure Portal updates frequently — if the menu has changed, search for "Roles and administrators" in the top search bar.

#### Screenshots

| # | Screenshot | What you should see |
|---|---|---|
| 16 | ![Roles and Administrators Page](../screenshots/16-roles-and-administrators-page.png) | The Roles and administrators page showing the list of available directory roles with a search bar at the top |

---

### 2. Assign User Administrator to Alice IT

1. In the search bar, type **User Administrator** and select the role.
2. Click **Add assignments**.
3. Search for **Alice IT**, select her, and click **Add**.

> **Expected result:** Alice IT appears in the assignments list for the User Administrator role, showing as **Active**.

#### Screenshots

| # | Screenshot | What you should see |
|---|---|---|
| 17 | ![User Admin Role Assignment](../screenshots/17-user-admin-role-assignment.png) | The User Administrator role page with the "Add assignments" button visible |
| 18 | ![User Admin Confirmation](../screenshots/18-user-admin-confirmation.png) | Alice IT appearing in the User Administrator assignments list with status "Active" |

---

### 3. Assign Global Reader to Bob Finance

1. Navigate back to **Roles and administrators** (breadcrumb at the top, or left sidebar).
2. Search for **Global Reader** and select it.
3. Click **Add assignments**.
4. Search for **Bob Finance**, select him, and click **Add**.

> **Expected result:** Bob Finance appears in the assignments list for the Global Reader role.

#### Screenshots

| # | Screenshot | What you should see |
|---|---|---|
| 19 | ![Global Reader Assignment](../screenshots/19-global-reader-assignment.png) | The Global Reader role page with the "Add assignments" button visible |
| 20 | ![Global Reader Confirmation](../screenshots/20-global-reader-confirmation.png) | Bob Finance appearing in the Global Reader assignments list |

---

### 4. Verify Assignments from User Profiles

1. Navigate to **Users** and open **Alice IT**.
2. In the left sidebar under **Manage**, select **Assigned roles**.
3. Confirm **User Administrator** is listed.
4. Repeat for **Bob Finance** — confirm **Global Reader** is listed.

> **Expected result:** Each user shows exactly one assigned role. No other roles should be present.

#### Screenshots

| # | Screenshot | What you should see |
|---|---|---|
| 21 | ![Verify Role Assignments](../screenshots/21-verify-role-assignments.png) | User profiles showing Alice IT with User Administrator role and Bob Finance with Global Reader role in their respective "Assigned roles" tabs |

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
