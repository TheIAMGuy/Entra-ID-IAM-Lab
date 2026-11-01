# Beginner's Guide

This guide helps you find your way around the repository if you are new to identity and access management (IAM) and Microsoft Entra ID.

## What You Need

- A Microsoft Entra ID tenant. A free tenant is enough for Phases 1 and 2. Phases 3 and 4 depend on your tenant's licence, so check each lab's header and the [licensing note in the lab index](LABS_INDEX.md).
- An admin account in that tenant (Global Administrator is the simplest for a personal lab tenant).
- A browser and, for the MFA labs, a phone with Microsoft Authenticator.
- Use a test tenant. Do not run these labs in a production tenant.

## Start Here (30 minutes)

1. Read the [README](../../README.md) for the phase overview.
2. Skim the [IAM Glossary](IAM_GLOSSARY.md) so the acronyms are familiar.
3. Open [Lab 01 — Environment Setup](../PHASE-1-FREE-TIER/01-environment-setup.md).

## Your Learning Path (Choose One)

### Path 1: Follow the labs in order (recommended)
**Best if:** you are new to IAM and want hands-on experience.

Work through the 12 labs in the order listed in the [Lab Index](LABS_INDEX.md). Each lab builds on the users, groups, roles and applications created in the earlier ones. Allow roughly 4–5 hours of hands-on time in total, plus reading.

**Outcome:** a working Entra ID tenant with provisioning, RBAC, privileged roles, application access, lifecycle handling, MFA, Conditional Access and an access review.

### Path 2: Fast path for people who know IAM
**Best if:** you already know the concepts and want the Entra specifics.

1. [QUICKSTART.md](QUICKSTART.md) for the condensed steps and PowerShell references.
2. [Lab 04 — Privileged Access Management](../PHASE-2-ENTRA-P1/04-privileged-access-management.md)
3. The Phase 3 guides: [Multi-Factor Authentication](../PHASE-3-ENTRA-P2/07a-multi-factor-authentication.md) and [Adaptive Authentication](../PHASE-3-ENTRA-P2/07c-adaptive-authentication.md)
4. [Identity Governance Administration](../PHASE-4-GOVERNANCE/17a-identity-governance-administration.md)

### Path 3: Learn by topic
- **Joiner, mover, leaver:** Labs 02, 06
- **Access control:** Labs 03, 04, 05
- **Authentication and risk:** Labs 07a, 07b, 07c, 07d
- **Audit and governance:** Lab 07, Lab 17a, [GRC Integration](../17b-grc-integration.md)

---

## Key Resources

- [Lab Index](LABS_INDEX.md) — every lab with time, difficulty and phase
- [Quickstart](QUICKSTART.md) — 2-hour fast path
- [IAM Glossary](IAM_GLOSSARY.md) — term definitions
- [Concept Index](CONCEPT_INDEX.md) — find a concept across the documents
- [Further Reading](FURTHER_READING.md) — books, courses and official documentation
- [`examples/`](../../examples/) — sample JSON configurations for each phase
- [`templates/`](../../templates/) — policy and script templates

---

## How Each Phase Builds on the Last

| Phase | Focus | Core idea |
|-------|-------|-----------|
| 1 – Free Tier | Users and groups | Identities exist, and access is granted through groups, not individuals |
| 2 – Entra P1 | Roles, apps, lifecycle | Admin rights are scoped, apps are assigned, and access changes when people move or leave |
| 3 – Entra P2 | Audit, MFA, Conditional Access | You can see what happened, and you can require stronger proof when risk is higher |
| 4 – Governance | Access reviews | Access is rechecked on a schedule and removed when it is no longer needed |

---

## Common Questions

**Where do I start if I have never done identity work?**
[Lab 01](../PHASE-1-FREE-TIER/01-environment-setup.md). No prerequisites beyond a tenant.

**Can I skip labs?**
Phase 1 is the foundation. Lab 06 uses users, groups and apps from Labs 02, 03 and 05, and Lab 17a reviews access built earlier. If you skip, create the missing objects first.

**What if my tenant does not have a feature a lab uses?**
Check the lab's header and your tenant's licence. Some Phase 3 and 4 features need P1, P2 or Governance licensing or a trial.

**How do I stay current?**
Entra features and licensing change often. Check [Further Reading](FURTHER_READING.md) and the [Microsoft Entra documentation](https://learn.microsoft.com/en-us/entra/) rather than relying on this repository alone.

---

## Tips for Success

1. **Do the steps, do not just read them.** The labs are short because they are meant to be run.
2. **Use a test tenant.** Mistakes in a lab cost nothing; in production they do.
3. **Keep the glossary open.** Identity has many acronyms.
4. **Read the audit log after each lab.** Lab 07 shows how every action you took is recorded.
5. **Note what differs in your tenant.** Portal layouts and defaults change; record what you see.

---

## Getting Help

- Each lab has a Troubleshooting section.
- Check the [IAM Glossary](IAM_GLOSSARY.md) for terms.
- Search [Microsoft Learn](https://learn.microsoft.com/en-us/entra/) for current portal steps.
- For repository questions or corrections, see [CONTRIBUTING.md](../../CONTRIBUTING.md).
