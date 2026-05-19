# Lab 05 — Application Access Management

**Objective:** Create enterprise application registrations representing internal systems, and assign users to each application based on their department.

**Time:** 20–30 minutes  
**Difficulty:** Intermediate  
**Cost:** Free

---

## Before You Start

Ensure you have completed [Lab 04 — Privileged Access Management](04-privileged-access-management.md).

---

## Background

In enterprise environments, Entra ID acts as the **Identity Provider (IdP)** for business applications. Instead of each application managing its own credentials, applications delegate authentication to Entra ID. This enables **Single Sign-On (SSO)** — users authenticate once and gain access to all their assigned applications without separate logins.

In this lab you will simulate three internal systems — HR-App, Finance-App, and Sales-App — and assign department users to each.

> **Free Tier Note:** Group-based application assignment requires an Entra ID P1 or P2 licence. In this lab, users are assigned directly to applications. In a production environment with P1/P2, you would assign the HR-Team group to HR-App, automatically granting access to all current and future group members.

---

## Applications to Create

| Application Name | Users to Assign |
|---|---|
| HR-App | John HR, Eve Intern |
| Finance-App | Bob Finance |
| Sales-App | Charlie Sales |

---

## Steps

### 1. Navigate to Enterprise Applications

1. In the Azure Portal, navigate to **Microsoft Entra ID**.
2. In the left sidebar under **Manage**, select **Enterprise applications**.
3. Click **New application**.

⚠️ **Note:** As of May 2026, "Enterprise applications" is in the left sidebar under **Manage**. The Azure Portal updates frequently — if the menu has changed, search for "Enterprise applications" in the top search bar.

#### Screenshots

| # | Screenshot | What you should see |
|---|---|---|
| 22 | ![Enterprise Applications Page](../screenshots/22-enterprise-applications-page.png) | The Enterprise applications page showing the list of applications (may be empty initially) with the "New application" button visible |

---

### 2. Create HR-App

1. On the application gallery page, click **Create your own application** (top left area).
2. Enter the name: **HR-App**
3. Select **Integrate any other application you don't find in the gallery (Non-gallery)**.
4. Click **Create**.

> **Expected result:** The HR-App overview page opens. The application now exists in your tenant.

⚠️ **Note:** As of May 2026, the "Create your own application" option is visible on the initial gallery page. If the UI has changed, look for options like "Custom app", "Non-gallery app", or "Create application" on the same page.

#### Screenshots

| # | Screenshot | What you should see |
|---|---|---|
| 23 | ![Create App Form](../screenshots/23-create-app-form.png) | The application creation page showing the "Create your own application" option and "Non-gallery" selection |
| 24 | ![App Created Confirmation](../screenshots/24-app-created-confirmation.png) | The HR-App overview page confirming the application has been created successfully |

---

### 3. Assign Users to HR-App

1. From the HR-App overview, in the left sidebar under **Manage**, select **Users and groups**.
2. Click **Add user/group**.
3. Under **Users**, click **None selected**.
4. Search for **John HR** and select him.
5. Search for **Eve Intern** and select her.
6. Click **Select**, then click **Assign**.

> **Expected result:** The Users and groups list for HR-App shows John HR and Eve Intern, both with the role "Default Access".

#### Screenshots

| # | Screenshot | What you should see |
|---|---|---|
| 25 | ![Assign Users to App](../screenshots/25-assign-users-to-app.png) | The "Add user/group" panel showing the search field and selected users (John HR and Eve Intern) before confirming |
| 26 | ![App Users Assigned](../screenshots/26-app-users-assigned.png) | The Users and groups list for HR-App showing John HR and Eve Intern with "Default Access" role assigned |

---

### 4. Create Finance-App and Sales-App

Repeat steps 2 and 3 for:
- **Finance-App** → assign **Bob Finance**
- **Sales-App** → assign **Charlie Sales**

> **Expected result:** Three enterprise applications exist in your tenant. Each shows the correct assigned user(s) under Users and groups.

#### Screenshots

| # | Screenshot | What you should see |
|---|---|---|
| 27 | ![Remaining Apps Created](../screenshots/27-remaining-apps-created.png) | The Enterprise applications page showing all three applications created: HR-App, Finance-App, and Sales-App |

---

### 5. Verify the Full Application Landscape

1. Navigate to **Enterprise applications**.
2. Search for "App" in the search bar to filter your three applications.
3. Open each one and confirm the assigned users.

> **Expected result:** HR-App: John HR, Eve Intern. Finance-App: Bob Finance. Sales-App: Charlie Sales. No cross-department access exists.

#### Screenshots

| # | Screenshot | What you should see |
|---|---|---|
| 28 | ![Verify Application Landscape](../screenshots/28-verify-application-landscape.png) | The Enterprise applications page showing all three apps (HR-App, Finance-App, Sales-App) with correct user assignments verified |

---

## IAM Concepts

**Application Access Management** — Every enterprise application should have an explicit list of authorised users or groups, with access defaulting to denied. Entra ID enforces this when "Assignment required" is enabled on the application.

**SSO Foundation** — Users authenticate once to Entra ID and access all assigned applications without re-entering credentials. This eliminates password sprawl and reduces the attack surface.

**Provisioning vs Access** — Creating an application registration in Entra ID does not automatically grant anyone access to it. Access must be explicitly assigned — this is the correct default posture.

> **Free Tier Limitation:** In production with P1/P2, you would assign the HR-Team group to HR-App rather than individual users. Any new HR employee added to HR-Team automatically gains HR-App access — no manual step required per user. This lab implements the correct access design; only the assignment mechanism differs due to the free tier.

---

## Troubleshooting

| Problem | Likely cause | Fix |
|---|---|---|
| "Create your own application" is not visible | Portal UI update | Look for a "custom" or "non-gallery" option on the same page |
| User does not appear in Users and groups after assignment | Assignment not saved | Click Add user/group again and reassign |
| Application does not appear in the list | Filter applied | Clear search filters on the Enterprise applications page |

---

## Next Step

Proceed to [Lab 06 — Identity Lifecycle — Mover & Leaver](06-identity-lifecycle-mover-leaver.md) to simulate an internal transfer and an employee offboarding.
