# Lab 02 — Identity Provisioning — Joiner

**Objective:** Create user accounts representing employees across four departments, assigning structured identity attributes to each.

**Time:** 20–30 minutes  
**Difficulty:** Beginner  
**Cost:** Free

---

## Before You Start

Ensure you have completed [Lab 01 — Environment Setup](01-environment-setup.md) and can access your Entra ID tenant in the Azure Portal.

---

## Background

The Joiner process creates digital identities for new employees. This lab creates five test users that will be used throughout the remaining Phase 1 labs.

---

## Users to Create

Replace `[yourdomain]` with your `.onmicrosoft.com` domain prefix (visible on your tenant overview page).

| Display Name | Username | Department | Job Title |
|---|---|---|---|
| John HR | john.hr@[yourdomain].onmicrosoft.com | HR | HR Coordinator |
| Alice IT | alice.it@[yourdomain].onmicrosoft.com | IT | IT Administrator |
| Bob Finance | bob.finance@[yourdomain].onmicrosoft.com | Finance | Finance Analyst |
| Charlie Sales | charlie.sales@[yourdomain].onmicrosoft.com | Sales | Sales Executive |
| Eve Intern | eve.intern@[yourdomain].onmicrosoft.com | HR | Intern |

---

## Steps

### 1. Navigate to Users

1. In the Azure Portal, navigate to **Microsoft Entra ID**.
2. In the left sidebar under **Manage**, select **Users**.
3. Click **New user** → **Create new user**.

---

### 2. Create John HR

**Basics tab:**
- **User principal name:** `john.hr@[yourdomain].onmicrosoft.com`
- **Display name:** `John HR`
- **Password:** Select **Auto-generate password** and note the value shown

**Properties tab:**
- **First name:** John
- **Last name:** HR
- **Job title:** HR Coordinator
- **Department:** HR

Click **Review + create**, then **Create**.

> **Expected result:** A confirmation banner appears: "Successfully created user John HR." The user appears in the All Users list.

---

### 3. Create the Remaining Four Users

Repeat step 2 for each remaining user in the table above, using the corresponding values.

> **Tip:** Keep the Users list open in one browser tab. Click **New user** from that page each time to speed up the process.

> **Expected result:** The All Users list shows all five new users. You may also see your own admin account. Use the search bar to confirm each user exists.

---

### 4. Verify User Attributes

1. Click on **John HR** in the user list.
2. Select the **Properties** tab.
3. Confirm **Department** shows `HR` and **Job title** shows `HR Coordinator`.

> **Expected result:** Both attribute fields are populated. If any field is blank, click **Edit properties** at the top of the profile to update it.

---

## IAM Concepts

- **Attributes matter:** Department and Job Title are used in later labs to grant access. Set them correctly here.
- **Users ≠ Access:** Creating a user does not grant them access to anything. Access comes later via group membership.

---

## Troubleshooting

| Problem | Likely cause | Fix |
|---|---|---|
| "User principal name already exists" | Username taken in your tenant | Slightly vary the name (e.g., `john.hr2@...`) |
| Properties tab fields are missing | Portal UI variation | Search for "Edit properties" to set fields directly |
| User does not appear in list | Filter applied to the list | Clear filters or search by display name |

---

## Next Step

Proceed to [Lab 03 — Group-Based Access Control](03-group-based-access-control.md) to organise users into department groups.
