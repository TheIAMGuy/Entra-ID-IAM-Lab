# CLAUDE.md — Project Context for AI Agents

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
| `docs/01-07-*` | **Primary lab walkthroughs** — the most important docs. Full, step-by-step guides the user follows in the Azure Portal to produce a verifiable result. |
| `docs/08-20-*` | Extended reference material. Deeper theory, standards, governance. Valuable but secondary. |
| `QUICKSTART_LABS.md` | Entry point for new users — do not restructure without good reason. |
| `BEGINNER_GUIDE.md`, `LABS_INDEX.md`, `SANDBOX_SETUP.md` | Navigation aids — keep accurate and current. |

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

- `docs/01-07` are fully expanded but not yet validated in a live Entra ID tenant. Treat as well-structured drafts until lab validation is complete.
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
