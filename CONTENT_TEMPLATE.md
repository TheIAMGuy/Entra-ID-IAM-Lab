# Content Template: Standard Document Structure

This template defines the standard structure for all documents in the Entra-ID-IAM-Lab knowledge base. Use this as your foundation for writing new content.

## Document Structure (11 Sections)

### 1. Introduction (500-800 words)
- **Objective**: Set context and expectations
- **Include**:
  - Clear statement of what this document covers
  - Learning objectives (3-5 bullet points)
  - Prerequisites or recommended reading
  - How this fits into the broader IAM landscape
  - Estimated reading and lab time (if applicable)

### 2. Core Concept Section 1 (1200-1800 words)
- **Objective**: Introduce primary concepts
- **Include**:
  - Concept definitions with context
  - Real-world business scenarios demonstrating the concept
  - Microsoft Entra ID specific implementation details
  - Comparison with industry alternatives (when relevant)
  - Visual diagrams or ASCII art representations

### 3. Core Concept Section 2 (1200-1800 words)
- **Objective**: Expand on intermediate concepts
- **Include**:
  - Build on concepts from Section 2
  - Configuration and implementation patterns
  - Common design patterns and best practices
  - Performance and scaling considerations
  - Security implications

### 4. Core Concept Section 3 (1200-1800 words)
- **Objective**: Advanced topics and practical applications
- **Include**:
  - Integration with other identity components
  - Troubleshooting common issues
  - Advanced scenarios and edge cases
  - Monitoring and health checks
  - Optimization techniques

### 5. Hands-on Lab (OPTIONAL - 1500-3000 words)
- **Objective**: Practical implementation experience
- **Include**:
  - Lab prerequisites and setup requirements
  - Step-by-step instructions with screenshots
  - Expected outputs at each step
  - Common issues and solutions
  - Lab cleanup procedures
  - Variations and extensions for advanced users

### 6. Advanced Topics (OPTIONAL - 800-1500 words)
- **Objective**: Deep-dive into specialized scenarios
- **Include**:
  - Advanced configurations
  - Performance tuning
  - Scaling considerations
  - Integration with third-party systems
  - Custom development scenarios

### 7. Compliance & Standards (400-800 words)
- **Objective**: Map to compliance frameworks
- **Include**:
  - NIST Cybersecurity Framework alignment
  - ISO 27001 Annex A.5 & A.9 alignment
  - SANS best practices alignment
  - Regulatory considerations (HIPAA, GDPR, SOC 2, etc.)
  - Audit and compliance validation points

### 8. Related Documents (200-400 words)
- **Objective**: Guide reader through prerequisite and follow-up content
- **Include**:
  - **Prerequisites**: Documents that should be read first
  - **Next Steps**: Documents that naturally follow
  - **Related Topics**: Cross-references to adjacent concepts
  - **Format**: Use the cross-reference format defined in WRITING_GUIDELINES.md

### 9. Further Reading (200-400 words)
- **Objective**: Point to external resources
- **Include**:
  - Microsoft official documentation links
  - Industry whitepapers
  - Standards documents
  - Recommended blogs/articles
  - Academic resources (where applicable)
  - **Note**: Include brief 1-2 sentence descriptions of each resource

### 10. FAQ (300-600 words)
- **Objective**: Answer common questions
- **Include**:
  - 5-8 frequently asked questions
  - Clear, concise answers
  - References to sections for deeper information
  - Common misconceptions to address

### 11. Next Steps (200-300 words)
- **Objective**: Provide clear path forward
- **Include**:
  - Recommended next document or learning path
  - Implementation roadmap if applicable
  - Key takeaways summary
  - Resources for continued learning

## Document Length Guidelines

- **Minimum**: 8-10 pages (2500-3000 words)
- **Target**: 12-15 pages (4000-5000 words)
- **Maximum**: 18-20 pages (6000-7000 words)
- **Exception**: Shorter documents (6-8 pages) acceptable for specialized topics if all required sections are covered

## Part-Specific Template Variations

### Part 0: Foundation & Context
- Emphasize landscape overview and strategic context
- Include more framework comparisons
- Focus on "why" over "how"
- Compliance & Standards section may be expanded

### Part 1: Core Identity & Lifecycle
- Strong emphasis on Hands-on Lab section
- Include detailed step-by-step procedures
- Focus on practical implementation
- Advanced Topics may be shorter

### Part 2-7: Technical Implementation
- Equal weight to all three concept sections
- Comprehensive Hands-on Lab required
- Advanced Topics usually present
- Focus on architecture and integration

### Part 8: Compliance & Audit
- Compliance section expanded significantly
- Focus on frameworks and standards
- May include fewer practical labs
- Emphasis on validation and measurement

### Part 9-10: Emerging & Leadership
- Longer Advanced Topics section
- Focus on strategy and future direction
- More external research references
- Lab section may be optional (research-based instead)

## Code Example Format

Format all code examples with language identifier and expected output:

```
LANGUAGE: [PowerShell | Azure CLI | C# | JSON | YAML | etc.]

[Code block here]

EXPECTED OUTPUT:
[Expected command output or result]

EXPLANATION: [Brief explanation of what the code does]
```

## Cross-Reference Format

When referencing other documents, use this format:

```
[Document Title](path-to-document.md) - Brief context explaining why this is relevant.
```

Example: [Identity Provisioning Joiner Flow](../docs/02-identity-provisioning-joiner.md) - Understand how users are created before we manage their access.

## Formatting Standards

### Headings
- H1 (#): Document title only
- H2 (##): Section headers
- H3 (###): Subsection headers
- H4 (####): Sub-subsection headers
- **Never exceed H4**

### Lists
- Use **numbered lists** for sequential steps or procedures
- Use **bullet lists** for options, examples, or non-sequential items
- Limit nesting to 2 levels maximum

### Emphasis
- Use **bold** for key concepts on first definition
- Use *italic* for emphasis only
- Use `code format` for commands, file names, system values
- Use **[bold + brackets]** for important warnings or notes

### Code Blocks
- Always include language identifier
- Limit width to 80-100 characters for readability
- Include explanatory comments for complex logic
- Show realistic, runnable examples

### Tables
- Use for comparing features, requirements, or options
- Keep maximum 4 columns
- Limit to 8-10 rows (break into multiple tables if needed)
- Always include descriptive table captions

### Diagrams
- Use ASCII art for architecture diagrams
- Include descriptive caption above diagram
- Keep within 80-character width when possible
- Or describe diagram in text if ASCII not feasible

## Quality Checklist

Before submitting any document, verify:

- [ ] Document contains all 11 required sections
- [ ] Document length is within 8-20 page guideline
- [ ] Introduction clearly states learning objectives
- [ ] Three core concept sections build logically
- [ ] All code examples include language identifier and expected output
- [ ] Compliance section references appropriate frameworks
- [ ] Related Documents use cross-reference format
- [ ] FAQ contains 5-8 questions with clear answers
- [ ] Tone matches WRITING_GUIDELINES.md standards
- [ ] All headings follow H1-H4 hierarchy
- [ ] No formatting inconsistencies (bold, code, etc.)
- [ ] All cross-references to other documents are relative paths
- [ ] Grammar and spelling verified (run spell check)
- [ ] Technical accuracy verified by subject matter expert
- [ ] Screenshots (if any) are clear and properly labeled
- [ ] All external links tested and working

## Document Metadata (Top of File)

Include a metadata comment at the very top of each document:

```
---
title: [Full Document Title]
part: [0-10 or Part Name]
section: [Specific section]
difficulty: [Foundation | Intermediate | Advanced]
estimated_reading_time: [X minutes]
estimated_lab_time: [X minutes, or N/A if no lab]
prerequisites: [[Link to prerequisite docs]]
learning_objectives:
  - [Objective 1]
  - [Objective 2]
  - [Objective 3]
---
```

This template provides a standardized approach while maintaining flexibility for different document types within our 70-75 document knowledge base.
