---
title: Compliance Frameworks Mapping - Identity Controls Aligned with Standards
part: 8
section: Compliance & Audit
difficulty: Advanced
estimated_reading_time: 35
estimated_lab_time: N/A
prerequisites:
  - 00a-nist-gartner-frameworks.md
learning_objectives:
  - Understand major compliance frameworks
  - Map identity controls to compliance requirements
  - Implement controls for each framework
  - Align identity governance with regulatory standards
  - Prepare for compliance audits
---

# Compliance Frameworks Mapping: Identity Controls Aligned with Standards

## Introduction

Compliance frameworks (HIPAA, GDPR, PCI DSS, SOC 2, ISO 27001, FedRAMP) define security requirements organizations must meet. Each framework has identity-related requirements: "Implement role-based access control" (HIPAA), "Delete personal data on user request" (GDPR), "Unique user IDs" (PCI). Identity programs must map controls to frameworks to demonstrate compliance. This document maps major frameworks to identity controls.

**Learning Objectives:**
- Understand six major compliance frameworks
- Map identity domains to compliance requirements
- Implement controls for each framework
- Track compliance status
- Prepare for audits

## Compliance Framework Overview

### Six Major Frameworks

```
Framework 1: HIPAA (Health Insurance Portability and Accountability Act)
  Jurisdiction: USA (healthcare)
  Scope: Protected Health Information (PHI)
  Relevant sections:
    - 45 CFR 164.308(a)(4) - Access control
    - 45 CFR 164.308(a)(5) - Audit controls
    - 45 CFR 164.312(a)(2) - User identification and authentication
  Key controls: RBAC, MFA, audit logging, access reviews

Framework 2: GDPR (General Data Protection Regulation)
  Jurisdiction: EU (all organizations processing EU residents' data)
  Scope: Personal data
  Relevant articles:
    - Article 32 - Security measures
    - Article 5 - Data principles (integrity, confidentiality, availability)
    - Article 17 - Right to be forgotten (deletion)
  Key controls: Data minimization, retention, user rights, deletion on request

Framework 3: PCI DSS (Payment Card Industry Data Security Standard)
  Jurisdiction: Global (card payment industry)
  Scope: Cardholder data
  Relevant requirements:
    - Requirement 7 - Restrict access to cardholder data
    - Requirement 8 - User identification and authentication
    - Requirement 10 - Logging and monitoring
  Key controls: Unique user IDs, strong authentication, access reviews

Framework 4: SOC 2 (Service Organization Control)
  Jurisdiction: Global (service providers)
  Scope: Security, availability, confidentiality
  Trust service criteria:
    - CC6 - Logical and physical access controls
    - CC7 - System monitoring
  Key controls: Access controls, monitoring, audit trail

Framework 5: ISO 27001 (Information Security Management)
  Jurisdiction: Global (all organizations)
  Scope: Information security
  Relevant controls:
    - A.5 - Organizational controls
    - A.6 - People management
    - A.7 - Access control
  Key controls: User registration, access review, RBAC

Framework 6: FedRAMP (Federal Risk and Authorization Management Program)
  Jurisdiction: USA (federal agencies)
  Scope: Cloud services
  Control categories:
    - AC (Access Control) - 22 controls
    - AU (Audit) - 12 controls
    - IA (Identification and Authentication) - 4 controls
  Key controls: RBAC, MFA, audit, access reviews, segregation of duties
```

## HIPAA Compliance Mapping

### HIPAA Requirements and Identity Controls

```
HIPAA Requirement: 45 CFR 164.308(a)(4)
  "Implement policies and procedures for granting access to ePHI"
  
  Identity Controls:
    ✓ Domain 4 (RBAC): Define roles for healthcare staff
      Example: Clinician role → Access to patient records
               Administrator role → Access to audit logs
               Finance role → Access to billing data
    
    ✓ Domain 7 (Least Privilege): Grant minimal access
      Example: Nurse can view patient vitals, not prescriptions
               Pharmacy can view prescriptions, not vitals
    
    ✓ Domain 12 (IGA): Quarterly access reviews
      Example: Verify each user still needs their access
               Remove access no longer needed
    
    ✓ Domain 13 (Audit): Log all access to PHI
      Example: User A viewed Patient Record X at Time T
               User B accessed Lab Results at Time T
  
  Evidence for audit:
    - Access control policy (approved by compliance officer)
    - Role definitions and access assignments
    - Access review documentation (quarterly)
    - Audit logs (6+ months retained)

Compliance status: COMPLIANT (if all controls implemented)
Verified: Annual HIPAA audit
```

## GDPR Compliance Mapping

### GDPR User Rights Implementation

```
GDPR Article 17: Right to Erasure
  "Data subject has right to erasure of personal data"
  
  Implementation:
    ✓ User deletion process
    ✓ Data retention policy
    ✓ Deletion automation post-departure

Evidence:
  - Data retention policy
  - Deletion procedures
  - User deletion logs
```

## PCI DSS Compliance Mapping

### PCI DSS Access Control

```
PCI DSS Requirement 8: User Identification
  "Assign unique ID to each person"
  
  Identity Controls:
    ✓ Unique usernames (one per employee)
    ✓ MFA enforcement
    ✓ Password policies
    ✓ Audit logging of access

Evidence:
  - User listing (verify uniqueness)
  - MFA implementation documentation
  - Access review records
  - Audit logs
```

## Best Practices

1. Map each framework to identity controls
2. Document evidence as you implement
3. Conduct quarterly reviews
4. Maintain audit trails for 6+ years
5. Train staff on compliance requirements

## Related Documents

**Prerequisites:**
- [NIST/Gartner Frameworks](./00a-nist-gartner-frameworks.md)

**Next Steps:**
- [IGA Platforms](./17a-identity-governance-administration.md)
- [GRC Integration](./17b-grc-integration.md)

## FAQ

**Q: Which framework applies to us?**

A: Depends on industry. Most organizations need ISO 27001 plus one other.

## Next Steps

1. Determine applicable frameworks
2. Map controls to requirements
3. Identify gaps
4. Remediate
5. Audit

Compliance frameworks drive identity control requirements.
