# Framework Alignment Mapping

This document shows how the labs and guides in this repository relate to common security and compliance frameworks. It is a study aid, not a compliance assessment. Completing a lab does not make a tenant compliant with any framework.

Framework references below are at category or article level. Verify control wording against the current published standard before citing it in an audit or portfolio write-up.

---

## What the Repository Covers

| Topic | Lab or guide |
|-------|--------------|
| Provisioning (Joiner) | [Lab 02](../PHASE-1-FREE-TIER/02-identity-provisioning-joiner.md) |
| Group-based RBAC | [Lab 03](../PHASE-1-FREE-TIER/03-group-based-access-control.md) |
| Privileged access | [Lab 04](../PHASE-2-ENTRA-P1/04-privileged-access-management.md) |
| Application access | [Lab 05](../PHASE-2-ENTRA-P1/05-application-access-management.md) |
| Mover and Leaver | [Lab 06](../PHASE-2-ENTRA-P1/06-identity-lifecycle-mover-leaver.md) |
| Audit and sign-in logging | [Lab 07](../PHASE-3-ENTRA-P2/07-audit-logging-monitoring.md) |
| MFA | Labs [07a](../PHASE-3-ENTRA-P2/07a-configure-totp-mfa.md), [07b](../PHASE-3-ENTRA-P2/07b-enable-authenticator-push-mfa.md) |
| Conditional Access and risk | Labs [07c](../PHASE-3-ENTRA-P2/07c-conditional-access-policy.md), [07d](../PHASE-3-ENTRA-P2/07d-risk-based-conditional-access.md) |
| Access reviews | [Lab 17a](../PHASE-4-GOVERNANCE/17a-set-up-access-reviews.md) |
| Governance and GRC | [IGA guide](../PHASE-4-GOVERNANCE/17a-identity-governance-administration.md), [GRC Integration](../17b-grc-integration.md) |

---

## NIST Cybersecurity Framework 2.0

The CSF 2.0 has six functions: Govern, Identify, Protect, Detect, Respond, Recover. Identity work maps mainly to Protect and Detect.

| CSF function | Relevant repository content |
|--------------|-----------------------------|
| Govern | IGA guide, GRC Integration |
| Identify | Lab 02 (identity inventory), Lab 05 (application inventory) |
| Protect | Labs 02–06 (identity management, authentication, access control), Labs 07a–07d |
| Detect | Lab 07 (audit and sign-in logs), Lab 07d (risk signals) |
| Respond | Lab 06 Part B (disable a leaver's account) |
| Recover | Not covered |

CSF 2.0 groups identity management, authentication and access control under the Protect category **PR.AA**. Monitoring falls under **DE.CM**.

---

## Compliance Frameworks

| Framework | Identity-relevant requirements | Related content |
|-----------|-------------------------------|-----------------|
| **HIPAA** Security Rule | Access control, audit controls, person or entity authentication (45 CFR 164.312(a), (b), (d)) | Labs 03, 04, 07, 07a–07d |
| **GDPR** | Integrity and confidentiality (Art. 5(1)(f)), security of processing (Art. 32) | Labs 03, 04, 17a |
| **PCI DSS 4.0** | Requirement 7 (restrict access by business need), 8 (identify and authenticate users), 10 (log and monitor) | Labs 03, 04, 07, 07a–07d |
| **SOC 2** | Common Criteria CC6 (logical access), CC7 (system operations and monitoring) | Labs 03, 04, 06, 07, 17a |
| **ISO/IEC 27001:2022** | Annex A access control, identity management, access rights, privileged access, authentication, logging | Labs 02–07, 17a |
| **FedRAMP** | NIST SP 800-53 families AC (access control), IA (identification and authentication), AU (audit) | Labs 03, 04, 07, 07a–07d |

---

## Gartner IAM Pillars

Gartner organises IAM into capabilities such as identity governance and administration (IGA), access management, privileged access management and machine identity management.

| Pillar | Repository coverage |
|--------|---------------------|
| Identity governance and administration | Labs 02, 06, 17a, IGA guide |
| Access management | Labs 03, 05, 07a–07d |
| Privileged access management | Lab 04 |
| Machine identity management | Not covered |

---

## Using This Mapping

1. Pick the framework your organisation or target employer uses.
2. Find the relevant lab above and complete it.
3. Cite the lab as an example of the control in practice, not as evidence of compliance.

## References
- NIST Cybersecurity Framework 2.0: https://www.nist.gov/cyberframework
- ISO/IEC 27001:2022: https://www.iso.org/standard/27001
- PCI Security Standards Council: https://www.pcisecuritystandards.org/
- HIPAA Security Rule: https://www.hhs.gov/hipaa/for-professionals/security/index.html
- Microsoft Entra documentation: https://learn.microsoft.com/en-us/entra/
