# Quick Start: Build Your First Identity Lab in 24 Hours

**Target Audience:** Complete beginners to identity who want a working demo in a weekend

**Time Investment:** 24 hours total (or split across 2-3 weekends)
- Reading: 6-8 hours
- Labs: 14-16 hours
- Breaks: 2 hours

**What You'll Build:**
- A complete user provisioning workflow (joiner → mover → leaver)
- Multi-factor authentication (MFA) with real devices
- A hybrid identity system (cloud + on-premises)
- Access governance with automated reviews
- A working incident response playbook

---

## Your 24-Hour Learning Path

### Hour 0-2: Understand Identity (2 hours, Reading)
**Why this first:** Foundation before you build anything

1. Read: `00-iam-landscape-overview.md` (30 min)
   - *Understand:* What is identity? 17 domains overview
   - *Takeaway:* Identity is more than passwords; it's a complete lifecycle

2. Read: `01-user-provisioning-joiner.md` (45 min)
   - *Understand:* How users get access (the "joiner" process)
   - *Takeaway:* Provisioning is complex; automation is key

3. Read: `07-authentication-fundamentals.md` (45 min)
   - *Understand:* How users prove who they are
   - *Takeaway:* Passwords alone are weak; MFA is necessary

**Checkpoint:** You can explain provisioning, authentication, and why both matter.

---

### Hour 2-6: Set Up Your Sandbox (2 hours, Setup + Reading)
**Why this:** You need a safe place to build without affecting production

1. Read: `SANDBOX_SETUP.md` (30 min)
   - *Action:* Set up Azure free tier account (or AWS free tier)
   - *Resources needed:* Email address, credit card (won't be charged)

2. Provision: Azure/AWS infrastructure (1.5 hours)
   - *Action:* Follow SANDBOX_SETUP.md to create test environment
   - *Resources created:* Entra ID instance, Azure subscription, VM for on-premises simulation
   - *Cost:* $0 (free tier) for first 90 days

**Checkpoint:** You have a working Azure subscription with Entra ID access.

---

### Hour 6-12: Build Lab 1 - Complete JML Cycle (6 hours, Hands-On)
**What you'll build:** A complete user lifecycle (hire → move → fire)

**Lab Goal:** Automate provisioning so when HR creates a user, everything happens automatically

1. Read: `18b-provisioning-automation.md` (1 hour)
   - *Understand:* How to automate the joiner/mover/leaver workflow
   - *Key concept:* Workflows vs. processes

2. Run Lab: Joiner Automation (2 hours)
   - Script: `../examples/scripts/01-joiner-automation-basic.sh`
   - *Do:*
     1. Create test user in HR system (simulate)
     2. Watch automation create AD account, email, groups
     3. Verify sign-in works
   - *Expected outcome:* User created + email provisioned in <5 minutes

3. Run Lab: Mover Workflow (2 hours)
   - Script: `../examples/scripts/02-mover-automation.sh`
   - *Do:*
     1. Change user's department (Sales → Engineering)
     2. Watch old access revoked, new access granted
     3. Verify new app access works
   - *Expected outcome:* Access changed automatically in <10 minutes

4. Run Lab: Leaver Offboarding (1 hour)
   - Script: `../examples/scripts/03-leaver-automation.sh`
   - *Do:*
     1. Mark user as terminated
     2. Watch all access disabled, data archived
     3. Verify no access remaining
   - *Expected outcome:* User disabled in <5 minutes, data archived

**Checkpoint:** You understand the complete user lifecycle and can demonstrate it.

---

### Hour 12-18: Build Lab 2 - Multi-Factor Authentication (4 hours, Hands-On)
**What you'll build:** MFA so users need two forms of proof (password + phone)

**Lab Goal:** Require MFA for all users; show how it prevents account takeover

1. Read: `07a-multi-factor-authentication.md` (1 hour)
   - *Understand:* MFA methods: TOTP, SMS, phone call, hardware keys
   - *Key concept:* MFA makes accounts 99% harder to compromise

2. Run Lab: Enable MFA (1.5 hours)
   - Script: `../examples/scripts/04-mfa-enrollment.sh`
   - *Do:*
     1. Set MFA policy (require for all users)
     2. Enroll test user in authenticator app (TOTP)
     3. Test sign-in with password + code
     4. Try sign-in without MFA (should fail)
   - *Expected outcome:* Sign-in requires password + 6-digit code

3. Run Lab: MFA Enforcement (1.5 hours)
   - Script: `../examples/scripts/05-mfa-conditional-access.sh`
   - *Do:*
     1. Create policy: "If risky sign-in → require FIDO2 hardware key"
     2. Simulate risky sign-in (unusual location)
     3. Watch system require stronger MFA
   - *Expected outcome:* Risk-based MFA works automatically

**Checkpoint:** You can explain MFA benefits and demonstrate it working.

---

### Hour 18-24: Build Lab 3 - Hybrid Identity (6 hours, Hands-On)
**What you'll build:** An identity system that works across cloud + on-premises

**Lab Goal:** Show users can sign in to both cloud (Azure) and on-premises (AD) systems

1. Read: `10-hybrid-identity-architecture.md` (1 hour)
   - *Understand:* Three sync models: cloud-only, hybrid, federated
   - *Key concept:* Users have one identity across multiple systems

2. Run Lab: Hybrid Identity Sync (3 hours)
   - Script: `../examples/scripts/06-hybrid-sync-setup.sh`
   - *Do:*
     1. Simulate on-premises AD (test VM with Active Directory)
     2. Install Azure AD Connect sync agent
     3. Configure attribute mapping
     4. Watch users sync from on-premises → cloud
   - *Expected outcome:* User created in AD; appears in Azure in <5 minutes

3. Run Lab: Hybrid Sign-In (2 hours)
   - Script: `../examples/scripts/07-hybrid-signin.sh`
   - *Do:*
     1. Sign in to on-premises system (AD)
     2. Sign in to cloud app (Office 365)
     3. Same credentials work for both
     4. MFA works across both systems
   - *Expected outcome:* Single sign-on works for cloud + on-premises

**Checkpoint:** You understand hybrid identity and can demonstrate seamless SSO.

---

## What's Next After 24 Hours?

**You now have:**
- ✅ A working identity lab environment
- ✅ Understanding of user provisioning
- ✅ MFA protecting accounts
- ✅ Hybrid identity working
- ✅ Confidence to explain identity to others

**Show It Off:**
- Record your labs as a video (20 min)
- Share with team: "Here's how user provisioning automation saves IT 2 days per hire"
- Demo to leadership: "Here's how MFA prevents 99% of breaches"

**Deepen Your Knowledge:**
- **If you care about security:** Read `08-identity-risk-detection.md` + `08b-zero-trust-identity-architecture.md`
- **If you care about compliance:** Read `17-compliance-frameworks-mapping.md` + `17a-identity-governance-administration.md`
- **If you care about cloud:** Read `11-multi-cloud-identity.md` + `15a-entra-workload-federation.md`
- **If you care about everything:** Follow Learning Path 1 (Foundations-First) for complete progression

---

## Troubleshooting Guide

| Problem | Cause | Solution |
|---------|-------|----------|
| Script fails: "Azure subscription not found" | Sandbox not set up | Follow SANDBOX_SETUP.md steps 1-3 |
| User sync stuck (not syncing from AD to Azure) | Azure AD Connect not running | Run `../examples/scripts/06-hybrid-sync-setup.sh` steps 3-4 again |
| MFA sign-in fails (code expired) | TOTP code has 30-sec window | Try sign-in again immediately after opening authenticator |
| Cannot access on-premises AD from cloud | Network/VPN issue | Verify VPN running, check firewall rules in SANDBOX_SETUP.md |
| Lab cost exceeded estimate | Too many resources running | Stop unused VMs in Azure Portal; check SANDBOX_SETUP.md cost section |

---

## What Each Lab Teaches

| Lab | You'll Learn | Why It Matters |
|-----|--------------|----------------|
| **JML Cycle** | How users get + change + lose access | 40% of IT time goes to manual provisioning; automation saves $100K+/year |
| **MFA** | How to prevent unauthorized access | 99.9% of breaches start with compromised passwords; MFA stops them |
| **Hybrid Identity** | How to manage users across cloud + on-premises | 80% of enterprises have hybrid systems; seamless SSO is critical |

---

## Success Criteria

After 24 hours, you should be able to:

1. **Explain to your manager:** "Here's what provisioning automation does, why it matters, and what it costs"
2. **Demonstrate to your team:** A complete user lifecycle (hire → move → fire) in <30 minutes
3. **Show security value:** Enable MFA, show how it blocks compromised accounts
4. **Prove hybrid works:** User signs in to both on-premises + cloud systems
5. **Discuss next steps:** "Here's what maturity level we're at, and what's needed to reach level 3"

---

## FAQ

**Q: I don't have Azure free credits yet. Can I still do this?**
A: Yes. Use AWS free tier instead (see SANDBOX_SETUP.md for AWS steps). Labs work on both.

**Q: Can I do this in fewer hours?**
A: Yes. Skip Lab 3 (hybrid sync) on first pass. You can do Labs 1-2 in 12 hours, then add hybrid later.

**Q: Will my lab work on production? Can I break things?**
A: No, it will NOT work on production. Sandbox is isolated. You cannot break anything production.

**Q: Do I need to be a developer to run these labs?**
A: No. Scripts are all written for non-developers. You'll run commands; you don't need to write code.

**Q: What if a script fails?**
A: See Troubleshooting Guide above. Most issues are sandbox setup. Follow SANDBOX_SETUP.md again.

---

## Resources

- **Sandbox Setup:** `SANDBOX_SETUP.md`
- **All Lab Scripts:** `../examples/scripts/`
- **Lab Scenarios:** `HANDS_ON_LAB_SCENARIOS.md`
- **Lab Index:** `LABS_INDEX.md`
- **Full Knowledge Base:** `./`

---

**You've got this. 24 hours. Three labs. One working identity system. Let's go.**
