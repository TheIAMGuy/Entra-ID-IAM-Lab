# CLAUDE.md – Entra-ID-IAM-Lab Repository

## Project Overview
**Purpose**: Hands-on enterprise IAM learning lab using Microsoft Entra ID (formerly Azure Active Directory)  
**Audience**: IAM practitioners from beginner to experienced identity architects  
**Scope**: Full Joiner-Mover-Leaver (JML) identity lifecycle, group-based RBAC, privileged access management, enterprise application provisioning, and compliance audit logging  
**Constraint**: All labs must remain compatible with the Microsoft Entra ID free tier

## Repository Structure
```
├── docs/                              # All lab guides and navigational documents
│   ├── 00-iam-landscape-overview.md   # and 70+ numbered lab files (00–20 series)
│   ├── BEGINNER_GUIDE.md              # Entry point for new IAM learners
│   ├── CONCEPT_CROSS_REFERENCE.md     # Cross-links between concepts
│   ├── CONCEPT_INDEX.md               # IAM concept reference index
│   ├── FRAMEWORK_MAPPING.md           # Maps content to industry frameworks
│   ├── FURTHER_READING.md             # External resources and references
│   ├── HANDS_ON_LAB_SCENARIOS.md      # Scenario-based exercises
│   ├── IAM_GLOSSARY.md                # Definitions of IAM terminology
│   ├── LABS_INDEX.md                  # Master index of all lab content
│   ├── QUICKSTART_LABS.md             # Fast-path for experienced readers
│   └── SANDBOX_SETUP.md               # Tenant and environment prep
├── examples/                          # Code and configuration samples
│   ├── 01-access-policy-example.json
│   ├── 02-role-based-access.json
│   ├── 03-attribute-mapping.json
│   └── scripts/                       # Automation and lab scripts
│       ├── 01-joiner-automation-basic.sh
│       ├── 02-mfa-enrollment.sh
│       └── 06-conditional-access-policy.sh
├── diagrams/                          # Architecture and flow diagrams
├── templates/                         # Document templates and style standards
│   ├── CONTENT_TEMPLATE.md            # Required structure for every new lab doc
│   └── WRITING_GUIDELINES.md          # Tone, sentence structure, formatting rules
├── README.md                          # Main entry point and navigation
├── CLAUDE.md                          # This file
├── CONTRIBUTING.md                    # Contribution instructions
└── LICENSE                            # MIT License
```

## Writing Standards
Always follow [WRITING_GUIDELINES.md](templates/WRITING_GUIDELINES.md) when creating or editing content.

### Tone
- Professional but approachable — technical accuracy without being academic
- Active voice: “you will configure” not “configuration can be performed”
- Direct language: avoid hedging
- Empathetic: acknowledge complexity and explain the “why”

### Structure per Document
Every lab guide must include all 11 sections defined in [CONTENT_TEMPLATE.md](templates/CONTENT_TEMPLATE.md):
1. Clear objective at the top
2. Prerequisites / what you need
3. Step-by-step instructions with Azure Portal screenshots
4. IAM concept explanations alongside each step
5. Design rationale callouts
6. Expected outputs (for code/CLI steps)
7. Verification steps
8. Troubleshooting notes
9. Related documents (cross-references)
10. Summary of what was accomplished
11. Next steps

### Heading Hierarchy
- `#` — Document title only (one per file)
- `##` — Major sections
- `###` — Subsections
- `####` — Sub-subsections (use sparingly)
- Never use `#####` or deeper

### Sentence & Paragraph Rules
- Target 15–20 words per sentence; hard max 30 words
- One idea per sentence
- Paragraphs: 2–4 sentences maximum
- Use numbered lists for sequential steps, bullet lists for options
- Maximum 2 levels of list nesting

### Callout Format
```
**[IMPORTANT]:** Critical information
**[NOTE]:** Additional context
**[TIP]:** Helpful shortcut
**[WARNING]:** Something that could go wrong
```

### Code Blocks
Always include language identifier and expected output:
```
LANGUAGE: [PowerShell | Azure CLI | JSON | etc.]
[code here]
EXPECTED OUTPUT: [what the reader should see]
```

## Terminology Standards
See [IAM_GLOSSARY.md](docs/IAM_GLOSSARY.md) for full definitions.

| Use | Instead Of |
|-----|------------|
| Microsoft Entra ID | Azure AD |
| Conditional Access | Generic access control |
| Security group | Distribution group |
| Service principal | Service account |
| Managed identity | Direct credentials |

**Acronym rule**: Define on first use (e.g., “Role-Based Access Control (RBAC)”), then use the acronym consistently throughout the document.

## Key Reference Files
- **[CONTENT_TEMPLATE.md](templates/CONTENT_TEMPLATE.md)** — Required structure for every new lab document; use this as a starting point
- **[WRITING_GUIDELINES.md](templates/WRITING_GUIDELINES.md)** — Tone, sentence structure, formatting rules
- **[IAM_GLOSSARY.md](docs/IAM_GLOSSARY.md)** — Authoritative definitions for all IAM terms
- **[CONCEPT_INDEX.md](docs/CONCEPT_INDEX.md)** — Find where concepts are covered across the lab
- **[FRAMEWORK_MAPPING.md](docs/FRAMEWORK_MAPPING.md)** — Maps lab content to SOC 2, ISO 27001, NIST, etc.
- **[LABS_INDEX.md](docs/LABS_INDEX.md)** — Master index; update this when adding new lab content

## Adding New Content
1. Copy [CONTENT_TEMPLATE.md](templates/CONTENT_TEMPLATE.md) as a starting point
2. Follow the 11-section structure (all sections required)
3. Add entry to [LABS_INDEX.md](docs/LABS_INDEX.md)
4. Add cross-references in [CONCEPT_INDEX.md](docs/CONCEPT_INDEX.md) for new IAM concepts introduced
5. Update [FRAMEWORK_MAPPING.md](docs/FRAMEWORK_MAPPING.md) if the content maps to a compliance framework
6. Verify all steps work within Entra ID free tier before submitting

## Quality Checklist (Before Every PR)
- [ ] All 11 CONTENT_TEMPLATE sections present
- [ ] Spell check and grammar verified
- [ ] All links tested
- [ ] Code examples include language identifier and expected output
- [ ] Screenshots annotated with numbered captions, file size < 500 KB
- [ ] Heading hierarchy follows H1–H4 only
- [ ] No undefined acronyms
- [ ] Terminology matches WRITING_GUIDELINES.md standards
- [ ] LABS_INDEX.md updated if new content was added
- [ ] Free-tier compatibility confirmed

## Repository Rules
- License: MIT (all content freely shareable and adaptable)
- All lab steps must work within Entra ID free tier limits
- Enterprise-aligned patterns only — no shortcuts that wouldn’t be acceptable in production
- Maintain production-design principles even when working around free-tier constraints
- No breaking changes to existing numbered lab sequence without team discussion
