# IAM Concept Index

Find where each identity and access management concept is covered in this repository. Every entry links to a document that exists today.

For definitions, see the [IAM Glossary](IAM_GLOSSARY.md). For the full lab list, see the [Lab Index](LABS_INDEX.md).

---

## Concepts by Topic

### Identity Lifecycle
| Concept | Where |
|---------|-------|
| Joiner (provisioning) | [Lab 02](../PHASE-1-FREE-TIER/02-identity-provisioning-joiner.md) |
| Mover (role or department change) | [Lab 06, Part A](../PHASE-2-ENTRA-P1/06-identity-lifecycle-mover-leaver.md) |
| Leaver (offboarding) | [Lab 06, Part B](../PHASE-2-ENTRA-P1/06-identity-lifecycle-mover-leaver.md) |
| Disable vs. delete | [Lab 06, step B4](../PHASE-2-ENTRA-P1/06-identity-lifecycle-mover-leaver.md) |
| Identity attributes | [Lab 02](../PHASE-1-FREE-TIER/02-identity-provisioning-joiner.md) |

### Access Control
| Concept | Where |
|---------|-------|
| Group-based RBAC | [Lab 03](../PHASE-1-FREE-TIER/03-group-based-access-control.md) |
| Privileged roles and least privilege | [Lab 04](../PHASE-2-ENTRA-P1/04-privileged-access-management.md) |
| Application assignment | [Lab 05](../PHASE-2-ENTRA-P1/05-application-access-management.md) |

### Authentication and Risk
| Concept | Where |
|---------|-------|
| MFA methods and rollout | [MFA guide](../PHASE-3-ENTRA-P2/guide-multi-factor-authentication.md) |
| TOTP | [Lab 07a](../PHASE-3-ENTRA-P2/07a-configure-totp-mfa.md) |
| Push notifications | [Lab 07b](../PHASE-3-ENTRA-P2/07b-enable-authenticator-push-mfa.md) |
| Conditional Access basics | [Lab 07c](../PHASE-3-ENTRA-P2/07c-conditional-access-policy.md) |
| Risk-based Conditional Access | [Lab 07d](../PHASE-3-ENTRA-P2/07d-risk-based-conditional-access.md) |
| Adaptive authentication, risk signals | [Adaptive Authentication guide](../PHASE-3-ENTRA-P2/guide-adaptive-authentication.md) |

### Audit and Monitoring
| Concept | Where |
|---------|-------|
| Audit logs | [Lab 07](../PHASE-3-ENTRA-P2/07-audit-logging-monitoring.md) |
| Sign-in logs | [Lab 07](../PHASE-3-ENTRA-P2/07-audit-logging-monitoring.md) |

### Governance
| Concept | Where |
|---------|-------|
| Access reviews | [Lab 17a](../PHASE-4-GOVERNANCE/17a-set-up-access-reviews.md) |
| Identity governance (IGA) | [IGA guide](../PHASE-4-GOVERNANCE/guide-identity-governance-administration.md) |
| Segregation of duties | [IGA guide](../PHASE-4-GOVERNANCE/guide-identity-governance-administration.md) |
| Non-human identity governance | [IGA guide](../PHASE-4-GOVERNANCE/guide-identity-governance-administration.md) |
| GRC integration, audit evidence | [GRC Integration](../PHASE-4-GOVERNANCE/guide-grc-integration.md) |

---

## Concepts by Phase

| Phase | Concepts |
|-------|----------|
| 1 – Free Tier | Tenant, users, attributes, security groups, RBAC |
| 2 – Entra P1 | Directory roles, least privilege, enterprise applications, mover and leaver |
| 3 – Entra P2 | Audit logs, MFA, Conditional Access, sign-in risk |
| 4 – Governance | Access reviews, entitlement governance, SoD, GRC |

---

## Not Covered Yet

This repository does not currently include labs or guides for the following. See [Further Reading](FURTHER_READING.md) and [Microsoft Learn](https://learn.microsoft.com/en-us/entra/) for these topics.

- Workload identity, managed identities and workload identity federation
- B2B and external identities
- Hybrid identity (Microsoft Entra Connect)
- Passwordless authentication (FIDO2, passkeys)
- Protocols in depth (SAML, OAuth 2.0, OpenID Connect, SCIM)
- Zero Trust architecture
- Privileged Identity Management (just-in-time activation)
- Entitlement management and lifecycle workflows
- Enterprise capstone design
