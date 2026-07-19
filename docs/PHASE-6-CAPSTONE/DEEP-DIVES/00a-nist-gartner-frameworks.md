---
title: NIST & Gartner Framework Alignment for IAM
part: 0
section: Foundation & Context
difficulty: Foundation
estimated_reading_time: 50
estimated_lab_time: N/A
prerequisites:
  - 00-iam-landscape-overview.md
learning_objectives:
  - Understand NIST Cybersecurity Framework 2.0 and its functions
  - Learn Gartner IAM Framework components
  - Map your IAM domains to these frameworks
  - Understand compliance requirements by framework
---

# NIST & Gartner Framework Alignment for IAM

## Introduction

Modern identity management doesn't exist in a vacuum. Organizations implement IAM to address specific requirements: compliance mandates, security risk mitigation, operational efficiency, or all three. This document explains two critical frameworks: NIST Cybersecurity Framework 2.0 (a government standard used across industries) and the Gartner IAM Framework (an industry analyst perspective).

**Learning Objectives:**
- Understand NIST Cybersecurity Framework 2.0 and its six functions
- Learn the Gartner IAM Framework and its components
- Map the 17 IAM domains to both frameworks
- Identify which domains matter most for your compliance requirements

## NIST Cybersecurity Framework 2.0

The NIST Cybersecurity Framework (NIST CSF 2.0) is a comprehensive, standards-based approach to managing cybersecurity risk. It includes six functions that form the foundation of any cybersecurity program:

### The Six Functions of NIST CSF 2.0

**Function 1: Govern (G)**
Establish organizational context, risk management strategy, and governance structures for cybersecurity.

**Function 2: Identify (ID)**
Understand your systems, assets, and information to manage cybersecurity risk.

**Function 3: Protect (P)**
Implement safeguards to ensure delivery of critical functions.

**Function 4: Detect (D)**
Implement processes and tools to identify cybersecurity events.

**Function 5: Respond (R)**
Respond to cybersecurity incidents.

**Function 6: Recover (Rc)**
Restore systems and identities to normal operation.

### IAM Domain Alignment with NIST Functions

| IAM Domain | NIST Function | Why It Matters |
|-----------|---------------|----------------|
| 1. Provisioning | Identify + Protect | Identify who needs accounts; protect new accounts |
| 2. Management | Govern + Protect | Governance determines access appropriateness; protection maintains it |
| 3. Deprovisioning | Protect + Respond | Protect systems when users leave; respond to incidents |
| 4. RBAC | Protect | Core protection mechanism |
| 5. ABAC | Protect + Govern | Governance defines attributes; protection uses them |
| 6. PAM | Protect + Detect | Protect privileged systems; detect unauthorized privilege use |
| 7. Least Privilege | Protect | Core protection principle |
| 8. App Access | Protect + Govern | Governance determines policies; protection enforces them |
| 9. Conditional Access | Protect + Detect | Protection based on context; detection of suspicious context |
| 10. Authentication | Protect + Detect | Stronger authentication protects; failed attempts detect |
| 11. Identity Verification | Identify + Protect | Identify who users are; protect against false identities |
| 12. IGA | Govern + Detect | Governance for access reviews; detection of inappropriate access |
| 13. Audit & Logging | Detect + Respond | Detect attacks through logs; respond informed by data |
| 14. Standards & Compliance | Govern | Establish compliance requirements |
| 15. Zero Trust | Protect + Detect | Continuous protection and verification |
| 16. Machine Identity | Identify + Protect | Identify machines; protect machine-to-machine access |
| 17. IVIP | Detect + Respond | Detect compromises and unusual behavior |

## Gartner IAM Framework

Gartner defines IAM through four primary components plus emerging domains:

### Gartner Primary Components

**1. Identity Access Governance (IGA)**
The processes, policies, and systems that determine who has access to what and ensure access is appropriate and compliant.

**2. Access Management**
Technologies and processes for authenticating users and controlling what applications and data they access.

**3. Privileged Access Management (PAM)**
A specialized focus on controlling, monitoring, and auditing access to sensitive systems and privileged accounts.

**4. Directory Management**
Systems that store identity information and synchronize it across on-premises and cloud environments.

### Gartner Emerging Components

**5. Identity Verification & Intelligence Platforms (IVIP)**
Platforms combining identity verification with behavioral analytics to detect and prevent identity fraud.

**6. Machine Identity Management**
Specialized access management for non-human entities (servers, services, APIs, IoT devices).

### Framework Comparison

| NIST Function | Gartner Component | Focus |
|---------------|------------------|-------|
| Govern | IGA | Establishing policies and governance |
| Identify | Directory Management | Discovering and tracking identities |
| Protect | Access Management + PAM | Implementing access controls |
| Detect | IVIP | Finding unusual behavior and compromise |
| Respond | IGA + Detect | Remediating inappropriate access |
| Recover | Directory Management | Restoring systems and identities |

## Compliance Standards

Different standards reference these frameworks:

**Aligned with NIST CSF 2.0:**
- NIST Special Publication 800-53
- NIST SP 800-171
- CMMC 2.0

**Aligned with Gartner Framework:**
- ISO 27001:2022
- SOC 2 Type II
- HIPAA

**Aligned with Both:**
- PCI DSS
- GDPR
- SOX

## Designing Your IAM Implementation

Use these frameworks to guide your implementation:

1. **Identify applicable frameworks**: What standards apply to you?
2. **Map to functions/components**: Which are required?
3. **Identify applicable domains**: Which 17 domains must you implement?
4. **Prioritize implementation**: Compliance requirements first, then risks, then efficiency
5. **Validate coverage**: Periodically confirm you're covering all requirements

## Real-World Example: Financial Institution

A bank implementing IAM following these frameworks would:

**Applicable Standards:** NIST 800-53, SOC 2, PCI DSS, GDPR

**Framework Mapping:**
- NIST CSF 2.0: All six functions required
- Gartner: All four primary components + IVIP

**Prioritized Domains:**
1. Phase 1: Core lifecycle (Domains 1-3) and authentication (Domain 10)
2. Phase 2: Access control (Domains 4-9) and audit (Domain 13)
3. Phase 3: Governance (Domain 12) and frameworks (Domain 14)
4. Phase 4: Threat detection (Domain 17) and Zero Trust (Domain 15)

## Related Documents

**Prerequisites:**
- [IAM Landscape Overview](./00-iam-landscape-overview.md)

**Next Steps:**
- [Enterprise IAM Maturity Assessment](./00b-enterprise-iam-maturity.md)
- [Part 5: Governance & Compliance](./08-identity-governance-administration.md)

## Further Reading

**NIST Resources:**
- [NIST Cybersecurity Framework 2.0](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5)
- [NIST SP 800-171 Revision 2](https://csrc.nist.gov/publications/detail/sp/800-171/rev-2)

**Standards:**
- [ISO 27001:2022](https://www.iso.org/standard/27001)
- [GDPR Regulation](https://gdpr-info.eu/)
- [SOC 2 Framework](https://www.aicpa.org/interestareas/informationsystems/resources/socseries)

## FAQ

**Q: Which framework should we use?**

A: If you're subject to government regulations, use NIST. If you're a commercial organization, Gartner provides industry perspective. Many use both.

**Q: Do we need all NIST functions for IAM?**

A: You need all six functions, but IAM is one part. Functions like Detect and Respond involve operations beyond identity.

**Q: Is Gartner Magic Quadrant reliable for vendor selection?**

A: It's useful but not the only factor. Consider your specific needs, their vision, execution capability, and support.

**Q: What if our standard isn't listed here?**

A: Map your standard's requirements to NIST functions or Gartner components. Most follow similar patterns.

## Next Steps

1. Identify your applicable frameworks
2. Map to NIST functions or Gartner components
3. Identify applicable domains from the 17
4. Read the maturity assessment to understand your current state
5. Plan your implementation roadmap

These frameworks aren't just for compliance; they're a roadmap to comprehensive, well-rounded IAM implementation.
