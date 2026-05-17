---
title: SCIM Provisioning - Automated User Synchronization
part: 3
section: Standards & Protocols
difficulty: Intermediate
estimated_reading_time: 40
estimated_lab_time: 60
prerequisites:
  - 02-identity-management.md
  - 09-identity-standards-overview.md
learning_objectives:
  - Understand SCIM protocol and message format
  - Configure SCIM provisioning in Microsoft Entra ID
  - Set up user synchronization to cloud applications
  - Monitor and troubleshoot SCIM provisioning
  - Understand provisioning workflows and filtering
---

# SCIM Provisioning: Automated User Synchronization

## Introduction

SCIM (System for Cross-Domain Identity Management) automates user account lifecycle across cloud applications. When you hire a new employee, create their account in your HR system, and within minutes that employee automatically has accounts created in Salesforce, Slack, Microsoft 365, Zoom, and dozens of other cloud apps. When the employee leaves, their accounts are deactivated across all systems simultaneously. SCIM is the standard protocol making this automation possible. This document explains SCIM, how to configure it in Entra ID, and how to troubleshoot common provisioning issues.

**Learning Objectives:**
- Understand SCIM protocol and REST operations
- Configure SCIM provisioning in Microsoft Entra ID
- Set up user and group synchronization
- Monitor provisioning activities and logs
- Troubleshoot provisioning failures

## SCIM Protocol Fundamentals

SCIM uses REST APIs to synchronize identity data. Key operations:

- **GET /Users:** Retrieve user list
- **POST /Users:** Create new user
- **PATCH /Users/{id}:** Update user attributes
- **DELETE /Users/{id}:** Delete user
- **GET /Groups:** Retrieve groups
- **POST /Groups:** Create group
- **PATCH /Groups/{id}:** Update group membership

SCIM message format (JSON):

```json
{
  "id": "user-id",
  "externalId": "emp-12345",
  "userName": "john.smith@contoso.com",
  "name": {
    "givenName": "John",
    "familyName": "Smith"
  },
  "emails": [
    {
      "value": "john@contoso.com",
      "primary": true
    }
  ],
  "active": true,
  "groups": [
    {
      "value": "finance-department"
    }
  ]
}
```

## Configuring SCIM in Microsoft Entra ID

### Step 1: Add Application

1. In Entra ID, go to **Enterprise applications → + New application**
2. Search for app (e.g., "Salesforce")
3. Add to Entra ID

### Step 2: Enable Provisioning

1. Go to app's **Provisioning** section
2. **Provisioning Mode:** Select "Automatic"
3. **Admin Credentials:** 
   - **Tenant URL:** App's SCIM endpoint (e.g., `https://api.example.com/scim`)
   - **Secret Token:** App's SCIM authentication token
4. Click **Test Connection**
5. If successful, click **Save**

### Step 3: Configure Mappings

1. Go to **Provisioning → Attribute Mappings**
2. Review default mappings (Entra ID → app attributes)
3. Example mappings:
   - `userPrincipalName` → `userName`
   - `givenName` → `name.givenName`
   - `surname` → `name.familyName`
   - `mail` → `emails[0].value`
   - `jobTitle` → `title`
4. Add custom mappings if needed
5. Save

### Step 4: Define Scope

1. Go to **Provisioning → Scope**
2. **Choose who to provision:**
   - **Sync only assigned users and groups** (recommended)
   - **Sync all users and groups** (if app requires)
3. Save

### Step 5: Assign Users/Groups

1. Go to **Users and groups**
2. Click **+ Add user/group**
3. Select users or groups to provision
4. Click **Assign**

After assignment, provisioning begins:
- New users are created in app
- User attributes are updated daily (or on-demand)
- Disabled users are deactivated
- Removed users are deleted (depends on configuration)

## Hands-On Lab: Configuring SCIM Provisioning

**Estimated Time:** 60 minutes

**Prerequisites:** Entra ID tenant, SCIM-enabled test application (Salesforce, GitHub, custom app)

**Lab Objectives:**
- Configure SCIM provisioning
- Test user provisioning
- Monitor provisioning logs
- Troubleshoot provisioning issues

### Step 1: Set Up Provisioning (20 minutes)

1. In Entra ID, go to Enterprise applications → Your app
2. Go to **Provisioning**
3. **Provisioning Mode:** "Automatic"
4. **Tenant URL:** Enter app's SCIM endpoint (from app documentation)
5. **Secret Token:** Enter SCIM authentication token
6. Click **Test Connection** → Should succeed
7. **Scope:** "Sync only assigned users and groups"
8. Click **Save**

### Step 2: Configure Attribute Mappings (15 minutes)

1. Go to **Provisioning → Attribute Mappings**
2. Review default mappings
3. Verify key mappings:
   - Entra ID `userPrincipalName` → App `userName`
   - Entra ID `mail` → App `emails[0].value`
4. If mappings look correct, save
5. If app requires additional attributes:
   - Click **+ Add Mapping**
   - Select Entra ID source attribute
   - Select app target attribute
   - Save

### Step 3: Assign Users for Provisioning (15 minutes)

1. Go to **Users and groups**
2. Click **+ Add user/group**
3. Select a test user
4. Click **Assign**
5. Within 5 minutes, user should be created in app
6. Verify in app's user management console

### Step 4: Monitor Provisioning Logs (10 minutes)

1. Go to **Provisioning → Provisioning logs**
2. Review recent provisioning activities
3. Look for successful provisioning:
   - "Create user [email]" → Success
   - "Update user [email]" → Success
4. If failures exist:
   - Review error message
   - Common issues: Missing attributes, invalid token, wrong endpoint
5. Troubleshoot and retry

## Provisioning Workflows

**Provisioning on Assignment:**
```
User assigned to app
  → Entra ID queries user attributes
  → Entra ID calls app's SCIM /Users POST
  → App creates user account
  → User can now sign in
```

**Provisioning on Update:**
```
User's attributes change (name, department)
  → Next sync cycle (~40 min) or manual trigger
  → Entra ID calls app's SCIM /Users PATCH
  → App updates user attributes
  → Reflects immediately in app
```

**Deprovisioning on Removal:**
```
User removed from app assignment
  → Entra ID calls app's SCIM /Users DELETE
  → App disables or deletes user
  → User can no longer access app
  (Note: Configure whether deletion is soft or hard)
```

## Common Issues and Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| "Test connection failed" | Wrong endpoint or token | Verify SCIM endpoint and token with app vendor |
| "User not created" | User not assigned to app | Assign user under Users and groups |
| "Attributes not syncing" | Mapping incorrect | Review attribute mappings, ensure names match app schema |
| "Provisioning loop" | Circular attribute mapping | Remove conflicting mappings |
| "Users created but can't login" | Missing password or MFA | App may require password reset; user must set password |

## Best Practices

1. **Test in non-production first** - Verify provisioning with test users
2. **Document attribute mappings** - Keep records of how Entra ID maps to app attributes
3. **Set scope carefully** - Use "Assign only" to avoid unintended provisioning
4. **Monitor logs** - Review provisioning logs weekly for errors
5. **Validate credentials** - Ensure SCIM token is valid and has required permissions
6. **Plan deprovisioning** - Decide whether to disable or delete users on removal
7. **Communicate schedule** - Inform users of provisioning timing (daily, hourly, on-demand)

## Compliance & Standards Alignment

**Standards:**
- **RFC 7643:** SCIM Core Schema
- **RFC 7644:** SCIM Protocol Operations

**Compliance:** HIPAA, PCI DSS, SOC 2 all support SCIM for automated provisioning

## Related Documents

**Prerequisites:**
- [Identity Management (Mover)](./02-identity-management.md) - User lifecycle
- [Identity Standards Overview](./09-identity-standards-overview.md) - Standards context

**Next Steps:**
- [Identity Deprovisioning](./03-identity-deprovisioning.md) - Leaver workflow
- [LDAP and Directory Services](./09d-ldap-and-directory-services.md) - Directory protocol

## Further Reading

**SCIM Specification:**
- [RFC 7643: SCIM Core Schema](https://tools.ietf.org/html/rfc7643)
- [RFC 7644: SCIM Operations](https://tools.ietf.org/html/rfc7644)

**Microsoft Docs:**
- [SCIM Provisioning in Entra ID](https://learn.microsoft.com/en-us/entra/identity/app-provisioning/use-scim-to-provision-users-and-groups)

## FAQ

**Q: How often does provisioning sync?**

A: Default: every 40 minutes. Can be manual (on-demand) or more frequent if configured. Check app documentation for options.

**Q: What happens when a user is removed?**

A: Depends on configuration. Default: user account is disabled (soft delete). Can configure for permanent deletion (hard delete).

**Q: Can we provision groups?**

A: Yes, many apps support group provisioning. Enable in attribute mappings. Groups are created/updated alongside users.

**Q: What if the SCIM endpoint is unavailable?**

A: Entra ID retries for 24-40 days. If endpoint comes back online, sync resumes automatically.

**Q: Can we customize SCIM mappings for custom attributes?**

A: Yes. If app has custom attributes, add mappings for them. Attribute names must match app's schema.

## Next Steps

1. Identify SCIM-enabled apps in your portfolio
2. Document SCIM endpoints and tokens
3. Configure provisioning in Entra ID
4. Test with pilot users
5. Monitor provisioning logs
6. Roll out to full user population
7. Audit provisioning monthly

SCIM automates user lifecycle. Configure it once, then provisioning happens automatically for years.
