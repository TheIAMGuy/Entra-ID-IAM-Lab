# Lab 03 — Group-Based Access Control

**Objective:** Create security groups for each department and assign users to their corresponding groups, establishing the foundation for scalable RBAC.

**Time:** 15–20 minutes  
**Difficulty:** Beginner  
**Cost:** Free

---

## Before You Start

Ensure you have completed [Lab 02 — Identity Provisioning (Joiner)](02-identity-provisioning-joiner.md). You should have five users in your directory: John HR, Alice IT, Bob Finance, Charlie Sales, and Eve Intern.

---

## Background

In enterprise IAM, access is almost never assigned directly to individual users. Instead, users are members of **groups**, and access is granted to the group. This is the foundation of **Role-Based Access Control (RBAC)**.

Why this matters: when an employee changes roles, you update their group membership — one change that adjusts all their access simultaneously. If access were assigned per-user, you would need to update dozens of individual permission records for every role change.

---

## Groups to Create

| Group Name | Members |
|---|---|
| HR-Team | John HR, Eve Intern |
| IT-Team | Alice IT |
| Finance-Team | Bob Finance |
| Sales-Team | Charlie Sales |

---

## Steps

### 1. Navigate to Groups

1. In the Azure Portal, navigate to **Microsoft Entra ID**.
2. In the left sidebar under **Manage**, select **Groups**.
3. Click **New group**.

---

### 2. Create HR-Team

Fill in the form:

| Field | Value |
|---|---|
| **Group type** | Security |
| **Group name** | HR-Team |
| **Group description** | Department group for HR employees |
| **Membership type** | Assigned |

Leave the Members field empty for now. Click **Create**.

> **Expected result:** HR-Team appears in the All Groups list.

---

### 3. Add Members to HR-Team

1. Open **HR-Team** from the groups list.
2. In the left sidebar under **Manage**, select **Members**.
3. Click **Add members**.
4. Search for **John HR**, select him.
5. Search for **Eve Intern**, select her.
6. Click **Select** to confirm.

> **Expected result:** The Members list for HR-Team shows two entries: John HR and Eve Intern.

---

### 4. Create Remaining Groups and Add Members

Repeat steps 2 and 3 for each remaining group:

- **IT-Team** → Add Alice IT
- **Finance-Team** → Add Bob Finance
- **Sales-Team** → Add Charlie Sales

> **Expected result:** The All Groups list shows four groups. Each group contains the correct member(s).

---

### 5. Verify Group Membership from a User Profile

1. Navigate to **Users** and open **John HR**.
2. In the left sidebar under **Manage**, select **Groups**.
3. Confirm **HR-Team** appears in the list.

> **Expected result:** John HR shows one group membership: HR-Team. No other groups should appear at this stage.

---

## IAM Concepts

**Security Groups as the Access Unit** — In Entra ID, Security groups are the primary mechanism for granting access to resources. Assign users to groups; assign permissions to groups. Never assign permissions directly to individual users in a scalable system.

**Least Privilege** — Each user is a member of only their own department group. No user has access to other departments' resources.

**Scalability** — Onboarding a new HR employee requires one action: add them to HR-Team. All associated resource access follows automatically. This scales to hundreds of users without increasing administrative overhead.

> **Design Decision:** Access is intentionally assigned to groups rather than individual users. When an employee changes departments, you update their group membership — one change — rather than modifying dozens of individual resource permissions. This is covered in Lab 06 (Mover).

---

## Troubleshooting

| Problem | Likely cause | Fix |
|---|---|---|
| "New group" button is greyed out | Insufficient permissions | Ensure you are signed in as Global Administrator or Groups Administrator |
| User not appearing in member search | Typo in search | Try searching by first name only |
| Group does not appear in user's Groups list | Membership not saved correctly | Re-open the group and confirm the member appears in the Members tab |

---

## Next Step

Proceed to [Lab 04 — Privileged Access Management](04-privileged-access-management.md) to assign administrative roles to appropriate users.
