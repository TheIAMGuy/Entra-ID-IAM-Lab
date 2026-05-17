# Writing Guidelines: Consistency Standards for Entra-ID-IAM-Lab

These guidelines ensure all 70-75 documents maintain consistent voice, tone, and structure while remaining accessible to diverse technical skill levels.

## Writing Tone & Voice

### Overall Approach
- **Professional but approachable**: Use technical accuracy without sounding academic or overly formal
- **Active voice preferred**: Use "you will configure" instead of "configuration can be performed"
- **Direct language**: Avoid unnecessary hedging; use "this is required" instead of "ideally, one might consider"
- **Empathetic to the reader**: Acknowledge complexity; provide context for why things work the way they do

### Examples

❌ **Too Formal**: "The implementation of role-based access control mechanisms necessitates the configuration of appropriate permissions within the identity management infrastructure."

✅ **Correct**: "To implement role-based access control, you configure permissions in Microsoft Entra ID that match your organizational roles."

## Sentence & Paragraph Structure

### Sentence Guidelines
- **Target length**: 15-20 words per sentence
- **Maximum length**: 30 words (avoid very long sentences)
- **Rule**: One idea per sentence
- **Structure**: Subject-Verb-Object (keep this order)

### Paragraph Structure
- **Opening**: Lead with topic sentence
- **Length**: 2-4 sentences maximum
- **Connection**: Logical flow between paragraphs
- **Conclusion**: Forward-looking statements or transitions

## Terminology & Definitions

### Microsoft-Specific Terminology

| Use | Instead Of |
|-----|-----------|
| Microsoft Entra ID | Azure AD |
| Conditional Access | Generic access control |
| Security group | Distribution group |
| Service principal | Service account |
| Managed identity | Direct credentials |

### IAM-Specific Terminology

Key terms to define on first use:
- Identity lifecycle (Joiner → Mover → Leaver workflow)
- Provisioning (Creating user accounts)
- Deprovisioning (Removing user accounts)
- Entitlement (A right or permission)
- Access review (Periodic verification)

### Acronyms

**Rule**: Define on first use with full spelling, then use consistently.

Common IAM acronyms:
- ABAC: Attribute-Based Access Control
- RBAC: Role-Based Access Control
- MFA: Multi-Factor Authentication
- PAM: Privileged Access Management
- IGA: Identity Governance and Administration

## Technical Writing Standards

### Code Formatting

Always include language identifier and expected output:

```
LANGUAGE: [PowerShell | Azure CLI | C# | JSON | etc.]
[Code block]
EXPECTED OUTPUT: [Expected result]
```

### Screenshots & Diagrams

- Use for step-by-step UI walkthroughs
- Annotate important elements
- Include descriptive captions
- Keep file size < 500KB

### Tables

Use to:
- Compare features or options
- List requirements
- Show configuration parameters
- Display information matrices

Guidelines:
- Maximum 4 columns
- Maximum 8-10 rows
- Always include descriptive captions

### Lists

- **Numbered lists**: For sequential steps
- **Bullet lists**: For options or examples
- **Maximum nesting**: 2 levels

## Structure Guidelines

### Heading Hierarchy

**Strict rules:**
- **H1 (#)**: Document title only (one per document)
- **H2 (##)**: Major sections
- **H3 (###)**: Subsections
- **H4 (####)**: Sub-subsections (use sparingly)
- **Never use H5+ (#####)**

### Cross-References

**Format**:
```
[Document Title](../docs/filename.md) - Brief explanation of relevance.
```

## Accessibility Guidelines

### Writing for Different Skill Levels

- **Foundation**: Explain everything; assume no prior knowledge
- **Intermediate**: Build on foundational knowledge; explain new concepts
- **Advanced**: Focus on scenarios and edge cases

### Formatting for Readability

- Short paragraphs (2-4 sentences)
- Use lists liberally
- Frequent subheadings
- Blank lines around code blocks
- Bold for key concepts
- Code format for technical terms

### Callout Formats

```
**[IMPORTANT]:** Critical information here
**[NOTE]:** Additional context
**[TIP]:** Helpful shortcut
**[WARNING]:** Something that could go wrong
```

## Quality Standards Checklist

Before submitting:
- [ ] Spell check completed
- [ ] Grammar verified
- [ ] All links tested
- [ ] Code examples tested
- [ ] Headings follow H1-H4 hierarchy
- [ ] Tables have captions
- [ ] Cross-references correct
- [ ] Tone is professional but approachable
- [ ] Sentences average 15-20 words
- [ ] No undefined acronyms
- [ ] All 11 sections complete (per CONTENT_TEMPLATE.md)

## Common Mistakes to Avoid

- ❌ Too technical without explanation → Define terms, explain the "why"
- ❌ Too vague → Use specific examples and expected outputs
- ❌ Assuming reader knowledge → Explain foundational concepts
- ❌ Very long paragraphs → Break into 2-4 sentence chunks
- ❌ Passive voice → Use active voice ("you configure" not "can be configured")
- ❌ Code without explanation → Always explain what code does
- ❌ No related documents → Always include prereqs and next steps

## Review Process

### Self-Review
1. Read aloud for flow and clarity
2. Run spell/grammar check
3. Test all links
4. Verify heading hierarchy
5. Check code examples have language identifier
6. Verify tables have captions
7. Count sentences per paragraph (should be 2-4)
8. Scan for undefined terminology

### Peer Review
1. Content accuracy and completeness
2. Clarity for unfamiliar readers
3. Logical flow and structure
4. Guideline compliance
5. Working links

### Final Approval
1. Address all review comments
2. Re-run quality checks
3. Test links again
4. Verify document ready

These guidelines ensure all Entra-ID-IAM-Lab documents are clear, accurate, and accessible.
