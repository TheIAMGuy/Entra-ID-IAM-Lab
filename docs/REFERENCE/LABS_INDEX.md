# Lab Index

This index lists every hands-on lab in the repository, in the order you should complete them. Each lab builds on the objects (users, groups, roles, apps) created in the earlier ones.

**Total:** 12 labs across 4 phases, roughly 4–5 hours of hands-on time.

---

## All Labs

| # | Lab | Phase | Time | Difficulty | Licence |
|---|-----|-------|------|------------|---------|
| 01 | [Environment Setup](../PHASE-1-FREE-TIER/01-environment-setup.md) | 1 – Free Tier | 10–15 min | Beginner | Free |
| 02 | [Identity Provisioning — Joiner](../PHASE-1-FREE-TIER/02-identity-provisioning-joiner.md) | 1 – Free Tier | 20–30 min | Beginner | Free |
| 03 | [Group-Based Access Control](../PHASE-1-FREE-TIER/03-group-based-access-control.md) | 1 – Free Tier | 15–20 min | Beginner | Free |
| 04 | [Privileged Access Management](../PHASE-2-ENTRA-P1/04-privileged-access-management.md) | 2 – Entra P1 | 15–20 min | Intermediate | Free |
| 05 | [Application Access Management](../PHASE-2-ENTRA-P1/05-application-access-management.md) | 2 – Entra P1 | 20–30 min | Intermediate | Free |
| 06 | [Identity Lifecycle — Mover & Leaver](../PHASE-2-ENTRA-P1/06-identity-lifecycle-mover-leaver.md) | 2 – Entra P1 | 25–35 min | Intermediate | Free |
| 07 | [Audit Logging & Monitoring](../PHASE-3-ENTRA-P2/07-audit-logging-monitoring.md) | 3 – Entra P2 | 15–20 min | Beginner–Intermediate | Free |
| 07a | [Configure TOTP-Based MFA](../PHASE-3-ENTRA-P2/07a-configure-totp-mfa.md) | 3 – Entra P2 | 20–25 min | Intermediate | Free (security defaults) to P1 |
| 07b | [Authenticator App Push MFA](../PHASE-3-ENTRA-P2/07b-enable-authenticator-push-mfa.md) | 3 – Entra P2 | 20–25 min | Intermediate | Free (security defaults) to P1 |
| 07c | [Create Your First Conditional Access Policy](../PHASE-3-ENTRA-P2/07c-conditional-access-policy.md) | 3 – Entra P2 | 25–30 min | Intermediate | Entra ID P1 |
| 07d | [Risk-Based Conditional Access](../PHASE-3-ENTRA-P2/07d-risk-based-conditional-access.md) | 3 – Entra P2 | 25–30 min | Intermediate–Advanced | Entra ID P2 |
| 17a | [Set Up Your First Access Review](../PHASE-4-GOVERNANCE/17a-set-up-access-reviews.md) | 4 – Governance | 30–40 min | Intermediate | Entra ID P2 or Governance |

> **Licensing note:** Labs 01–07 use free features. Conditional Access needs Entra ID P1, risk-based Conditional Access needs Entra ID P2, and access reviews need Entra ID P2 or Entra ID Governance. Basic MFA is free through security defaults. Microsoft offers free trials of the Premium tiers. Licensing changes over time, so confirm against [Microsoft Entra licensing](https://learn.microsoft.com/en-us/entra/fundamentals/licensing) before starting Phase 3 and 4.

---

## Labs by Identity Domain

| Domain | Labs |
|--------|------|
| Provisioning (Joiner) | 02 |
| Group-based RBAC | 03 |
| Privileged access | 04 |
| Application access | 05 |
| Lifecycle (Mover & Leaver) | 06 |
| Audit & monitoring | 07 |
| Authentication (MFA) | 07a, 07b |
| Conditional Access & risk | 07c, 07d |
| Governance (access reviews) | 17a |

---

## Concept Guides

These are reading material, not step-by-step labs. Some contain a short embedded exercise.

| Guide | Phase | Pairs with |
|-------|-------|-----------|
| [Multi-Factor Authentication: Implementation & Best Practices](../PHASE-3-ENTRA-P2/guide-multi-factor-authentication.md) | 3 | Labs 07a, 07b |
| [Adaptive Authentication: Risk-Based Access Control](../PHASE-3-ENTRA-P2/guide-adaptive-authentication.md) | 3 | Labs 07c, 07d |
| [Identity Governance Administration: IGA Platforms](../PHASE-4-GOVERNANCE/guide-identity-governance-administration.md) | 4 | Lab 17a |
| [GRC Integration](../PHASE-4-GOVERNANCE/guide-grc-integration.md) | 4 | Lab 17a |

---

## Suggested Order

1. **Phase 1 (Labs 01–03):** Set up the tenant, create users, organise them into groups.
2. **Phase 2 (Labs 04–06):** Assign admin roles, grant application access, run a Mover and a Leaver.
3. **Phase 3 (Labs 07–07d):** Read the audit trail, then add MFA and Conditional Access.
4. **Phase 4 (Lab 17a):** Run an access review over what you built.

Skipping ahead is possible if you already have a tenant with users, groups and apps. Lab 06 assumes the objects from Labs 02, 03 and 05 exist.

---

## Related Documents

- [QUICKSTART.md](QUICKSTART.md) — 2-hour fast path with PowerShell references
- [BEGINNER_GUIDE.md](BEGINNER_GUIDE.md) — start here if you are new to IAM
- [CONCEPT_INDEX.md](CONCEPT_INDEX.md) — find concepts across documents
- [IAM_GLOSSARY.md](IAM_GLOSSARY.md) — term definitions
