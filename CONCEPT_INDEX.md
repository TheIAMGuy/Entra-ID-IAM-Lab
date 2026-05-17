# IAM Concept Index

Cross-reference of all 17 IAM domains and key concepts covered in this knowledge base.

## 17 IAM Domains

### Domain 1: User Provisioning & Joiner
**Documents:** 01-user-provisioning-joiner.md, 01a-identity-proofing.md
**Concepts:** New hire onboarding, HR integration, access initialization, identity verification
**Related:** JML cycle, provisioning automation

### Domain 2: User Management & Mover
**Documents:** 02-user-management-mover.md
**Concepts:** Job changes, org moves, role updates, access recertification
**Related:** Lifecycle management, RBAC updates

### Domain 3: User Deprovisioning & Leaver
**Documents:** 06-leaver-offboarding.md
**Concepts:** Offboarding, account disable, access removal, final approval
**Related:** Offboarding automation, asset recovery

### Domain 4: Role-Based Access Control (RBAC)
**Documents:** 03-role-based-access-control.md, 03a-attribute-based-access-control.md
**Concepts:** Roles, permissions, role hierarchy, RBAC policy
**Related:** ABAC, Fine-grained authorization, Role design

### Domain 5: Privileged Access Management (PAM)
**Documents:** 04-privileged-access-management.md
**Concepts:** Admin access, just-in-time, session recording, SoD
**Related:** Admin governance, segregation of duties

### Domain 6: Application Access & Entitlements
**Documents:** 05-application-access-management.md
**Concepts:** App provisioning, entitlements, connectors, federated access
**Related:** SCIM, SAML, OAuth

### Domain 7: Least Privilege Access
**Documents:** Multiple (embedded in Domain 4, 5, 13)
**Concepts:** Minimal permissions, JIT, time-bound, risk-based
**Related:** ABAC conditions, conditional access

### Domain 8: Conditional Access & Risk
**Documents:** 08-identity-risk-detection.md, 07c-adaptive-authentication.md
**Concepts:** Risk-based policies, MFA challenges, device policies
**Related:** Zero Trust, adaptive auth, risk scoring

### Domain 9: Advanced Authorization (See Domain 13)

### Domain 10: Authentication
**Documents:** 07-authentication-fundamentals.md, 07a-multi-factor-authentication.md, 07b-passwordless-authentication.md
**Concepts:** MFA, passwordless, phishing resistance, FIDO2
**Related:** Adaptive auth, risk detection

### Domain 11: Identity Verification
**Documents:** 01a-identity-proofing.md
**Concepts:** KYC, identity proofing, liveness detection
**Related:** Fraud prevention, zero-trust

### Domain 12: Identity Governance & Administration (IGA)
**Documents:** 17a-identity-governance-administration.md, 06a-access-reviews.md
**Concepts:** Access reviews, certifications, risk scoring, analytics
**Related:** Compliance, audit

### Domain 13: Audit & Compliance Logging
**Documents:** 06b-governance-workflows.md, 19-identity-reporting-analytics.md
**Concepts:** Audit trails, compliance reporting, forensics
**Related:** GRC, incident response

### Domain 14: Standards & Protocols
**Documents:** 09-identity-standards-overview.md, 09a-saml-single-sign-on.md, 09b-oauth-and-openid-connect.md, 09c-scim-provisioning.md, 09d-ldap-and-directory-services.md, 09e-jwt-tokens-implementation.md, 09f-emerging-standards.md
**Concepts:** SAML, OAuth, OIDC, SCIM, LDAP, JWT, FIDO2, SPIFFE
**Related:** Federation, API security

### Domain 15: Zero Trust & Verification
**Documents:** 08b-zero-trust-identity-architecture.md
**Concepts:** Assume breach, verify explicitly, least privilege
**Related:** Conditional access, device compliance

### Domain 16: Machine & Workload Identity
**Documents:** 11a-workload-identity.md, 11b-machine-identity-management.md, 14-spiffe-spire-implementation.md, 14a-service-mesh-identity.md, 14b-container-workload-identity.md, 15-managed-identities.md, 15a-entra-workload-federation.md
**Concepts:** Service principals, managed identity, SPIFFE/SPIRE, certificates, mTLS
**Related:** Cloud-native, Kubernetes, federation

### Domain 17: Identity Intelligence & Risk (IVIP)
**Documents:** 19a-identity-intelligence-ivip.md (planned)
**Concepts:** Behavioral analytics, anomaly detection, risk scoring
**Related:** ML-based detection, UEBA

## Cross-Domain Concepts

### Provisioning & Lifecycle
- Domains: 1, 2, 3
- Documents: 01, 02, 06, 18b
- Flow: Joiner → Mover → Leaver

### Access Control
- Domains: 4, 5, 7, 13
- Documents: 03, 04, 13, 13a, 13b
- Models: RBAC, ABAC, SoD

### Authentication & Security
- Domains: 10, 11, 15, 16
- Documents: 07, 07a, 07b, 08, 08b
- Technologies: MFA, passwordless, Zero Trust

### Standards & Integration
- Domain: 14
- Documents: 09, 09a-f, 09g, 09h
- Protocols: SAML, OAuth, OIDC, SCIM

### Governance & Compliance
- Domains: 12, 13, 17
- Documents: 17, 17a, 17b, 19
- Activities: Reviews, audits, reporting

### Cloud & Hybrid
- Domains: 14, 16
- Documents: 10, 10a, 11, 12, 12a, 14, 14a, 14b, 15, 15a, 15b, 15c
- Models: Hybrid sync, multi-cloud, B2B/B2C

### Data Quality & Management
- Documents: 16, 16a, 16b, 16c
- Dimensions: Completeness, accuracy, consistency, timeliness

## Key Concepts by Maturity Level

### Level 1 Foundation
- User provisioning/deprovisioning
- Basic RBAC
- Password authentication
- Manual processes

### Level 2 Managed
- MFA
- Password policies
- Access reviews (annual)
- Policy documentation

### Level 3 Optimized
- Adaptive authentication
- IGA platforms
- Conditional Access
- Data quality governance

### Level 4 Advanced
- Zero Trust
- Workload identity federation
- Risk-based access
- Automated remediation

### Level 5 Intelligent
- ML-based anomaly detection
- Predictive risk scoring
- Autonomous response
- Continuous verification

## Learning Path Cross-Reference

**Path 1: Foundations-First**
- Start: 00 (landscape), 00a (frameworks), 00b (maturity)
- Progress: 01 (provisioning), 02 (management), 03 (RBAC), 07 (auth)

**Path 2: Security-Focused**
- Start: 00 (landscape)
- Progress: 07, 08, 08a, 08b, 10, 11, 15
- Focus: Authentication, risk, zero trust

**Path 3: Enterprise Governance**
- Start: 00a (frameworks), 00b (maturity)
- Progress: 12, 17, 17a, 17b, 19
- Focus: IGA, compliance, controls

**Path 4: Cloud & Hybrid**
- Start: 10 (hybrid architecture)
- Progress: 10a, 11, 11a, 11b, 14, 14a, 14b, 15, 15a
- Focus: Federation, workload identity, cloud

**Path 5: Standards & Protocols**
- Start: 09 (standards overview)
- Progress: 09a-f (SAML, OAuth, SCIM, LDAP, JWT, emerging)
- Focus: Integration, federated access

**Path 6: Complete JML Cycle**
- Start: 01 (joiner)
- Progress: 01a (identity proofing), 02 (mover), 06 (leaver)
- Focus: Lifecycle, automation

**Path 7: Compliance & Audit**
- Start: 17 (compliance frameworks)
- Progress: 17a, 17b, 19
- Focus: Controls, governance, reporting

**Path 8: Enterprise Program**
- Start: 00a (frameworks)
- Progress: 20 (governance), 20a, 20b, 20c
- Focus: Strategy, implementation, maturity

## Compliance Framework Mapping

### HIPAA
- Domains: 10, 4, 13, 12
- Documents: 17 (mapping), 07a (MFA), 06a (reviews)
- Key Controls: MFA, RBAC, audit, access reviews

### GDPR
- Domains: 12, 13, 11, 3
- Documents: 17 (mapping)
- Key Controls: User rights, audit trail, data deletion

### PCI DSS
- Domains: 10, 4, 7, 13
- Documents: 17 (mapping)
- Key Controls: MFA, RBAC, unique IDs, audit

### SOC 2
- Domains: 4-7, 12, 13, 8
- Documents: 17 (mapping)
- Key Controls: Policies, enforcement, monitoring

### ISO 27001
- Domains: 1-3, 10, 12, 13
- Documents: 17 (mapping)
- Key Controls: Registration, reviews, MFA, documentation

### FedRAMP
- All domains at advanced level
- Documents: 17 (mapping)
- Key Controls: FISMA, MFA, PKI, Zero Trust

## Technology Stack

### On-Premises
- Documents: 09d (LDAP), 10 (hybrid)
- Technology: Active Directory, directory services

### Hybrid
- Documents: 10, 10a, 11
- Technology: Azure AD Connect, OIDC federation

### Cloud (Azure)
- Documents: 03, 03a, 15, 15a, 15b, 15c
- Technology: Azure AD, Managed Identities, Workload Federation

### Multi-Cloud
- Documents: 11, 14, 14a, 14b
- Technology: SPIFFE/SPIRE, service mesh, federation

### SaaS
- Documents: 09a, 09b, 12a
- Technology: SAML, OAuth, SCIM

## Hands-On Labs

**Hands-on labs with step-by-step instructions:**
- 07: MFA configuration in Entra ID
- 07a: Conditional Access policies
- 07b: Passwordless authentication
- 08: Identity Protection
- 09a: SAML single sign-on
- 09b: OAuth/OIDC
- 09c: SCIM provisioning
- 10: Azure AD Connect
- 15: Managed Identity setup
- 17a: Access reviews
- 18: Self-service portal
- 19: Reporting dashboards
- 13: Fine-grained authorization (OPA)
- 14: SPIRE in Kubernetes
- 14a: Service mesh mTLS
- 14b: Container workload identity
- 15a: Workload federation (GitHub Actions)
- 15b: Key Vault secrets
- 15c: Certificate automation
- 18a: Delegated approval workflow

**Labs by domain:**
- Authentication: 07, 07a, 07b
- Authorization: 03, 13, 13a
- Standards: 09a, 09b, 09c, 09d
- Cloud: 10, 15, 15a
- Workload: 14, 14a, 14b
- Governance: 17a, 18a, 19
