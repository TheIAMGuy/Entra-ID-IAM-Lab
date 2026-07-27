# Lab 07a — Configure TOTP-Based MFA

**Objective:** Enable Time-Based One-Time Password (TOTP) multi-factor authentication using Microsoft Authenticator, configure MFA enforcement for users, and verify MFA is working end-to-end.

**Time:** 20–25 minutes  
**Difficulty:** Intermediate  
**Cost:** Free (P2 features available in free tier)

---

## Before You Start

Ensure you have completed [Lab 07 — Audit Logging & Monitoring](07-audit-logging-monitoring.md). You'll need at least two test users from Labs 01–02 (e.g., Alice Smith and Bob Glasgow) to test MFA enforcement.

---

## Background

Multi-Factor Authentication (MFA) requires users to prove their identity using *two or more factors*:
1. **Something you know** — Password
2. **Something you have** — Phone with authenticator app
3. **Something you are** — Biometric (fingerprint, face)

TOTP (Time-Based One-Time Password) uses an authenticator app (Microsoft Authenticator, Google Authenticator) to generate six-digit codes that change every 30 seconds. The app works offline — no internet needed to generate codes.

**Why TOTP?**
- ✓ Most secure of simple MFA methods
- ✓ No cost to users (app is free)
- ✓ Works offline
- ✓ No SIM swap vulnerability (unlike SMS)

---

## Steps

### 1. Enable MFA via Azure AD Portal (Admin Setup)

In this step, you'll enable MFA enforcement for your test users.

1. In the Entra ID admin center, navigate to **Microsoft Entra ID** → **Security** → **MFA**.
2. Click **Get started** or **Fraud alerts** (depending on your version).

> **Note:** If you see "Multifactor authentication" under Security, click it.

3. In the MFA settings page, look for **Per-user MFA** (legacy approach) or **Conditional Access** (modern approach).
   - **For this lab:** Use **Per-user MFA** to keep it simple.

4. Click **Per-user MFA** and select your test users:
   - Alice Smith
   - Bob Glasgow
5. Check the **ENABLED** checkbox next to each user.
6. Click **Save**.

> **Expected result:** Alice and Bob now have MFA enabled. Their status shows "Enabled" in the per-user MFA list.

---

### 2. Register TOTP in Microsoft Authenticator (User Setup)

Now you'll simulate user registration. Sign in as one of your test users (Alice Smith) and register TOTP.

1. Open a new browser tab and navigate to **https://myaccount.microsoft.com** (or **https://aka.ms/mysecurityinfo**).
2. Sign in as **Alice Smith** (alice.smith@yourtenant.onmicrosoft.com).
3. You'll be prompted with: **"More information required"** → Select **Next**.
4. You'll see options to add an authentication method:
   - Select **Authenticator app** (or **Microsoft Authenticator**).
5. Click **Download and install the Microsoft Authenticator app**.
   - If you're testing on your phone: Download Microsoft Authenticator from your app store.
   - If testing on desktop: You can use a simulator or describe the flow.

6. In the Authenticator app on your phone (or simulator):
   - Open the app → **+** (Add account) → **Work or school account**
   - Scan the QR code shown on **myaccount.microsoft.com**.
   - Or enter the setup key manually if QR code doesn't work.

7. The app generates six-digit codes every 30 seconds.
8. Back on **myaccount.microsoft.com**, enter the current six-digit code from Authenticator.
9. Click **Next** or **Verify**.

> **Expected result:** TOTP is now registered. Authenticator app shows: "yourtenant.onmicrosoft.com — alice.smith@yourtenant.onmicrosoft.com" with a live six-digit code updating every 30 seconds.

---

### 3. Test MFA Sign-In

Now test that MFA actually requires the TOTP code at sign-in.

1. Sign out of **myaccount.microsoft.com**.
2. Navigate to **https://portal.azure.com** (Azure Portal).
3. Sign in as Alice Smith:
   - Email: alice.smith@yourtenant.onmicrosoft.com
   - Password: (her password)
4. After entering the password, you'll see: **"More information required"** → **Next**.
5. The portal will ask: **"How do you want to sign in?"**
   - Select **Authenticator app** (or **Microsoft Authenticator**).
6. Look at the Authenticator app on your phone:
   - It should show a notification: **"Approve sign-in request?"**
   - Or display the current six-digit TOTP code.
7. **If push notification:** Tap **Approve** in the app.
   - **If TOTP code:** Enter the six-digit code from the app.
8. You should now be signed in to Azure Portal.

> **Expected result:** MFA required the second factor (TOTP or push) before granting access. Sign-in successful.

---

### 4. Verify MFA in Audit Logs

Verify that the MFA authentication appears in the audit log.

1. Still signed in as Alice Smith, navigate to **Microsoft Entra ID** → **Monitoring** → **Audit logs**.
2. Click **Add filters** → **Activity**.
3. Search for: **"MFA"** or **"Multi-factor"**.
4. Look for entries like:
   - "MFA credential validated"
   - "MFA authentication successful"
   - Or "Sign-in activity with MFA"

> **Expected result:** Audit log shows MFA activity for Alice Smith's recent sign-in.

---

### ✓ Checkpoint

Verify you've completed this lab:
- [ ] MFA is enabled for at least two test users (Alice & Bob)
- [ ] TOTP is registered in Authenticator app for at least one user
- [ ] You successfully signed in to Azure Portal using TOTP MFA
- [ ] Audit log shows MFA activity for the sign-in

If any item is unchecked, revisit the steps above.

---

## Summary

You've successfully configured and tested TOTP-based MFA:
- **Alice Smith** is now protected by MFA (TOTP via Authenticator)
- Every sign-in requires a valid six-digit code from her phone
- All MFA activity is logged in the audit trail (compliance proof)

This is the foundation of modern access control: users can no longer be compromised by password theft alone.

---

## Next Steps

→ Proceed to [Lab 07b — Authenticator App Push Notifications](07b-enable-authenticator-push-mfa.md)

**Or jump to:**
- [Lab 07c — Create Your First Conditional Access Policy](07c-conditional-access-policy.md) if you want to enforce MFA organization-wide
- [Audit Logging](07-audit-logging-monitoring.md) to review more MFA events
