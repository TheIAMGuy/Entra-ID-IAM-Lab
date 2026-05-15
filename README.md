# Entra-ID Cloud Identity & Access Management Lab

Welcome! This guide will help you understand and implement enterprise-grade Identity and Access Management (IAM) using Microsoft Entra ID (formerly Azure Active Directory). Whether you're new to IAM or an experienced identity architect, you'll find step-by-step instructions to build a complete, production-aligned IAM environment.

## What is This Lab?

This hands-on lab simulates a complete enterprise Identity and Access Management implementation using Microsoft Entra ID. It covers the full **Joiner-Mover-Leaver (JML)** identity lifecycle, **group-based role-based access control (RBAC)**, **privileged access management (PAM)**, **enterprise application provisioning**, and **compliance audit logging** — the same workflows and patterns used by IAM teams in production environments.

## Why Learn Enterprise IAM with This Lab?

- 🔐 **Industry-Standard Practices** — Learn real-world IAM patterns aligned with enterprise standards
- 🚀 **Complete Lifecycle** — Understand the full Joiner-Mover-Leaver identity workflow
- 👥 **Access Control** — Master group-based RBAC and delegated administration
- 📋 **Compliance Ready** — Implement audit logging and traceability for compliance
- 🎯 **Hands-On Experience** — Practical, repeatable implementation you can add to your portfolio
- ☁️ **Cloud-Native** — Modern cloud identity using Microsoft Entra ID

## Quick 5-Minute Overview

1. **Environment Setup** - Configure your Entra ID tenant and verify the foundation
2. **Identity Provisioning** - Create user identities across departments (Joiner process)
3. **Access Control** - Organize users into groups and assign department-based access (RBAC)
4. **Privileged Access** - Delegate administrative roles with least-privilege principle (PAM)
5. **Application Access** - Provision enterprise applications and assign users (SSO integration)
6. **Identity Lifecycle** - Simulate internal transfers and offboarding (Mover & Leaver)
7. **Audit & Monitoring** - Review audit logs and verify traceability (Compliance)

## Table of Contents

1. **[Environment Setup](docs/01-environment-setup.md)** — Configure your Entra ID tenant and verify prerequisites
2. **[Identity Provisioning — Joiner](docs/02-identity-provisioning-joiner.md)** — Create and attribute user identities
3. **[Group-Based Access Control](docs/03-group-based-access-control.md)** — Implement RBAC using security groups
4. **[Privileged Access Management](docs/04-privileged-access-management.md)** — Assign scoped admin roles
5. **[Application Access Management](docs/05-application-access-management.md)** — Provision enterprise apps and users
6. **[Identity Lifecycle — Mover & Leaver](docs/06-identity-lifecycle-mover-leaver.md)** — Simulate role changes and offboarding
7. **[Audit Logging & Monitoring](docs/07-audit-logging-monitoring.md)** — Verify compliance and traceability

## Key Features

### Complete JML Lifecycle
Experience the full Joiner-Mover-Leaver identity workflow — from onboarding new employees, through internal role changes, to secure offboarding with access revocation and audit preservation.

### Enterprise RBAC Foundation
Learn group-based access control that scales — using security groups as the access unit rather than assigning permissions to individual users, following IAM best practices.

### Privileged Access Management
Understand least-privilege role assignment — delegating specific administrative functions (User Administrator, Global Reader) without granting excessive access.

### Application Access & SSO
Provision enterprise applications and manage user access — simulating real-world SaaS and line-of-business application integration.

### Compliance & Audit
Implement tamper-evident audit logging and user-level traceability — essential for compliance frameworks like SOC 2, ISO 27001, and regulatory requirements.

### Production-Aligned Design
All patterns reflect enterprise-grade IAM architecture, adapted to work within free-tier constraints while maintaining production design principles.

## Getting Started Now

👉 **Start here**: [Environment Setup](docs/01-environment-setup.md)

Ready to dive in? Begin with the environment setup to ensure your Entra ID tenant is ready.

## Documentation Structure

Each guide is designed to be:
- **Hands-On** — Screenshot-guided walkthroughs with real Azure Portal steps
- **Concept-Focused** — Learn IAM principles alongside practical implementation
- **Enterprise-Aligned** — Reflects real-world practices and production constraints
- **Free-Tier Compatible** — Works within Microsoft Entra ID free tier limits

Pick your path and dive into any section:
- **New to IAM?** Start with [Environment Setup](docs/01-environment-setup.md)
- **Familiar with identity?** Jump to [RBAC Implementation](docs/03-group-based-access-control.md)
- **Need design rationale?** Check [Key Design Decisions](docs/KEY_DESIGN_DECISIONS.md)
- **Troubleshooting?** Review the specific step guide

## Skills Demonstrated

| Domain | Concepts Covered |
|---|---|
| Identity Provisioning | User creation, attribute assignment, organizational structure |
| Access Control | Group-based RBAC, security groups, least privilege |
| Privileged Access | Scoped role assignment, delegated administration, break-glass design |
| Application Access | Enterprise app provisioning, SSO, user-to-app assignment |
| Identity Lifecycle | JML processes, access re-provisioning, account offboarding |
| Audit & Monitoring | Compliance logging, audit trails, user-level traceability |

## Need Help?

- 📖 Check the relevant step guide (e.g., [Audit Logging](docs/07-audit-logging-monitoring.md) for traceability questions)
- 🔗 [Microsoft Entra ID Documentation](https://learn.microsoft.com/en-us/entra/identity/)
- 📚 [IAM Best Practices Guide](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/)
- ❓ [Azure Portal Support](https://learn.microsoft.com/en-us/azure/azure-portal/)

## Contributing

Have suggestions, corrections, screenshots, or improvements? We'd love your help! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This lab is licensed under the [MIT License](LICENSE) — feel free to share, adapt, and use it in your own portfolio!

---

**Ready to get started?** Begin with [Environment Setup](docs/01-environment-setup.md) →
