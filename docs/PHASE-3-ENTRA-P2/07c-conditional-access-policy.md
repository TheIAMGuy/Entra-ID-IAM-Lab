# Lab 07c — Create Your First Conditional Access Policy

**Objective:** Build your first Conditional Access policy to require MFA for all cloud application sign-ins, test the policy in report mode, then enable it.

**Time:** 25–30 minutes  
**Difficulty:** Intermediate  
**Cost:** Free (CA available in free tier)

---

## Before You Start

Complete [Lab 07a — Configure TOTP-Based MFA](07a-configure-totp-mfa.md) or [Lab 07b — Authenticator Push MFA](07b-enable-authenticator-push-mfa.md). You'll have MFA enabled for at least one user (Alice Smith).

---

## Background

**Conditional Access (CA)** is the modern way to enforce MFA at scale. Instead of enabling MFA per-user manually, you create a **policy** that automatically requires MFA based on conditions:

```
IF (user signs in) AND (user = in a specific group) AND (app = cloud apps)
THEN (require MFA)
```

**Why CA over per-user MFA?**
- ✓ Scales automatically (new hires inherit the policy)
- ✓ Flexible conditions (by location, device, risk, time of day)
- ✓ Report-only mode (test before enforcement)
- ✓ Modern best practice (per-user MFA is deprecated)

---

## Steps

### 1. Navigate to Conditional Access

1. In the Entra ID admin center, go to **Security** → **Conditional Access**.
2. Click **+ New policy** (or **Create new policy**).

> **Expected result:** You see a blank policy form with sections: Name, Assignments, Conditions, Access Controls, and Session.

---

### 2. Name Your Policy

1. In the **Name** field, enter: **"Require MFA for cloud applications"**

---

### 3. Define Assignments (Who)

**Assignments** define which users and applications the policy applies to.

#### Users or workload identities

1. Under **Assignments**, click **Users and groups** (or **Users**).
2. Select **Include** → **All users** (for this lab, we're testing on all users).

> **Note:** In production, you'd exclude emergency break-glass accounts and service accounts. For now, "All users" is fine for testing.

3. Click **Done**.

> **Expected result:** The policy shows "Include: All users".

#### Cloud apps or actions

1. Under **Assignments**, click **Cloud apps or actions**.
2. Select **Include** → **All cloud apps**.

> **Note:** This means the policy applies when users sign in to ANY cloud application (Office 365, Azure Portal, SaaS apps, etc.).

3. Click **Done**.

> **Expected result:** The policy shows "Include: All cloud apps".

---

### 4. Set Access Control (Require MFA)

1. Under **Access controls**, click **Grant** (or **Grant access**).
2. Select **Require multi-factor authentication**.
3. Leave other options unchecked (no device compliance required for this lab).
4. Click **Select**.

> **Expected result:** The policy now requires MFA for all included users and apps.

---

### 5. Set Policy State to Report-Only (Test Mode)

**IMPORTANT:** Before enabling, set the policy to **Report-only** to test without blocking anyone.

1. At the bottom of the form, look for **Enable policy** or **Policy state**.
2. Select **Report only** (or leave as **Off**, depending on your UI).

> **This is critical:** Report-only mode lets you see what would be affected WITHOUT actually enforcing the policy yet.

3. Click **Create** or **Save**.

> **Expected result:** The policy is created in report-only mode. No users are blocked yet.

---

### 6. Test the Policy (Sign-In & Verify)

Now test that the policy would trigger (without actually enforcing it yet).

1. Open a new incognito/private browser window.
2. Navigate to **https://portal.azure.com**.
3. Sign in as Alice Smith:
   - Email: alice.smith@yourtenant.onmicrosoft.com
   - Password: (her password)
4. MFA should be **required** (since your policy triggers).
5. Complete the MFA challenge (TOTP code or push notification approval).
6. You should be signed in to Azure Portal.

> **Expected result:** MFA was required even though Alice has MFA already enabled. This confirms the Conditional Access policy is working.

---

### 7. Review Report-Only Activity

Check the Conditional Access report to see what the policy is doing.

1. Go back to **Security** → **Conditional Access**.
2. Click on your policy: **"Require MFA for cloud applications"**.
3. Look for **Insights and reporting** or **Report-only activity**.
4. Click **Insights** or **View report**.

> **Note:** Report data may take a few minutes to populate. You may see: "X sign-in attempts would have been blocked" or "X sign-in attempts matched this policy".

> **Expected result:** The report shows that Alice Smith's sign-in attempt matched this policy (would have required MFA).

---

### 8. Enable the Policy for Real

Once you've confirmed the policy works correctly in report-only mode, enable it.

1. Back on the policy page, change the state from **Report only** to **Enabled** (or **On**).
2. Click **Save**.

> **Expected result:** The policy is now active and will enforce MFA for all cloud app sign-ins.

---

### 9. Verify Policy is Active

Test one more sign-in to confirm the policy is enforcing.

1. Open a new incognito window.
2. Sign in to **https://portal.azure.com** as Alice Smith.
3. After password entry, you'll be required to complete MFA (Authenticator push or TOTP).
4. Approve MFA.
5. You're signed in.

> **Expected result:** MFA is now **enforced** by the Conditional Access policy (not just per-user setting).

---

### ✓ Checkpoint

Verify you've completed this lab:
- [ ] Created a Conditional Access policy requiring MFA for cloud apps
- [ ] Policy was tested in report-only mode first
- [ ] Policy was then enabled for real
- [ ] Successfully tested sign-in with MFA enforcement
- [ ] Audit log shows Conditional Access policy activity

If any item is unchecked, revisit the steps above.

---

## Summary

You've deployed your first Conditional Access policy:
- **"Require MFA for cloud applications"** now protects all cloud sign-ins
- All users must complete MFA (TOTP, push notification, or other method) when signing in
- The policy will automatically apply to new users and new cloud apps

This is the modern standard for MFA deployment: policy-based, scalable, and auditable.

---

## Next Steps

→ Proceed to [Lab 07d — Risk-Based Conditional Access](07d-risk-based-conditional-access.md) to add intelligence to your policies

**Or jump to:**
- [Audit Logging](07-audit-logging-monitoring.md) to review all MFA and CA activity
- [Phase 4 — Identity Governance](../PHASE-4-GOVERNANCE/17a-identity-governance-administration.md) for access review and governance
