# Writing Guidelines for Entra-ID-IAM-Lab Contributors

**Guidelines for maintaining consistency, quality, and clarity across all 70-75 documents.**

---

## CORE PRINCIPLES

1. **Clarity First** — Explain for someone hearing this for the first time
2. **Practical Focus** — Include real Entra ID examples and labs
3. **Framework Alignment** — Connect to NIST, Gartner, ISO, SANS
4. **Progressive Disclosure** — Start simple, build to advanced
5. **Accessibility** — Write for diverse skill levels
6. **Consistency** — Follow templates and style guides

---

## WRITING STYLE

### Tone
- **Professional but approachable** — Not academic, not casual
- **Active voice** — "You create a user" not "Users are created"
- **Second person** — "You will learn" not "Readers will learn"
- **Direct** — Get to the point quickly

### Sentence Structure
- **Short sentences** — Average 15-20 words
- **Simple words** — "Use" not "utilize"; "help" not "facilitate"
- **Avoid jargon** — Define technical terms on first use
- **Vary length** — Mix short and medium sentences for readability

### Paragraph Structure
- **Topic sentence first** — State the main idea upfront
- **2-4 sentences per paragraph** — Keep it digestible
- **One idea per paragraph** — Don't mix concepts
- **Whitespace** — Use short paragraphs to improve readability

### Example Good vs. Bad

**❌ Bad:**
"The process of implementing role-based access control in cloud environments necessitates careful consideration of organizational hierarchies and the establishment of a governance framework that will ensure ongoing compliance with industry standards."

**✅ Good:**
"To implement role-based access control (RBAC), you need to:
1. Define your organizational roles
2. Assign permissions to each role
3. Add users to appropriate roles
4. Review access regularly"

---

## TECHNICAL WRITING

### Code & Configuration

**Format:**
```markdown
[Language/Product Name]
[Code block with proper indentation]
[Expected output or result]
```

**Example:**
```powershell
# Create a security group in Entra ID
New-MgGroup -DisplayName "Finance-Admins" -MailEnabled:$false -SecurityEnabled:$true
```

### Screenshots & Diagrams

- **Screenshots:** Use for step-by-step walkthroughs; mark important buttons/fields
- **Diagrams:** Use for architecture, flows, relationships
- **Size:** Screenshots 800-1000px wide; diagrams sized for readability
- **Captions:** "Figure 1: [Descriptive caption]"
- **Tool:** Use Mermaid for diagrams (built into GitHub)

### Tables

**When to use:**
- Comparing features or options
- Listing requirements or prerequisites
- Showing matrices or mappings

**Format:**
```markdown
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Data | Data | Data |
```

---

## STRUCTURE & ORGANIZATION

### Headings Hierarchy
```
# Document Title (H1 — only one per document)
## Major Section (H2 — use for main sections)
### Subsection (H3 — use for detail within section)
#### Sub-subsection (H4 — rarely needed)
```

### Numbering & Ordering
- **Sequential steps:** 1, 2, 3 (numbered list)
- **Options:** • (bullet list)
- **Hierarchical:** Use indentation under bullets
- **Never:** Skip numbers or mix formats

### Lists Best Practices

**Good numbered list:**
1. First step
2. Second step
3. Third step

**Good bullet list:**
- Concept 1
- Concept 2
- Concept 3

**Good nested list:**
- Parent concept
  - Child concept 1
  - Child concept 2
- Another parent concept

---

## TERMINOLOGY & DEFINITIONS

### First Use of Technical Terms
**Rule:** Define on first use, then use consistently

**Example:**
"Role-Based Access Control (RBAC) is a method of restricting access based on user roles. In RBAC, you assign permissions to roles rather than directly to users."

### Microsoft-Specific Terms
- **Entra ID** — Not "Azure AD" (Azure AD is legacy)
- **Managed Identity** — Not "Service Principal" (though SP is related)
- **Security Group** — Not "Azure group"
- **Conditional Access** — Specific to Entra ID, not generic
- **PIM** — Privileged Identity Management

### IAM-Specific Terms
- **Identity Provisioning** — Creating user accounts
- **Access Control** — Determining permissions
- **PAM** — Privileged Access Management
- **JML** — Joiner-Mover-Leaver lifecycle
- **RBAC** — Role-Based Access Control
- **ABAC** — Attribute-Based Access Control

### Acronyms
- Define on first use: "Multi-Factor Authentication (MFA)"
- Use consistently throughout document
- Don't overuse acronyms; spell out if readers might not know

---

## CROSS-REFERENCES & LINKING

### Internal Links Format
```markdown
[Document Name](../path/to/document.md)
```

### Related Documents Section
```markdown
## RELATED DOCUMENTS

**Prerequisites (read first):**
- [Document Name](../path) — Why it matters

**Build on this knowledge:**
- [Document Name](../path) — What you'll learn next

**Cross-references:**
- [Related concept](../path)
```

### Inline References
"See [Document Name](link) for more details on [concept]."

### Avoid Dead Links
- Every link must point to an actual document
- Test all links before submitting
- Update links when documents move

---

## ACCESSIBILITY & READABILITY

### For Diverse Skill Levels
- **Beginner sections:** Explain basics, don't assume knowledge
- **Intermediate sections:** Build on foundational knowledge
- **Advanced sections:** Assume familiarity; dig deeper
- **Visual learners:** Include diagrams and examples
- **Hands-on learners:** Include labs and step-by-step guides

### Formatting for Readability
- Use **bold** for important terms
- Use `code` for technical terms
- Use > for callouts or important notes
- Use lists instead of paragraphs when possible
- Use whitespace — short sections are more readable

### Callout Formats

**Important Note:**
> **Note:** [Something important to remember]

**Warning:**
> **Warning:** [Something that could go wrong]

**Tip:**
> **Tip:** [A helpful shortcut or best practice]

**Example:**
> **Example:** [Real-world scenario]

---

## QUALITY STANDARDS

### Before You Submit

- [ ] **Spelling & Grammar:** Use spell checker; proofread twice
- [ ] **Accuracy:** Verify all technical information with Entra ID docs
- [ ] **Screenshots:** Current and clear; all important elements visible
- [ ] **Code Examples:** Tested and working in Entra ID
- [ ] **Links:** All internal links valid and tested
- [ ] **Structure:** Follows CONTENT_TEMPLATE.md
- [ ] **Length:** 8-20 pages appropriate for topic
- [ ] **Tone:** Professional, clear, approachable
- [ ] **Objectives:** Learning objectives are clear and achievable

### Technical Accuracy

- [ ] **Entra ID features:** Correct product names and capabilities
- [ ] **Workflow steps:** Tested in actual Azure Portal
- [ ] **Configuration options:** Accurate and current
- [ ] **Security practices:** Follow Microsoft best practices
- [ ] **Framework alignment:** NIST/Gartner/ISO mappings correct

### Completeness

- [ ] **Introduction:** Clear overview and learning objectives
- [ ] **Real examples:** Includes Entra ID walkthroughs
- [ ] **Labs:** Technical docs include hands-on steps
- [ ] **Related docs:** All prerequisites and next steps linked
- [ ] **FAQ:** Common questions answered
- [ ] **Compliance:** NIST/Gartner/ISO mappings included

---

## COMMON MISTAKES TO AVOID

### ❌ Too Technical (Without Context)
**Bad:** "Implement SPIFFE SVID attestation in your Kubernetes workload identity."
**Good:** "To verify workload identity in Kubernetes, you can use SPIFFE (Secure Production Identity Framework for Everyone), which provides standardized identity verification."

### ❌ Too Vague (No Detail)
**Bad:** "Configure access control."
**Good:** "Configure role-based access control (RBAC) by assigning the 'User Administrator' role to department managers who need to create and manage user accounts."

### ❌ Assuming Knowledge
**Bad:** "Use SCIM to synchronize identities."
**Good:** "Use SCIM (System for Cross-domain Identity Management), a standard REST API protocol, to automatically synchronize user identities between systems."

### ❌ Long Paragraphs
**Bad:** One paragraph of 5+ sentences covering multiple ideas
**Good:** 2-3 sentence paragraphs, each with one main idea

### ❌ Inconsistent Terminology
**Bad:** Switching between "role", "authorization role", "access role", "role assignment"
**Good:** Use "role" consistently; define once as "role-based access control (RBAC)"

### ❌ Missing Context for Examples
**Bad:** Just code without explanation
**Good:** Explain what the code does, then show it, then explain the result

---

## FORMATTING CHECKLIST

### Markdown Formatting
- [ ] Proper heading hierarchy (H1 title, H2 sections, H3 subsections)
- [ ] Bold for **emphasis** and key terms
- [ ] Backticks for `technical terms` and code
- [ ] Code blocks with language specified
- [ ] Tables for comparisons/matrices
- [ ] Lists for non-sequential items
- [ ] Numbered lists for steps
- [ ] Blockquotes for callouts/notes

### Consistency Across Document
- [ ] Same terminology used throughout
- [ ] Consistent formatting for similar elements
- [ ] Consistent code example format
- [ ] Consistent table styling
- [ ] No spelling variations (e.g., "user name" vs "username")

---

## REVIEW PROCESS

### Self-Review (Before Submitting)
1. Read document aloud to catch awkward phrasing
2. Check all technical details against official docs
3. Test all code examples
4. Verify all links work
5. Use spell checker and grammar checker
6. Ask: "Would a beginner understand this?"
7. Ask: "Is this technically accurate?"

### Peer Review (During PR)
- Reviewer checks for clarity and accuracy
- Reviewer tests any hands-on labs
- Reviewer verifies framework alignments
- Reviewer suggests improvements

### Final Approval
- Technical SME approves accuracy
- Editor approves style and clarity
- Maintainer approves structure and linking

---

## EXAMPLES OF GOOD DOCUMENTATION

These documents exemplify the standards we're aiming for:

- **Existing Part 1 docs** — See how Entra ID labs are structured
- **NEW_STRUCTURE_PLAN.md** — See how to use tables and organization
- **STRUCTURAL_ANALYSIS.md** — See how to do comparative analysis

---

## QUESTIONS?

If you have questions about:
- **Structure:** See CONTENT_TEMPLATE.md
- **Style:** See examples in current Part 1 docs
- **Technical accuracy:** Ask on PR or contact SME
- **Framework alignment:** Check FRAMEWORK_MAPPING.md

---

**Last Updated:** 2026-05-17
**Version:** 1.0
