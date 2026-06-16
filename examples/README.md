# Examples – Entra-ID-IAM-Lab

This folder contains configuration samples and automation scripts that support the lab guides in `docs/`. Use these files as reference material alongside the numbered lab guides, not as production-ready deployments.

All examples are compatible with the Microsoft Entra ID free tier unless otherwise noted.

---

## JSON Configuration Examples

### `01-access-policy-example.json`

A sample Conditional Access policy configuration that requires multi-factor authentication (MFA) for users accessing sensitive applications (Finance Portal, HR System, Payroll). It demonstrates:

- User and group scoping (include/exclude patterns)
- Application targeting
- Sign-in risk conditions (medium and high)
- Grant controls combining MFA and device compliance
- Session controls for persistent browser behavior

**Related lab:** See `docs/` guides covering Conditional Access policy configuration.

### `02-role-based-access.json`

An RBAC group assignment example showing three role definitions for a sales and finance organization:

- `sales-rep` — Read/create/update access to Salesforce and read-only access to customer data
- `sales-manager` — Elevated Salesforce access plus team access management and approval rights
- `finance-admin` — Full financial system access with Segregation of Duties (SoD) constraints

This example illustrates least-privilege design and SoD enforcement patterns.

**Related lab:** See `docs/` guides covering group-based RBAC and access control models.

### `03-attribute-mapping.json`

An attribute mapping configuration for syncing user identity data from on-premises Active Directory to Microsoft Entra ID. It covers:

- Direct attribute mappings (givenName, surname, department, jobTitle)
- DN resolution for manager relationships
- Extension attribute usage for employeeId and costCenter
- Source and target scoping rules (active users only)

**Related lab:** See `docs/` guides covering identity synchronization and hybrid identity.

---

## Scripts

All scripts are located in `scripts/`. They require Azure CLI or PowerShell with the Microsoft Graph module installed, and appropriate admin permissions in your Entra ID tenant.

**[IMPORTANT]:** Review every script carefully before running it. Test in a non-production tenant first. These scripts are learning examples, not production automation.

### `scripts/01-joiner-automation-basic.sh`

A Joiner (new hire) automation script that demonstrates the onboarding steps in the Joiner-Mover-Leaver (JML) identity lifecycle. It covers creating a new user account, assigning group memberships, and triggering provisioning to downstream applications.

**Related lab:** See `docs/` guides covering the JML lifecycle and provisioning automation.

### `scripts/02-mfa-enrollment.sh`

An MFA enrollment automation script that demonstrates how to configure and enforce MFA registration for new users. It shows the enrollment workflow from an administrator's perspective.

**Related lab:** See `docs/` guides covering MFA configuration and authentication methods.

### `scripts/06-conditional-access-policy.sh`

A Conditional Access policy automation script that shows how to create and enable a policy via the Microsoft Graph API or Azure CLI. It corresponds to the JSON structure in `01-access-policy-example.json`.

**Related lab:** See `docs/` guides covering Conditional Access policy deployment.

---

## How to Use These Examples

### JSON files

Open any `.json` file in your editor to study the structure. Use it as a reference when configuring settings in the Entra ID portal or when writing your own Graph API calls.

Do not import these files directly into a production tenant without reviewing and adjusting every value for your environment.

### Shell scripts

1. Open the script in your editor and read through the comments.
2. Verify you have the required permissions (Global Administrator or a scoped admin role as noted in each script).
3. Run in a sandbox or dev tenant first:

```bash
LANGUAGE: Bash
bash scripts/01-joiner-automation-basic.sh
EXPECTED OUTPUT: See individual script headers for expected output.
```

4. Verify the result in the Entra ID portal before running in any other environment.

---

## Permissions Required

| Script | Minimum Role Required |
|--------|-----------------------|
| `01-joiner-automation-basic.sh` | User Administrator |
| `02-mfa-enrollment.sh` | Authentication Administrator |
| `06-conditional-access-policy.sh` | Conditional Access Administrator |

**[NOTE]:** All scripts are designed for Entra ID free tier compatibility. Features that require Entra ID P1 or P2 licenses are clearly noted inside the relevant script or JSON file.

---

## Adding New Examples

1. Follow the existing naming convention: `NN-descriptive-name.json` or `scripts/NN-descriptive-name.sh`.
2. Include comments explaining what each section or command does and why.
3. Note the minimum required permissions at the top of the file.
4. Confirm free-tier compatibility before submitting.
5. Add an entry to this README under the appropriate section.

See [CONTRIBUTING.md](../CONTRIBUTING.md) for the full contribution process.
