# CLAUDE.md — Entra-ID-IAM-Lab Repository Standards

This file documents the structure and standards for the Entra-ID-IAM-Lab GitHub repository. Use this file when:
- **Adding new labs or phases** to the repo
- **Updating existing documentation**
- **Requesting Claude Code to generate or modify lab content**

When you ask Claude Code to upload or create a lab, it will follow this structure exactly.

---

## Repository Overview

**Purpose:** Portfolio-grade hands-on learning path through enterprise Microsoft Entra ID identity and access management (IAM).

**Delivery Model:**
- Documentation (markdown) hosted on GitHub
- Progressive 6-phase curriculum
- Hands-on labs with step-by-step instructions
- Reference materials and templates
- No code delivery (content only)

**Progression:** Free → P1 License → P2 License → Governance → Specialist → Capstone Design

---

## Standard Lab Document Structure

Every lab file (Phase 1–5) must follow this structure exactly. Use this as a template when requesting new content.

### 1. **File Naming**
```
{PHASE}/NN-descriptive-name.md
Example: PHASE-2-ENTRA-P1/04-privileged-access-management.md
```

### 2. **Front Matter (Metadata)**

If the lab is advanced/reference material, include YAML front matter:

```yaml
---
title: Lab Title
part: 4
section: Category
difficulty: Intermediate
estimated_reading_time: 20
estimated_lab_time: 15
prerequisites:
  - link-to-prerequisite.md
  - another-prerequisite.md
learning_objectives:
  - Objective 1
  - Objective 2
---
```

For simpler Phase 1–3 labs, front matter is optional; omit if the header provides sufficient context.

### 3. **Header Section**

```markdown
# Lab NN — [Lab Title]

**Objective:** [One-sentence goal — what will the learner be able to do?]

**Time:** [X–Y minutes]  
**Difficulty:** [Beginner | Beginner–Intermediate | Intermediate | Intermediate–Advanced | Advanced | Professional Capstone]  
**Cost:** [Free | Free Trial | Paid Licence | Usage Based]

---
```

Example:
```markdown
# Lab 04 — Privileged Access Management

**Objective:** Assign scoped administrative roles following the principle of least privilege.

**Time:** 15–20 minutes  
**Difficulty:** Intermediate  
**Cost:** Free

---
```

### 4. **Prerequisites Section**

```markdown
## Before You Start

Ensure you have completed [Lab NN — Title](link.md). Your [objects] should [state].

> **Tip:** If the lab can be skipped or taken out of order, note that here.
```

### 5. **Background/Context Section**

```markdown
## Background

[2–4 paragraphs explaining the IAM concept, why it matters, and real-world context.]

### Key Concepts

[Optional subsection defining terms used in the lab.]
```

### 6. **Steps Section**

Each numbered step follows this format:

```markdown
## Steps

### 1. [Step Title]

[Narrative context or explanation if needed]

1. In the [Portal/App], navigate to **[Path] → [Submenu] → [Option]**.
2. [Action]

> **Expected result:** [What the user should see after completing the step]

---

### 2. [Next Step Title]

[Continue as above]
```

**Screenshot Placeholders:**

For every screenshot reference, use this format:

```markdown
> **[PLACEHOLDER: Screenshot of Entra ID admin center showing {specific element}]**  
> _Expected screenshot shows: [what should be visible]_
```

Example:
```markdown
> **[PLACEHOLDER: Screenshot of Roles and Administrators page with User Administrator role highlighted]**  
> _Expected screenshot shows: List of directory roles with search bar and User Administrator role visible_
```

### 7. **Verification/Checkpoint Section**

After a logical group of steps, add verification:

```markdown
### ✓ Checkpoint

Verify you've completed this section:
- [ ] [Checklist item 1]
- [ ] [Checklist item 2]
- [ ] [Checklist item 3]

If any item is unchecked, revisit the steps above.
```

### 8. **Summary / Next Steps Section**

```markdown
## Summary

[1–2 sentences recapping what you accomplished and why it matters in production.]

---

## Next Steps

→ Proceed to [Lab NN — Title](link.md)

**Or jump to:**
- [Quickstart](../REFERENCE/QUICKSTART.md) for a 2-hour fast path
- [IAM Glossary](../REFERENCE/IAM_GLOSSARY.md) if you need definitions
- [Concept Index](../REFERENCE/CONCEPT_INDEX.md) to find related topics
```

---

## Standard Sections Across Document Types

### For Lab Instructions (Phase 1–5)
1. Header (objective, time, difficulty, cost)
2. Before You Start (prerequisites)
3. Background (concept explanation)
4. Steps (numbered step-by-step)
5. Checkpoints (verification)
6. Summary (what you learned)
7. Next Steps (progression links)

### For Reference Docs (REFERENCE/ folder)
1. Introduction (purpose)
2. Table of contents or sections
3. Detailed content with examples
4. Links back to relevant labs
5. External resources if applicable

### For Capstone Design (Phase 6)
1. Introduction (design challenge)
2. Key Design Decisions table
3. Production Considerations (evolution beyond lab)
4. Architecture patterns
5. Governance and lifecycle workflow
6. Compliance and risk considerations

---

## Content Standards

### IAM Concepts
- **Accuracy first:** Statements must align with Microsoft Learn documentation or industry standards (NIST, ISO 27001).
- **Concrete over generic:** Name vendors, protocols, and standards. "Use Conditional Access with risk-based policies" beats "add security."
- **Production-aligned:** Every design decision should reflect what production IAM teams actually do, not just lab-friendly shortcuts.
- **Note free-tier constraints:** If something is simplified for the free tier, explicitly document the production pattern you're demonstrating.

### Language & Tone
- **Clear and direct:** No corporate jargon, no hedging. "Assign this role to Alice Smith" not "Consider assigning a role to a user."
- **Active voice:** "You will configure conditional access" not "Conditional access should be configured."
- **Scannable:** Use headers, bullet points, tables, and bold for key terms.
- **Definitions inline:** If a term is used for the first time, define it. Link to IAM_GLOSSARY.md for comprehensive definitions.

### Screenshots & Visuals
- **Always use placeholders during authoring:** `[PLACEHOLDER: Description of screenshot]`
- **Numbered format:** If multiple screenshots in one step, label them: `[PLACEHOLDER: Screenshot 1 of 3 — ...]`
- **Consistency:** Screenshot captions should describe what's visible and highlight the relevant UI element (red box, arrow, highlight).
- **Aspect ratio:** Keep screenshots consistent with modern browser/portal UI (16:9 or 4:3).

### Links & References
- **Internal links:** Use relative paths: `[Lab 03](03-group-based-access-control.md)` or `[IAM Glossary](../REFERENCE/IAM_GLOSSARY.md)`
- **External links:** Link to Microsoft Learn, official docs, and industry standards. Prefer permanent URLs (docs.microsoft.com/en-us/entra/...).
- **Check link validity:** All links must be tested and functional before merge.

### Time Estimates
- Be realistic. Test the lab yourself (or account for testing time).
- Separate "reading time" (concept understanding) from "lab time" (hands-on configuration).
- Example: `**Estimated time:** 15 min (5 min read + 10 min hands-on)`

---

## Notion Database Integration

Each lab maps to a **Project Name** entry in your Notion "Microsoft Entra Identity Portfolio" database.

### Notion Fields to Populate per Lab

When you complete a lab:

| Notion Field | Source | Example |
|--------------|--------|---------|
| **Project Name** | Lab title from GitHub | "Lab 04 — Privileged Access Management" |
| **Phase** | GitHub phase folder | "Authentication & Access" |
| **Learning Order** | Sequential position | 4 |
| **Difficulty** | Lab header | "Intermediate" |
| **Estimated Hours** | Lab header (converted to decimal) | 0.33 (20 min) |
| **Identity Domain** | Concepts covered | ["Privileged Access", "RBAC", "Delegated Administration"] |
| **Licence Tier** | Lab cost | "Entra ID P1" |
| **Intended Outcome** | Lab objective | "Assign scoped administrative roles following principle of least privilege" |
| **Steps** | GitHub lab step numbers | "Steps 1–4: Assign User Administrator role; Steps 5–7: Assign Global Reader role" |
| **Status** | Your completion state | "Not started" / "In progress" / "Done" |
| **Completed** | Checkpoint completion | "No" / "Yes" |
| **Notes** | Your observations | "Took longer than estimated; searched for User Admin role in step 2" |
| **Platform** | Target platform | "Cloud" |
| **Cost Category** | Licensing requirement | "Free Trial" (for P1 trial) |

---

## When Claude Code Adds Content

**Standard request format:**

```
Add a new lab to Phase X (folder PHASE-N-DESCRIPTION):
- Lab number: NN
- Title: [Title]
- Objective: [One-sentence goal]
- Time: X–Y minutes
- Difficulty: [Level]
- Cost: [Free/Trial/Paid]
- Prerequisites: [Link to Lab MM]
- Key concepts: [Concepts to cover]
- Steps: [Numbered list of major steps or actions]
- Expected outcome: [What learner should see at end]
```

**Claude Code will:**
1. Create the file with the correct naming: `PHASE-N-DESCRIPTION/NN-lab-title.md`
2. Follow the standard structure exactly (header, before you start, background, steps, checkpoints, summary, next steps)
3. Use placeholder text for screenshots: `[PLACEHOLDER: Screenshot description]`
4. Use relative links for internal cross-references
5. Populate Notion "Steps" field with the step descriptions
6. NOT create the lab examples, scripts, or policies — only documentation

---

## File Organization

```
Entra-ID-IAM-Lab/
├── README.md                               (entry point, learning paths, quick ref)
├── CLAUDE.md                               (this file)
├── CONTRIBUTING.md                         (contribution guidelines)
├── LICENSE
├── docs/
│   ├── PHASE-1-FREE-TIER/
│   │   ├── 01-environment-setup.md
│   │   ├── 02-identity-provisioning-joiner.md
│   │   └── 03-group-based-access-control.md
│   ├── PHASE-2-ENTRA-P1/
│   │   ├── 04-privileged-access-management.md
│   │   ├── 05-application-access-management.md
│   │   └── 06-identity-lifecycle-mover-leaver.md
│   ├── PHASE-3-ENTRA-P2/
│   │   ├── 07-audit-logging-monitoring.md
│   │   ├── 07a-multi-factor-authentication.md
│   │   └── 07c-adaptive-authentication.md
│   ├── PHASE-4-GOVERNANCE/
│   │   └── 17a-identity-governance-administration.md
│   ├── PHASE-5-SPECIALIST/
│   │   ├── 11a-workload-identity.md
│   │   └── 12-b2b-external-identities.md
│   ├── PHASE-6-CAPSTONE/
│   │   └── KEY_DESIGN_DECISIONS.md
│   └── REFERENCE/
│       ├── IAM_GLOSSARY.md
│       ├── CONCEPT_INDEX.md
│       ├── LABS_INDEX.md
│       ├── BEGINNER_GUIDE.md
│       └── [other reference docs]
├── examples/                               (COMING: working configs per phase)
│   ├── phase-1-free/
│   ├── phase-2-p1/
│   └── ...
└── templates/
    ├── CLAUDE.md.template
    ├── CLAUDE.local.md.template
    ├── CONTENT_TEMPLATE.md
    ├── WRITING_GUIDELINES.md
    └── [policy & script templates]
```

---

## Checklist: Before Requesting Content Upload

Use this when asking Claude Code to add or modify a lab:

- [ ] I know the **Phase number and folder name** (e.g., PHASE-3-ENTRA-P2)
- [ ] I know the **lab number** (NN) and it doesn't conflict with existing labs
- [ ] I have the **objective** (one sentence)
- [ ] I have the **estimated time** (X–Y minutes)
- [ ] I've listed **prerequisites** (which labs must be done first)
- [ ] I've identified the **key IAM concepts** being taught
- [ ] I have an **outline of steps** (what the lab will walk through)
- [ ] I know which **Identity Domain tags** apply (for Notion mapping)
- [ ] I'm ready for **placeholder screenshots** (I'll add real ones later)
- [ ] I understand the lab will follow **standard structure** (header → before you start → background → steps → checkpoints → summary → next)

---

## Questions?

- **Not sure how to structure a concept?** Check an existing lab (e.g., 07-audit-logging-monitoring.md) or reference CONTENT_TEMPLATE.md
- **Need IAM definitions?** See IAM_GLOSSARY.md
- **Looking for a specific concept across labs?** See CONCEPT_INDEX.md
- **Want to map your progress?** Use the Notion database with fields from the "Notion Database Integration" section above

---

**Last updated:** 2026-07-27  
**For:** GitHub repository: https://github.com/TheIAMGuy/Entra-ID-IAM-Lab
