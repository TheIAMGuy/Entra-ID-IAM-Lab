---
title: LDAP and Directory Services - On-Premises Integration
part: 3
section: Standards & Protocols
difficulty: Intermediate
estimated_reading_time: 40
estimated_lab_time: N/A
prerequisites:
  - 02-identity-management.md
  - 09-identity-standards-overview.md
learning_objectives:
  - Understand LDAP protocol and directory schema
  - Understand on-premises Active Directory integration
  - Learn directory synchronization (hybrid identity)
  - Configure password hash synchronization and pass-through authentication
  - Understand when to use LDAP vs. modern protocols
---

# LDAP and Directory Services: On-Premises Integration

## Introduction

LDAP (Lightweight Directory Access Protocol) is the standard for on-premises directory services. Active Directory, the most common directory on Windows networks, is LDAP-based. In hybrid environments, organizations maintain both on-premises Active Directory and cloud-based Microsoft Entra ID. This requires synchronization: when users are created, modified, or deleted on-premises, those changes must reflect in Entra ID. This document explains LDAP, hybrid identity synchronization, and how Microsoft Entra ID integrates with on-premises directories.

**Learning Objectives:**
- Understand LDAP protocol and directory schema
- Understand Active Directory and distinguishedNames
- Learn directory synchronization mechanisms
- Configure password hash sync and pass-through auth
- Understand hybrid identity architecture

## LDAP Fundamentals

LDAP is a protocol for accessing directory services. Key concepts:

### Distinguished Names (DN)

LDAP identifies users with hierarchical distinguished names:

```
CN=John Smith,OU=Finance,OU=Users,DC=contoso,DC=com
```

**Components:**
- `CN=John Smith` - Common Name (user)
- `OU=Finance` - Organizational Unit (department)
- `OU=Users` - Organizational Unit (user container)
- `DC=contoso` - Domain Component
- `DC=com` - Domain Component

### LDAP Operations

- **Search:** Query directory for users matching criteria
- **Bind:** Authenticate with directory
- **Modify:** Update user attributes
- **Add:** Create new user
- **Delete:** Remove user

### Active Directory (AD)

Active Directory is Microsoft's LDAP-based directory service. Provides:
- Centralized user and computer management
- Group Policy for security policies
- Kerberos authentication
- ACL-based access control

## Hybrid Identity Architecture

Hybrid identity bridges on-premises AD and cloud Entra ID.

### Three Sync Models

**1. Cloud-Only (No Sync)**
- Users exist only in Entra ID
- Best for pure cloud organizations
- No dependency on on-premises AD

**2. Hybrid (Synchronized)**
- Users exist in both AD and Entra ID
- Changes in AD sync to Entra ID
- Most common in enterprises

**3. Federated**
- Users managed in AD only
- Entra ID queries AD in real-time (no sync)
- Used when AD must remain source of truth

### Directory Synchronization Methods

**Azure AD Connect (Recommended)**
- Synchronizes users, groups, attributes from AD to Entra ID
- Password hash sync: Hash of password synced (not password itself)
- Pass-through auth: Validates password against on-premises AD
- Standard sync interval: 30 minutes
- Handles deletions, renames, attribute updates

**Azure AD Connect Cloud Sync** (Newer)
- Lightweight alternative to Azure AD Connect
- Better for multi-forest scenarios
- Uses provisioning agents (cloud-based)

**PowerShell/Graph API** (Custom)
- For organizations with custom needs
- Less common, more complex

## Password Hash Synchronization

Password hash sync is the most common sync method:

**Flow:**
```
User changes password in AD
  → Password change triggers sync
  → Entra AD Connect hashes password (not password itself)
  → Hash stored in Entra ID
  → User can sign in to cloud apps with same password
  → If on-premises AD is offline, can still sign in to cloud with cached hash
```

**Advantages:**
- Simplest implementation
- Works even if on-premises AD is down (cached hash)
- No additional infrastructure

**Disadvantages:**
- Requires network connectivity to Entra ID
- Password history exposed if Entra ID is breached

## Pass-Through Authentication

Pass-through auth validates passwords against on-premises AD (no hash):

**Flow:**
```
User signs in to cloud app
  → Cloud app sends username/password to Entra ID
  → Entra ID validates against on-premises AD (real-time)
  → On-premises AD confirms or denies
  → Access granted or denied
```

**Advantages:**
- Password never stored in cloud
- Real-time validation (on-premises password policies enforced)
- Seamless experience

**Disadvantages:**
- Requires on-premises AD to be always online
- Higher latency (network hop to AD required)
- More complex infrastructure

## Configuring Directory Sync

### Azure AD Connect Installation

1. **Download** Azure AD Connect from Microsoft
2. **Run installer** on domain-joined machine
3. **Sign in** with global admin credentials
4. **Express Settings** (recommended):
   - Single forest
   - Password hash sync
   - Sync all users
5. **Continue** to completion
6. **Verify** users appear in Entra ID within 30 minutes

### Attribute Mappings

Configure which AD attributes sync to Entra ID:
- `cn` → `displayName` (user's display name)
- `mail` → `userPrincipalName` (email as username)
- `title` → `jobTitle`
- `department` → `department`
- `memberOf` → `memberOf` (group membership)

### Filtering

Limit what syncs to Entra ID:
- **Domain/OU filtering:** Only sync users from Finance OU
- **Attribute filtering:** Only sync users where department = "Engineering"
- **Object type filtering:** Sync users but not computers

## Troubleshooting Directory Sync

| Issue | Cause | Solution |
|-------|-------|----------|
| Users not appearing in Entra ID | Sync disabled or stalled | Check Azure AD Connect service status |
| Password changes not syncing | Password hash sync disabled | Enable password hash sync in AAD Connect |
| Duplicate users | User synced and manually created | Delete duplicate in Entra ID, wait for sync |
| Conflicting attributes | Multiple users with same email | Ensure email is unique in AD |
| Sync errors | AD schema incompatibility or corruption | Check Azure AD Connect logs |

## Hybrid vs. Cloud-Only: When to Choose Each

| Scenario | Approach | Reason |
|----------|----------|--------|
| Greenfield organization | Cloud-only | No legacy on-premises investment |
| Enterprise with existing AD | Hybrid | Leverage AD investment while moving cloud |
| High security environment | Pass-through auth | Real-time validation, no cloud password storage |
| Disaster recovery | Cloud-only backup | Cloud accounts work if on-premises fails |

## Compliance & Standards Alignment

**Standards:**
- **RFC 4511:** LDAP Protocol (networking and basic operations)
- **RFC 4512:** LDAP Schema
- **RFC 3112:** LDAP Authentication Password Schema

**Compliance:** HIPAA, PCI DSS, SOC 2 support LDAP integration

## Related Documents

**Prerequisites:**
- [Identity Management (Mover)](./02-identity-management.md) - User lifecycle
- [Identity Standards Overview](./09-identity-standards-overview.md) - Standards context

**Next Steps:**
- [SCIM Provisioning](./09c-scim-provisioning.md) - Cloud provisioning
- [Application Access Management](./05-sso-and-application-provisioning.md) - Integrated app access

## Further Reading

**Microsoft Documentation:**
- [Azure AD Connect: What It Is and What It Does](https://learn.microsoft.com/en-us/entra/identity/hybrid/whatis-hybrid-identity)
- [Password Hash Synchronization](https://learn.microsoft.com/en-us/entra/identity/hybrid/how-to-connect-password-hash-synchronization)

**LDAP Standards:**
- [RFC 4511: LDAP Protocol](https://tools.ietf.org/html/rfc4511)

## FAQ

**Q: Should we use password hash sync or pass-through auth?**

A: Password hash sync is simpler and works when AD is offline. Pass-through auth is more secure (password never in cloud) but requires on-premises AD to be always online. Most enterprises choose password hash sync for resilience.

**Q: How often does directory sync happen?**

A: Default: every 30 minutes. Can be manual or triggered by password change (2-3 minute sync).

**Q: What if a user is deleted on-premises?**

A: Entra ID disables the account by default (soft delete). User can be re-enabled if needed. Configure hard delete if user must be completely removed.

**Q: Can we sync just some users to Entra ID?**

A: Yes. Use OU filtering or attribute filtering to sync only specific users (e.g., only Engineering department).

**Q: Is LDAP itself still used or just AD?**

A: AD is the main LDAP implementation. Direct LDAP queries are less common in modern environments but still used for legacy systems and third-party apps.

## Next Steps

1. Assess current directory infrastructure (on-premises AD)
2. Determine sync strategy (cloud-only vs. hybrid)
3. If hybrid, install Azure AD Connect
4. Configure attribute mappings
5. Set up filtering if needed
6. Monitor sync health (check logs, validate user count)
7. Plan password hash sync vs. pass-through auth

Directory sync is the bridge between on-premises and cloud. Get it right and hybrid identity works seamlessly.
