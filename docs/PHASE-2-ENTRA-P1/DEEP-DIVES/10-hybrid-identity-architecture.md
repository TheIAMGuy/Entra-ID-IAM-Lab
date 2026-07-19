---
title: Hybrid Identity Architecture - Bridging On-Premises and Cloud
part: 4
section: Hybrid & Cloud Identity
difficulty: Intermediate
estimated_reading_time: 45
estimated_lab_time: 60
prerequisites:
  - 09d-ldap-and-directory-services.md
  - 02-identity-management.md
learning_objectives:
  - Understand hybrid identity architecture patterns
  - Design directory synchronization strategies
  - Implement pass-through authentication for security
  - Configure single sign-on across on-premises and cloud
  - Plan migration from on-premises to cloud-only
---

# Hybrid Identity Architecture: Bridging On-Premises and Cloud

## Introduction

Most enterprises operate in hybrid environments: some systems and users on-premises, others in the cloud. This hybrid reality requires bridging identity across environments. Users should sign in once and access both on-premises and cloud resources. This document explains hybrid identity architecture, synchronization strategies, and how to design systems that seamlessly span on-premises and cloud.

**Learning Objectives:**
- Understand three hybrid identity models
- Design directory synchronization architecture
- Implement pass-through authentication
- Configure cross-premises single sign-on
- Plan migration to cloud-only

## Hybrid Identity Models

### Model 1: Cloud Sync (Password Hash Sync)

**Architecture:**
```
On-Premises AD
  ↓ (Directory Sync)
Azure AD Connect
  ↓ (Password hash sync)
Microsoft Entra ID
  ↓ (User signs in to cloud app)
Cloud app logs user in
```

**Characteristics:**
- Users exist in both AD and Entra ID
- Passwords synchronized as hash (not plain password)
- Can sign in to cloud if on-premises AD is offline
- ~2-3 minute sync latency
- Simplest to implement

**When to use:**
- On-premises AD is reliable
- Need offline access to cloud
- Want simplest architecture

### Model 2: Pass-Through Authentication

**Architecture:**
```
User signs in to cloud app
  ↓ (sends username/password to Entra ID)
Entra ID
  ↓ (validates against on-premises AD)
On-Premises AD (Pass-Through Auth agent)
  ↓ (confirms or denies)
Response sent to Entra ID
  ↓ (user authenticated)
Cloud app logs user in
```

**Characteristics:**
- No password hash stored in cloud
- Real-time validation against on-premises AD
- Requires on-premises infrastructure online
- Higher latency (~100-200ms per auth)
- More secure (password never in cloud)

**When to use:**
- Security policy forbids cloud password storage
- On-premises AD is always online
- Regulatory requirement (HIPAA, PCI DSS)

### Model 3: Federated (AD FS / SAML)

**Architecture:**
```
User signs in to cloud app
  ↓ (redirects to on-premises ADFS)
AD FS (federated service)
  ↓ (validates with AD)
On-Premises AD
  ↓ (issues SAML assertion)
AD FS returns SAML to cloud app
  ↓ (user authenticated)
Cloud app logs user in
```

**Characteristics:**
- SAML-based federation
- Requires AD FS infrastructure
- Most complex setup
- Provides advanced scenarios (claims-based auth)

**When to use:**
- Complex authorization requirements
- Integration with legacy federation
- Need claims transformation

## Synchronization Architecture

### Azure AD Connect Components

```
On-Premises:
- Sync Agent (installed on DC or member server)
- Scheduler (30-minute default sync cycle)
- Filtering rules (which users to sync)

Cloud:
- Entra ID tenant
- Azure AD Connect service
- Directory DB

Sync Flow:
AD → Sync Agent → Cloud Sync Service → Entra ID
```

### Attribute Mapping Strategy

**Core Attributes (must sync):**
- mail (email)
- givenName, sn (first, last name)
- displayName
- userPrincipalName
- objectGUID (unique identifier)

**Extended Attributes (common):**
- department, title
- office, telephoneNumber
- manager (for org charts)
- extensionAttribute1-15 (custom)

**Scoping (filter which users):**

```
Sync only users from Finance OU:
CN=Users,OU=Finance,DC=contoso,DC=com

Sync only active users:
accountStatus = enabled

Result: Only matching users appear in Entra ID
```

## Single Sign-On Architecture

**Seamless SSO (Pass-Through Auth + Seamless SSO):**

```
On-Premises:
- User signs in with AD credentials
- Kerberos token obtained

Cloud:
- User visits cloud app
- Seamless SSO detects Kerberos token
- No password prompt
- User automatically signed in
```

**Configuration:**
1. Install Pass-Through Auth agents
2. Enable Seamless SSO in Azure AD Connect
3. Add Entra ID URLs to intranet zone (GPO)
4. Users on domain-joined machines get SSO

## Hands-On Lab: Configuring Hybrid Identity

**Estimated Time:** 60 minutes

**Prerequisites:** On-premises AD, Azure AD Connect, Entra ID tenant

**Lab Objectives:**
- Install Azure AD Connect
- Configure password hash sync
- Verify users sync to Entra ID
- Test hybrid sign-in

### Step 1: Install Azure AD Connect (20 minutes)

1. Download from microsoft.com
2. Run installer on domain-joined machine
3. Accept license
4. Click **Express Settings** (recommended)
5. Enter Entra ID global admin credentials
6. Enter on-premises AD admin credentials
7. Configure:
   - Single forest: Select your domain
   - User sign-in: Password Hash Synchronization
   - Users to sync: All
8. Complete installation
9. Verify service started: Services.msc → Azure AD Sync

### Step 2: Verify Synchronization (20 minutes)

1. Wait 5-10 minutes for first sync
2. In Entra ID, go to **Users**
3. Should see users from on-premises AD
4. Click user → Details
5. Verify attributes synced correctly (name, email, department)

### Step 3: Test Sign-In (15 minutes)

1. Sign in to cloud app with on-premises user account
2. Use format: `user@domain.com` (UPN from AD)
3. Verify successful sign-in
4. Check sign-in logs in Entra ID

### Step 4: Configure Sync Filters (5 minutes)

1. Run Azure AD Connect again
2. Click **Customize synchronization options**
3. **Sync users from specific OUs:**
   - Uncheck OUs you don't need to sync
   - Example: Exclude "Computers" OU
4. Complete sync
5. Verify unwanted objects removed from Entra ID

## Planning Migration: Hybrid → Cloud-Only

**Phase 1: Establish Hybrid (Current)**
- Users in both AD and Entra ID
- On-premises still authoritative for some systems
- Cloud gradually taking more workloads

**Phase 2: Cloud Primary**
- New users created in Entra ID first
- AD syncs to Entra ID
- Cloud is primary for new systems

**Phase 3: Cloud-Only**
- All users and systems in cloud
- On-premises AD decommissioned
- Timeline: 3-5 years

**Migration Checklist:**
- ☐ Inventory all on-premises applications
- ☐ Migrate apps to cloud or retire
- ☐ Plan user experience (minimize disruption)
- ☐ Coordinate with HR (new users to cloud)
- ☐ Test cloud-only scenarios
- ☐ Plan AD decommission

## Compliance & Standards

**Hybrid Architecture Compliance:**
- HIPAA: Support pass-through auth (no cloud passwords)
- PCI DSS: Encrypt sync channel (requires HTTPS)
- SOC 2: Log sync activities
- GDPR: Respect data residency if mandated

## Related Documents

**Prerequisites:**
- [LDAP and Directory Services](./09d-ldap-and-directory-services.md) - Directory protocols
- [Identity Management](./02-identity-management.md) - User lifecycle

**Next Steps:**
- [Pass-Through Authentication](./10a-pass-through-authentication.md) - Advanced auth
- [Multi-Cloud Identity](./11-multi-cloud-identity.md) - Cloud federation

## FAQ

**Q: How long until we can go cloud-only?**

A: Typically 3-5 years after starting hybrid. Plan migrations of legacy apps incrementally.

**Q: Can we sync some users and not others?**

A: Yes, use scoping filters. Sync users by OU, department, or custom attribute.

**Q: What if on-premises AD fails?**

A: With password hash sync, users can still sign in (hash cached). With pass-through auth, authentication fails. Plan redundancy.

## Next Steps

1. Assess current hybrid state
2. Choose sync model (hash vs. pass-through vs. federated)
3. Install Azure AD Connect
4. Test synchronization
5. Plan cloud-only migration timeline

Hybrid identity bridges your infrastructure. Get the architecture right and everything else flows naturally.
