# Content Template: Standard Document Structure

**Use this template for all 70-75 documents in the Entra-ID-IAM-Lab knowledge base.**

---

## DOCUMENT TEMPLATE (Copy & Customize)

```markdown
# [Document Title]

**Part:** [Part X — Part Name]  
**Domain:** [Which of the 17 IAM domains]  
**Level:** Beginner | Intermediate | Advanced  
**Time to Read:** X minutes  

---

## INTRODUCTION

### What This Document Covers
[1-2 sentence overview of what the reader will learn]

### Why This Matters
[2-3 sentences explaining business/technical importance]

### Learning Objectives
- [ ] Objective 1
- [ ] Objective 2
- [ ] Objective 3
- [ ] Objective 4

### Prerequisites
[What should readers know before starting this doc?]
- Prerequisite 1 (link to prerequisite doc)
- Prerequisite 2 (link to prerequisite doc)

---

## SECTION 1: [MAIN CONCEPT]

### Overview
[Clear explanation of the concept, suitable for someone hearing it for the first time]

### Key Principles
1. **Principle 1** — [Explanation]
2. **Principle 2** — [Explanation]
3. **Principle 3** — [Explanation]

### How It Works

[Diagram or visual representation if helpful]

#### Step-by-Step Flow
```
Step 1: [What happens first]
  ↓
Step 2: [What happens next]
  ↓
Step 3: [Final step]
```

### Real-World Example
**Scenario:** [Realistic business scenario]

**In Entra ID:**
```
[Configuration steps or code examples]
```

**Result:** [What the user achieves]

---

## SECTION 2: [SECOND MAJOR CONCEPT]

### Overview
[Explanation of second concept]

### Comparison with Related Concepts

| Feature | [Concept A] | [Concept B] | [Concept C] |
|---------|-----------|-----------|-----------|
| Use Case | | | |
| Complexity | | | |
| Best For | | | |

### Implementation Patterns

#### Pattern 1: [Pattern Name]
- **When to use:** [When this pattern applies]
- **Steps:** [How to implement]
- **Example in Entra ID:** [Code or config]
- **Considerations:** [Important notes]

#### Pattern 2: [Pattern Name]
- **When to use:** [When this pattern applies]
- **Steps:** [How to implement]
- **Example in Entra ID:** [Code or config]
- **Considerations:** [Important notes]

---

## SECTION 3: HANDS-ON LAB (Optional for technical docs)

### Lab Scenario
**Goal:** [What the user will accomplish]  
**Time:** [Estimated time]  
**Prerequisites:** [What you need before starting]

### Lab Steps

**Step 1: [Action]**
1. Go to [Azure Portal location]
2. Click [specific button/link]
3. Configure [setting name]
4. Expected result: [What you should see]

**Step 2: [Action]**
[Continue steps...]

### Verification
How to confirm the lab worked:
```
[Command or verification step]
Expected output: [What success looks like]
```

### Troubleshooting
| Issue | Solution |
|-------|----------|
| [Problem description] | [How to fix it] |
| [Problem description] | [How to fix it] |

---

## ADVANCED TOPICS (Optional for intermediate+ docs)

### Topic 1: [Advanced Concept]
[Detailed explanation for advanced users]

### Topic 2: [Advanced Concept]
[Detailed explanation for advanced users]

### Best Practices
- ✅ **DO:** [Best practice with explanation]
- ✅ **DO:** [Best practice with explanation]
- ❌ **DON'T:** [Anti-pattern with explanation]
- ❌ **DON'T:** [Anti-pattern with explanation]

---

## COMPLIANCE & STANDARDS

### Frameworks Addressed
- **NIST CSF 2.0:** [Which functions this covers]
- **Gartner Framework:** [Which pillar this addresses]
- **ISO 27001:** [Which annex/control this satisfies]

### Compliance Notes
[Any regulatory considerations or compliance implications]

---

## KEY TAKEAWAYS

- ✅ Key point 1
- ✅ Key point 2
- ✅ Key point 3
- ✅ Key point 4

---

## RELATED DOCUMENTS

**Prerequisites (read first):**
- [Related doc 1](link) — [Why it matters]
- [Related doc 2](link) — [Why it matters]

**Build on this knowledge:**
- [Next doc 1](link) — [What you'll learn next]
- [Next doc 2](link) — [What you'll learn next]

**Cross-references:**
- [Related concept in other domain](link)
- [Related concept in other domain](link)

---

## FURTHER READING

### Microsoft Learn Documentation
- [Link to official docs](url) — [Brief description]

### Industry Standards & Frameworks
- [NIST CSF 2.0](url)
- [ISO 27001:2022](url)
- [Gartner Research](url)

### External Resources
- [Tool/service documentation](url)
- [Community article/guide](url)

---

## FREQUENTLY ASKED QUESTIONS

**Q: [Common question 1]**  
A: [Clear, concise answer]

**Q: [Common question 2]**  
A: [Clear, concise answer]

**Q: [Common question 3]**  
A: [Clear, concise answer]

---

## NEXT STEPS

After reading this document:
1. [Recommended action 1]
2. [Recommended action 2]
3. [Recommended action 3]

---

*Last updated: [Date]*  
*Contributing authors: [Names]*
```

---

## TEMPLATE GUIDELINES

### Length Guidelines
- **Beginner docs:** 8-12 pages (introductory)
- **Intermediate docs:** 12-18 pages (balanced depth)
- **Advanced docs:** 15-20 pages (detailed)

### Section Usage
- **INTRODUCTION** — Always required
- **SECTION 1-3** — Adjust number based on topic complexity
- **HANDS-ON LAB** — Required for technical/implementation docs
- **ADVANCED TOPICS** — Optional, for intermediate+ docs
- **COMPLIANCE & STANDARDS** — Always required
- **RELATED DOCUMENTS** — Always required
- **FURTHER READING** — Always required
- **FAQ** — Optional but recommended
- **NEXT STEPS** — Always required

### Formatting Standards
- Use **bold** for emphasis and key terms
- Use `code formatting` for technical terms, commands, config names
- Use > for blockquotes (important notes)
- Use tables for comparisons
- Use numbered lists for sequential steps
- Use bullet lists for non-sequential items
- Use diagrams/ASCII art for flows

### Code Examples Standards
```markdown
[Language indicator]
[Code or configuration]
[Expected output]
```

### Cross-Reference Format
Always link to related documents:
- `[Document Name](../path/to/document.md)` for internal links
- Include brief explanation of why it's related
- Use "Prerequisites" section for docs that should be read first
- Use "Related Documents" section for optional reading

---

## PART-SPECIFIC VARIATIONS

### Part 0: Foundation Docs
- Include landscape diagrams
- Provide strategic context
- Include framework mappings
- 15-20 pages typical

### Part 1: Core Identity & Lifecycle
- Heavy hands-on labs required
- Real Entra ID configurations
- Screenshot walkthroughs
- Azure Portal step-by-step

### Part 2-6: Technical Domains
- Include architecture diagrams
- Hands-on labs essential
- Code examples and configs
- Troubleshooting sections

### Part 7-9: Operations & Governance
- Focus on processes and workflows
- Include checklists and templates
- Less code, more concepts
- Real-world scenarios

### Part 10: Enterprise Program
- High-level strategic content
- Roadmap examples
- Decision matrices
- Maturity models

### Reference Section
- Glossary: Simple definitions with links
- Concept Cross-Reference: Matrix format with page numbers
- Framework Mapping: Alignment tables

---

## QUALITY CHECKLIST

Before submitting any document:

- [ ] Title accurately describes content
- [ ] Introduction clearly states learning objectives
- [ ] Prerequisites listed (if applicable)
- [ ] All sections follow standard structure
- [ ] Code examples are valid and tested
- [ ] Screenshots are current and clear (if included)
- [ ] All cross-references use correct links
- [ ] Related documents section is populated
- [ ] FAQ addresses common confusion points
- [ ] Compliance & Standards section completed
- [ ] Document is 8-20 pages (appropriate for topic)
- [ ] Grammar and spelling checked
- [ ] Technical accuracy verified by SME

---

## EXAMPLES

See these documents for implementation examples:
- Part 1 docs (existing 7 docs) — How to structure hands-on labs
- STRUCTURAL_ANALYSIS.md — How to structure comparison docs
- NEW_STRUCTURE_PLAN.md — How to structure planning docs

---

**Questions?** Check WRITING_GUIDELINES.md for detailed rules.
