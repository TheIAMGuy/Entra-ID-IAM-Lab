# Lab 12 — B2B Guest Access

**Objective:** Invite an external user (partner, vendor, consultant) as a guest, assign them access to a cloud application, verify the guest invitation flow, and review B2B activity in audit logs.

**Time:** 20–25 minutes  
**Difficulty:** Intermediate  
**Cost:** Free

---

## Before You Start

Complete [Lab 11a — Workload Identity Fundamentals](11a-workload-identity-fundamentals.md). You should have created at least one enterprise application.

---

## Background

**B2B (Business-to-Business) Identity** enables external users to access your cloud resources without creating new accounts.

**Use cases:**
- Partner employee needs access to your collaboration platform
- Consultant needs temporary access to development environment
- Vendor needs to view project management tool
- Customer needs access to support portal

**B2B Flow:**
```
1. You invite: partner@partner-company.com
2. Guest receives invitation email
3. Guest signs in with their own identity (Google, Microsoft account, etc.)
4. Guest is added to your tenant as a guest user
5. Guest can access resources you've granted
6. After 90 days of inactivity, guest access expires (configurable)
```

**Key difference from employees:**
- Employees sign in to YOUR organizational account
- Guests sign in with THEIR OWN account (federated from their organization)
- Guests have limited rights by default (read-only, no admin)

---

## Steps

### 1. Invite a Guest User

1. In the Entra ID admin center, go to **Users** → **All users**.
2. Click **+ New guest user** (or **+ Invite user**).
3. **Email address:** Enter an external email address (for testing, use a personal email or test account you can access, e.g., `testguest@gmail.com`)
4. **Display name:** Enter `"Partner Test User"` (or any name)
5. **Send invite immediately:** Check this box (or leave unchecked if you want to invite later)
6. Click **Invite**.

> **Expected result:** The guest is invited. If "Send invite immediately" is checked, they receive an invitation email.

---

### 2. Review the Guest User

1. In the **Users** list, find your newly invited guest.
2. Click on them to open their profile.
3. Note the **User type:** Should show **"Guest"** (not "Member")
4. Note the **External identity source:** Shows where they'll sign in (Microsoft account, Google, etc.)

> **Expected result:** Guest user appears in your tenant with type "Guest".

---

### 3. Assign Guest Access to an Application

Now give the guest permission to use one of your enterprise applications.

1. Go to **Enterprise applications**.
2. Select the app you created in Lab 05 or Lab 11a (e.g., "Test Enterprise App").
3. Go to **Users and groups** (or **Assign users/groups**).
4. Click **+ Add user/group** (or **+ Assign**).
5. Click **None selected** to pick the guest user.
6. Search for and select your guest user: "Partner Test User".
7. Select a **role** (if available):
   - "User" or "Viewer" (read-only)
   - NOT "Admin" (guests shouldn't have admin rights)
8. Click **Assign**.

> **Expected result:** The guest is now assigned to the application with limited privileges.

---

### 4. Simulate Guest Sign-In (Optional)

If you have access to the guest email account, test the sign-in flow:

1. Open a **new incognito/private browser window**.
2. Navigate to the application (e.g., Azure Portal, Office 365, etc.).
3. Sign in with the guest's email address: `testguest@gmail.com`
4. You'll be redirected to the guest's identity provider (Google, Microsoft account, etc.)
5. Sign in with their credentials.
6. You'll be returned to your application.
7. The guest can now access the app based on their assigned role.

> **Expected result:** Guest authentication works. They're federated from their own organization, not signed in to YOUR tenant's account.

---

### 5. Configure Guest Invitation Settings (Optional)

Set policies for how guests are treated:

1. Go to **External Identities** (or **B2B settings**).
2. Look for **Guest user access restrictions**:
   - **Guest users have the same access as members:** (No, for security)
   - **Guest users have limited access:** (Yes, recommended)
3. Set **Guest invitation restrictions:**
   - **Only admins and users assigned the "Guest Inviter" role can invite guests** (recommended)
4. Click **Save**.

> **Note:** These policies enforce that guests are treated as external, not full members.

---

### 6. Review Guest Activity in Audit Logs

1. Navigate to **Microsoft Entra ID** → **Monitoring** → **Audit logs**.
2. Click **Add filters** → **Activity**.
3. Search for: **"Invite external user"**, **"Guest"**, or **"B2B"**.
4. Look for entries like:
   - "Invite external user" (when you invited the guest)
   - "Consent granted for external user"
   - "Guest user access granted"

> **Expected result:** Audit log shows the complete B2B lifecycle (invitation, access grant, sign-in attempts).

---

### 7. Monitor Guest Expiration (Conceptual)

Guests have an expiration date. Review when the guest access will expire:

1. On the guest user profile, find the **Expiration date** field (if set).
2. By default, guests expire after:
   - 90 days of inactivity (if not set to permanent)
   - Or a specific date you configured during invitation

> **Expected result:** You see the guest expiration policy. In production, you'd renew expired guest access or remove it if no longer needed.

---

### ✓ Checkpoint

Verify you've completed this lab:
- [ ] Invited an external guest user
- [ ] Guest user appears in your tenant with type "Guest"
- [ ] Assigned guest access to an enterprise application
- [ ] (Optional) Tested guest sign-in flow
- [ ] Configured guest invitation policies
- [ ] Verified audit log shows B2B activity

If any item is unchecked, revisit the steps above.

---

## Summary

You've implemented **B2B identity management**:
- **Guest users** can access your apps without you creating accounts for them
- Guests sign in with **their own organizational credentials** (federated from their company)
- **Least-privilege access** ensures guests can't accidentally become admins
- **Audit trails** track all guest activity for compliance and investigations

This is essential for modern enterprises that work with partners, vendors, and customers.

---

## Next Steps

→ You've completed Phase 5! Proceed to [Phase 6 — Enterprise Capstone Design](../PHASE-6-CAPSTONE/KEY_DESIGN_DECISIONS.md) to synthesize everything you've learned

**Or review:**
- [Audit Logging](../PHASE-3-ENTRA-P2/07-audit-logging-monitoring.md) for detailed B2B audit events
