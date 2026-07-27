---
title: B2B External Identities - Partner and Vendor Access
part: 4
section: Hybrid & Cloud Identity
difficulty: Intermediate
estimated_reading_time: 35
estimated_lab_time: 45
prerequisites:
  - 03-role-based-access-control.md
  - 04-privileged-access-management.md
learning_objectives:
  - Understand B2B scenarios and partner collaboration
  - Implement guest user access in Entra ID
  - Configure external collaboration policies
  - Manage partner access lifecycle
  - Secure cross-organization identity flows
---

# B2B External Identities: Partner and Vendor Access

## Introduction

Organizations rarely work in isolation. Partners, vendors, consultants, and customers need access to resources: collaborative documents, project management systems, development environments. B2B (Business-to-Business) identity enables secure access for external users without forcing them to create new accounts. Instead of "create a corporate email for your partner," you invite their existing identity (Microsoft, Google, Azure AD) to access your resources. This document explains B2B external identity concepts, implementation in Entra ID, and governance best practices.

**Learning Objectives:**
- Understand B2B collaboration scenarios
- Implement guest user access
- Configure cross-organization collaboration
- Manage external user lifecycle
- Secure partner resource access

## B2B Collaboration Scenarios

### Scenario 1: Partner Employee Access
**Use case:** Marketing partner's employee needs access to campaign management system
- Partner employee signs in with their own Azure AD account
- You invite them as guest to your organization
- They access shared resources without creating new account
- No new credentials to manage
- Partner remains responsible for their user account

### Scenario 2: Consultant/Contractor
**Use case:** External consultant needs 6-month access to development environment
- Consultant may use personal email (gmail, outlook) or company email
- You invite them as guest with time-limited expiration
- They authenticate with their email (Microsoft account for outlook.com)
- Access automatically revokes after 6 months
- No identity management burden on your organization

### Scenario 3: Vendor Integration
**Use case:** SaaS vendor needs API access to your environment for integration testing
- Vendor uses their own service principal (application registration)
- You grant limited permissions (API scopes)
- Vendor's app authenticates using OAuth 2.0
- Access auditable and revocable
- Service-to-service, not human user access

### Scenario 4: Document Sharing
**Use case:** Partner company's employees need read access to shared documents
- You share Teams, SharePoint, or OneDrive content
- External users authenticate with their own identity
- SharePoint/OneDrive provides guest access UI
- No manual user provisioning needed

## B2B Identity Types

### Guest User (Microsoft Account)
**Identity:** user@gmail.com, user@outlook.com, user@company.com
**Authentication:** Provider-specific (Google OAuth for gmail.com, Microsoft account for outlook.com)
**Lifespan:** Time-bound (30 days to 1 year default, customizable)
**Use case:** External partners, consultants, one-time collaborators

### Member (Other Organization)
**Identity:** user@partnercompany.com authenticated by their organization's Azure AD
**Authentication:** Partner's Azure AD via SAML federation
**Lifespan:** As long as partnership exists
**Use case:** Long-term partner employees, vendor employees

### Managed Identity (Service Principal)
**Identity:** ServicePrincipalName@partnercompany.com
**Authentication:** OAuth 2.0 with certificate/secret
**Lifespan:** Service lifetime
**Use case:** API integration, automated workflows, vendor services

## Implementing B2B in Entra ID

### Step 1: Enable B2B Collaboration

**Check current settings:**
```
Entra ID admin center → Entra ID → External Identities → External collaboration settings
```

**Configure policies:**
1. **Guest user access permissions:** Choose level (Most restrictive: guest can't enumerate users; Least restrictive: guest can enumerate and access all)
2. **Guest invite restrictions:** Allow any user to invite guests (default), or restrict to specific roles
3. **Collaboration restrictions:** Allow all organizations or block specific tenant IDs

### Step 2: Invite External User

**Method 1: Entra ID admin center**
```
Entra ID → Users → New guest user
Enter email: partner@partnercompany.com
Assign role: Contributor, Reader, or custom
Send invitation
```

**Method 2: Azure CLI**
```bash
az ad user invite \
  --email-address partner@partnercompany.com \
  --display-name "Partner Employee"
```

**Method 3: Graph API**
```json
POST https://graph.microsoft.com/v1.0/invitations
{
  "invitedUserEmailAddress": "partner@partnercompany.com",
  "inviteRedirectUrl": "https://myapp.com",
  "sendInvitationMessage": true
}
```

### Step 3: Assign Resources and Permissions

**Grant resource access:**
1. Add guest to Azure AD group (e.g., "Marketing Partners")
2. Assign group to application or resource
3. Guest inherits permissions via group membership

**Direct role assignment:**
```
Resource → Access Control (IAM) → Add role assignment
Role: Contributor
Assign to: Guest user email
```

### Step 4: Guest Redeems Invitation

**Flow:**
1. Guest receives invitation email
2. Guest clicks "Get Started" link
3. Guest redirected to sign-in page
4. Guest authenticates with their email provider (Google, Microsoft, etc.)
5. Guest grants consent to access your organization
6. Guest added to your directory as guest user object

### Step 5: Manage Guest Lifecycle

**Monitor active guests:**
```
Entra ID → Users → filter: User type = Guest
Review: last sign-in date, access expiration, role assignments
```

**Revoke access:**
```
Delete guest user:
Entra ID → Users → Select guest → Delete
User immediately loses all access
```

**Extend access:**
```
Update guest user object:
Modify expirationDateTime property
Can extend multiple times
```

## B2B Access Policies

### Conditional Access for Guests

**Policy Example: Require MFA for Guest Access**
```
Target: Guest users
Condition: Accessing sensitive apps
Action: Require MFA
```

**Implementation:**
```
Entra ID → Security → Conditional Access → New policy
Name: "Require MFA for guest users"
Users: External guests
Apps: Select sensitive applications
Require: Multifactor authentication
```

### Guest User Limitations

**By default, guest users cannot:**
- Enumerate user directory
- View all users/groups
- Read organizational information
- Access unlimited resources without explicit assignment

**Customizable via policy:**
```
External collaboration settings → Guest user access permissions
Choose: None / Limited / Same as members
```

## Secure B2B Best Practices

1. **Verify Partner Identity** - Confirm email before sending invitation
2. **Time-Limit Access** - Set expiration dates, review periodically
3. **Least Privilege** - Grant minimum required permissions
4. **MFA Required** - Require MFA for all external access
5. **Separate Groups** - Create guest-specific groups for governance
6. **Monitor Activity** - Track guest sign-ins, access patterns, resource usage
7. **Data Sensitivity Classification** - Label data shared with guests
8. **Confidentiality Agreements** - Ensure legal agreements in place
9. **Offboarding Process** - Automated guest removal when project ends
10. **Incident Response** - Plan for compromised guest account

## Hands-On Lab: B2B Guest Access

**Estimated Time:** 45 minutes

**Prerequisites:** Two Entra ID tenants (host organization + test account with external email)

**Lab Objectives:**
- Invite external guest user
- Assign resource access
- Grant Conditional Access policy
- Guest redeems invitation

### Step 1: Configure B2B Settings (10 minutes)

```
Entra ID → External Identities → External collaboration settings
1. Guest user access permissions: Set to "Guest users have the same access"
2. Guest invite restrictions: "Anyone can invite guests"
3. Collaboration restrictions: "Allow invitations to be sent to any domain"
4. Click "Save"
```

### Step 2: Create Test Group (5 minutes)

```bash
az ad group create \
  --display-name "External Partners" \
  --mail-nickname "external-partners"
```

### Step 3: Invite Guest User (10 minutes)

```
Entra ID → Users → New guest user
Email: your-test-email@gmail.com (or any external email)
Display name: "Test Partner"
Click "Invite"
```

Invitation email sent. Check your email inbox for invitation link.

### Step 4: Assign Permissions (10 minutes)

```
Entra ID → Groups → External Partners
Members → Add members → Select guest user
Click "Select"
```

Guest now member of group. Any Azure resource assigned to this group grants guest access.

### Step 5: Guest Redeems Invitation (10 minutes)

**On guest's device:**
1. Open invitation email link
2. Click "Get Started"
3. Sign in with external email account
4. Grant consent to access organization
5. Redirected to organization portal

**Verify on host organization:**
```
Entra ID → Users → Filter "User type = Guest"
Should show guest user with status "Invited"
```

## B2B Governance

### Tracking External Access

**Audit Log Query (KQL):**
```kql
AuditLogs
| where OperationName == "Add user"
| where TargetResources[0].userPrincipalName contains "#EXT#"
| project Timestamp, TargetResources, InitiatedBy, Activity
```

**Sign-in Report:**
```
Entra ID → Sign-in logs → Filter: User type = Guest
View: Guest sign-in frequency, last activity, success rate
```

### Periodic Access Reviews

**Quarterly guest access reviews:**
1. List all active guests
2. For each guest: confirm still needed, verify permissions correct
3. Remove guests no longer needed
4. Document business justification

```
Entra ID → Identity Governance → Access reviews
Create new review:
- Scope: Guest users
- Frequency: Quarterly
- Auto-apply: Deny (remove access)
- Reviewers: Partner managers
```

### Guest Expiration Policy

**Automatically expire guests:**
```
External collaboration settings → Guest user lifetime
Set to 365 days
Guests expire after 1 year (configurable)
```

## Troubleshooting B2B

| Issue | Cause | Solution |
|-------|-------|----------|
| **Invitation not received** | Email filtered, wrong address | Resend invitation, check spam folder |
| **Guest can't sign in** | Provider authentication fails | Verify email provider (Google, Microsoft), test provider login |
| **Guest sees "Insufficient permissions"** | Not assigned role/group | Assign guest to appropriate group or role |
| **Guest can enumerate all users** | Policy allows it | Adjust "Guest user access permissions" to "Limited" |
| **Expired guest still has access** | Expiration didn't auto-revoke | Manually delete guest user |

## B2B vs. B2C

| Aspect | B2B | B2C |
|--------|-----|-----|
| **Users** | Business partners, employees | Customers, public users |
| **Auth** | Their organization's identity | Social/email signup |
| **Purpose** | Internal collaboration | Customer service/apps |
| **Lifecycle** | Project-based | Indefinite |
| **See also** | This document | Document 12a |

## Compliance & Standards

**B2B and Compliance:**
- **Zero Trust:** Require verification of external identity
- **Least Privilege:** Guest permissions minimal by default
- **Audit Trail:** All guest access logged and auditable
- **Data Residency:** Partner data stored in home organization's region

## Related Documents

**Prerequisites:**
- [Role-Based Access Control](./03-role-based-access-control.md) - Permission models
- [Privileged Access Management](./04-privileged-access-management.md) - Sensitive resource governance

**Next Steps:**
- [B2C/CIAM](./12a-b2c-ciam.md) - Customer/public identity
- [Fine-Grained Authorization](./13-fine-grained-authorization.md) - Resource-level access

## FAQ

**Q: Can we use B2B for long-term external employees?**

A: Yes. Invite as guest with no expiration date, or use member identity if partner organization is federated.

**Q: What happens to guest data when account is deleted?**

A: Files remain, ownership transfers to delete requester. Comments, shared documents unaffected. Use retention policies to manage archived data.

**Q: Can guests access on-premises resources?**

A: Not directly. If hybrid identity, can access cloud resources. For on-premises, use VPN or conditional access device requirements.

**Q: How do we prevent accidental data sharing?**

A: Use sensitivity labels, DLP policies, and resource access reviews. Require approvals for sharing with external users.

**Q: Can we track what guests access?**

A: Yes. Monitor sign-in logs, audit logs, application-specific activity. Use Cloud App Security for detailed monitoring.

## Next Steps

1. Configure B2B collaboration settings
2. Design guest access governance policy
3. Identify external partner needs
4. Create security baseline (MFA, Conditional Access)
5. Implement periodic access reviews
6. Train organization on B2B best practices

B2B enables secure partner collaboration without new credentials or accounts. Plan your B2B strategy early.
