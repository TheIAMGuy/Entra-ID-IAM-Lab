# Step 1 — Environment Setup

**Objective:** Establish a cloud identity tenant to serve as the organisation's directory.

## Implementation Steps

- Signed into the Azure Portal and reviewed the landing dashboard — the central control plane for cloud and identity services.
- Accessed the Microsoft Entra ID tenant, which represents the organisation's identity directory.
- Verified tenant details including directory name, tenant ID, and default domain (`onmicrosoft.com`).
- Confirmed operation within the free tier to avoid paid feature dependencies.

## IAM Concept: The Identity Tenant

A tenant in Entra ID is the foundational identity boundary for an organisation. All users, groups, roles, and applications exist within this directory. Think of it as the "root" of your identity infrastructure — everything built in this lab will exist within this tenant.

| # | Screenshot | Description |
|---|---|---|
| 1 | ![Azure Portal Home Dashboard](../screenshots/01-azure-portal-home-dashboard.png.png) | Azure Portal home dashboard — central control panel |
| 2 | ![Entra ID Overview](../screenshots/02-entra-id-overview-tenant-name-domain.png.png) | Entra ID overview page showing tenant name and domain |

## Next Step

Proceed to [Identity Provisioning — Joiner](02-identity-provisioning-joiner.md) to begin creating user identities.
