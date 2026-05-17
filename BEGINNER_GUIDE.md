# Beginner's Guide to the IAM Knowledge Base

Welcome! This guide will help you navigate the repository if you're new to identity and access management (IAM).

## Start Here (30 minutes)

1. **Read:** `docs/00-iam-landscape-overview.md` (understand what IAM is)
2. **Read:** `docs/01-user-provisioning-joiner.md` (see a real example)
3. **Explore:** This guide

## Your Learning Path (Choose One)

### 🚀 Path 1: Build Your First Lab (24 Hours)
**Best if:** You want hands-on experience immediately

1. **Setup (1 hour):** Follow `SANDBOX_SETUP.md`
2. **Learn & Build (24 hours):** Follow `QUICKSTART_LABS.md`
   - Lab 1: Joiner provisioning (joiner workflow)
   - Lab 2: Multi-factor authentication
   - Lab 3: Hybrid identity sync

**Outcome:** You have a working identity system and can explain it to others.

### 🏢 Path 2: Complete the Course (60 Hours)
**Best if:** You want comprehensive knowledge

1. **Follow:** Learning Path 1 (Foundations-First) from main README
2. **Duration:** 2-3 months at 5-10 hours/week
3. **Topics:** All 17 IAM domains, compliance, enterprise strategies

**Outcome:** You're proficient in IAM and can design systems.

### 📋 Path 3: Deep Dive by Topic (Custom)
**Best if:** You care about specific areas

- **Security-focused?** → Learning Path 2 (Security-Focused)
- **Cloud-focused?** → Learning Path 4 (Cloud & Hybrid)
- **Compliance-focused?** → Learning Path 7 (Compliance & Audit)
- **Everything?** → Learning Path 8 (Enterprise Program)

---

## Key Resources

### Quick Reference
- **Lab Index:** `LABS_INDEX.md` — All 15 hands-on labs with time estimates
- **Glossary:** `IAM_GLOSSARY.md` — 100+ IAM terms explained
- **Framework Mapping:** `FRAMEWORK_MAPPING.md` — How topics map to NIST/Gartner frameworks

### Visual Aids
- **Diagrams:** `/diagrams/` folder contains architecture visuals
  - `01-user-provisioning-flow.md` — User lifecycle (hire, move, fire)
  - `02-hybrid-identity-architecture.md` — Cloud + on-premises integration
  - `03-zero-trust-architecture.md` — Zero Trust design

### Hands-On Labs
- **Scripts:** `/labs/scripts/` — Ready-to-run examples
- **Samples:** `/samples/` — Configuration templates

---

## Understanding IAM Domains (17 Pillars)

Don't try to learn all 17 at once. They build on each other.

### Tier 1: Foundational (Start Here)
1. **User Provisioning** — How users get access
2. **RBAC** — Role-based access control
3. **Authentication** — How users prove who they are
4. **Authorization** — What users can do

### Tier 2: Intermediate (Next)
5. **PAM** — Privileged access management
6. **MFA** — Multi-factor authentication
7. **Standards** — SAML, OAuth, SCIM
8. **Hybrid Identity** — Cloud + on-premises

### Tier 3: Advanced (After Tier 2)
9. **Workload Identity** — Machines/containers getting access
10. **Zero Trust** — Trust nothing, verify everything
11. **IGA** — Identity governance & administration
12. **Risk Scoring** — AI-driven threat detection

### Tier 4: Enterprise (Last)
13-17. **Enterprise Strategy** — How to scale across organizations

---

## How to Use This Repository

### Reading a Document
1. Start with the **Introduction** (sets context)
2. Skim the **Concepts** section (high-level overview)
3. Deep dive into topics that interest you
4. Check **Hands-On Lab** if available
5. Reference **FAQ** if confused

### Running a Lab
1. Follow `SANDBOX_SETUP.md` (one-time setup)
2. Pick a lab from `LABS_INDEX.md`
3. Read the prerequisite documents
4. Run the script from `labs/scripts/`
5. Troubleshoot using "Common Mistakes" sections

### Understanding a Framework
1. Check `FRAMEWORK_MAPPING.md` for overview
2. Find which documents cover that framework
3. Read "Framework Alignment" sections in documents
4. See how identity controls map to framework requirements

---

## Common Questions

**Q: Where do I start if I've never done identity before?**
A: Start with `QUICKSTART_LABS.md` (24-hour learning path). No prerequisites.

**Q: How long until I can build a production system?**
A: ~3-6 months. Learning Path 1 (Foundations) is ~60 hours. Add your own projects.

**Q: Can I skip parts?**
A: Yes, but understand dependencies. User Provisioning (Part 1) is prerequisite for most others. See learning path prerequisites in main README.

**Q: How do I stay current?**
A: Check `FURTHER_READING.md` for books, blogs, certifications. Subscribe to identity newsletters.

**Q: What certifications should I get?**
A: See `FURTHER_READING.md` → Certifications section. Start with Azure fundamentals, then AZ-500 (Security), then AZ-305 (Architecture).

---

## Tips for Success

### 1. Learn by Doing
Don't just read. Every document has a hands-on lab. Do it.

### 2. Build a Test Lab
Use `SANDBOX_SETUP.md` to get free Azure/AWS. Practice there, not production.

### 3. Take Notes
Identity has lots of acronyms. Keep glossary handy.

### 4. Join Communities
- Microsoft Entra ID forums
- Identity-focused Slack channels
- Local IT meetups

### 5. Apply What You Learn
Start small:
- Week 1: Enable MFA in your organization
- Week 2: Automate user provisioning
- Week 3: Set up access reviews
- Month 2: Implement hybrid identity
- Month 3: Add risk-based conditional access

---

## What You Can Do After This Course

✅ Design a complete identity system
✅ Explain identity concepts to non-technical people
✅ Build provisioning automation
✅ Implement multi-factor authentication
✅ Set up secure hybrid identity (cloud + on-prem)
✅ Detect and respond to identity attacks
✅ Govern access and prevent excessive permissions
✅ Architect Zero Trust architecture
✅ Design workload identity for containers/K8s
✅ Speak confidently about identity security

---

## Next Steps

1. **Right Now:** Pick a learning path above
2. **This Week:** Complete one lab
3. **This Month:** Read 3-4 foundational documents
4. **This Quarter:** Complete one learning path
5. **This Year:** You're proficient in IAM

---

## Getting Help

**Documentation unclear?**
- Check `IAM_GLOSSARY.md` for term definitions
- Review "Common Mistakes" in lab
- Look at code samples in `/samples/`

**Script not working?**
- Check prerequisites (tools installed, accounts created)
- Review script comments
- Check troubleshooting section in corresponding document

**Want more?**
- Read the full document beyond the lab
- Check related documents (links in each doc)
- Explore learning path for your role

---

## Final Advice

Identity is complex because **security is complex**. But the fundamentals are simple:
- Users need access (provisioning)
- Users prove who they are (authentication)
- Users get what they need, nothing more (authorization)
- Bad guys are stopped (security)

Master those four concepts, and everything else builds on them.

**You've got this. Let's build some identity systems.**

---

For questions or feedback: See CONTRIBUTING.md

