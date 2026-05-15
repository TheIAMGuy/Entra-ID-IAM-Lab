# Key IAM Design Decisions

These decisions reflect real-world IAM principles applied throughout the lab:

| Decision | Rationale |
|---|---|
| **Group-based access instead of direct user assignment** | Scalable, auditable, and consistent with RBAC best practices. When a user changes roles, you update group membership (one change) rather than updating dozens of resource permissions. |
| **Scoped roles (User Admin, Global Reader) instead of Global Admin** | Reduces blast radius in case of account compromise; enforces least privilege. Global Administrator should be rare and protected with just-in-time (JIT) access. |
| **Account disabled on offboarding — not deleted** | Preserves audit trail and identity history for compliance review and historical investigation. Deleted accounts leave gaps in the audit record. |
| **Attributes updated before group changes during a Mover event** | Ensures access decisions remain attribute-driven and auditable. Update the source of truth (department, job title) before changing access. |
| **Free-tier constraints documented and design intent preserved** | Demonstrates understanding of production-grade design regardless of environment limitations. The correct architectural pattern is followed; only implementation details were adapted for tier constraints. |

## Production Considerations

When implementing in a production environment, consider:

- **Conditional Access Policies** — Add device compliance, location, and risk-based policies to access decisions
- **Privileged Identity Management (PIM)** — Use just-in-time access for administrative roles
- **Multi-Factor Authentication (MFA)** — Require MFA for all users, especially administrators
- **Hybrid Identity** — Integrate on-premises Active Directory with Entra ID
- **Application-Specific Security** — Implement app-level authorization beyond Entra ID SSO
- **Regular Access Reviews** — Quarterly reviews of user access and group membership
- **Incident Response** — Establish procedures for rapid account disablement and access revocation
