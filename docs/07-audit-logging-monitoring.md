# Step 7 — Audit Logging & Monitoring

**Objective:** Verify that all identity and access changes are captured in logs for accountability and compliance.

## Implementation Steps

- Accessed **Audit Logs** within Entra ID to review a record of all directory changes made throughout the lab.
- Filtered audit logs by target user (`John HR`) to trace specific identity changes — provisioning, group changes, application assignments, and profile updates.
- Reviewed **Sign-in Logs** to monitor authentication activity. No significant sign-in events were recorded, consistent with a lab environment where users were not actively logging in.

## IAM Concepts

**Compliance Logging** — Maintaining a tamper-evident record of identity changes (who did what, when, why)

**Audit Traceability** — Ability to filter and trace actions to a specific user or time window for investigation

**User-Level Monitoring** — Sign-in logs used in production to detect suspicious authentication, failed login attempts, or unusual locations

> In a production environment, these logs would feed into a SIEM (Security Information and Event Management system, e.g., Microsoft Sentinel) to trigger alerts for anomalous behaviour — such as logins from unexpected geographies, brute-force patterns, or impossible travel scenarios.

| # | Screenshot | Description |
|---|---|---|
| 18 | ![Audit Logs Multiple Activities](../screenshots/18-audit-logs-showing-multiple-activities.png.png) | Audit logs showing multiple recorded activities |
| 19 | ![Filtered Logs John HR Target](../screenshots/19-filtered-logs-john-hr-as-target.png.png) | Audit logs filtered by John HR as target user |

## Key Takeaway

Audit logs are your proof of compliance and your detective tool for security incidents. Every identity and access change should be logged, queryable, and retained according to regulatory requirements.

## Lab Complete! 🎉

You've now implemented a complete, enterprise-aligned IAM environment covering:
- ✅ Identity provisioning (Joiner)
- ✅ Group-based RBAC (Access Control)
- ✅ Privileged access management (PAM)
- ✅ Application access provisioning (SSO)
- ✅ Identity lifecycle management (Mover & Leaver)
- ✅ Compliance logging and monitoring (Audit)

## Next Steps

- Review the [Key Design Decisions](KEY_DESIGN_DECISIONS.md) for architectural rationale
- Add this lab to your portfolio — it demonstrates enterprise IAM knowledge
- Explore advanced topics in Entra ID (Conditional Access, Multi-Factor Authentication, hybrid identity)
