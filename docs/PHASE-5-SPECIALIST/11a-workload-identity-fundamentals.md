# Lab 11a — Workload Identity Fundamentals

**Objective:** Understand workload identity concepts, create a service principal for a non-human entity (application), configure app-only permissions, and test token-based authentication without long-lived secrets.

**Time:** 25–30 minutes  
**Difficulty:** Intermediate–Advanced  
**Cost:** Free

---

## Before You Start

Complete [Phase 4 — Identity Governance](../PHASE-4-GOVERNANCE/17a-set-up-access-reviews.md). You should understand role assignments and access patterns.

---

## Background

**Workload Identity** is authentication for non-human entities: applications, services, CI/CD pipelines, and microservices.

**Problem with long-lived secrets:**
```
Traditional approach:
  App needs to access database
  → Admin creates API key
  → Key stored in config file
  → Key has no expiration
  → Key exposed in breach
  → Database compromised indefinitely
```

**Modern workload identity:**
```
Workload Identity approach:
  App runs with managed identity or service principal
  → Entra ID issues short-lived token (1 hour)
  → App uses token to access resources
  → Token expires, app gets new one
  → No secrets in code, automatic rotation
  → Full audit trail of app access
```

---

## Steps

### 1. Create a Service Principal (Workload Identity)

A **service principal** is the non-human identity for your application.

1. In the Entra ID admin center, go to **Applications** → **App registrations**.
2. Click **+ New registration**.
3. **Name:** Enter `"WorkloadTest-App"` (or any app name)
4. **Supported account types:** Select **Accounts in this organizational directory only**
5. **Redirect URI:** Leave blank (not needed for workload identity)
6. Click **Register**.

> **Expected result:** A new app registration is created. You're now on the app overview page.

---

### 2. Note the Application (Client) ID

This is your app's unique identifier.

1. On the app overview page, find the **Application (client) ID** field.
2. **Copy and save it** (you'll need it later). Example: `12345678-1234-1234-1234-123456789abc`

> **Expected result:** You have your app's client ID.

---

### 3. Create an Application Secret

For this lab, we'll use a **client secret** (long-lived credentials). In production, you'd use **certificates** or **federated credentials** (more secure, no secrets stored).

1. On the app page, go to **Certificates & secrets**.
2. Click **+ New client secret**.
3. **Description:** Enter `"Test secret for workload identity demo"`
4. **Expires:** Select **6 months** (or whatever fits your policy)
5. Click **Add**.

> **Expected result:** A new secret is generated. **IMPORTANT:** Copy the **Value** (not the ID) immediately — you can only see it once!

---

### 4. Assign Permissions to the App

Apps need permissions to access resources. In this step, we'll grant the app permission to read cloud applications.

1. On the app page, go to **API permissions**.
2. Click **+ Add a permission**.
3. Select **Microsoft Graph** (the API your app will use).
4. Select **Application permissions** (not delegated — this app runs unattended).
5. Search for and select:
   - `Directory.Read.All` (read directory data)
   - `Application.Read.All` (read app registrations)
6. Click **Add permissions**.

> **Expected result:** The app now has permissions to read directory and application data.

---

### 5. Grant Admin Consent

App permissions require admin approval.

1. Still on the **API permissions** page, look for a button: **"Grant admin consent for [tenant]"** or **"Grant consent"**.
2. Click **Grant admin consent for [your tenant name]**.
3. Confirm the prompt.

> **Expected result:** The status changes to **"✓ Granted for [tenant]"** in green. The app is now authorized.

---

### 6. Verify the App Registration in Audit Logs

1. Navigate to **Microsoft Entra ID** → **Monitoring** → **Audit logs**.
2. Click **Add filters** → **Activity**.
3. Search for: **"App registration created"** or **"Application created"**.
4. Look for your "WorkloadTest-App" entry.

> **Expected result:** Audit log shows the app registration event with timestamp and initiator.

---

### 7. Understand the Service Principal

The app registration creates a linked **service principal** — the instance of the app in your tenant.

1. Go to **Enterprise applications**.
2. Search for **"WorkloadTest-App"**.
3. Click on it to see the service principal details:
   - **Object ID:** Unique identifier for this instance
   - **Assigned roles:** Roles the app has been granted
   - **Permissions:** API permissions you configured

> **Expected result:** You see the service principal linked to your app registration.

---

### 8. Simulate App Authentication (Conceptual)

In a real scenario, your app would now authenticate using the client ID and secret:

```
App authentication flow:
  1. App has: client_id, client_secret
  2. App calls: POST https://login.microsoft.com/[tenant-id]/oauth2/v2.0/token
     with: client_id, client_secret, scope=https://graph.microsoft.com/.default
  3. Entra ID verifies credentials
  4. Entra ID returns: access_token (valid for 1 hour)
  5. App uses token: GET https://graph.microsoft.com/v1.0/applications
     with: Authorization: Bearer [access_token]
  6. Graph API validates token, returns data
  7. Token expires after 1 hour
  8. App repeats step 2 to get a new token
```

For this lab, you don't need to implement the actual code, just understand the flow:
- **No password in code**
- **Tokens are short-lived (1 hour)**
- **Automatic rotation**
- **Full audit trail**

---

### 9. Review App Permissions in Audit Logs

1. Go to **Audit logs** again.
2. Search for: **"App role assignment"**, **"Application consent"**, or **"Permission granted"**.
3. Look for entries showing the permissions you granted to WorkloadTest-App.

> **Expected result:** Audit log shows when permissions were created and who granted them.

---

### ✓ Checkpoint

Verify you've completed this lab:
- [ ] Created a service principal (app registration)
- [ ] Noted the Application (client) ID
- [ ] Generated a client secret
- [ ] Assigned API permissions (Directory.Read.All, Application.Read.All)
- [ ] Granted admin consent
- [ ] Found the app in enterprise applications
- [ ] Verified app registration in audit logs

If any item is unchecked, revisit the steps above.

---

## Summary

You've created your first **workload identity**:
- **Service Principal (WorkloadTest-App)** is now a non-human identity in your tenant
- It has **permissions to read directory data** (confined to what it needs)
- It can authenticate using **client credentials** without storing secrets in code
- All **access is logged** in the audit trail

This is the foundation of modern application security:
- **No secrets in code or config files**
- **Automatic token rotation (hourly)**
- **Least-privilege permissions**
- **Full audit accountability**

---

## Next Steps

→ Proceed to [Lab 12 — B2B External Identities](12-b2b-external-identities.md) to handle partner and vendor access

**Or review:**
- [Audit Logging](../PHASE-3-ENTRA-P2/07-audit-logging-monitoring.md) to see detailed workload identity events
