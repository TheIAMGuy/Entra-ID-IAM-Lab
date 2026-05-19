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

The Joiner process is the first phase of the **Joiner-Mover-Leaver (JML)** identity lifecycle. When a new employee joins, a digital identity is created in the directory. This identity is the foundation for everything that follows — access to systems, group membership, and audit traceability all depend on having a well-attributed identity record.

In this lab you will create five users across four departments. These same users are used throughout all subsequent labs.

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

⚠️ **Note:** As of May 2026, the "New user" button is located at the top of the Users page. If the interface has changed, look for a button or menu option labelled "New user" or "Create user".

#### Screenshots

| # | Screenshot | What you should see |
|---|---|---|
| 05 | ![Navigate Users Page](../screenshots/05-navigate-users-page.png) | The Users page showing the list of current users in the tenant |
| 06 | ![New User Button](../screenshots/06-new-user-button.png) | The "New user" button and dropdown menu with "Create new user" option visible |

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

#### Screenshots

| # | Screenshot | What you should see |
|---|---|---|
| 07 | ![User Form John HR](../screenshots/07-user-form-john-hr.png) | The user creation form with fields filled in: John HR display name, john.hr@[domain], job title "HR Coordinator", department "HR" |
| 08 | ![User Created Confirmation](../screenshots/08-user-created-confirmation.png) | The success confirmation banner showing "Successfully created user John HR" |

---

### 3. Create the Remaining Four Users

Repeat step 2 for each remaining user in the table above, using the corresponding values.

> **Tip:** Keep the Users list open in one browser tab. Click **New user** from that page each time to speed up the process.

> **Expected result:** The All Users list shows all five new users. You may also see your own admin account. Use the search bar to confirm each user exists.

#### Screenshots

| # | Screenshot | What you should see |
|---|---|---|
| 09 | ![Users List All Five](../screenshots/09-users-list-all-five.png) | The Users page showing all five created users: John HR, Alice IT, Bob Finance, Charlie Sales, Eve Intern |

---

### 4. Verify User Attributes

1. Click on **John HR** in the user list.
2. Select the **Properties** tab.
3. Confirm **Department** shows `HR` and **Job title** shows `HR Coordinator`.

> **Expected result:** Both attribute fields are populated. If any field is blank, click **Edit properties** at the top of the profile to update it.

#### Screenshots

| # | Screenshot | What you should see |
|---|---|---|
| 10 | ![User Properties Verification](../screenshots/10-user-properties-verification.png) | John HR's user profile with the Properties tab open, showing Department: HR and Job title: HR Coordinator |

---

## IAM Concepts

**Identity Provisioning** — Creating digital identities for new joiners. At this stage, users exist in the directory but have no access to any resources. Identity and access are managed as two separate concerns — this separation is a foundational IAM design principle.

**Attribute-Based Identity Management** — Attributes like Department and Job Title are metadata that drive downstream access decisions. Getting these right at provisioning time is an IAM data quality issue: incorrect attributes lead to incorrect access.

**Separation of Identity and Access** — A user can exist in the directory without being able to access anything. Access is granted through group membership and role assignments in subsequent labs.

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
