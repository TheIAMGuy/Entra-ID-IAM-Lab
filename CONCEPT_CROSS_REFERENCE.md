# IAM Concept Cross-Reference

Comprehensive matrix of 70+ IAM concepts and their relationships across 17 domains, frameworks, maturity levels, and learning paths.

## Concepts Matrix (Subset)

| Concept | Domains | Frameworks | Maturity | Learning Path | Document |
|---------|---------|-----------|----------|---------------|----------|
| User Provisioning | 1, 2, 3 | All | Level 2 | Path 1, 6 | 01 |
| Role-Based Access Control | 4, 7 | NIST, Gartner | Level 2 | Path 1 | 03 |
| Privileged Access Mgmt | 5 | FedRAMP, ISO | Level 3 | Path 1 | 04 |
| MFA (Multi-Factor Auth) | 10 | All frameworks | Level 3 | Path 2 | 07a |
| Passwordless Authentication | 10 | HIPAA, FedRAMP | Level 3 | Path 2 | 07b |
| Conditional Access | 8, 15 | NIST, Gartner | Level 3 | Path 2 | 08 |
| Zero Trust Architecture | 15 | FedRAMP, NIST | Level 4 | Path 2 | 08b |
| SAML Single Sign-On | 14 | NIST | Level 2 | Path 5 | 09a |
| OAuth 2.0 / OIDC | 14 | NIST | Level 2 | Path 5 | 09b |
| SCIM Provisioning | 6, 14 | NIST | Level 3 | Path 5 | 09c |
| Hybrid Identity | 4, 10 | Gartner | Level 3 | Path 4 | 10 |
| Workload Identity | 16 | Gartner | Level 4 | Path 4 | 15a |
| RBAC vs. ABAC | 4, 13 | NIST | Level 2 | Path 1 | 03, 03a |
| Segregation of Duties | 5, 13 | All frameworks | Level 3 | Path 7 | 13b |
| Access Review | 12, 13 | All frameworks | Level 2 | Path 7 | 06a |
| Identity Governance | 12 | Gartner | Level 3 | Path 3 | 17a |
| Compliance Mapping | 12, 13 | All | Level 2 | Path 7 | 17 |
| Risk Scoring | 8, 17 | NIST | Level 3 | Path 2 | 17d |
| Identity Intelligence | 17, 8 | Gartner | Level 4 | Path 2 | 19a |
| Data Quality Management | 7, 16 | ISO | Level 3 | Path 8 | 16 |
| Master Data Management | 16 | ISO | Level 3 | Path 8 | 16b |
| Attribute Standardization | 7, 16 | ISO | Level 3 | Path 8 | 16c |
| Self-Service Portal | 9, 12 | NIST | Level 2 | Path 3 | 18 |
| Delegation Administration | 5, 12 | Gartner | Level 3 | Path 3 | 18a |
| Provisioning Automation | 1, 2, 3 | NIST | Level 3 | Path 6 | 18b |
| KPI Management | 12, 17 | All | Level 2 | Path 8 | 19b |
| Governance Structure | 12 | NIST | Level 3 | Path 8 | 20 |
| Enterprise Roadmap | 12 | All | Level 3 | Path 8 | 20a |
| Maturity Assessment | 12 | All | Level 3 | Path 8 | 20b |
| System Migration | 12 | All | Level 3 | Path 8 | 20c |

## Domain-Concept Mapping

### Domain 1: User Provisioning & Joiner
Concepts: User lifecycle, HR integration, onboarding, account creation, attribute population
Learning paths: Path 1 (Foundations), Path 6 (JML cycle)
Maturity: Level 2-3

### Domain 4: RBAC (Role-Based Access Control)
Concepts: Role hierarchy, role assignment, role management, policy enforcement
Learning paths: Path 1 (Foundations), Path 3 (Enterprise Governance)
Maturity: Level 2-3

### Domain 8: Conditional Access & Risk
Concepts: Risk scoring, anomaly detection, adaptive authentication, policy enforcement
Learning paths: Path 2 (Security-Focused)
Maturity: Level 3-4

### Domain 12: IGA (Identity Governance & Administration)
Concepts: Access reviews, certifications, remediation, analytics, KPIs
Learning paths: Path 3 (Enterprise Governance), Path 7 (Compliance)
Maturity: Level 3-4

### Domain 14: Standards & Protocols
Concepts: SAML, OAuth, OIDC, SCIM, LDAP, JWT, FIDO2, SPIFFE
Learning paths: Path 5 (Standards & Protocols)
Maturity: Level 2-3

### Domain 16: Machine & Workload Identity
Concepts: Service principals, managed identities, SPIFFE/SPIRE, certificate lifecycle
Learning paths: Path 4 (Cloud & Hybrid)
Maturity: Level 3-4

### Domain 17: Identity Intelligence & Risk (IVIP)
Concepts: Behavioral analytics, anomaly detection, UEBA, risk scoring, threat intelligence
Learning paths: Path 2 (Security-Focused)
Maturity: Level 4-5

## Framework-Concept Mapping

### HIPAA Compliance
Key concepts: RBAC, MFA, audit logging, access reviews, PAM
Governance: Annual audits, quarterly reviews
Enforcement: Technical controls + documentation

### GDPR Compliance
Key concepts: Data minimization, retention, user rights, deletion, consent
Governance: Data Protection Officer oversight
Enforcement: Automated deletion, audit trail, consent management

### PCI DSS Compliance
Key concepts: Unique user IDs, MFA, access control, logging, SoD
Governance: Quarterly assessments
Enforcement: Strong authentication, role-based access

### SOC 2 Compliance
Key concepts: Access controls, monitoring, audit trails, incident response
Governance: Annual Type II audit
Enforcement: Automated logging, alerting, control testing

### ISO 27001 Compliance
Key concepts: User registration, access management, role-based access, reviews
Governance: Annual audit
Enforcement: Policy-based, evidence-based

### FedRAMP Compliance
Key concepts: All 17 IAM domains at advanced level
Governance: Annual assessment
Enforcement: Strict control implementation, continuous monitoring

## Maturity-Concept Mapping

### Level 1 (Ad-Hoc) Concepts
Basic concepts: User creation, password reset, simple access
No: Automation, governance, risk management

### Level 2 (Managed) Concepts
Documented: Processes, policies, roles
Basic: RBAC, annual reviews, MFA optional
No: Automation, intelligence, continuous governance

### Level 3 (Optimized) Concepts
Automated: Provisioning, reviews, policy enforcement
Advanced: Conditional access, IGA, SoD
Continuous: Monitoring, risk scoring

### Level 4-5 (Advanced/Intelligent) Concepts
ML/AI: Anomaly detection, predictive risk, autonomous response
Zero Trust: Assume breach, continuous verification
Intelligence-driven: Risk-based decisions, predictive controls

## Learning Path - Concept Coverage

### Path 1: Foundations-First
01 (provisioning), 02 (management), 03 (RBAC), 07 (auth)
Core concepts: Provisioning, roles, basic authentication
Outcome: Understand IAM foundations

### Path 2: Security-Focused
07a, 07b, 08, 08b, 15 (Zero Trust)
Core concepts: MFA, passwordless, risk, adaptive auth
Outcome: Implement modern authentication

### Path 5: Standards & Protocols
09, 09a-f (SAML, OAuth, OIDC, SCIM, LDAP, JWT)
Core concepts: Federation, provisioning protocols
Outcome: Implement standards-based integration

## Cross-Concept Dependencies

```
User Provisioning
  ↓ (requires)
RBAC → Role definitions
  ↓ (enforces)
Least Privilege
  ↓ (enables)
Access Reviews
  ↓ (validates)
Compliance Mapping

Authentication
  ↓ (adds)
MFA
  ↓ (enables)
Conditional Access
  ↓ (detects)
Risk Scoring
  ↓ (drives)
Adaptive Authentication

Access Control
  ↓ (enables)
Governance
  ↓ (requires)
IGA Platform
  ↓ (supports)
Compliance
  ↓ (achieves)
Standards Certification
```

## Searching Concepts

By domain: See "Domain-Concept Mapping" section
By framework: See "Framework-Concept Mapping" section  
By learning path: See "Learning Path" section
By maturity level: See "Maturity-Concept Mapping" section

Total concepts covered: 70+
Documents referenced: 75 (across phases 0-5)
Frameworks covered: 6 (HIPAA, GDPR, PCI, SOC 2, ISO, FedRAMP)
Learning paths: 8
Maturity levels: 5
