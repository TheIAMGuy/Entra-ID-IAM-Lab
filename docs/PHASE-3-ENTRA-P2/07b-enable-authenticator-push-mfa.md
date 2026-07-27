# Lab 07b — Authenticator App Push Notifications

**Objective:** Configure Microsoft Authenticator push notification-based MFA as an alternative to TOTP codes, compare user experience, and test approval flow.

**Time:** 20–25 minutes  
**Difficulty:** Intermediate  
**Cost:** Free

---

## Before You Start

Complete [Lab 07a — Configure TOTP-Based MFA](07a-configure-totp-mfa.md). You'll have at least one user (Alice Smith) with MFA already enabled.

---

## Background

While TOTP codes are secure, push notifications offer **better user experience**:
- No need to manually type codes
- No 30-second countdown pressure
- Single tap to approve or deny
- Faster sign-in (2–3 seconds vs. 30+ seconds for TOTP)

With push notifications, the Authenticator app sends a **notification to your phone**: "Approve sign-in from Seattle, WA?" → User taps **Approve** → Sign-in succeeds instantly.

---

## Steps

### 1. Configure Microsoft Authenticator for Push Notifications

As Alice Smith (already set up with TOTP), configure push notifications as an alternative MFA method.

1. Navigate to **https://myaccount.microsoft.com** (signed in as Alice).
2. Go to **Security info** → **Add method** (or **+ Add sign-in method**).
3. Select **Authenticator app**.
4. Click **Add**.
5. Scan the QR code with Authenticator app (or add manually if this is a second registration).
   - The app should show both the TOTP codes (from Lab 07a) and push notification capability.
6. In Authenticator app settings, ensure:
   - **Phone sign-in** is enabled (or **Passwordless sign-in** if available)
   - Or at minimum, **Require approval** is enabled so push notifications are used

> **Expected result:** Microsoft Authenticator is now configured for both TOTP and push notifications for Alice Smith.

---

### 2. Test Push Notification Sign-In

Now test signing in with push notification approval instead of typing TOTP.

1. Sign out of **myaccount.microsoft.com**.
2. Navigate to **https://portal.azure.com** again.
3. Sign in as Alice Smith:
   - Email: alice.smith@yourtenant.onmicrosoft.com
   - Password: (her password)
4. After password entry, you'll see: **"How do you want to sign in?"**
   - Select **Authenticator app** or **Microsoft Authenticator**.
5. **On your phone** (or Authenticator):
   - You should see a **notification** or **in-app prompt**: **"Approve sign-in?"**
   - Shows location and time: "Approve sign-in to Microsoft Azure from Seattle, WA at 3:42 PM?"
6. Tap **Approve** in the Authenticator app.
7. Within 2–3 seconds, you should be signed in to Azure Portal.

> **Expected result:** Sign-in succeeded with a single tap. No code entry needed. This is the superior user experience compared to TOTP.

---

### 3. Compare Push vs. TOTP (Optional Exercise)

To understand the difference, test TOTP sign-in again:

1. Sign out of Azure Portal.
2. Sign in again, but this time select **"Enter code instead"** (if that option appears).
3. Go to Authenticator → find the TOTP code for alice.smith@yourtenant.onmicrosoft.com.
4. Manually enter the six-digit code.
5. You're signed in, but notice: **Took longer** (typing + time pressure) vs. **Push** (single tap, instant).

> **Observation:** Push notifications are significantly faster and more user-friendly.

---

### 4. Test Denial (Reject Sign-In Attempt)

Test what happens when a user **denies** a sign-in request (e.g., if someone else is trying to sign in as them).

1. From a different browser (or incognito), navigate to **https://portal.azure.com**.
2. Attempt to sign in as Alice Smith:
   - Email: alice.smith@yourtenant.onmicrosoft.com
   - Password: (her password)
3. On your phone, **Authenticator shows notification**: **"Approve sign-in?"**
4. This time, tap **Deny** or **Reject**.
5. The sign-in attempt should **fail** with an error: **"Sign-in was denied"** or **"MFA authentication failed"**.

> **Expected result:** Denying the sign-in blocks access. This prevents unauthorized sign-in even if the attacker has the password.

---

### 5. Verify MFA Approval Activity in Audit Logs

Check the audit log for push notification approval/denial activity.

1. As an admin (or signed back in as an admin), navigate to **Microsoft Entra ID** → **Monitoring** → **Audit logs**.
2. Click **Add filters** → **Activity**.
3. Search for: **"MFA"**, **"Authenticator"**, or **"Push notification"**.
4. Look for entries like:
   - "MFA credential validated (push notification approved)"
   - "MFA authentication denied"
   - "Sign-in activity with MFA"

> **Expected result:** Audit log shows both successful MFA approvals and any denials.

---

### ✓ Checkpoint

Verify you've completed this lab:
- [ ] Authenticator app is configured for push notifications on at least one user
- [ ] You successfully signed in using push notification approval (single tap)
- [ ] You tested denying a sign-in attempt
- [ ] Audit log shows MFA approval/denial activity

If any item is unchecked, revisit the steps above.

---

## Summary

You've now tested two MFA methods:
- **TOTP:** Secure, offline, but requires manual code entry (30-second window)
- **Push Notifications:** User-friendly, fast (2–3 seconds), requires device possession

In production, organizations typically support both methods:
- Power users choose push notifications for speed
- Users without smartphone access can use TOTP
- Security teams can enforce whichever method fits their risk profile

---

## Next Steps

→ Proceed to [Lab 07c — Create Your First Conditional Access Policy](07c-conditional-access-policy.md) to enforce MFA organization-wide

**Or jump to:**
- [Audit Logging](07-audit-logging-monitoring.md) to deep-dive into compliance trails
