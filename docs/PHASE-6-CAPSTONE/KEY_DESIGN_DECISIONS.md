# Key IAM Design Decisions

These decisions reflect real-world IAM principles applied throughout the lab:

| Decision | Rationale |
|---|---|
| **Group-based access instead of direct user assignment** | Scalable, auditable, and consistent with RBAC best practices. When a user changes roles, you update group membership (one change) rather than updating dozens of resource permissions. |
| **Scoped roles (User Admin, Global Reader) instead of Global Admin** | Reduces blast radius in case of account compromise; enforces least privilege. Global Administrator should be rare and protected with just-in-time (JIT) access. |
| **Account disabled on offboarding — not deleted** | Preserves audit trail and identity history for compliance review and historical investigation. Deleted accounts leave gaps in the audit record. |
| **Attributes updated before group changes during a Mover event** | Ensures access decisions remain attribute-driven and auditable. Update the source of truth (department, job title) before changing access. |
| **Free-tier constraints documented and design intent preserved** | Demonstrates understanding of production-grade design regardless of environment limitations. The correct architectural pattern is followed; only implementation details were adapted for tier constraints. |

## Production Considerations (2024-2026)

When implementing in a production environment, consider these modern IAM capabilities:

### Core Zero Trust Capabilities
- **Conditional Access Policies** — Add device compliance, location, and risk-based policies to access decisions
- **Continuous Access Evaluation (CAE)** — Real-time token revocation when risk changes (emerging standard in 2024-2025)
- **Privileged Identity Management (PIM)** — Use just-in-time access for administrative roles
- **Multi-Factor Authentication (MFA)** — Mandatory MFA for all sign-ins (Microsoft enforcing October 1, 2025)
- **Passwordless-First** — FIDO2 security keys, Windows Hello, Microsoft Authenticator instead of passwords (new accounts default to passwordless)

### Advanced Identity Architecture (2025+)
- **Identity Fabric** — Unified IAM across cloud, on-premises, and third-party systems via microservices and API-first design
- **Adaptive Identity** — AI-driven continuous verification using behavioral analytics, risk scoring, and contextual signals to make dynamic access decisions
- **AI-Powered Identity Protection** — [Entra Agent ID](https://learn.microsoft.com/en-us/entra/fundamentals/) for AI workload identity; [Security Copilot](https://www.microsoft.com/en-us/security/business/security-101/what-is-copilot-for-security) for automating Conditional Access policy optimization

### Lifecycle & Governance
- **Hybrid Identity** — Integrate on-premises Active Directory with Entra ID
- **Non-Human Identity Governance** — Extend access reviews to service principals, managed identities, and workload identities (30-50% of entitlements in modern orgs)
- **Regular Access Reviews** — Quarterly reviews of user AND workload access (increasingly AI-assisted for triage)
- **Incident Response** — Establish procedures for rapid account disablement and access revocation
- **Application-Specific Security** — Implement app-level authorization beyond Entra ID SSO

### Compliance & Audit (Updated Standards)
- **NIST CSF 2.0** (Feb 2024) — Reference the new "Govern" function alongside Identify, Protect, Detect, Respond, Recover
- **ISO 27001:2022** — Full identity lifecycle (registration, provisioning, maintenance, de-registration) for all entities including non-human
- **SOC 2 & PCI DSS 4.0** — MFA required (no exceptions); Continuous monitoring and dynamic authorization expected
