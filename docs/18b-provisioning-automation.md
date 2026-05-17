---
title: Provisioning Automation - Workflow Automation and Orchestration
part: 9
section: Operations & Administration
difficulty: Intermediate
estimated_reading_time: 25
estimated_lab_time: 30
prerequisites:
  - 01-user-provisioning-joiner.md
  - 18-self-service-portal.md
learning_objectives:
  - Understand provisioning automation concepts
  - Design identity workflow automation
  - Implement provisioning workflows
  - Orchestrate multi-system provisioning
  - Monitor and optimize automation
---

# Provisioning Automation: Workflow Automation and Orchestration

## Introduction

Provisioning automation eliminates manual steps in identity lifecycle processes. Instead of IT manually creating a user account, sending welcome emails, requesting hardware, provisioning email, the system orchestrates all steps: HR creates hire → Auto-provisions user in Azure AD → Auto-requests laptop → Auto-sends welcome → Auto-provisions email. Automation speeds onboarding (days to hours), reduces errors (consistency), and scales (same cost for 10 or 10,000 users). This document explains provisioning automation concepts, workflow design, and implementation.

**Learning Objectives:**
- Design identity provisioning workflows
- Automate joiner, mover, leaver processes
- Implement workflow orchestration
- Integrate with HR, applications, equipment
- Monitor and optimize automation

## Provisioning Automation Concepts

### Workflow vs. Process

**Key distinction:**

```
Process (Manual):
  1. HR creates hire in Workday
  2. IT admin checks Workday, creates Azure AD user (manual)
  3. IT admin sends email to user (manual)
  4. IT admin creates email account (manual)
  5. IT admin sends hardware request (manual)
  
  Timeline: 2-3 days
  Error rate: 10-15% (missing steps, typos)
  Cost: Significant (multiple admins involved)

Workflow (Automated):
  1. HR creates hire in Workday (same)
  2. Workflow trigger: New hire created → Automatically:
     ├─ Create Azure AD user
     ├─ Create email account
     ├─ Send welcome email
     ├─ Request laptop
     ├─ Add to distribution groups
     ├─ Notify manager
     ├─ Schedule training
  
  Timeline: Minutes to 1 hour (full onboarding)
  Error rate: <1% (automated, repeatable)
  Cost: Low (no manual intervention)
```

### Automation Benefits

**Why automate:**

```
Speed
  Manual: 2-5 days to full access
  Automated: 1-2 hours
  Benefit: Faster user productivity, better experience

Quality
  Manual: 10-15% error rate (missed steps, typos)
  Automated: <1% error rate (consistent, repeatable)
  Benefit: Reliable onboarding, fewer exceptions

Scalability
  Manual: 1-2 users per admin per day (doesn't scale)
  Automated: 100+ users per day (scales automatically)
  Benefit: Same infrastructure for 10 or 10,000 users

Audit Trail
  Manual: No record of who did what, when
  Automated: Complete record of every step, every change
  Benefit: Compliance, troubleshooting, forensics

Cost
  Manual: 2-3 hours per user × labor cost = $300-500 per hire
  Automated: 30 minutes setup × labor cost = <$50 per hire
  Benefit: 80%+ cost reduction at scale
```

## Joiner Automation

### Joiner Workflow (Hire → Access Ready)

**Complete onboarding in automated sequence:**

```
Trigger: HR creates new hire in Workday
         Name: John Smith
         Department: Sales
         Start date: 2024-01-15
         Manager: Mary Johnson

Hour 0 (Minutes after hire created):
  ├─ Pre-provisioning check
  │  └─ Validate required data (email, department, manager)
  │     If missing: Notify HR to complete, retry
  │
  ├─ Create Azure AD user
  │  ├─ Generate UPN: john.smith@company.com
  │  ├─ Generate temporary password
  │  ├─ Set attributes (department, manager, etc.)
  │  └─ Enable account
  │
  ├─ Create email account
  │  ├─ Create Exchange mailbox
  │  ├─ Set email address: john.smith@company.com
  │  └─ Configure Outlook (web and desktop)
  │
  ├─ Request hardware
  │  ├─ Create ticket in ServiceNow
  │  ├─ Request laptop (based on department)
  │  ├─ Assign shipping address (office location)
  │  └─ Set delivery date: Start date
  │
  ├─ Add to groups
  │  ├─ All employees group
  │  ├─ Department group (Sales)
  │  ├─ Location group (New York)
  │  └─ Level group (IC1 - individual contributor)
  │
  ├─ Grant application access
  │  ├─ Provision Salesforce account
  │  ├─ Provision ServiceNow account
  │  ├─ Provision SharePoint site access
  │  └─ Provision phone system account
  │
  ├─ Create documentation
  │  ├─ Create user guide document
  │  ├─ Create Visio diagram in team folder
  │  ├─ Set up calendar (30-min Welcome Call with HR)
  │  └─ Schedule first week training
  │
  └─ Send communications
     ├─ Welcome email (to new hire)
     ├─ Notification to manager (access ready)
     ├─ Notification to help desk (new user created)
     └─ Notification to equipment team (hardware requested)

Hour 1-2 (Post-provisioning):
  ├─ Verify provisioning
  │  ├─ Test Azure AD sign-in works
  │  ├─ Test email account accessible
  │  ├─ Verify all groups added
  │  └─ Verify all applications provisioned
  │
  ├─ If verification fails:
  │  ├─ Alert help desk
  │  ├─ Rollback provisioning
  │  ├─ Investigate root cause
  │  └─ Notify stakeholders of delay
  │
  └─ If verification succeeds:
     ├─ Mark onboarding complete
     ├─ Archive workflow execution
     └─ Send final confirmation

Day 1 (First day):
  ├─ System auto-logs user into new device with credentials
  ├─ User receives hardware with pre-configured setup
  ├─ User attends welcome meeting with manager
  └─ All access ready to use

Timeline: 1-2 hours (fully provisioned and ready to work)
Manual effort: ~10 minutes (IT just triggered workflow)
```

### Workflow Execution Monitoring

**Track workflow progress in real-time:**

```
Workflow execution dashboard:

Workflow: Joiner - John Smith
Status: In Progress (50% complete)
Started: 2024-01-15 09:00 UTC
Current time: 2024-01-15 09:15 UTC
Estimated completion: 2024-01-15 10:30 UTC

Steps completed:
  ✓ Data validation (1 min)
  ✓ Azure AD user created (2 min)
  ✓ Email account created (3 min)
  ✓ Hardware requested (1 min)
  ✓ Groups added (2 min)

Steps in progress:
  ⏳ Salesforce provisioning (2 min elapsed, est. 3 min total)

Steps pending:
  ⏱ ServiceNow provisioning (pending)
  ⏱ SharePoint provisioning (pending)
  ⏱ Phone system provisioning (pending)
  ⏱ Verification (pending)

Alerts:
  ⚠ Workflow delayed: Salesforce API timeout (retry in 30 sec)
  ℹ Hardware team notified of request

Actions:
  [Retry] [Skip Step] [Rollback] [View Logs]

Log output:
  09:00 UTC - Workflow started
  09:01 UTC - Data validation: SUCCESS
  09:02 UTC - Azure AD user creation: SUCCESS
  09:03 UTC - Email account creation: SUCCESS (john.smith@company.com)
  09:04 UTC - Hardware request creation: SUCCESS (SN-12345)
  09:05 UTC - Groups sync: SUCCESS (4 groups added)
  09:07 UTC - Salesforce provisioning: TIMEOUT (retry 1 of 3)
  09:08 UTC - Salesforce provisioning: TIMEOUT (retry 2 of 3)
  09:09 UTC - Salesforce provisioning: TIMEOUT (retry 3 of 3)
  09:09 UTC - Salesforce provisioning: FAILED
  (Alert sent to help desk)
```

## Mover Automation

### Mover Workflow (Job Change → New Access)

**Update access when employee changes roles:**

```
Trigger: HR updates employee in Workday
         John Smith
         From: Sales, reporting to Mary Johnson
         To: Engineering, reporting to Bob Lee
         Effective: 2024-02-01

Automated steps:

1. Validate change
   ├─ Confirm both department values valid
   ├─ Confirm new manager exists
   └─ If invalid: Notify HR, pause workflow

2. Remove old access (Sales)
   ├─ Remove from Sales group
   ├─ Remove from Salesforce app role
   ├─ Remove from "Sales reports" distribution list
   ├─ Revoke Sales database access
   └─ Archive Sales shared drives

3. Grant new access (Engineering)
   ├─ Add to Engineering group
   ├─ Provision development environment access
   ├─ Provision GitHub team access
   ├─ Provision Jira project access
   ├─ Add to "Engineering reports" distribution list
   └─ Request seat license for engineering tools

4. Notify stakeholders
   ├─ Notify John (new access available)
   ├─ Notify new manager Bob (team member added)
   ├─ Notify old manager Mary (team member moved)
   ├─ Notify help desk (access changed)
   └─ Notify equipment team (tools/licenses needed)

5. Update documentation
   ├─ Org chart updated automatically
   ├─ Email directory updated
   ├─ Team rosters updated
   └─ Manager reporting relationships updated

6. Schedule training
   ├─ Request engineering onboarding training
   ├─ Add to new team calendar invites
   └─ Schedule 1:1 with new manager

Timeline: 30-45 minutes (all access updated)
Manual effort: 0 minutes (fully automated)
```

## Leaver Automation

### Leaver Workflow (Termination → Offboarding Complete)

**Disable access when employee departs:**

```
Trigger: HR marks employee as terminated in Workday
         John Smith, termination date: 2024-03-31

Day before termination (automated prep):
  ├─ Schedule offboarding tasks
  ├─ Notify manager of offboarding
  ├─ Prepare access removal steps
  └─ Send IT offboarding checklist to manager

Day of termination (T-Day):

T+1 hour (Immediate lockdown):
  ├─ Disable Azure AD account (sign-in blocked)
  ├─ Terminate all active sessions
  ├─ Revoke all OAuth refresh tokens
  ├─ Disable email account (cannot receive new mail)
  ├─ Revoke VPN access
  └─ Disable phone/device access

T+4 hours (Access revocation):
  ├─ Remove from all groups
  ├─ Revoke all application access
  ├─ Remove from distribution lists
  ├─ Disable database access
  ├─ Revoke cloud storage access
  └─ Remove from Slack, Teams, collaboration tools

T+8 hours (Data handling):
  ├─ Archive mailbox (preserve for compliance)
  ├─ Convert OneDrive to inactive
  ├─ Notify users who share files with John
  ├─ Transfer ownership of shared resources
  └─ Generate data export (for records)

T+24 hours (Final cleanup):
  ├─ Send exit survey (optional)
  ├─ Remove from all service subscriptions
  ├─ Deactivate network access
  ├─ Remove from physical access systems
  └─ Archive user record

Post-termination (ongoing):
  Day 7: Archive mailbox if no longer needed
  Day 30: Delete cloud storage if no holds
  Day 90: Delete user account if no compliance hold

Timeline: All critical access removed within 4 hours
Manual effort: 30 minutes (just verify completion)
```

## Workflow Implementation Platforms

### Platform Options

```
Platform: Azure Logic Apps
  Model: Cloud-native workflow builder
  Connectors: HR systems, Azure AD, applications (100+)
  Trigger: HR creates hire → Automatically run workflow
  Cost: Pay-per-execution model
  Example: Create joiner workflow with 10 steps
  
Platform: Power Automate (Microsoft Copilot Studio)
  Model: Visual workflow builder
  Audience: Business analysts, power users
  Complexity: Low-to-medium automation
  Cost: Per-user licensing + execution fees
  Example: Approval workflows, simple provisioning
  
Platform: ServiceNow Workflows
  Model: Integrated with ServiceNow ITSM
  Audience: IT teams already using ServiceNow
  Complexity: Medium automation
  Cost: Included in ServiceNow licensing
  Example: IT service request automation
  
Platform: Okta Workflows
  Model: Identity-centric workflow engine
  Audience: Organizations using Okta
  Complexity: Medium-to-high automation
  Cost: Workflow licensing separate from Okta
  Example: Provisioning, deprovisioning, webhook handling
  
Platform: IAM-specific (SailPoint, Okta, Ping)
  Model: Dedicated identity provisioning
  Audience: Enterprise IAM teams
  Complexity: High automation, extensive customization
  Cost: High (enterprise pricing)
  Example: Enterprise-scale joiner/mover/leaver automation
```

## Best Practices

1. **Validate First** - Check all required data before starting workflow
2. **Fail Safe** - Pause on errors, don't cascade failures
3. **Idempotent** - Safe to retry without duplicating actions
4. **Monitor** - Real-time dashboard of running workflows
5. **Audit** - Log every step for compliance and troubleshooting
6. **Rollback** - Ability to undo if workflow fails halfway
7. **Test** - Dry-run workflows before production
8. **Exception Handling** - Clear path for manual intervention
9. **Scaling** - Performance tested for peak volumes
10. **Governance** - Version control, change tracking, approvals

## Related Documents

**Prerequisites:**
- [Joiner](./01-user-provisioning-joiner.md) - Onboarding concepts
- [Self-Service Portal](./18-self-service-portal.md) - User-initiated requests

**Next Steps:**
- [Delegation](./18a-delegation-administration.md) - Manager approvals
- [Reporting](./19-identity-reporting-analytics.md) - Provisioning metrics

## FAQ

**Q: What if HR system is down during onboarding?**

A: Workflow waits for HR data. Cache last-known data if available. Manual escalation if no data after 24 hours.

**Q: Can we handle exceptions in the workflow?**

A: Yes. Pause workflow, notify help desk, allow manual action, resume.

**Q: How do we test provisioning workflows?**

A: Use staging environment with test data. Dry-run before production deployment.

## Hands-On Lab: Joiner Automation

**Estimated Time:** 30 minutes

**Prerequisites:** Azure subscription, Azure Logic Apps, Azure AD

**Lab Objectives:**
- Create joiner automation workflow
- Trigger workflow from HR data
- Verify provisioning steps

### Step 1: Create Azure Logic App (10 min)

```bash
# Create resource group
az group create --name iam-automation-rg --location eastus

# Create Logic App
az logic workflow create \
  --name joiner-workflow \
  --resource-group iam-automation-rg \
  --location eastus
```

### Step 2: Design Workflow Trigger (5 min)

```
Trigger: When Workday Create Employee event received
Connector: Workday
Event: New employee created
Map fields: Name, email, department, manager
```

### Step 3: Add Provisioning Actions (10 min)

```
Action 1: Create Azure AD user
  Input: Name, UPN, email, department
  
Action 2: Send welcome email
  Input: User email, user name
  
Action 3: Create task in ServiceNow
  Input: Hardware request, shipping address
  
Action 4: Add to group
  Input: Department group
```

### Step 4: Test Workflow (5 min)

```
Test: Create test employee in Workday
Observe: Workflow executes, all steps complete
Verify: User created in Azure AD, email sent, task created
```

## Next Steps

1. Identify manual provisioning steps
2. Design joiner/mover/leaver workflows
3. Implement using Azure Logic Apps or platform of choice
4. Test with pilot group (10-20 users)
5. Monitor and optimize
6. Roll out to production
7. Measure time and cost savings

Provisioning automation transforms identity operations from manual to automated, reducing time from days to hours.
