# Lab 17a — Set Up Your First Access Review

**Objective:** Configure and run your first access review to validate that users still need their current cloud application access, remove unused access, and document the review for compliance.

**Time:** 30–40 minutes  
**Difficulty:** Intermediate  
**Cost:** Free (access reviews available with Governance license or free trial)

---

## Before You Start

Complete [Phase 3 — Authentication & Access](../PHASE-3-ENTRA-P2/07-audit-logging-monitoring.md). You should have:
- Multiple users created (Labs 01–02)
- Groups set up (Lab 03)
- Application assignments (Lab 05)
- MFA policies configured (Lab 07c)

---

## Background

**Access Review** is the process of periodically asking: *"Does this user still need this access?"*

**Problem it solves:**
- Users accumulate access over time (job changes, projects end, departments shift)
- No one removes old access proactively
- Result: "permission creep" — users have more access than they need
- Compliance auditors require proof that access is justified and current

**Access Review Flow:**
1. **Manager review:** "Does Alice still need Finance role?" → Yes/No
2. **System enforcement:** If "No," remove access
3. **Audit trail:** Document what was approved and what was removed
4. **Attestation:** Manager signs off: "I reviewed and certify this access is appropriate"

---

## Steps

### 1. Navigate to Access Reviews

1. In the Entra ID admin center, go to **Identity** → **Identity Governance** → **Access reviews**.

> **Note:** If this option doesn't appear, your tenant may not have Governance license. Skip to **Step 9 (Simulate)** below.

2. Click **+ New access review** (or **Create access review**).

> **Expected result:** Access review creation form appears.

---

### 2. Name and Describe the Review

1. **Review name:** Enter `"Q3 Cloud Application Access Review"`
2. **Description:** Enter `"Quarterly review of user access to cloud applications and roles to ensure continued business need"`
3. **Review type:** Select **Inclusive of guests** or just **Users** (for this lab, select **Users**)

---

### 3. Select What to Review

1. Under **Select what to review**, choose:
   - **Cloud applications** (to review app-level access)
   - Or **Groups** (to review group memberships)
2. For this lab, select **Cloud applications**.
3. Click **Select applications**.
4. Choose one of the enterprise apps you set up in Lab 05 (e.g., "Test Enterprise App").
5. Click **Select**.

> **Expected result:** The review will cover access to your chosen cloud application.

---

### 4. Designate Reviewers

1. Under **Reviewers**, click **Select reviewers**.
2. Choose **Managers** (if available) or select specific users (e.g., Alice Smith, who has admin rights).
3. Click **Select**.

> **Alternative if "Managers" isn't available:** Select a specific user who will act as the reviewer.

> **Expected result:** Managers (or designated users) are now assigned to review access.

---

### 5. Set Review Schedule

1. **Duration (in days):** Set to `7` (one week — shorter for testing, longer in production: 30 days)
2. **Recurrence:** Set to **Monthly** or **Quarterly** (for testing, "No recurrence" is fine)
3. **Start date:** Set to **Today**

> **Expected result:** The review will run for 7 days starting today.

---

### 6. Configure Auto-Apply Settings

1. Under **Upon completion**, enable:
   - **Auto apply results** (optional, for testing leave unchecked)
   - **If reviewers don't respond** → Select **Remove access** (or **Keep access** — your choice)

> **Note:** "Auto apply" automatically removes access if no action is taken. "Remove access" is stricter; "Keep access" is more conservative.

2. For this lab, leave auto-apply **disabled** so you can manually review results.

---

### 7. Create the Access Review

1. Click **Create**.

> **Expected result:** Access review is created and starts immediately. A confirmation message appears: "Access review 'Q3 Cloud Application Access Review' has been created."

---

### 8. Monitor the Review

Now watch the review in action:

1. You should see the review listed under **Access reviews** with status **In progress** or **Active**.
2. Click on the review name to see **Details**:
   - **Status:** In progress
   - **Reviewers:** (names of assigned reviewers)
   - **Submissions:** How many decisions have been made (likely 0 if just created)

> **Expected result:** The review is running and waiting for reviewer decisions.

---

### 9. Simulate Reviewer Approval (If You're the Reviewer)

If you're also the designated reviewer, complete a review decision:

1. Click on the review again.
2. Look for **"Review decisions"** or **"Respond to review"**.
3. You should see a list of users with their current access to the application:
   - E.g., "Alice Smith: Admin role"
   - "Bob Glasgow: User role"
4. For each user, decide:
   - **Approve** — User should keep this access
   - **Deny** — User should lose this access
5. For testing, **Approve** both users (they genuinely need the access).
6. Add a comment (optional): "Reviewed and confirmed. Both users need this role for their current responsibilities."
7. Click **Save** or **Submit**.

> **Expected result:** Your review decisions are recorded. The review now shows your submission count increased.

---

### 10. Review Audit Log for Access Review Activity

Verify that the access review appears in the audit log:

1. Navigate to **Microsoft Entra ID** → **Monitoring** → **Audit logs**.
2. Click **Add filters** → **Activity**.
3. Search for: **"Access review"**, **"Review completed"**, or **"Access certification"**.
4. Look for entries like:
   - "Access review created"
   - "Access review decision made"
   - "Access review completed"

> **Expected result:** Audit log shows the access review lifecycle events (creation, decisions, completion).

---

### ✓ Checkpoint

Verify you've completed this lab:
- [ ] Created an access review for a cloud application
- [ ] Assigned reviewers (managers or designate users)
- [ ] Set review duration and schedule
- [ ] Started the review
- [ ] (If reviewer) Approved/denied access decisions
- [ ] Verified audit log shows review activity

If any item is unchecked, revisit the steps above.

---

## Summary

You've implemented **access governance** — the process of regularly validating that users still need their access:
- **Quarterly access review** ensures access aligns with current business needs
- **Manager attestation** creates accountability and compliance proof
- **Audit trail** documents all decisions for auditors and investigations

This is a compliance requirement for SOC 2, ISO 27001, HIPAA, and PCI DSS certifications.

---

## Next Steps

→ You've completed Phase 4 fundamentals! Proceed to [Phase 5 — Specialist Identity](../PHASE-5-SPECIALIST/11a-workload-identity.md)

**Or review:**
- [Audit Logging](../PHASE-3-ENTRA-P2/07-audit-logging-monitoring.md) for detailed access review audit entries
