# Complete Lab Index: All Hands-On Exercises

This document indexes all hands-on labs in the knowledge base, organized by topic, difficulty, and time commitment.

---

## Quick Filter: Find Your Lab

**Just getting started?** → `QUICKSTART_LABS.md` (24-hour learning path with 3 core labs)

**Want to skip ahead?** → Find by difficulty:
- **Beginner (1-2 hours):** Labs 1, 2, 4, 8, 12
- **Intermediate (2-4 hours):** Labs 3, 5, 6, 10, 14
- **Advanced (4+ hours):** Labs 7, 9, 11, 15

**Need to learn specific domains?**
- Provisioning → Labs 1, 3
- Authentication/MFA → Labs 2, 4
- Hybrid identity → Labs 5, 6
- Authorization → Labs 7, 8
- Incident response → Lab 9
- Workload identity → Labs 10, 11
- Governance → Labs 12, 13, 14
- Multi-cloud → Lab 15

---

## All 15 Lab Exercises

### Lab 1: Joiner Provisioning Workflow ⭐ Beginner
| Attribute | Details |
|-----------|----------|
| **Time Required** | 1-2 hours |
| **Difficulty** | Beginner |
| **Prerequisites** | SANDBOX_SETUP.md completed, Azure access |
| **Document** | `01-user-provisioning-joiner.md` |
| **Script** | `../examples/scripts/01-joiner-automation-basic.sh` |
| **What You'll Learn** | How new users are automatically provisioned with all required access |
| **What You'll Build** | Automated workflow: HR creates user → AD account created → email provisioned → groups assigned → all in <5 minutes |
| **Expected Outcome** | New test user fully provisioned and can sign in |
| **Cost** | $0 (free tier) |

**Lab Flow:**
1. Simulate HR creating new hire in Workday
2. Watch automation create:
   - Azure AD user account
   - Email mailbox
   - Security groups
   - Application assignments
3. Test: New user signs in successfully

**Common Mistakes:**
- HR data incomplete → validation fails (add department!)
- Email provisioning timeout → wait 2 mins, retry
- User can't sign in → reset password in Azure AD

---

### Lab 2: Multi-Factor Authentication (MFA) Setup ⭐ Beginner
| Attribute | Details |
|-----------|----------|
| **Time Required** | 1-2 hours |
| **Difficulty** | Beginner |
| **Prerequisites** | Lab 1 complete, authenticator app on phone (Microsoft Authenticator or Google Authenticator) |
| **Document** | `07a-multi-factor-authentication.md` |
| **Script** | `../examples/scripts/02-mfa-enrollment.sh` |
| **What You'll Learn** | How to enable MFA globally and enroll users |
| **What You'll Build** | MFA policy requiring all users to complete authentication with password + phone code |
| **Expected Outcome** | Sign-in requires password + 6-digit code from authenticator app |
| **Cost** | $0 (free tier) |

**Lab Flow:**
1. Create Conditional Access policy: "Require MFA for all cloud apps"
2. Enroll test user:
   - Open https://myaccount.microsoft.com
   - Register authenticator app
   - Scan QR code with phone
3. Test sign-in:
   - Sign out
   - Sign back in with username + password
   - Enter 6-digit code from phone
   - Sign-in succeeds

**Common Mistakes:**
- TOTP code expired (30-second window) → generate new code immediately
- App not synced → app clock must match system time
- User registration times out → close browser, try again

---

### Lab 3: Mover Workflow (Role Change) ⭐ Intermediate
| Attribute | Details |
|-----------|----------|
| **Time Required** | 2-3 hours |
| **Difficulty** | Intermediate |
| **Prerequisites** | Lab 1 complete |
| **Document** | `06-mover-leaver-workflows.md` |
| **Script** | `../examples/scripts/03-mover-automation.sh` |
| **What You'll Learn** | How to automatically update access when employees change roles |
| **What You'll Build** | Workflow: Employee changes department → Old access removed → New access granted → All in <15 minutes |
| **Expected Outcome** | User transitions from Sales team to Engineering team; Salesforce access removed, GitHub access granted |
| **Cost** | $0 (free tier) |

**Lab Flow:**
1. Create two test users: one in Sales, one in Engineering
2. Change Sales user to Engineering role in HR system
3. Watch automation:
   - Remove Sales group → loses Salesforce access
   - Add Engineering group → gains GitHub access
   - Update manager relationship
   - Send notifications
4. Verify:
   - User can no longer access Salesforce
   - User can now access GitHub
   - Manager is updated

**Common Mistakes:**
- Workflows run in parallel → timing issues (retry if not all steps complete)
- Access not fully revoked → check all dependent systems
- Manager change fails → verify new manager exists in system

---

### Lab 4: Passwordless Authentication (FIDO2) ⭐ Beginner
| Attribute | Details |
|-----------|----------|
| **Time Required** | 1.5 hours |
| **Difficulty** | Beginner |
| **Prerequisites** | Lab 2 complete, hardware security key (optional: simulate with software) |
| **Document** | `07b-passwordless-authentication.md` |
| **Script** | `../examples/scripts/04-passwordless-setup.sh` |
| **What You'll Learn** | How passwordless authentication (FIDO2 keys) works and why it's more secure than passwords |
| **What You'll Build** | Passwordless sign-in policy where users sign in with hardware key instead of password |
| **Expected Outcome** | User signs in to Azure AD with FIDO2 key (no password needed) |
| **Cost** | $0 (free tier) + ~$20-50 for hardware key (optional; can simulate) |

**Lab Flow:**
1. Register FIDO2 device:
   - https://myaccount.microsoft.com → Security info
   - Register security key
   - Touch key when prompted
2. Enable passwordless sign-in policy
3. Test sign-in:
   - Go to login.microsoft.com
   - Select "Sign-in options" → "Windows Hello or security key"
   - Touch key
   - Sign-in succeeds (no password!)

**Common Mistakes:**
- Key registration fails → wait for system to prompt, then touch key
- Timing out during registration → keys expire after 5 mins, restart
- "Key not supported" → use modern key (FIDO2/U2F)

---

### Lab 5: Hybrid Identity Sync ⭐ Intermediate
| Attribute | Details |
|-----------|----------|
| **Time Required** | 3-4 hours |
| **Difficulty** | Intermediate |
| **Prerequisites** | SANDBOX_SETUP.md completed (on-prem AD running), Azure access, Azure AD Connect downloaded |
| **Document** | `10-hybrid-identity-architecture.md` |
| **Script** | `../examples/scripts/05-hybrid-sync-setup.sh` |
| **What You'll Learn** | How to sync users from on-premises AD to Azure AD cloud |
| **What You'll Build** | Hybrid identity: create user in on-prem AD → user appears in Azure within 5 minutes → can sign in to cloud apps |
| **Expected Outcome** | Users managed in one place (on-prem AD) but can sign in to both on-prem and cloud systems |
| **Cost** | $0 (free tier) |

**Lab Flow:**
1. Create test users in on-prem AD
2. Install Azure AD Connect on VM:
   ```bash
   # Download and run installer
   # Choose: cloud sync or traditional sync
   # Configure attribute mapping
   # Test sync
   ```
3. Verify sync working:
   - Create user in on-prem AD
   - Check Android Entra ID after 2-5 minutes
   - User appears in cloud
4. Test sign-in:
   - User signs in to on-prem system (AD): works
   - User signs in to cloud app (Office 365): works
   - Same credentials work for both

**Common Mistakes:**
- AD Connect not started → service should auto-start; restart if needed
- Sync stuck → check service running (`net start ADSync`)
- Attribute mapping wrong → re-run wizard to fix

---

### Lab 6: Conditional Access Policies ⭐ Intermediate
| Attribute | Details |
|-----------|----------|
| **Time Required** | 2-3 hours |
| **Difficulty** | Intermediate |
| **Prerequisites** | Lab 2 complete (MFA enrolled), Azure access |
| **Document** | `07c-adaptive-authentication.md` |
| **Script** | `../examples/scripts/06-conditional-access.sh` |
| **What You'll Learn** | How to create risk-based policies that adapt authentication based on context |
| **What You'll Build** | Policy: "If user signs in from unusual location → require MFA; if sign-in is very risky → block" |
| **Expected Outcome** | Different authentication requirements based on sign-in risk |
| **Cost** | $0 (free tier) |

**Lab Flow:**
1. Create 3 Conditional Access policies:
   - Policy 1: "Require MFA for all cloud apps" (baseline)
   - Policy 2: "Require FIDO2 for high-risk sign-ins"
   - Policy 3: "Block if impossible travel detected"
2. Test each policy:
   - Normal sign-in (NYC, business hours) → allow with MFA
   - Risky sign-in (Tokyo, 3 AM) → require FIDO2
   - Impossible travel (NYC → London in 1 hour) → block
3. Verify policies don't conflict

**Common Mistakes:**
- Policies not in order → wrong one fires first (order matters!)
- Exclude yourself from blocking policy → you'll lock yourself out
- Test before rollout → always have escape plan

---

### Lab 7: Fine-Grained Authorization (ABAC) ⭐ Advanced
| Attribute | Details |
|-----------|----------|
| **Time Required** | 4-5 hours |
| **Difficulty** | Advanced |
| **Prerequisites** | Intermediate understanding of RBAC, OPA or similar policy engine |
| **Document** | `13-fine-grained-authorization.md` |
| **Script** | `../examples/scripts/07-fga-implementation.sh` |
| **What You'll Learn** | How attribute-based access control (ABAC) enables more nuanced permissions than RBAC |
| **What You'll Build** | Policy engine that evaluates: user attributes, resource attributes, environment → decision (allow/deny) |
| **Expected Outcome** | "Grant access if: user department = Finance AND resource = financial database AND time = business hours AND device = managed" |
| **Cost** | $0 (free tier) |

**Lab Flow:**
1. Install OPA (Open Policy Agent)
2. Write Rego policy for financial data:
   ```rego
   allow {
       input.user.department == "Finance"
       input.resource.classification == "Financial"
       input.time.hour >= 9
       input.time.hour <= 17
       input.device.managed == true
   }
   ```
3. Test policy engine:
   - Allow: Finance user, 2 PM, managed device → ✅
   - Deny: Finance user, 11 PM, personal device → ❌
   - Deny: Sales user, 2 PM, managed device → ❌
4. Integrate with application

**Common Mistakes:**
- Rego syntax errors → validate with `opa fmt`
- Missing attributes → ensure all attributes passed to policy
- Order of evaluation → AND logic vs OR logic matters

---

### Lab 8: Access Reviews & Recertification ⭐ Beginner
| Attribute | Details |
|-----------|----------|
| **Time Required** | 1-2 hours |
| **Difficulty** | Beginner |
| **Prerequisites** | Lab 1 complete, test users created |
| **Document** | `06a-access-reviews.md` |
| **Script** | `../examples/scripts/08-access-review.sh` |
| **What You'll Learn** | How to audit user access and remove stale/excessive permissions |
| **What You'll Build** | Automated access review: list all users' access → managers approve/deny → revoke denied access |
| **Expected Outcome** | Review complete, unauthorized access removed, audit trail created |
| **Cost** | $0 (free tier) |

**Lab Flow:**
1. Create access review campaign:
   - Scope: All users with cloud app access
   - Reviewers: Managers
   - Deadline: 5 days
2. Send review requests to managers
3. Manager reviews users' access:
   - Approve: "Yes, this user needs Salesforce"
   - Deny: "No, this contractor no longer needs GitHub"
4. After deadline, auto-revoke denied access
5. Generate audit report

**Common Mistakes:**
- Reviewers don't respond → enable escalation to backup
- Revoking access breaks app → verify no hard dependencies
- Audit trail not preserved → ensure all decisions logged

---

### Lab 9: Incident Response Playbook ⭐ Advanced
| Attribute | Details |
|-----------|----------|
| **Time Required** | 4-5 hours (can be simulation) |
| **Difficulty** | Advanced |
| **Prerequisites** | Labs 1-2 complete, understanding of security incidents |
| **Document** | `17c-incident-response.md` |
| **Script** | `../examples/scripts/09-incident-simulation.sh` |
| **What You'll Learn** | How to detect, respond to, and investigate identity security incidents |
| **What You'll Build** | Incident response playbook for account compromise |
| **Expected Outcome** | Compromised account disabled, attack contained, forensics collected, incident report generated |
| **Cost** | $0 (free tier) |

**Lab Flow:**
1. Simulate account compromise:
   - User account logs in from impossible location (Tokyo, 3 AM)
   - Multiple failed MFA attempts
   - Unusual file access pattern
2. Alert system detects anomalies → triggers incident
3. Incident commander follows playbook:
   - **Phase 1 (Detect):** Alert received, triaged as HIGH severity
   - **Phase 2 (Contain):** Account disabled, all sessions terminated, tokens revoked
   - **Phase 3 (Investigate):** Collect logs, determine entry point (phishing email)
   - **Phase 4 (Eradicate):** Remove attacker persistence, reset password
   - **Phase 5 (Recover):** Re-enable account, user resets password, send communications
4. Generate incident report with metrics:
   - MTTD (Mean Time To Detect): 8 minutes
   - MTTR (Mean Time To Respond): 12 minutes
   - Containment time: 5 minutes

**Common Mistakes:**
- Panic mode → follow playbook, don't improvise
- Destroying evidence → preserve logs before taking action
- Not communicating → notify users/leadership
- Incomplete eradication → attacker persists

---

### Lab 10: Workload Identity (Kubernetes) ⭐ Intermediate
| Attribute | Details |
|-----------|----------|
| **Time Required** | 3-4 hours |
| **Difficulty** | Intermediate |
| **Prerequisites** | Kubernetes cluster (can use AKS free tier or local minikube), kubectl access |
| **Document** | `14b-container-workload-identity.md` |
| **Script** | `../examples/scripts/10-workload-identity-k8s.sh` |
| **What You'll Learn** | How containers/pods get identity to access cloud resources (instead of storing credentials) |
| **What You'll Build** | Pod in Kubernetes → uses workload identity → accesses Azure Key Vault without hardcoded secrets |
| **Expected Outcome** | Kubernetes pod retrieves database password from Key Vault using identity (no secret files) |
| **Cost** | $0-5 (AKS free tier + Key Vault) |

**Lab Flow:**
1. Create Kubernetes cluster (AKS)
2. Create workload identity:
   ```bash
   # Create service account in K8s
   kubectl create serviceaccount app-identity
   
   # Link to Azure AD app
   az aks pod-identity add --identity-name app-workload
   ```
3. Create pod that uses workload identity:
   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: app-pod
   spec:
     serviceAccountName: app-identity
     containers:
     - name: app
       image: myapp:latest
   ```
4. Pod automatically gets token from Azure AD
5. Pod uses token to access Key Vault:
   ```bash
   # Inside pod, no credentials needed
   az keyvault secret show --vault-name mykeyvault --name database-password
   ```

**Common Mistakes:**
- Service account not linked → pod can't get token
- RBAC permissions missing → pod can't access vault
- Token expired → system automatically refreshes

---

### Lab 11: Multi-Cloud Federation ⭐ Advanced
| Attribute | Details |
|-----------|----------|
| **Time Required** | 4-5 hours |
| **Difficulty** | Advanced |
| **Prerequisites** | Azure subscription + AWS account, understanding of SAML/OAuth |
| **Document** | `11-multi-cloud-identity.md` |
| **Script** | `../examples/scripts/11-multi-cloud-federation.sh` |
| **What You'll Learn** | How to federate identity across cloud providers (Azure ↔ AWS) |
| **What You'll Build** | Single sign-on spanning Azure AD and AWS; user signs in once, can access both clouds |
| **Expected Outcome** | Azure user can sign in to AWS console without separate AWS password |
| **Cost** | $0 (free tier) + ~$5-10/month for minimal resources |

**Lab Flow:**
1. Create SAML trust between Azure AD and AWS
2. In Azure AD:
   - Register AWS as enterprise application
   - Configure SAML assertion
   - Map attributes (email → AWS account)
3. In AWS:
   - Create IAM role trusting Azure AD SAML issuer
   - Set up SSO
4. Test federation:
   - User signs in to Azure AD
   - Azure redirects to AWS
   - User gains AWS console access
   - No separate AWS login needed

**Common Mistakes:**
- SAML metadata URL wrong → federation won't trust issuer
- Attribute mapping mismatch → AWS can't find user role
- Time sync issues → clock skew breaks SAML validation

---

### Lab 12: Identity Governance Platform ⭐ Intermediate
| Attribute | Details |
|-----------|----------|
| **Time Required** | 2-3 hours |
| **Difficulty** | Intermediate |
| **Prerequisites** | Labs 1, 8 complete, test users with varied access |
| **Document** | `17a-identity-governance-administration.md` |
| **Script** | `../examples/scripts/12-iga-platform.sh` |
| **What You'll Learn** | How IGA platforms (SailPoint, Okta, ServiceNow) manage access lifecycle at scale |
| **What You'll Build** | IGA dashboard showing: users, their access, risk scores, compliance status |
| **Expected Outcome** | See complete access inventory, identify excessive access, run access reviews |
| **Cost** | $0 (free tier/trial of open-source alternative) |

**Lab Flow:**
1. Deploy open-source IGA alternative (Keycloak + custom dashboard)
2. Import users and their access from AD
3. Dashboard shows:
   - All users and their group memberships
   - All applications and who has access
   - Risk score for each user
   - Excessive access (users with more access than their role requires)
4. Run access review:
   - Select 10 random users
   - Send review to managers
   - Collect approvals/denials
   - Revoke denied access

**Common Mistakes:**
- Data import incomplete → verify all users/apps synced
- Risk scoring not accurate → tune algorithm for your environment
- Review notification lost → enable email escalation

---

### Lab 13: Segregation of Duties (SoD) ⭐ Intermediate
| Attribute | Details |
|-----------|----------|
| **Time Required** | 2-3 hours |
| **Difficulty** | Intermediate |
| **Prerequisites** | Understanding of SoD principle (incompatible duties) |
| **Document** | `13b-segregation-of-duties.md` |
| **Script** | `../examples/scripts/13-sod-detection.sh` |
| **What You'll Learn** | How to prevent conflicts of interest (e.g., someone who can approve expenses and also spend money) |
| **What You'll Build** | Policy engine that detects SoD violations and prevents them |
| **Expected Outcome** | System blocks attempts to grant conflicting roles |
| **Cost** | $0 (free tier) |

**Lab Flow:**
1. Define SoD conflict matrix:
   - Finance example: "Cannot have both 'Approve Invoice' AND 'Submit Expense Claim'"
   - IT example: "Cannot have both 'Create AD User' AND 'Delete AD User' AND 'Reset Password'"
2. Create test users with conflicting roles:
   - User 1: Try to grant "Approver" + "Requestor" → system blocks ❌
   - User 2: Grant "Create" + "Read" → system allows ✅
3. Run SoD audit:
   - Scan all users for conflicts
   - Find 2-3 violations
   - Generate exception request
   - Approve with business justification
4. Validate: Violations reported to compliance

**Common Mistakes:**
- SoD rules too strict → blocks legitimate access
- Rules not enforced → violations exist but not prevented
- Exceptions not tracked → compliance audit fails

---

### Lab 14: Risk Scoring Algorithm ⭐ Advanced
| Attribute | Details |
|-----------|----------|
| **Time Required** | 3-4 hours |
| **Difficulty** | Advanced |
| **Prerequisites** | Understanding of ML/statistics (optional but helpful) |
| **Document** | `17d-risk-scoring-algorithm.md` |
| **Script** | `../examples/scripts/14-risk-scoring.sh` |
| **What You'll Learn** | How to build a risk scoring model (predict which sign-ins are suspicious) |
| **What You'll Build** | ML model that scores sign-in risk (0-100) based on location, device, time, user behavior |
| **Expected Outcome** | Model correctly classifies 90%+ of sign-ins as low/medium/high risk |
| **Cost** | $0 (free tier) |

**Lab Flow:**
1. Collect training data:
   - 1,000 historical sign-in events
   - Label each: legitimate or suspicious
2. Feature engineering:
   - Location: distance from known locations
   - Device: is it recognized?
   - Time: business hours or 3 AM?
   - User: is this user's pattern changing?
3. Train ML model (Random Forest):
   ```python
   from sklearn.ensemble import RandomForestClassifier
   model = RandomForestClassifier()
   model.fit(X_train, y_train)
   ```
4. Evaluate model:
   - True positive rate: 92% (catch most attacks)
   - False positive rate: 3% (minimal disruption)
5. Deploy and test:
   - New sign-in → model scores it → policy enforces

**Common Mistakes:**
- Overfitting → model memorizes training data, fails on new data
- Imbalanced training data → 99% legitimate, 1% attack (skew model)
- Not retraining → model degrades over time as patterns change

---

### Lab 15: Complete Enterprise Scenario ⭐ Advanced
| Attribute | Details |
|-----------|----------|
| **Time Required** | 8+ hours (full certification challenge) |
| **Difficulty** | Advanced |
| **Prerequisites** | Labs 1-14 complete or strong familiarity with all topics |
| **Document** | `HANDS_ON_LAB_SCENARIOS.md` → Scenario 8 (Enterprise Security Assessment) |
| **Script** | `../examples/scripts/15-enterprise-scenario.sh` |
| **What You'll Learn** | How to design a complete enterprise identity system from scratch |
| **What You'll Build** | End-to-end: user provisioning → authentication → authorization → governance → incident response |
| **Expected Outcome** | Production-ready identity system design and partial implementation |
| **Cost** | $0-50 (depends on resources) |

**Lab Flow:**
1. Business scenario:
   - Fictitious company: TechCorp (1,000 employees, 3 locations, 2 cloud providers)
   - Current state: Manual provisioning, no MFA, no governance
   - Goal: Become "Advanced" maturity (Level 4)
2. Design architecture:
   - Hybrid identity (on-prem AD + Azure AD sync)
   - Multi-cloud (AWS + Azure federation)
   - Workload identity (Kubernetes)
   - Risk-based conditional access
   - IGA platform with access reviews
   - Incident response procedures
3. Implement pilot:
   - Deploy hybrid sync
   - Enable MFA for executives
   - Set up access reviews
   - Configure incident alerts
4. Measure results:
   - Provisioning time: 3 days → <2 hours ✅
   - MFA adoption: 0% → 100% (execs) ✅
   - Access reviews: Ad-hoc → quarterly ✅
   - Incidents detected: None → 3 per quarter ✅

**Common Mistakes:**
- Overscoping → try to do everything at once (phase it!)
- Ignoring user experience → policies too strict, users complain
- No rollback plan → implementation breaks production (test first!)

---

## Lab Scheduling Recommendations

### Option 1: Fast Track (4 weeks, 2-3 hours/week)
- Week 1: Labs 1, 2 (provisioning + MFA)
- Week 2: Lab 5 (hybrid identity)
- Week 3: Labs 6, 8 (conditional access + access reviews)
- Week 4: Lab 12 (IGA platform)
- **Total:** 10-12 hours, covers core topics

### Option 2: Comprehensive (12 weeks, 3-5 hours/week)
- Weeks 1-2: Labs 1-4 (provisioning, MFA, passwordless)
- Weeks 3-4: Lab 5-6 (hybrid, conditional access)
- Weeks 5-6: Labs 7-8 (authorization, access reviews)
- Weeks 7-8: Labs 9-10 (incident response, workload identity)
- Weeks 9-10: Labs 11-12 (multi-cloud, IGA)
- Weeks 11-12: Labs 13-15 (SoD, risk scoring, enterprise scenario)
- **Total:** 40-50 hours, comprehensive coverage

### Option 3: Self-Paced (Your schedule)
- Start with QUICKSTART_LABS.md (Labs 1-3, 24 hours)
- Follow learning paths at your own pace
- Deep-dive into topics that interest you

---

## Success Metrics

After completing labs, you should be able to:

| Skill | Validation |
|-------|------------|
| **Explain user provisioning** | Can describe joiner → mover → leaver workflow |
| **Implement MFA** | Can enable MFA policy and enroll users |
| **Design hybrid identity** | Can explain on-prem sync + cloud authentication |
| **Secure access** | Can write conditional access policies |
| **Audit access** | Can run access review and remove stale permissions |
| **Detect incidents** | Can identify suspicious sign-in and respond |
| **Architect system** | Can design enterprise identity system |

---

## Lab Support

**Issues during lab?**
1. Check lab-specific "Common Mistakes" section above
2. Review document that lab is based on (listed in each lab)
3. Check SANDBOX_SETUP.md for environment issues
4. Check `../examples/scripts/` for script comments/documentation

**Want to contribute?**
- Found a lab bug? Submit issue
- Have a lab idea? We welcome suggestions

---

**Ready to start?** Begin with `QUICKSTART_LABS.md` and Lab 1. Good luck!
