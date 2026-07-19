---
title: Multi-Cloud Identity Federation
part: 4
section: Hybrid & Cloud Identity
difficulty: Advanced
estimated_reading_time: 40
estimated_lab_time: N/A
prerequisites:
  - 09-identity-standards-overview.md
  - 10-hybrid-identity-architecture.md
learning_objectives:
  - Design multi-cloud identity architecture
  - Implement SAML federation across clouds
  - Configure cross-cloud single sign-on
  - Manage identities across AWS, Azure, GCP
  - Understand federation patterns and trust models
---

# Multi-Cloud Identity Federation

## Introduction

Organizations increasingly run workloads across multiple cloud providers (Azure, AWS, GCP). Users need single sign-on across all clouds. This requires federation: each cloud trusts a central identity provider (Entra ID). This document explains multi-cloud identity architecture and how to federate identity across clouds.

**Learning Objectives:**
- Design multi-cloud identity architectures
- Implement SAML federation to AWS and GCP
- Configure cross-cloud single sign-on
- Manage roles and permissions across clouds
- Understand federation trust models

## Multi-Cloud Architecture

**Hub-and-Spoke Model:**

```
Central Identity Provider (Microsoft Entra ID)
  ↓ (SAML federation)
┌─────────┬─────────┬──────────┐
↓         ↓         ↓          ↓
Azure     AWS       GCP      Okta
Workloads Workloads Workloads Integration
```

**Flow:**
```
User signs into Azure
  → Single Sign-On (seamless, already authenticated)
User accesses AWS workload
  → Redirected to Entra ID (SAML)
  → Entra ID checks if user already authenticated
  → Yes → Entra ID sends SAML assertion to AWS
  → AWS accepts assertion, logs user in
User accesses GCP workload
  → Same flow to GCP
```

## Federation Patterns

### Pattern 1: SAML Federation (Recommended)

**Setup:**
1. AWS/GCP configured as SAML Service Provider
2. Entra ID as Identity Provider
3. Trust relationship established via metadata
4. Users sign in once, access all clouds

**Advantages:**
- Proven, stable
- Works with all major clouds
- Single sign-on experience

### Pattern 2: OAuth 2.0 Federation (Mobile/APIs)

**Setup:**
1. Cloud configured as OAuth client
2. Entra ID as authorization server
3. Users authenticate via OAuth flow
4. Apps get tokens valid across clouds

**Use for:**
- API access
- Microservices
- Cross-cloud service-to-service auth

### Pattern 3: Workload Federation (Services)

**Setup:**
1. Services authenticate with cloud-specific workload identity
2. Entra ID issues tokens to services
3. Services use tokens to access other clouds

**Use for:**
- Automation, CI/CD
- Kubernetes workloads
- Microservices

## Implementing AWS-Azure Federation

**AWS Setup:**
```
1. In IAM, create SAML provider
   - Name: "Entra ID SAML"
   - Metadata: Download from Entra ID
2. Create IAM role: "Azure-Users"
   - Trust policy: SAML provider
   - Permissions: Attach policies (PowerUser, etc.)
3. Create SAML assertion attributes in Entra ID
   - Map groups to AWS roles
   - Example: Finance group → Finance IAM role
```

**Entra ID Setup:**
```
1. Add AWS as enterprise application
2. Configure SAML:
   - ACS: AWS SAML endpoint
   - Entity ID: AWS account ID
3. Map attributes:
   - Group claim → AWS role ARN
4. Users assigned to app can federate to AWS
```

**Test:**
```
1. Sign in to Entra ID
2. Access AWS app from portal
3. Redirected to AWS with SAML assertion
4. Auto-logged in, can access resources
```

## Cross-Cloud Authorization

**Challenge:** User has different roles in each cloud:
- Azure: Global Admin
- AWS: PowerUser  
- GCP: Editor

**Solution: Attribute-Based Access Control**

```
Entra ID stores user attributes:
- azure_role: GlobalAdmin
- aws_role: PowerUser
- gcp_role: Editor
- department: Finance

SAML assertion includes all attributes
Each cloud interprets attributes for its role system
Result: Consistent access across clouds
```

## Multi-Cloud Single Sign-On

**Seamless Experience:**

```
User signs in once (to Entra ID or first cloud)
  → Session token cached
  → Access any other cloud
  → No re-authentication needed
  → 24-hour session window (configurable)
```

**Implementation:**
1. Configure session lifetime in Entra ID (default: 24 hours)
2. Clouds trust Entra ID's session
3. Users get SSO automatically

## Governance in Multi-Cloud

**Challenges:**
- Users have different access levels in each cloud
- Provisioning/deprovisioning across clouds
- Compliance with multiple cloud providers

**Solutions:**

1. **Centralized Provisioning:**
   - Entra ID source of truth
   - SCIM provisioning to each cloud
   - Automated role assignment

2. **Access Reviews:**
   - Quarterly reviews across clouds
   - Consolidated reporting
   - Automated removal of unused access

3. **Audit Trail:**
   - Log access to all clouds
   - Unified dashboard
   - SIEM integration

## Compliance & Standards

**Multi-Cloud Compliance Challenges:**
- **GDPR:** Data residency (EU users may need EU data)
- **HIPAA:** Each cloud must be HIPAA-compliant
- **PCI DSS:** Federation supported with proper controls

**Solution:** Map users to appropriate cloud based on compliance requirements.

## Related Documents

**Prerequisites:**
- [Identity Standards Overview](./09-identity-standards-overview.md) - Federation standards
- [Hybrid Identity Architecture](./10-hybrid-identity-architecture.md) - Identity architecture

**Next Steps:**
- [Workload Identity](./11a-workload-identity.md) - Service-to-service identity
- [Machine Identity](./11b-machine-identity.md) - Non-human entities

## FAQ

**Q: Can we federate to multiple clouds simultaneously?**

A: Yes, each cloud trusts Entra ID. Users access all clouds with single sign-on.

**Q: What if a user has same email in multiple clouds?**

A: Use unique attribute mapping (tenant ID + email) to distinguish.

**Q: How do we handle cloud-specific roles?**

A: Map Entra ID groups to cloud-specific IAM roles in SAML assertion.

## Next Steps

1. Map multi-cloud architecture
2. Configure SAML in each cloud
3. Set up attribute mappings
4. Test federation flows
5. Implement cross-cloud access reviews

Multi-cloud identity federation enables true global workload distribution.
