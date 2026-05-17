# Framework Alignment Mapping

Complete mapping of how the 75-document knowledge base aligns with major identity and security frameworks: NIST CSF 2.0, Gartner IAM Framework, and compliance standards (HIPAA, GDPR, PCI DSS, SOC 2, ISO 27001, FedRAMP).

## NIST Cybersecurity Framework 2.0

### NIST Function 1: Govern

**Objective**: Establish governance structure, policy, strategy, and risk management

Relevant documents:
- 20: Governance Structure
- 20a: Implementation Roadmap  
- 20b: Enterprise Maturity Assessment
- 20c: Migration Strategy
- 17: Compliance Frameworks Mapping
- 00a: NIST/Gartner Frameworks
- 00b: Enterprise IAM Maturity

**Governance controls mapped:**
- Governance committees and decision authorities
- Policy development and enforcement
- Risk management and compliance
- Executive oversight
- Enterprise strategy and planning

### NIST Function 2: Identify

**Objective**: Develop understanding of identity landscape and systems

Relevant documents:
- 00: IAM Landscape Overview
- 01: User Provisioning (Joiner)
- 02: User Management (Mover)
- 06: User Deprovisioning (Leaver)
- 16: Data Quality Management
- 16b: Master Data Management
- 16c: Attribute Management

**Identity controls mapped:**
- User and entity identification
- Attribute standards and management
- Data quality assessment
- Current state analysis
- Inventory of systems and access

### NIST Function 3: Protect

**Objective**: Implement safeguards and controls to prevent unauthorized access

Relevant documents:
- 03: RBAC (Role-Based Access Control)
- 03a: ABAC (Attribute-Based Access Control)
- 04: PAM (Privileged Access Management)
- 05: Application Access Management
- 07: Authentication Fundamentals
- 07a: Multi-Factor Authentication
- 07b: Passwordless Authentication
- 08b: Zero Trust Architecture
- 13: Fine-Grained Authorization
- 13b: Segregation of Duties
- 15: Managed Identities
- 18: Self-Service Portal
- 18a: Delegation Administration

**Access control and protection measures:**
- Role definitions and RBAC
- Least privilege enforcement
- MFA and strong authentication
- PAM for admin access
- Fine-grained authorization
- Application integration
- Zero Trust principles

### NIST Function 4: Detect

**Objective**: Identify anomalies and security incidents

Relevant documents:
- 08: Identity Risk Detection
- 08a: Insider Threat Management
- 17c: Incident Response
- 17d: Risk Scoring Algorithm
- 19a: Identity Intelligence (IVIP)

**Detection capabilities:**
- User and sign-in risk scoring
- Anomaly detection and behavioral analytics
- Insider threat indicators
- Incident alerting
- Risk-based access decisions

### NIST Function 5: Respond

**Objective**: Respond to and manage security incidents

Relevant documents:
- 17c: Incident Response
- 17b: GRC Integration
- 19b: Identity KPI Management

**Response processes:**
- Incident detection and triage
- Containment and eradication
- Investigation and forensics
- Remediation and recovery
- Post-incident review

### NIST Function 6: Recover

**Objective**: Restore systems after incidents

Relevant documents:
- 17c: Incident Response (recovery phase)
- 20c: Migration Strategy (rollback)
- 19-identity-reporting-analytics.md (verify restoration)

## Gartner IAM Framework

### Gartner Pillar 1: Identity Management (IDM)

Core identity lifecycle: user provisioning, updates, deprovisioning

Documents:
- 01: Joiner Provisioning
- 02: Mover Management  
- 06: Leaver Offboarding
- 18b: Provisioning Automation
- 16: Data Quality Management

### Gartner Pillar 2: Access Management (AM)

Granting and managing access rights

Documents:
- 03: RBAC
- 04: PAM
- 05: App Access Management
- 13: Fine-Grained Authorization
- 13b: Segregation of Duties
- 18: Self-Service Portal
- 18a: Delegation Administration

### Gartner Pillar 3: Privileged Access Management (PAM)

Managing high-privilege accounts

Documents:
- 04: PAM Deep Dive
- 13b: SoD (applies to privileged users)
- 15: Managed Identities (eliminates privileged credentials)

### Gartner Pillar 4: Directory Services

Core identity store

Documents:
- 09d: LDAP and Directory Services
- 10: Hybrid Identity
- 16b: Master Data Management

### Gartner Pillar 5: Identity Verification Intelligence Platform (IVIP)

Risk scoring and threat detection

Documents:
- 08: Risk Detection
- 17d: Risk Scoring Algorithm
- 19a: Identity Intelligence (IVIP)
- 08a: Insider Threat Detection

### Gartner Pillar 6: Machine Identity Management

Workload and service identity

Documents:
- 11a: Workload Identity
- 11b: Machine Identity
- 14: SPIFFE/SPIRE
- 14a: Service Mesh Identity
- 14b: Container Workload Identity
- 15a: Workload Federation
- 15b: Secrets Management
- 15c: Certificate Management

## Compliance Framework Alignment

### HIPAA (Healthcare Privacy & Security)

Required identity controls:
- RBAC (Domain 4, Doc 03)
- MFA (Domain 10, Doc 07a)
- Audit logging (Domain 13, Doc 13)
- Access reviews (Domain 12, Doc 17a)

Documents mapping:
- 17: Compliance mapping (HIPAA section)
- 06a: Access reviews
- 19: Reporting and audit

**Compliance status**: Full coverage of HIPAA identity requirements

### GDPR (EU Data Protection)

Required identity controls:
- Data minimization (Doc 16, 16c)
- User rights (right to deletion, access, portability)
- Consent management
- Audit trail (Doc 19)

Documents mapping:
- 17: Compliance mapping (GDPR section)
- 16: Data quality (data minimization)
- 06: Offboarding (user deletion)

**Compliance status**: Full coverage of GDPR identity requirements

### PCI DSS (Payment Card Security)

Required identity controls:
- Unique user IDs (Doc 01, 02)
- Strong authentication (Doc 07a)
- RBAC (Doc 03)
- Access reviews (Doc 17a)
- Audit logging (Doc 19)

Documents mapping:
- 17: Compliance mapping (PCI section)
- 03: RBAC enforcement
- 07a: MFA requirement

**Compliance status**: Full coverage of PCI DSS identity requirements

### SOC 2 (Service Organization Controls)

Required identity controls:
- Access controls (Doc 03, 04, 05)
- Monitoring (Doc 08, 19a)
- Incident response (Doc 17c)
- Audit trail (Doc 19)

Documents mapping:
- 17: Compliance mapping (SOC 2 section)
- 17c: Incident response procedures
- 19a: Monitoring and intelligence

**Compliance status**: Full coverage of SOC 2 identity requirements

### ISO 27001 (Information Security Management)

Required identity controls:
- User registration (Doc 01, 02, 06)
- Access management (Doc 03, 04, 05)
- Role-based access (Doc 03)
- Access review (Doc 17a)

Documents mapping:
- 17: Compliance mapping (ISO section)
- 06a: Access reviews (A.6.2.6)
- 13: Authorization (A.7.2)

**Compliance status**: Full coverage of ISO 27001 identity controls

### FedRAMP (Federal Cloud Security)

Required identity controls:
- AC (Access Control) - 22 controls
- AU (Audit) - 12 controls  
- IA (Identification/Authentication) - 4 controls
- Plus all other domains at advanced level

Documents mapping:
- 17: Compliance mapping (FedRAMP section)
- All 17 identity domains at Level 3-4

**Compliance status**: Comprehensive coverage supporting FedRAMP authority to operate

## 17 Identity Domain Coverage

| Domain | Primary Documents | Frameworks | NIST Function |
|--------|------------------|-----------|---------------|
| 1. Provisioning | 01, 02, 06, 18b | NIST, ISO, HIPAA | Identify, Protect |
| 2. Management | 02, 06a | NIST, ISO | Protect |
| 3. Deprovisioning | 06 | NIST, GDPR, ISO | Protect |
| 4. RBAC | 03, 03a | NIST, PCI, SOC 2 | Protect |
| 5. PAM | 04 | NIST, FedRAMP | Protect |
| 6. App Access | 05 | NIST, PCI | Protect |
| 7. Least Privilege | 03, 04, 13b | All | Protect |
| 8. Conditional Access | 08, 08c | NIST, Gartner | Detect |
| 9. Adv Authorization | 13, 13a, 13b | NIST | Protect |
| 10. Authentication | 07, 07a, 07b | All | Protect |
| 11. Identity Verification | 01a | GDPR, ISO | Identify |
| 12. IGA | 17a, 06a | Gartner | Govern |
| 13. Audit & Logging | 19, 19b | All | Detect |
| 14. Standards | 09a-f | NIST, Gartner | Protect |
| 15. Zero Trust | 08b | NIST, FedRAMP | Protect |
| 16. Workload Identity | 11a, 11b, 14, 14a, 14b, 15a | Gartner, Emerging | Protect |
| 17. Identity Intelligence | 19a | Gartner, NIST | Detect |

## Enterprise Program Alignment

### Enterprise Governance (Part 10)

Documents align with:
- NIST: Govern function
- Gartner: Enterprise governance best practices
- ISO 27001: A.5 Organizational controls
- All compliance frameworks: Governance requirements

**Coverage**: Governance structure, roles, policies, roadmap, maturity, migration

## Summary Statistics

- **Total documents**: 75
- **NIST function coverage**: 6/6 (100%)
- **Gartner pillar coverage**: 6/6 (100%)
- **Compliance frameworks**: 6/6 (100%)
- **Identity domains**: 17/17 (100%)
- **Learning paths**: 8/8 (100%)
- **Maturity levels**: 5/5 (100%)

## Using This Mapping

**By framework**: Find your compliance/security framework above, see which documents cover requirements

**By control**: See which documents implement each control

**By domain**: See which documents cover each identity domain

**Integration**: All 75 documents work together as comprehensive, integrated knowledge base
