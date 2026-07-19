---
title: IAM Landscape Overview - The Complete Identity Ecosystem
part: 0
section: Foundation & Context
difficulty: Foundation
estimated_reading_time: 45
estimated_lab_time: N/A
prerequisites: []
learning_objectives:
  - Understand the complete IAM landscape and its 17 major domains
  - Map how Microsoft Entra ID addresses each domain
  - Identify your organization's current and target maturity levels
  - Navigate this knowledge base based on your specific needs
---

# IAM Landscape Overview: The Complete Identity Ecosystem

## Introduction

Identity and Access Management (IAM) is one of the most critical but complex areas of enterprise technology. Whether you manage identities for 10 employees or 100,000 users across global organizations, you face similar fundamental challenges: how do you verify who someone is, ensure they can access what they need when they need it, and maintain security while minimizing friction?

This document provides a comprehensive map of the entire IAM landscape. Rather than diving into specific Microsoft Entra ID configurations, we'll first establish a shared vocabulary and conceptual framework. Think of this as your field guide to identity management.

**Learning Objectives:**
- Understand the 17 major domains that comprise modern IAM
- See how these domains interconnect and depend on each other
- Identify which domains apply to your organization
- Learn how this knowledge base is structured to help you master each domain
- Understand the progression from foundational to advanced concepts

**Estimated Reading Time:** 45 minutes

**Note:** This document requires no hands-on lab. It establishes concepts and context used throughout the rest of the knowledge base. After reading, you should understand the "big picture" of identity management and be ready to dive into specific implementation areas.

## The 17 Domains of Modern IAM

Identity and Access Management encompasses 17 distinct but interconnected domains. These domains address different aspects of the identity lifecycle and access control.

### Core Identity & Lifecycle Management (Domains 1-3)

**Domain 1: Identity Provisioning (Joiner)**
Creating and enabling new user identities in your systems. When someone joins your organization, provisioning ensures they have the accounts and attributes needed to be productive on day one.

**Domain 2: Identity Management (Mover)**
Ongoing administration of user accounts throughout their tenure, including updating attributes, managing group memberships, and handling role changes.

**Domain 3: Identity Deprovisioning (Leaver)**
Disabling, revoking, and removing access when users leave the organization. Critical for security and compliance.

### Access Control & Authorization (Domains 4-7)

**Domain 4: Role-Based Access Control (RBAC)**
Assigning permissions to roles rather than individual users. Scales much better as your organization grows.

**Domain 5: Attribute-Based Access Control (ABAC)**
Assigning permissions based on user attributes like department, job title, or location. More flexible than RBAC.

**Domain 6: Privileged Access Management (PAM)**
Controlling and monitoring access to sensitive systems, administrative accounts, and critical infrastructure.

**Domain 7: Least Privilege Access**
The principle that users should have the minimum permissions necessary to perform their job.

### Application & Service Access (Domains 8-9)

**Domain 8: Application Access Management**
Ensuring users can access the applications they need while maintaining security and compliance.

**Domain 9: Conditional Access**
Enforcing security requirements based on conditions (device status, location, risk level).

### Identity Verification & Authentication (Domains 10-11)

**Domain 10: Authentication**
Proving that someone is who they claim to be using multiple factors (password, phone, biometric).

**Domain 11: Identity Verification & Proofing**
Ensuring that when a user sets up their account, they are actually who they claim to be.

### Governance & Compliance (Domains 12-15)

**Domain 12: Identity Governance & Administration (IGA)**
Controlling who has access to what and ensuring that access aligns with business requirements and compliance.

**Domain 13: Audit & Compliance Logging**
Recording who did what and when for compliance and investigation purposes.

**Domain 14: Standards & Compliance Framework Alignment**
Ensuring IAM implementations meet applicable standards and regulations (HIPAA, GDPR, SOC 2, etc.).

**Domain 15: Zero Trust Architecture**
Assuming no one is inherently trustworthy; requires verification at every step.

### Emerging & Advanced Domains (Domains 16-17)

**Domain 16: Machine Identity & IoT**
Managing identities for non-human entities (servers, APIs, microservices, IoT devices).

**Domain 17: Identity Verification & Intelligence Platforms (IVIP)**
Using intelligence and analytics to enhance identity verification and detect unusual access patterns.

## How These Domains Interconnect

These 17 domains form an integrated ecosystem where each layer depends on the ones below it:

```
GOVERNANCE & COMPLIANCE LAYER (Domains 12-15)
    Ensures everything is compliant and auditable
              ↑
SECURITY & VERIFICATION LAYER (Domains 10-11)
    Proves the user is who they claim to be
              ↑
APPLICATION LAYER (Domains 8-9)
    Connects authenticated users to applications
              ↑
ACCESS CONTROL LAYER (Domains 4-7)
    Determines who can do what, with what oversight
              ↑
FOUNDATION LAYER (Domains 1-3)
    Creates → Manages → Terminates identities
```

## Mapping Domains to Microsoft Entra ID

Microsoft Entra ID addresses all 17 domains across its platform:

| Domain | Microsoft Entra Capability |
|--------|----------------------------|
| 1. Provisioning | Cloud sync, directory extension |
| 2. Management | User & group management |
| 3. Deprovisioning | Account disable, remove |
| 4. RBAC | Azure role assignments |
| 5. ABAC | Dynamic groups |
| 6. PAM | Privileged Identity Management |
| 7. Least Privilege | Governance |
| 8. App Access | Enterprise applications, SSO |
| 9. Conditional Access | Conditional Access policies |
| 10. Authentication | Multi-factor authentication |
| 11. Identity Verification | Identity verification policies |
| 12. IGA | Access reviews, entitlement management |
| 13. Audit Logging | Sign-in logs, audit logs |
| 14. Compliance | Compliance manager integration |
| 15. Zero Trust | Conditional Access + device compliance |
| 16. Machine Identity | Managed identities, service principals |
| 17. IVIP | Identity Protection, threat analytics |

## Understanding IAM Maturity

Organizations don't implement all 17 domains perfectly at once. Most progress through maturity stages:

- **Level 1 (Ad Hoc)**: Manual processes, inconsistent identity management
- **Level 2 (Managed)**: Basic provisioning and access control, limited automation
- **Level 3 (Optimized)**: Defined processes, comprehensive implementation
- **Level 4 (Advanced)**: All domains implemented with advanced threat detection
- **Level 5 (Intelligent)**: All domains with ML-based continuous improvement

Where is your organization? This knowledge base is organized so you can progress through maturity levels systematically.

## Key Takeaways

- **IAM is complex but learnable**: 17 domains may seem overwhelming, but each is manageable
- **All domains interconnect**: You can't optimize one domain in isolation
- **Microsoft Entra ID covers all domains**: You have a comprehensive platform
- **Your organization doesn't need all domains equally**: Tailor implementation to your specific needs
- **Maturity progresses over time**: Implement domains progressively

## Compliance & Standards Alignment

This landscape aligns with:
- **NIST Cybersecurity Framework 2.0**: Govern, Identify, Protect, Detect, Respond, Recover functions
- **ISO 27001:2022**: Annex A.5 (Organisational Controls) and A.9 (Access Control)
- **Gartner IAM Framework**: IGA, Access Management, PAM, Directory Management, plus emerging domains

## Related Documents

**Prerequisites:**
- None - this is the foundational document

**Next Steps:**
- [NIST & Gartner Framework Alignment](./00a-nist-gartner-frameworks.md) - Deep dive into compliance frameworks
- [Enterprise IAM Maturity Assessment](./00b-enterprise-iam-maturity.md) - Assess your organization's current state
- [Environment Setup & Prerequisites](./01-environment-setup.md) - Set up your Microsoft Entra ID tenant for hands-on labs

## Further Reading

**Microsoft Official Documentation:**
- [Microsoft Entra ID Overview](https://learn.microsoft.com/en-us/entra/fundamentals/) - Official platform overview
- [Identity and Access Management in Azure](https://learn.microsoft.com/en-us/azure/security/fundamentals/identity-management-overview) - Azure perspective on IAM
- [What is Zero Trust?](https://learn.microsoft.com/en-us/security/zero-trust/) - Microsoft's Zero Trust guidance

## FAQ

**Q: Do we need to implement all 17 domains?**

A: No. Implement domains that address your specific compliance requirements and security risks. A small organization might focus on the first 10 domains, while a financial institution might emphasize all 17.

**Q: What's the difference between IAM and identity management?**

A: Identity management (Domain 2) focuses on managing individual user accounts. IAM is broader and includes the entire ecosystem of provisioning, access control, governance, and compliance.

**Q: How do RBAC and ABAC compare?**

A: RBAC (role-based) is simpler but less flexible. ABAC (attribute-based) is more flexible but more complex. Many organizations use both.

**Q: Is our organization ready for Zero Trust?**

A: Zero Trust is a journey, not a destination. It requires foundational IAM maturity plus advanced technologies. See the maturity assessment document.

**Q: How often should access reviews happen?**

A: Minimum annually per compliance standards. High-risk systems might require quarterly reviews. Organizations at Level 4-5 maturity often conduct continuous reviews.

## Next Steps

You now understand the IAM landscape and how 17 domains work together. Your next steps:

1. Read [NIST & Gartner Framework Alignment](./00a-nist-gartner-frameworks.md) to understand compliance frameworks
2. Complete the assessment in [Enterprise IAM Maturity Assessment](./00b-enterprise-iam-maturity.md)
3. Go to [Part 1: Core Identity & Lifecycle](./02-identity-provisioning-joiner.md) to begin hands-on implementation

This knowledge base is structured so you can either read sequentially or jump to parts most relevant to your needs.
