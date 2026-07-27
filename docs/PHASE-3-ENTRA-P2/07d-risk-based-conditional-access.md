# Lab 07d — Risk-Based Conditional Access

**Objective:** Create a Conditional Access policy that enforces MFA only when sign-in risk is detected, allowing low-risk sign-ins through without MFA friction.

**Time:** 25–30 minutes  
**Difficulty:** Intermediate–Advanced  
**Cost:** Free (risk detection available in free tier)

---

## Before You Start

Complete [Lab 07c — Create Your First Conditional Access Policy](07c-conditional-access-policy.md). You'll have an MFA enforcement policy already in place.

---

## Background

**Lab 07c** requires MFA for *every* sign-in. But this creates friction:
- Familiar sign-in from home office at 9 AM: **Low risk** → Doesn't need MFA
- Suspicious sign-in from unknown country at 2 AM: **High risk** → Should require MFA

**Risk-Based Conditional Access** evaluates sign-in risk in real-time and only requires MFA when needed. This improves **both security and user experience**.

### Risk Signals

Entra ID automatically evaluates these signals:
- **Anonymous IP:** Tor, VPN, proxy usage
- **Atypical travel:** Geographically impossible or unusual
- **Unfamiliar properties:** Device, browser, OS you haven't seen before
- **Malware-linked IP:** IP known to distribute malware
- **Credential leak indicators:** Your password found in breach databases

### Risk Levels

- **Low:** Familiar device, familiar location, normal behavior → Allow without MFA
- **Medium:** Some odd signals → Require MFA
- **High:** Multiple signals or leaked credentials → Require MFA + device compliance

---

## Steps

### 1. Understand Your Current Policy

Before creating a risk-based policy, review your existing MFA policy from Lab 07c:

1. Go to **Security** → **Conditional Access**.
2. Click on **"Require MFA for cloud applications"** (from Lab 07c).
3. Note the current state: It requires MFA **for all sign-ins** with no conditions.

> **Observation:** This is broad. A risk-based approach would be more nuanced.

---

### 2. Create a Risk-Based Policy

Now create a more sophisticated policy: **"Require MFA for high-risk sign-ins"**.

1. Click **+ New policy**.
2. Name it: **"Require MFA for high-risk sign-ins"**

---

### 3. Set Assignments (Who)

1. Click **Users and groups** → **Include** → **All users** → **Done**.
2. Click **Cloud apps or actions** → **Include** → **All cloud apps** → **Done**.

---

### 4. Add Risk-Based Condition

This is the key difference: we're adding a **sign-in risk condition**.

1. Under **Conditions**, click **Sign-in risk** (or **User risk**).
2. Select **Include** → **High** (and optionally **Medium** if you want to be stricter).

> **What this means:** This policy only triggers when sign-in risk is evaluated as "High".

3. Click **Done**.

> **Expected result:** The policy now has a condition: "Sign-in risk is High".

---

### 5. Set Grant Control (Require MFA)

1. Under **Access controls**, click **Grant**.
2. Select **Require multi-factor authentication**.
3. Click **Select**.

---

### 6. Set Policy State to Report-Only

1. Change the policy state to **Report only** (not enabled yet).
2. Click **Create**.

> **Why report-only?** Risk signals may not be available in your lab environment yet. Report-only lets you see what would trigger.

---

### 7. (Optional) Test Risk Simulation

If your tenant supports it, simulate a risky sign-in to test the policy:

1. Sign in from a **VPN or proxy** (creates "anonymous IP" risk signal).
2. Or sign in at an **unusual time** (e.g., 3 AM if you normally sign in at 9 AM).
3. Observe if the policy is triggered (in report-only mode, it won't block, but will log the event).

> **Note:** Risk signals may take time to populate. If you don't see risk events immediately, that's normal in a lab.

---

### 8. Verify Risk Signals in Audit Log

Check if any risk signals have been detected for your test users:

1. Go to **Microsoft Entra ID** → **Monitoring** → **Audit logs**.
2. Click **Add filters** → **Activity**.
3. Search for: **"Risk"**, **"Risk detected"**, or **"Anonymous IP"**.
4. Look for entries like:
   - "Sign-in from anonymous IP detected"
   - "Atypical travel detected"
   - "Risky sign-in activity"

> **Expected result:** If any risk signals exist, they'll appear here. Even in a lab, you may see some detections over time.

---

### 9. Review the Two Policies Together

Now you have two policies working in tandem:

1. Go to **Security** → **Conditional Access** → view both policies:
   - **"Require MFA for cloud applications"** (Lab 07c) — Requires MFA for ALL sign-ins
   - **"Require MFA for high-risk sign-ins"** (This lab) — Requires MFA only for HIGH-risk sign-ins

2. Understand how they interact:
   - Policy 1 (Lab 07c) is broad: ALL cloud app sign-ins need MFA
   - Policy 2 (This lab) is targeted: Only HIGH-risk events need MFA

> **In production:** You'd typically use Policy 2 (risk-based) and disable Policy 1 (blanket MFA) to reduce friction. But for this lab, keeping both shows how layered security works.

---

### 10. Enable the Risk-Based Policy

Once you've reviewed the report-only activity:

1. Click on **"Require MFA for high-risk sign-ins"**.
2. Change policy state from **Report only** to **Enabled**.
3. Click **Save**.

> **Expected result:** The policy is now active. High-risk sign-ins will require MFA automatically.

---

### ✓ Checkpoint

Verify you've completed this lab:
- [ ] Created a Conditional Access policy based on sign-in risk
- [ ] Policy was set to "high-risk" condition (not all sign-ins)
- [ ] Policy was tested in report-only mode
- [ ] Policy was then enabled
- [ ] Audit log shows any risk-detection activity (if available)

If any item is unchecked, revisit the steps above.

---

## Summary

You've now implemented **adaptive authentication**:
- **Policy 1** (Lab 07c): Broad MFA requirement (all cloud apps)
- **Policy 2** (This lab): Risk-based MFA (only high-risk sign-ins)

In production, organizations would:
- Use **risk-based policy** as the primary enforcement (better UX)
- Add **broad MFA policy** as a fallback for users without risk signals
- Monitor and tune both policies based on false positives and actual attacks

This is the modern standard for balancing **security** (catch risky sign-ins) and **usability** (don't block safe sign-ins).

---

## Next Steps

→ You've completed Phase 3! Proceed to [Phase 4 — Identity Governance](../PHASE-4-GOVERNANCE/17a-identity-governance-administration.md)

**Or review:**
- [Audit Logging](07-audit-logging-monitoring.md) for a complete audit trail of all MFA and CA activity
