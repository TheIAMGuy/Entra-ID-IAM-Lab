# Entra ID Cloud Identity & Access Management Lab

Welcome! This hands-on lab will help you master enterprise Identity and Access Management (IAM) using Microsoft Entra ID. Whether you're new to identity or an experienced architect, you'll build a production-aligned IAM environment, progressing from fundamentals to enterprise-scale governance.

## What is This Lab?

This is a **progressive, hands-on learning journey** through complete enterprise IAM. You'll implement the full **Joiner-Mover-Leaver (JML) lifecycle**, **group-based RBAC**, **privileged access management**, **enterprise application provisioning**, **compliance audit logging**, and advanced governance — the same workflows IAM teams use in production.

The lab is organised in **6 phases**, progressing from free-tier foundations to enterprise-scale identity governance. Each phase builds on the previous one, with optional deep dives for specialists.

## Why Learn Enterprise IAM Here?

- 🔐 **Industry-Standard Practices** — Real-world IAM patterns aligned with enterprise standards (NIST, SOC 2, ISO 27001)
- 📚 **Progressive Learning** — Start simple, build complexity—no overwhelming everything at once
- 🚀 **Complete Lifecycle** — Master the full Joiner-Mover-Leaver identity workflow
- 👥 **Hands-On Access Control** — Group-based RBAC and delegated administration you can use immediately
- 📋 **Compliance Ready** — Audit logging and traceability for real compliance frameworks
- 🎯 **Portfolio Project** — Enterprise capstone project you can showcase
- ☁️ **Cloud-Native** — Modern cloud identity using Microsoft Entra ID

## The 6-Phase Progression

```
Phase 1: Free Tier          → Basic users, groups, RBAC (no cost)
         ↓
Phase 2: Entra ID P1        → Privileged access, applications, lifecycle
         ↓
Phase 3: Entra ID P2        → MFA, risk, conditional access
         ↓
Phase 4: Identity Governance → Access reviews, entitlement mgmt
         ↓
Phase 5: Specialist Identity → Workload, B2B, verified ID
         ↓
Phase 6: Enterprise Capstone → Design a complete enterprise system
```

---

## Getting Started Now

### First Time With IAM?
**Start here:** [Phase 1: Environment Setup](docs/PHASE-1-FREE-TIER/01-environment-setup.md)
- ~2 hours
- Free tier compatible
- No IAM experience required

### Already Know IAM Basics?
**Jump here:** [Phase 3: Authentication & Risk](docs/PHASE-3-ENTRA-P2/07-audit-logging-monitoring.md)
- Skip Phase 1-2 if you have tenant experience
- Build MFA and risk intelligence skills

### Building a Portfolio Project?
**Head here:** [Phase 6: Enterprise Capstone](docs/PHASE-6-CAPSTONE/KEY_DESIGN_DECISIONS.md)
- Design a complete enterprise IAM system
- Integrate Phases 1-5 into one cohesive architecture

### Need This NOW (2-Hour Fast Path)?
**Quick start:** [QUICKSTART.md](docs/REFERENCE/QUICKSTART.md)
- Essential commands only
- Experienced-only; skips concepts

---

## Learning Paths

Choose your path and follow the links in order:

### **Path 1: First-Time IAM Learner**
1. [Phase 1: Environment Setup](docs/PHASE-1-FREE-TIER/01-environment-setup.md)
2. [Phase 1: Identity Provisioning](docs/PHASE-1-FREE-TIER/02-identity-provisioning-joiner.md)
3. [Phase 1: Group-Based RBAC](docs/PHASE-1-FREE-TIER/03-group-based-access-control.md)
4. [Phase 2: Privileged Access](docs/PHASE-2-ENTRA-P1/04-privileged-access-management.md)
5. [Phase 2: Application Access](docs/PHASE-2-ENTRA-P1/05-application-access-management.md)
6. [Phase 3: Audit & Monitoring](docs/PHASE-3-ENTRA-P2/07-audit-logging-monitoring.md)
7. [Phase 6: Capstone Design](docs/PHASE-6-CAPSTONE/KEY_DESIGN_DECISIONS.md)

**Estimated time:** 12–16 hours  
**Best for:** Identity newcomers, students, people transitioning into IAM

---

### **Path 2: Experienced Identity Person**
1. [QUICKSTART.md](docs/REFERENCE/QUICKSTART.md) — Refresh on Entra specifics
2. [Phase 2: Privileged Access](docs/PHASE-2-ENTRA-P1/04-privileged-access-management.md)
3. [Phase 3: MFA & Risk](docs/PHASE-3-ENTRA-P2/07a-multi-factor-authentication.md)
4. [Phase 4: Identity Governance](docs/PHASE-4-GOVERNANCE/17a-identity-governance-administration.md)
5. [Phase 5: Workload Identity](docs/PHASE-5-SPECIALIST/11a-workload-identity.md)
6. [Phase 6: Capstone Design](docs/PHASE-6-CAPSTONE/KEY_DESIGN_DECISIONS.md)

**Estimated time:** 6–8 hours  
**Best for:** Identity architects, consultants, people familiar with IAM concepts

---

### **Path 3: Building a Enterprise IAM Portfolio Project**
1. Start with [Phase 6 Capstone](docs/PHASE-6-CAPSTONE/KEY_DESIGN_DECISIONS.md) to understand enterprise requirements
2. Go back and work through Phases 1–5 in order
3. Document your implementation decisions
4. Record screenshots and create a portfolio write-up

**Estimated time:** 20–24 hours (includes documentation)  
**Best for:** Career transitions, job interviews, demonstrating hands-on experience

---

### **Path 4: Deep-Dive Specialist Track**
Pick a specialty and explore:

**OAuth, SAML, SCIM (Modern Authentication):**
1. [Phase 2: Identity Standards](docs/PHASE-2-ENTRA-P1/DEEP-DIVES/09-identity-standards-overview.md)
2. [SAML SSO](docs/PHASE-2-ENTRA-P1/DEEP-DIVES/09a-saml-single-sign-on.md)
3. [OAuth & OIDC](docs/PHASE-2-ENTRA-P1/DEEP-DIVES/09b-oauth-and-openid-connect.md)
4. [SCIM Provisioning](docs/PHASE-2-ENTRA-P1/DEEP-DIVES/09c-scim-provisioning.md)

**Zero Trust & Risk (Advanced Security):**
1. [Phase 3: Identity Risk Detection](docs/PHASE-3-ENTRA-P2/DEEP-DIVES/08-identity-risk-detection.md)
2. [Zero Trust Architecture](docs/PHASE-3-ENTRA-P2/DEEP-DIVES/08b-zero-trust-identity-architecture.md)
3. [Conditional Access](docs/PHASE-3-ENTRA-P2/07c-adaptive-authentication.md)

**Workload & Application Identity (Cloud-Native):**
1. [Phase 5: Workload Identity](docs/PHASE-5-SPECIALIST/11a-workload-identity.md)
2. [Managed Identities](docs/PHASE-5-SPECIALIST/DEEP-DIVES/15-managed-identities.md)
3. [Workload Federation](docs/PHASE-5-SPECIALIST/DEEP-DIVES/15a-entra-workload-federation.md)

---

## Documentation Structure

### Core (Main Learning Path)
Each phase has 1–3 **core** documents plus optional deep-dives:

- **PHASE-1-FREE-TIER/** — Foundations: setup, users, groups, RBAC
  - **CORE ONLY:** Setup, provisioning, RBAC (~2–3 hours, no deep-dives)
  
- **PHASE-2-ENTRA-P1/** — Application lifecycle, provisioning, standards
  - **CORE:** PAM, applications, identity lifecycle
  - **DEEP-DIVES:** SAML, OAuth, SCIM, hybrid identity, delegation
  
- **PHASE-3-ENTRA-P2/** — Security & audit: MFA, risk, conditional access
  - **CORE:** Audit, MFA, adaptive auth
  - **DEEP-DIVES:** Passwordless auth, risk detection, zero trust, incident response
  - ⚠️ **CRITICAL:** Microsoft mandating MFA for all sign-ins October 1, 2025. Plan your rollout now.
  
- **PHASE-4-GOVERNANCE/** — Advanced governance: access reviews, entitlement mgmt
  - **CORE:** Identity governance administration
  - **DEEP-DIVES:** Self-service, analytics, compliance, migration
  - ⭐ **NEW:** Non-Human Identity (NHI) governance—extend reviews to service principals, workloads, API keys
  
- **PHASE-5-SPECIALIST/** — Specialists: workload identity, B2B, verified ID
  - **CORE:** Workload identity (OIDC federation preferred), B2B external identities
  - **DEEP-DIVES:** Managed identities, workload federation, B2C/CIAM, certificates
  - ⚠️ **UPDATE:** Azure AD B2C end-of-sale May 1, 2025 → migrate to Microsoft Entra External ID for customers
  
- **PHASE-6-CAPSTONE/** — Enterprise design patterns and capstone project
  - **CORE:** Key design decisions, capstone project
  - **DEEP-DIVES:** NIST/Gartner frameworks, maturity assessment

### Reference
Cross-cutting docs (not phase-specific):
- [IAM_GLOSSARY.md](docs/REFERENCE/IAM_GLOSSARY.md) — Definitions of all IAM terms
- [CONCEPT_INDEX.md](docs/REFERENCE/CONCEPT_INDEX.md) — Find concepts across phases
- [LABS_INDEX.md](docs/REFERENCE/LABS_INDEX.md) — Master index of all content
- [HANDS_ON_LAB_SCENARIOS.md](docs/REFERENCE/HANDS_ON_LAB_SCENARIOS.md) — Scenario-based exercises
- [FURTHER_READING.md](docs/REFERENCE/FURTHER_READING.md) — External resources

---

## Key Concepts at a Glance

| Concept | Where You Learn It | Why It Matters |
|---------|-------------------|-----------------|
| **Joiner-Mover-Leaver (JML)** | Phase 1–2 | Core identity lifecycle in every enterprise |
| **Group-Based RBAC** | Phase 1 | How access control scales without chaos |
| **Privileged Access Management (PAM)** | Phase 2 | Securing admin accounts (highest-risk) |
| **Multi-Factor Authentication (MFA)** | Phase 3 | Beyond passwords; preventing account takeovers |
| **Conditional Access** | Phase 3 | Risk-based access decisions in real time |
| **Access Reviews** | Phase 4 | Compliance: who *should* still have access? |
| **Identity Governance** | Phase 4 | Automating access decisions at scale |
| **Workload Identity** | Phase 5 | Apps & services authenticating securely |
| **B2B & External Identity** | Phase 5 | Partner and customer access patterns |

---

## Quick Reference

### The 6 Phases at a Glance

| Phase | License | What You Build | Estimated Hours |
|-------|---------|-----------------|-----------------|
| 1 | Free | Tenant setup, users, groups, basic RBAC | 2–3 |
| 2 | P1 | Privileged roles, apps, JML lifecycle | 3–4 |
| 3 | P2 | MFA, risk detection, conditional access | 2–3 |
| 4 | Governance | Access reviews, entitlement management | 2–3 |
| 5 | Specialist | Workload identity, B2B, verified ID | 2–3 |
| 6 | Any | Enterprise design capstone | 3–4 |
| **Total** | — | **Complete enterprise IAM system** | **14–20 hours** |

### Key Files by Phase

**Want to start now?**
- Phase 1 → [01-environment-setup.md](docs/PHASE-1-FREE-TIER/01-environment-setup.md)
- Phase 2 → [04-privileged-access-management.md](docs/PHASE-2-ENTRA-P1/04-privileged-access-management.md)
- Phase 3 → [07-audit-logging-monitoring.md](docs/PHASE-3-ENTRA-P2/07-audit-logging-monitoring.md)

**Want examples?**
- See [examples/](examples/) folder for sample configs, policies, and scripts

**Want templates?**
- See [templates/](templates/) folder for reusable CLAUDE.md, policies, and document templates

---

## Skills You'll Gain

| Domain | After Phase | Can You... |
|--------|-------------|-----------|
| **Provisioning** | 1 | Create users, assign attributes, organize groups ✓ |
| **Access Control** | 1 | Implement group-based RBAC at scale ✓ |
| **Privileged Access** | 2 | Assign scoped admin roles, delegate safely ✓ |
| **Applications** | 2 | Provision enterprise apps and manage user access ✓ |
| **Security & Audit** | 3 | Enforce MFA, detect risky access, audit trails ✓ |
| **Governance** | 4 | Run access reviews, manage entitlements ✓ |
| **Cloud-Native Identity** | 5 | Authenticate workloads, B2B partners, external users ✓ |
| **Enterprise Design** | 6 | Architect a complete IAM system | ✓ |

---

## Prerequisites

Before starting the labs:

- **A free Microsoft account** — sign up at [account.microsoft.com](https://account.microsoft.com)
- **A free Entra ID tenant** — Get one via:
  - [Microsoft 365 Developer Program](https://developer.microsoft.com/en-us/microsoft-365/dev-program) (90-day renewable)
  - [Azure free account](https://azure.microsoft.com/free/) (includes free tier)
- **A modern browser** — Chrome, Edge, Firefox, or Safari
- **No prior Entra ID experience required** — Labs start from zero

> **Free Tier Note:** All phases work within Entra ID free tier. Steps requiring P1 or P2 licenses are marked explicitly. You can progress through Phase 1 entirely free; Phases 2–6 require a P1 or P2 license trial.

---

## Examples & Templates

### Examples
Find ready-to-use configurations in [examples/](examples/):
- **phase-1-free/** — User provisioning, group RBAC samples
- **phase-2-p1/** — PAM roles, app provisioning examples
- And more for each phase...

Copy, adapt, and use in your own tenant.

### Templates
Find reusable templates in [templates/](templates/):
- **CONTENT_TEMPLATE.md** — Structure for new lab docs
- **group-naming-template.txt** — Naming conventions
- **policy-template.json** — Policy structure template
- And more...

---

## Having Trouble?

- 📖 **New to IAM?** Start with [Phase 1: Environment Setup](docs/PHASE-1-FREE-TIER/01-environment-setup.md)
- 🔍 **Looking for a concept?** Check [CONCEPT_INDEX.md](docs/REFERENCE/CONCEPT_INDEX.md)
- ❓ **Need a definition?** See [IAM_GLOSSARY.md](docs/REFERENCE/IAM_GLOSSARY.md)
- 🔗 **Want external resources?** See [FURTHER_READING.md](docs/REFERENCE/FURTHER_READING.md)
- 💡 **Specific scenario?** Check [HANDS_ON_LAB_SCENARIOS.md](docs/REFERENCE/HANDS_ON_LAB_SCENARIOS.md)

---

## Contributing

Have suggestions, corrections, screenshots, or improvements? We'd love your help!

Before contributing:
1. Read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines
2. Test all steps in your own tenant
3. Check that all links and commands work
4. Spell-check your content

How to contribute:
1. Fork the repository
2. Create a feature branch: `git checkout -b docs/your-improvement`
3. Make your changes (follow [CLAUDE.md](CLAUDE.md) standards)
4. Test locally
5. Commit with [TYPE] format: `[DOCS] Update Phase 3 MFA guide`
6. Push and create a pull request

---

## License

This lab is licensed under the [MIT License](LICENSE) — feel free to share, adapt, and use it in your portfolio!

---

## Ready to Start?

👉 **First time?** Begin with [Phase 1: Environment Setup](docs/PHASE-1-FREE-TIER/01-environment-setup.md)

👉 **Know the basics?** Jump to [QUICKSTART.md](docs/REFERENCE/QUICKSTART.md)

👉 **Building a capstone?** Go to [Phase 6: Enterprise Design](docs/PHASE-6-CAPSTONE/KEY_DESIGN_DECISIONS.md)

Happy learning! 🎉
