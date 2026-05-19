# Lab 01 — Environment Setup

**Objective:** Sign in to the Azure Portal, locate your Entra ID tenant, and verify it is correctly configured before starting the lab exercises.

**Time:** 10–15 minutes  
**Difficulty:** Beginner  
**Cost:** Free

---

## Before You Start

You need a free Microsoft account and a free Entra ID tenant. If you have not set these up yet, follow the [Prerequisites](../README.md#prerequisites) section in the README before continuing.

---

## Steps

### 1. Sign In to the Azure Portal

1. Open your browser and navigate to [portal.azure.com](https://portal.azure.com).
2. Sign in with your Microsoft account credentials.

> **Expected result:** The Azure Portal home page loads with a blue header bar and a dashboard of service tiles.

#### Screenshots

| # | Screenshot | What you should see |
|---|---|---|
| 01 | ![Azure Portal Sign In](../screenshots/01-azure-portal-signin.png) | The Azure Portal home page with the blue header bar and service tiles dashboard |

---

### 2. Locate Microsoft Entra ID

1. In the search bar at the top of the portal, type **Entra ID**.
2. Select **Microsoft Entra ID** from the search results.

Alternatively, select **Microsoft Entra ID** from the left-hand navigation sidebar or from the **Azure services** row on the home dashboard.

> **Expected result:** The Microsoft Entra ID overview page appears, showing your tenant name, tenant ID, and default domain.

⚠️ **Note:** As of May 2026, the search bar is at the top of the Portal and the left sidebar is labelled **Manage**. The Azure Portal UI updates frequently — if the layout differs, look for "Entra ID" or "Microsoft Entra ID" in the search functionality.

#### Screenshots

| # | Screenshot | What you should see |
|---|---|---|
| 02 | ![Entra ID Search](../screenshots/02-entra-id-search.png) | The search bar with "Entra ID" typed in and search results displayed |
| 03 | ![Tenant Overview Details](../screenshots/03-tenant-overview-details.png) | The Microsoft Entra ID overview page showing tenant name, tenant ID, and primary domain |

---

### 3. Verify Your Tenant Details

On the overview page, confirm the following:

| Field | What to check |
|---|---|
| **Tenant name** | Reflects your account or organisation name |
| **Tenant ID** | A unique GUID — note this down, you will reference it throughout the lab |
| **Primary domain** | Ends in `.onmicrosoft.com` |
| **Licence** | Shows **Microsoft Entra ID Free** |

> **Expected result:** All fields are populated. The licence shows Free. If you see a Premium trial, that is fine — the labs will still work.

#### Screenshots

| # | Screenshot | What you should see |
|---|---|---|
| 03 | ![Tenant Overview Details](../screenshots/03-tenant-overview-details.png) | The Entra ID overview page with Tenant name, Tenant ID, and Primary domain fields clearly visible and populated |

---

### 4. Confirm Free Tier Operation

1. In the left sidebar under **Manage**, select **Licences**.
2. Confirm that no premium products are assigned, or note any active trial licences.

> **Why this matters:** This lab is designed to work within the free tier. Where a premium feature is relevant, it is called out explicitly with a callout note.

⚠️ **Note:** As of May 2026, "Licences" is located in the left sidebar under **Manage**. This menu has been stable, but if you cannot find it, try searching for "Licences" in the top search bar.

#### Screenshots

| # | Screenshot | What you should see |
|---|---|---|
| 04 | ![Licenses Page Free Tier](../screenshots/04-licenses-page-free-tier.png) | The Licences page showing no premium products assigned, confirming free tier status |

---

## IAM Concept: The Identity Tenant

A tenant is the foundational identity boundary in Entra ID. All users, groups, roles, and applications in this lab exist within this one directory. Think of it as the root of your identity infrastructure — every action in the subsequent labs builds on this foundation.

In enterprise environments, a tenant typically maps to one organisation. Large enterprises may operate multiple tenants (e.g., separate tenants for subsidiaries or test environments), but a single authoritative tenant is the most common production pattern.

---

## Troubleshooting

| Problem | Likely cause | Fix |
|---|---|---|
| Cannot sign in | Wrong Microsoft account | Ensure you are using the account linked to your Entra ID tenant |
| Tenant ID is blank | Tenant not fully provisioned | Wait a few minutes and refresh |
| Portal shows the wrong tenant | Multiple directories on your account | Click your name in the top right → **Switch directory** |

---

## Next Step

Proceed to [Lab 02 — Identity Provisioning (Joiner)](02-identity-provisioning-joiner.md) to begin creating user identities.
