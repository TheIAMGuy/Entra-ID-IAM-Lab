# Hands-On Lab Scenarios

8 comprehensive end-to-end lab scenarios covering complete IAM workflows and implementations. Each scenario includes learning objectives, step-by-step instructions, validation steps, and time estimates.

## Lab Scenario 1: Complete JML Cycle (Joiner-Mover-Leaver)

**Objective**: Execute full employee lifecycle in Azure AD with HR integration

**Prerequisites**: Azure AD tenant, HR system (simulated), test users

**Timeline**: 90 minutes

**Scenario**: Sarah is hired, promoted after 6 months, then leaves company. Document entire lifecycle.

**Steps**:
1. HR creates hire in Workday (simulated)
2. Azure AD auto-provisions user with Joiner workflow
3. Verify: Email, Teams, SharePoint, Salesforce access
4. After 6 months: Sarah promoted from Sales to Engineering
5. Azure AD auto-updates: removes Sales access, adds Engineering
6. Verify: Access updated within 4 hours
7. Sarah leaves company (termination date)
8. Azure AD auto-disables: removes all access within 4 hours
9. Verify: Sarah cannot sign in, data archived

**Validation Checklist**:
- ☐ User provisioned in <1 hour
- ☐ Email accessible within 30 minutes
- ☐ Groups updated within 4 hours (mover)
- ☐ Access revoked within 4 hours (leaver)
- ☐ Audit logs show all changes

**Lab Document**: 01 (Provisioning), 02 (Management), 06 (Deprovisioning), 18b (Automation)

---

## Lab Scenario 2: Multi-Cloud Identity Federation

**Objective**: Implement identity federation between Azure AD and AWS

**Prerequisites**: Azure AD tenant, AWS account, SAML configuration

**Timeline**: 120 minutes

**Scenario**: Company uses Azure AD for employee identity, needs SSO to AWS for cloud services

**Steps**:
1. Configure Azure AD as SAML IdP
2. Create AWS IAM Identity Provider (trust Azure AD)
3. Create AWS IAM roles for Finance and Engineering teams
4. Configure SAML attribute mappings (department → AWS role)
5. Test SSO: Log in to AWS console via Azure AD

**Validation**:
- ☐ Finance user lands in Finance AWS role
- ☐ Engineering user lands in Engineering role
- ☐ Cross-cloud identity working
- ☐ No separate AWS passwords needed

**Lab Documents**: 10 (Hybrid), 11 (Multi-Cloud), 09a (SAML), 15a (Workload Federation)

---

## Lab Scenario 3: Zero Trust Access Implementation

**Objective**: Implement Zero Trust principles: assume breach, verify explicitly

**Prerequisites**: Azure AD Premium, Conditional Access

**Timeline**: 90 minutes

**Scenario**: Company moving from implicit trust (on-network = trusted) to Zero Trust (verify every access)

**Steps**:
1. Create baseline Conditional Access policies
2. Require MFA for all users
3. Block unmanaged devices
4. Require passwordless for executives
5. Implement location-based policies
6. Add anomaly detection
7. Implement adaptive MFA (risk-based)

**Validation**:
- ☐ All users prompted for MFA
- ☐ Unmanaged devices blocked
- ☐ High-risk logins require strong auth
- ☐ Policies logged and monitored

**Lab Documents**: 08b (Zero Trust), 07a (MFA), 07b (Passwordless), 08 (Risk Detection)

---

## Lab Scenario 4: IGA Platform Access Review Workflow

**Objective**: Implement quarterly access reviews with SailPoint IGA platform

**Prerequisites**: IGA platform, user data sync, manager hierarchy

**Timeline**: 150 minutes

**Steps**:
1. Sync users and access from Azure AD
2. Create access review campaign for Q1
3. Define SoD rules (finance conflict checking)
4. Send reviews to managers
5. Managers certify or recommend access removal
6. Auto-disable access for non-certified items
7. Generate compliance report

**Validation**:
- ☐ 100% of managers reviewed their teams
- ☐ SoD conflicts detected and flagged
- ☐ Excess access removed
- ☐ Report shows compliance status

**Lab Documents**: 17a (IGA Platforms), 13b (SoD), 17 (Compliance), 19 (Reporting)

---

## Lab Scenario 5: Incident Response and Risk Remediation

**Objective**: Detect, investigate, and remediate account compromise

**Prerequisites**: Identity Protection enabled, risk scoring, incident response team

**Timeline**: 120 minutes

**Steps**:
1. Risk detection identifies impossible travel (NYC to Tokyo in 1 hour)
2. System blocks access, requires re-authentication
3. IT team begins investigation
4. Review audit logs for attacker activity
5. Reset password, revoke tokens
6. Enable MFA (if not already enabled)
7. Investigation: what data accessed, where did attacker go
8. Post-incident review: how did phishing succeed

**Validation**:
- ☐ Incident detected automatically (MTTD <1 hour)
- ☐ Account contained within 30 minutes
- ☐ Audit logs show all attacker activity
- ☐ Post-incident report completed

**Lab Documents**: 17c (Incident Response), 17d (Risk Scoring), 08 (Risk Detection), 19a (Intelligence)

---

## Lab Scenario 6: Hybrid Identity Sync and Seamless SSO

**Objective**: Sync on-premises AD to Azure AD with seamless SSO

**Prerequisites**: On-premises AD, Azure AD, Azure AD Connect

**Timeline**: 120 minutes

**Steps**:
1. Install Azure AD Connect
2. Configure directory sync (one-way: on-prem → cloud)
3. Sync users, groups, attributes
4. Enable password hash sync
5. Configure seamless SSO
6. Test: User logs in with on-prem credentials, automatically signed in to cloud apps
7. Update password on-prem, verify it syncs to cloud

**Validation**:
- ☐ Users synced to cloud (count matches)
- ☐ Password updated in cloud within 5 minutes
- ☐ Seamless SSO working (no re-auth prompts)
- ☐ Groups synced correctly

**Lab Documents**: 10 (Hybrid), 09d (LDAP), 10a (Pass-Through Auth)

---

## Lab Scenario 7: Workload Identity and Service-to-Service Auth

**Objective**: Implement workload identity for microservices running in Kubernetes

**Prerequisites**: Kubernetes cluster, SPIFFE/SPIRE or Azure workload federation

**Timeline**: 150 minutes

**Steps**:
1. Deploy SPIFFE/SPIRE in Kubernetes
2. Create trust domain
3. Register workloads (payment service, inventory service)
4. Generate SVIDs (workload certificates)
5. Configure mTLS between services
6. Test: Payment service calls inventory service with SVID
7. Verify: Service-to-service auth via mTLS

**Validation**:
- ☐ Each service has unique identity
- ☐ mTLS working between services
- ☐ Audit logs show service-to-service calls
- ☐ No long-lived secrets in logs

**Lab Documents**: 14 (SPIFFE), 14b (Container Workload), 15a (Workload Federation), 15b (Secrets)

---

## Lab Scenario 8: Governance and KPI Dashboard

**Objective**: Implement identity governance metrics and executive dashboard

**Prerequisites**: Monitoring tools, reporting platform, Azure AD activity logs

**Timeline**: 90 minutes

**Steps**:
1. Define KPIs: Time to provision, MFA adoption, access review completion
2. Configure data collection (Azure AD logs, HR data)
3. Build Power BI dashboard
4. Create automated monthly reports
5. Set thresholds and alerts
6. Share with executive steering committee
7. Track metrics over 3 months, show improvement

**Validation**:
- ☐ Dashboard updated daily
- ☐ All KPIs visible with trends
- ☐ Executives can access (appropriate permissions)
- ☐ Alerts firing for threshold breaches
- ☐ Monthly trends showing

**Lab Documents**: 19b (KPI Management), 19 (Reporting), 20b (Maturity Assessment)

---

## Lab Prerequisite Setup (For All Labs)

Create test environment:
1. Azure AD tenant (free tier acceptable)
2. 10 test users (various roles)
3. 3-4 test applications
4. HR system simulation (spreadsheet or test data)
5. Monitoring/logging enabled
6. Help desk ticketing system (optional)

Estimated setup time: 30-45 minutes
See [SANDBOX_SETUP.md](SANDBOX_SETUP.md) for detailed environment setup instructions.

## Lab Support Resources

- Sample automation scripts in `../examples/scripts/`
- Sample policy configurations in `../examples/`
- Troubleshooting guides per lab

## Certification Path

Complete all 8 scenarios + pass knowledge assessment = IAM Implementation Specialist certification

Time commitment: 15-20 hours total
Difficulty: Medium to Advanced
Recommended order: 1, 2, 6, 3, 4, 5, 7, 8
