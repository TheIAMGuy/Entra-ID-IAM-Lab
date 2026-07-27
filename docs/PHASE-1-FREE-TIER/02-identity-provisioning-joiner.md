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

Replace `[yourdomain]` with your `domain.onmicrosoft.com` domain prefix (visible on your tenant overview page).

| Display Name | Username | Department | Job Title |
|---|---|---|---|
| John Smith | John.Smith@[yourdomain].onmicrosoft.com | HR | HR Coordinator |
| Alice Smith | Alice.Smith@[yourdomain].onmicrosoft.com | IT | IT Administrator |
| Bob Glasgow | Bob.Glasgow@[yourdomain].onmicrosoft.com | Finance | Finance Analyst |
| Charlie Jones | Charlie.Jones@[yourdomain].onmicrosoft.com | Sales | Sales Executive |
| Eve Smith | Eve.Smith@[yourdomain].onmicrosoft.com | HR | Intern |

---

## Steps

### 1. Navigate to Users

1. Navigate to **Microsoft Entra ID**.
2. In the left sidebar under **Entra ID**, select **Users**.
3. Click **New user** → **Create new user**.

---

### 2. Create John Smith

**Basics tab:**
- **User principal name:** `John.Smithr@[yourdomain].onmicrosoft.com`
- **Display name:** `John Smith`
- **Password:** Untick **Auto-generate password**, you will create a password for each user, or one password for all since this is a home lab.

**Properties tab:**
- **First name:** John
- **Last name:** Smith
- **Job title:** HR Coordinator
- **Department:** HR

Click **Review + create**, then **Create**.

> **Expected result:** A confirmation banner appears: "Successfully created user John Smith." The user appears in the All Users list.

---

### 3. Create the Remaining Four Users

Repeat step 2 for each remaining user in the table above, using the corresponding values.

> **Tip:** Keep the Users list open in one browser tab. Click **New user** from that page each time to speed up the process.

> **Expected result:** The All Users list shows all five new users. You may also see your own admin account. Use the search bar to confirm each user exists.

---

### 4. Verify User Attributes

1. Click on **John Smith** in the user list.
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
