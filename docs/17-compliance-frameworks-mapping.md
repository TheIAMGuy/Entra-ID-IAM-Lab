---
title: Compliance Frameworks - HIPAA, GDPR, PCI DSS, SOC 2 Alignment
part: 8
section: Compliance & Audit
difficulty: Advanced
estimated_reading_time: 45
estimated_lab_time: N/A
prerequisites:
  - 00a-nist-gartner-frameworks.md
  - 00b-enterprise-iam-maturity.md
learning_objectives:
  - Understand major compliance frameworks
  - Map IAM domains to compliance requirements
  - Assess compliance gaps
  - Plan compliance remediation
  - Document compliance posture
---

# Compliance Frameworks: Regulatory Requirements for IAM

## Introduction

Identity and Access Management is critical to compliance with industry regulations. HIPAA requires strong authentication for healthcare data. GDPR mandates user rights and audit trails. PCI DSS demands access control for payment systems. SOC 2 requires documented security controls. This document maps compliance frameworks to IAM domains and shows how to achieve and demonstrate compliance.

**Learning Objectives:**
- Understand major compliance frameworks
- Map IAM domains to compliance requirements
- Assess your compliance gaps
- Plan compliance implementation
- Document compliance evidence

## Major Compliance Frameworks

### HIPAA (Health Insurance Portability & Accountability Act)

**Scope:** Healthcare organizations, health plans, healthcare clearinghouses

**IAM Requirements:**
- Authentication: MFA required for administrative access
- Access Control: Role-based, principle of least privilege
- Audit Logging: All access to protected health information (PHI)
- Encryption: Data in transit and at rest
- User Management: Provisioning, deprovisioning, access reviews

**Relevant IAM Domains:**
- Domain 10 (Authentication): MFA required
- Domain 4 (RBAC): Core requirement
- Domain 13 (Audit): Comprehensive logging
- Domain 12 (IGA): Access reviews at least annually

**Maturity Level Required:** Level 3 minimum

### GDPR (General Data Protection Regulation)

**Scope:** Organizations processing EU resident data

**IAM Requirements:**
- User Rights: Right to access, delete, portability (user-controlled)
- Consent: Explicit consent for data processing
- Data Protection: Encryption, anonymization
- Breach Notification: Report compromised identities within 72 hours
- Audit Trail: Document all data access

**Relevant IAM Domains:**
- Domain 12 (IGA): User rights, access reviews
- Domain 13 (Audit): Audit trails for all data access
- Domain 11 (Identity Verification): Verify user identity for right-to-access
- Domain 3 (Deprovisioning): Handle "right to be forgotten"

**Maturity Level Required:** Level 3

### PCI DSS (Payment Card Industry Data Security Standard)

**Scope:** Organizations processing payment card data

**IAM Requirements:**
- Authentication: MFA for admin access
- Access Control: Role-based, restrict to need-to-know
- Unique Accountability: Unique user IDs, no shared accounts
- Audit Logging: Track all access to cardholder data
- Password Management: Strong passwords, regular changes

**Relevant IAM Domains:**
- Domain 10 (Authentication): MFA for admins
- Domain 4 (RBAC): Core requirement
- Domain 7 (Least Privilege): Core requirement
- Domain 13 (Audit): Comprehensive logging

**Maturity Level Required:** Level 3

### SOC 2 Type II (Service Organization Control)

**Scope:** SaaS providers, cloud services, service organizations

**IAM Requirements:**
- Access Control: Documented policies, enforced technically
- Change Management: Approvals, documentation
- Segregation of Duties: Prevent unauthorized modifications
- Logical Access: Authentication, authorization
- Monitoring: Detect and respond to unauthorized access

**Relevant IAM Domains:**
- Domain 4-7 (Access Control): Core requirement
- Domain 12 (IGA): Documented policies, reviewed regularly
- Domain 13 (Audit): Comprehensive monitoring
- Domain 8 (Conditional Access): Risk-based access

**Maturity Level Required:** Level 3

### ISO 27001:2022 (Information Security Management)

**Scope:** Any organization seeking comprehensive security

**IAM Requirements:**
- User Registration: Documented provisioning
- Access Review: Periodic reviews of access appropriateness
- Access Rights Removal: Documented deprovisioning
- User Authentication: MFA for sensitive systems
- User Responsibilities: Security awareness, password policy

**Relevant IAM Domains:**
- Domain 1-3 (Lifecycle): Provisioning, management, deprovisioning
- Domain 10 (Authentication): MFA
- Domain 12 (IGA): Reviews, responsibility
- Domain 13 (Audit): Documentation

**Maturity Level Required:** Level 3

### FedRAMP (Federal Risk and Authorization Management Program)

**Scope:** Cloud services used by US Federal Government

**IAM Requirements:**
- FISMA Compliance: Federal Information Security Modernization Act
- MFA: Required for all access
- PKI: Certificate-based authentication
- Zero Trust: Assume compromise, continuous verification
- Audit: Comprehensive, immutable logs
- PAM: Privileged access management (Domain 6)

**Relevant IAM Domains:**
- All 17 domains required at high maturity

**Maturity Level Required:** Level 4

## Compliance Assessment Framework

### Step 1: Identify Applicable Frameworks

| Industry | Frameworks | Scope |
|----------|-----------|-------|
| Healthcare | HIPAA | All patient data |
| Financial | PCI DSS, SOX | Payment/banking data |
| EU Operations | GDPR | All EU resident data |
| SaaS Provider | SOC 2 | Customer data access |
| Government | FedRAMP, NIST | Federal data |

### Step 2: Map to IAM Domains

**Example: HIPAA Compliance Mapping**

| HIPAA Requirement | IAM Domain | Implementation |
|------------------|-----------|----------------|
| MFA for admins | Domain 10 | Enforce MFA policy |
| Role-based access | Domain 4 | RBAC with job roles |
| Least privilege | Domain 7 | Remove unnecessary permissions |
| Access reviews | Domain 12 | Quarterly access reviews |
| Audit logs | Domain 13 | Log all PHI access |
| User provisioning | Domain 1 | Automated from HR |
| User termination | Domain 3 | Immediate access removal |

### Step 3: Gap Analysis

**Process:**

1. **Document Current State**
   - What controls are implemented?
   - How are they documented?
   - How are they enforced?

2. **Identify Gaps**
   - What's missing?
   - What's not fully implemented?
   - What's not documented?

3. **Prioritize Remediation**
   - Critical gaps (high risk, required for compliance)
   - Important gaps (should implement)
   - Nice-to-have (good practice, not required)

**Example Gap Analysis:**

```
Current State: Password-based authentication
HIPAA Requirement: MFA for administrative access
Gap: MFA not enforced
Risk: Non-compliance, potential audit finding
Remediation: Implement MFA policy, enforce immediately
Timeline: 30 days
```

### Step 4: Implementation Plan

**Plan Steps:**

1. **Design Compliance Controls**
   - Which IAM domains to implement?
   - How will they be enforced?
   - How will compliance be demonstrated?

2. **Implement Technical Controls**
   - Configure Entra ID policies
   - Enable MFA, audit logging, access reviews
   - Test thoroughly

3. **Document Policies & Procedures**
   - Write formal security policies
   - Document processes (provisioning, access reviews, etc.)
   - Train staff

4. **Audit & Assess**
   - Internal audit of compliance
   - Third-party audit (if required)
   - Address findings

## Compliance Evidence Collection

### Documentation to Maintain

1. **Policies**
   - Access control policy
   - Password policy
   - Multi-factor authentication policy
   - Audit policy

2. **Evidence**
   - MFA enforcement logs
   - Access review documentation
   - Role assignment records
   - Audit logs (preserved)

3. **Risk Assessment**
   - Data classification (what data is sensitive?)
   - Risk assessment (what could go wrong?)
   - Mitigation controls (how do we protect?)

### Audit Logs as Evidence

```
Azure AD Sign-in Logs:
- User authentication events
- MFA success/failure
- Conditional Access policy application

Audit Logs:
- User provisioning/deprovisioning
- Role assignments
- Policy changes
- Administrator actions
```

## Compliance Maturity by Framework

| Framework | Level 2 | Level 3 | Level 4 | Level 5 |
|-----------|---------|---------|---------|---------|
| HIPAA | Basic auth | MFA, RBAC, logs | Advanced controls | Predictive threat detection |
| GDPR | Basic privacy | Full user rights, reviews | Advanced governance | Privacy-by-design automation |
| PCI DSS | Passwords, logs | MFA, RBAC, reviews | Advanced controls | Real-time threat detection |
| SOC 2 | Basic controls | Documented, enforced | Continuous monitoring | AI-driven detection |
| ISO 27001 | Basic controls | Full implementation | Continuous improvement | Maturity excellence |

## Related Documents

**Prerequisites:**
- [NIST & Gartner Frameworks](./00a-nist-gartner-frameworks.md) - Framework context
- [Enterprise IAM Maturity](./00b-enterprise-iam-maturity.md) - Maturity model

**Next Steps:**
- [Audit & Compliance Logging](./06b-governance-workflows.md) - Logging implementation
- [Identity Governance Administration](./17a-identity-governance-administration.md) - IGA platforms

## FAQ

**Q: Do we need to comply with all frameworks?**

A: Only those applicable to your business. Assess which apply to you.

**Q: How do we prepare for compliance audit?**

A: Document policies, maintain audit logs, conduct gap analysis, remediate findings.

**Q: Is maturity level 3 sufficient for compliance?**

A: For most frameworks (HIPAA, GDPR, PCI DSS, SOC 2), yes. FedRAMP requires Level 4+.

**Q: How often should we audit compliance?**

A: Minimum annually. Quarterly or continuous preferred.

**Q: Can we outsource compliance management?**

A: Compliance responsibility can't be outsourced (it's on you), but compliance work can be.

## Next Steps

1. Identify applicable compliance frameworks
2. Map to IAM domains
3. Assess current maturity
4. Document gaps
5. Plan remediation
6. Maintain ongoing compliance

Compliance is continuous, not one-time. Plan for ongoing management.
