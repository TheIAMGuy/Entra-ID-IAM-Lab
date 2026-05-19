# CLAUDE.md — Project Context for AI Agents

## Session Handoff Warning

**If this session's context has been compacted**, stop immediately and tell the user:

> "This session's context has been compressed and I may be missing important history.
> Please start a new Claude Code session and reference this CLAUDE.md — it contains
> everything needed to continue from the right phase."

Do not attempt to continue work in a compacted session without the user's explicit
confirmation that they understand context may be incomplete.

---

## What This Repo Is

A hands-on learning lab for enterprise Identity and Access Management (IAM) using
Microsoft Entra ID. The goal is for IAM professionals to follow the labs step-by-step
and build real, verifiable skills in their own Entra ID tenant.

This is a **learning path**, not a theoretical reference. Depth is valuable but secondary
to having working, validated labs a user can follow from start to finish.

## Primary Audience

IAM professionals, identity architects, and security practitioners who want hands-on
Entra ID experience. They have enterprise context but may not have used Entra ID before.

## Lab Structure

| Path | Role |
|---|---|
| `docs/01-07-*` | **Primary lab walkthroughs** — fully expanded instructional guides (Phase 2 complete). |
| `docs/08-20-*` | Extended reference material. Deeper theory, standards, governance. Secondary. |
| `QUICKSTART_LABS.md` | Entry point for new users — do not restructure without good reason. |
| `BEGINNER_GUIDE.md`, `LABS_INDEX.md`, `SANDBOX_SETUP.md` | Navigation aids — keep accurate and current. |

## Phase Status

### Completed

| Phase | What Was Done |
|---|---|
| Phase 1 | Deleted 3 internal planning docs (`NEW_STRUCTURE_PLAN.md`, `STRUCTURAL_ANALYSIS.md`, `CONTENT_TEMPLATE.md`); added Prerequisites section to README; created this CLAUDE.md; fixed broken URL in `getting-started-with-claude-code` README. |
| Phase 2 | Rewrote all 7 primary labs (`docs/01–07`) from past-tense portfolio narratives into second-person instructional walkthroughs. Each lab now has: Azure Portal navigation steps, expected results callouts, troubleshooting tables, and IAM concept explanations. Broken screenshot image references were replaced with descriptive "Expected result" callouts. |

All Phase 1 and Phase 2 changes are on branch `claude/repo-discovery-audit-COdu8` and have
an open PR (#2) against `main`. That PR has not yet been merged.

### Pending (start here in a new session)

**Phase 3 — Lab Validation and Screenshots**
- Walk through each lab (`docs/01–07`) in a real Entra ID tenant to verify every step works
- Add a `docs/screenshots/` directory
- Add real screenshots to key steps in each lab
- Fix any steps where the Azure Portal UI has changed since writing

**Phase 4 — Lab Navigation and Polish**
- Add Previous / Next navigation links at the bottom of each lab
- Add a `docs/00-overview.md` master guide that explains the full lab arc
- Consider a completion checklist or progress tracker

**Phase 5 — iam-roadmap**
- Repo is a placeholder with no clear vision — user needs to decide direction
- Options: structured learning roadmap, resource list, career guide
- Repo should be made private (manual GitHub action, not a code change)

**Phase 6 — candidate-compass and recruiting-crm**
- `candidate-compass`: Supabase `.env` was removed (Phase 0 security fix). The Supabase
  integration code in `src/integrations/` is still present but the project is deleted.
  Decision needed: remove Supabase code entirely, or replace with a working backend.
- `recruiting-crm`: Assess current state. Similar Supabase dependency likely.
- Both repos should be made private (manual GitHub action).

**Phase 7 — Community**
- Enable GitHub Discussions on `entra-id-iam-lab`
- Add issue templates (bug report, lab feedback, content gap)
- Add a contributing guide for external contributors

## Pending Manual Actions (cannot be done via API)

These require the user to act in the GitHub web UI:

| Action | Repo | Where |
|---|---|---|
| Make private | `candidate-compass` | Settings → General → Danger Zone |
| Make private | `iam-roadmap` | Settings → General → Danger Zone |
| Make private | `recruiting-crm` | Settings → General → Danger Zone |
| Add topics | `entra-id-iam-lab` | Settings → General → Topics: `microsoft-entra-id`, `identity-access-management`, `iam`, `azure-active-directory`, `rbac`, `zero-trust`, `hands-on-lab`, `joiner-mover-leaver`, `cybersecurity` |
| Add topics | `getting-started-with-claude-code` | Settings → General → Topics: `claude-code`, `github`, `ai-tools`, `developer-guide`, `getting-started`, `anthropic` |
| Merge PR #1 | `candidate-compass` | Pull Requests → PR #1 — removes `.env` file |
| Merge PR #2 | `entra-id-iam-lab` | Pull Requests → PR #2 — Phase 1 + Phase 2 lab improvements |
| Merge PR #1 | `getting-started-with-claude-code` | Pull Requests → PR #1 — fixes broken docs URL |

---

## What Not to Change

- Do not restructure the README Table of Contents without validating all links still work.
- Do not rename `docs/01-07-*` files — they are linked from README and navigation guides.
- Do not remove CONTRIBUTING.md or LICENSE.
- Do not add more reference docs (docs/08+) until docs/01-07 are fully validated.
- Do not commit planning or scaffolding documents to the public branch.
- Do not add Premium/P1/P2-required steps to the primary labs (01-07) without a clear callout.

## Tone and Style

- Enterprise-aligned but accessible. Not academic.
- Use second person: "you will", "navigate to", "you should see".
- Steps must be specific and verifiable: state the expected result after each step.
- Note when free-tier limits apply.
- Note when a step may vary due to Azure Portal UI updates.

## What Counts as Done for Labs 01–07

A lab doc is complete when:
1. Every step is fully described — enough detail to follow without outside help.
2. Each step states the expected result so the user can verify it.
3. The lab has been tested in a real Entra ID tenant.
4. Screenshots or output examples are included for key steps.

## Known Gaps (May 2026)

- `docs/01-07` have been fully expanded (Phase 2 done) but **not yet validated** in a live
  Entra ID tenant. Treat them as well-structured drafts until Phase 3 is complete.
- Shell scripts in `labs/scripts/` have not been validated end-to-end. Treat as reference only.
- No screenshots exist yet in any lab doc.

## AI Attribution

This content was substantially generated with AI assistance (Claude). This is stated in
CONTRIBUTING.md. Do not obscure this attribution. Do not add hallucinated portal navigation
steps — if you are unsure of a UI path, mark it with a `> **Note:** Verify this step in
the portal as the UI may have changed.` callout.

## Security

No credentials, tenant IDs, or secrets should ever be committed to this repo. Labs reference
the user's own Entra ID tenant — no shared credentials exist or should exist.
