---
title: Identity Intelligence - IVIP and Behavioral Analytics
part: 9
section: Operations & Administration
difficulty: Advanced
estimated_reading_time: 30
estimated_lab_time: N/A
prerequisites:
  - 08-identity-risk-detection.md
  - 17a-identity-governance-administration.md
  - 19-identity-reporting-analytics.md
learning_objectives:
  - Understand identity intelligence and IVIP concepts
  - Implement behavioral analytics and anomaly detection
  - Use UEBA for threat detection
  - Apply intelligence to governance and compliance
  - Monitor identity risk continuously
---

# Identity Intelligence: IVIP and Behavioral Analytics

## Introduction

Identity Intelligence and Identity Verification Intelligence Platform (IVIP) apply machine learning and behavioral analytics to detect identity threats. Instead of rules-based detection ("blocked 5 failed logins"), IVIP learns user baselines (location, apps, times, data access patterns) and detects deviations (anomalies). A user normally works in New York 9-5 accessing Salesforce. Suddenly accessing database from Tokyo at 3 AM is anomalous. IVIP flags this as potential compromise. This document explains identity intelligence concepts, behavioral analytics, UEBA, and implementation.

**Learning Objectives:**
- Understand behavioral analytics concepts
- Implement user and entity behavior analytics (UEBA)
- Build identity baselines
- Detect anomalies in real-time
- Use intelligence for governance and risk reduction

## Identity Intelligence Concepts

### IVIP (Identity Verification Intelligence Platform)

**Gartner category:**

```
Definition: Platform combining identity analytics, anomaly detection,
           threat intelligence, and intelligence-driven access control

Components:
  1. Behavioral Analytics
     - User baseline models
     - Activity anomaly detection
     - Deviation scoring
  
  2. Risk Scoring
     - User risk (account compromise probability)
     - Sign-in risk (login attempt legitimacy)
     - Entity risk (app, database, service risk)
  
  3. Threat Intelligence
     - Breach databases (credentials in dark web)
     - Known attack patterns
     - Malware/ransomware indicators
  
  4. Intelligence-Driven Controls
     - Risk-based conditional access
     - Adaptive authentication
     - Automated remediation

Providers:
  - Microsoft Entra ID (Azure AD) + Microsoft Defender
  - Okta Adaptive MFA
  - Ping Identity Risk Engine
  - CyberArk IVIP
  - Deloitte/EY UEBA platforms
```

### UEBA (User and Entity Behavior Analytics)

**Machine learning approach to threat detection:**

```
Traditional Detection (Rules-based):
  "If 5 failed logins in 10 minutes → Block"
  Limitations: Rules are static, attackers adapt, many false positives

UEBA (ML-based):
  "Learn each user's baseline. Flag significant deviations as anomalous"
  Advantages: Dynamic, personalized, learns patterns, detects novel attacks

UEBA Pipeline:
  1. Data Collection
     - Collect activities from all systems (sign-ins, file access, API calls)
     - Normalize data across sources
     - Timestamp and attribute all events
  
  2. User Profiling
     - Build baseline model for each user
     - Typical locations, times, apps, data accessed
     - Role-based patterns (manager accesses different data than IC)
  
  3. Behavior Analysis
     - Real-time activity scoring against baseline
     - Anomaly detection (statistical deviation)
     - Insider threat indicators (unusual data access)
  
  4. Risk Scoring
     - Combine multiple anomaly signals
     - Calculate overall risk score
     - Feed to policy engine for decisions
  
  5. Intelligence Output
     - Alerts for security team
     - Risk scores for Conditional Access
     - Intelligence for investigations
```

## Building Identity Baselines

### Baseline Components

**What defines a user's normal behavior:**

```
Location Baseline:
  John Smith typical locations:
    - Primary: New York (95% of activities)
    - Secondary: San Francisco (4% - quarterly travel)
    - Home: Boston area
    - Occasional: London (customer visits)
  
  Baseline = [NYC primary, SF secondary, rare international]
  Anomaly = Tokyo (never visited before) → Flag

Time Baseline:
  John's typical activity times:
    - 8 AM - 6 PM: Work hours
    - Monday - Friday: Workdays
    - Minimal activity: Weekends, nights
  
  Baseline = [9-to-5, Monday-Friday]
  Anomaly = 3 AM on Sunday → Flag

Device Baseline:
  John's typical devices:
    - Primary: Corporate laptop (Lenovo)
    - Secondary: iPhone (personal)
    - Rare: Desktop at home
    - Never: Linux machines
  
  Baseline = [Windows laptop, iPhone, rare desktop]
  Anomaly = Linux machine sign-in → Flag

App Baseline:
  John's typical applications:
    - Daily: Outlook, Teams, OneDrive, Salesforce
    - Weekly: SharePoint, Power BI
    - Monthly: ServiceNow, Jira
    - Never: Database tools, code repositories
  
  Baseline = [CRM/email/productivity apps]
  Anomaly = Accessing database, GitHub → Flag

Data Access Baseline:
  John's typical data access:
    - Reads: Customer files, sales reports
    - Writes: Salesforce records, email
    - Never: HR records, financial data, source code
  
  Baseline = [Sales data read/write]
  Anomaly = Access to HR database → Flag
```

### Baseline Calculation

**Algorithms for computing baselines:**

```
Algorithm 1: Frequency-based
  Count activities by attribute over 30-day window
  Most common 80% = baseline
  Less common 19% = normal variation
  Rare <1% = potential anomaly
  
  Example: Locations in last 30 days
    New York: 95 activities (80%)
    San Francisco: 4 activities (3%)
    Airplane (WiFi): 3 activities (2%)
    Tokyo: 0 activities (baseline doesn't include)
  
  Anomaly threshold: Activities outside top locations

Algorithm 2: Time-series forecasting
  Use statistical model (ARIMA, Prophet) to forecast
  expected activity for time T
  Compare actual vs. predicted
  High residual = anomalous
  
  Example: User typically sends 20 emails/hour at 9 AM
    Monday 9 AM: Expected = 20 emails
    Actual = 50 emails (unusual, flag for investigation)

Algorithm 3: Clustering
  Cluster users by role, department, location
  Use cluster centroid as baseline
  Flag users who deviate from cluster
  
  Example: Sales managers baseline
    Locations: Sales offices
    Apps: CRM, email
    Hours: 8 AM - 6 PM
  
  John (sales manager) accessing engineering tools at 2 AM
  → Deviates from cluster → Anomalous
```

## Behavioral Analytics Implementation

### Anomaly Detection in Real-Time

**Detect suspicious activity as it happens:**

```
System ingests login event:
  User: john.smith@company.com
  Time: 2024-01-15 03:45 UTC
  Location: Tokyo
  Device: Unknown mobile phone
  App: OneDrive
  Action: Download 500 files

Step 1: Check location anomaly
  Baseline locations: NYC (95%), SF (4%), Boston (1%)
  Current location: Tokyo
  Anomaly score: 30/40 (location very unusual)

Step 2: Check time anomaly
  Baseline times: 8 AM - 6 PM weekdays
  Current time: 3:45 AM on Sunday
  Anomaly score: 15/15 (completely off-baseline)

Step 3: Check device anomaly
  Baseline devices: Corporate laptop, iPhone
  Current device: Unknown mobile phone
  Anomaly score: 10/10 (not recognized)

Step 4: Check app anomaly
  Baseline apps: Salesforce, email, Teams
  Current app: OneDrive (known app but unusual context)
  Anomaly score: 5/20 (known app, but context unusual)

Step 5: Check data access anomaly
  Baseline data access: Customer records (read)
  Current action: Bulk download (500 files)
  Anomaly score: 30/30 (unusual volume, potential exfiltration)

Total anomaly score: 90/125 = 72% (HIGH RISK)

Decision:
  Risk level: HIGH
  Action: Block access and challenge user
  Message: "Unusual activity detected. Verify your identity."
  
Immediate Actions:
  ├─ Block OneDrive access
  ├─ Notify security team (alert)
  ├─ Send challenge to user (email + phone call)
  ├─ Log incident for investigation
  └─ Prepare incident response playbook
```

### Insider Threat Detection

**Detect employees exfiltrating data:**

```
Insider Threat Indicators:

Indicator 1: Bulk Data Access
  Normal: John reads 10-20 customer records/day
  Anomalous: John suddenly reads 1,000 records in 1 hour
  Why: Possible preparation for data theft
  Action: Flag, investigate
  
Indicator 2: Unusual Data Access
  Normal: John accesses Sales data
  Anomalous: John accesses HR salary data (outside his role)
  Why: Curiosity or preparation for leverage/extortion
  Action: Flag, notify manager
  
Indicator 3: Off-Hours Activity
  Normal: John works 9-5
  Anomalous: John accesses systems at 11 PM on weekend
  Why: Reduced monitoring, unauthorized access
  Action: Flag, investigate context
  
Indicator 4: Unusual Export/Download
  Normal: John creates weekly reports (10 MB)
  Anomalous: John downloads entire database (500 GB)
  Why: Data exfiltration
  Action: Block, investigate
  
Indicator 5: VPN/Network Location Change
  Normal: John connects from office/home
  Anomalous: John connects from 10 different public IPs in 1 week
  Why: Using VPN to mask true location, possible unauthorized access
  Action: Flag, investigate
  
Indicator 6: Failed Access Attempts
  Normal: Occasional failed login (typo)
  Anomalous: 100 failed attempts to database in 2 hours
  Why: Brute force attack or unauthorized access attempt
  Action: Block, investigate
  
Insider Threat Scoring:
  Multiple indicators = higher risk
  Recent departure date + data access = very high risk
  Disgruntled employee + bulk download = critical risk
```

## Identity Intelligence Use Cases

### Use Case 1: Risk-Based Access Control

**Apply IVIP intelligence to conditional access:**

```
Traditional Conditional Access:
  "If user is in executives group → Require MFA"
  
  Problem: Same policy for all executives
            Doesn't account for actual risk

Intelligence-Driven Conditional Access:
  "If user risk > 50 OR sign-in risk > 60 → Require strong MFA (FIDO2)"
  "If user risk > 80 OR sign-in risk > 80 → Block, require admin approval"
  
  Benefit: Dynamic, threat-responsive, personalized
```

### Use Case 2: Adaptive Authentication

**Adjust authentication requirements based on risk:**

```
Example: Accessing Salesforce

Scenario 1: Low-risk login
  User: John Smith, typical location (NYC), typical time (9 AM Monday)
  Device: Known laptop, healthy
  Network: Corporate network
  Risk score: 15/100 (LOW)
  Authentication: Password only (user experience optimized)

Scenario 2: Medium-risk login
  User: John Smith, traveling (London), business hours
  Device: Personal laptop (less secure)
  Network: Hotel WiFi
  Risk score: 45/100 (MEDIUM)
  Authentication: Password + TOTP (code from authenticator)

Scenario 3: High-risk login
  User: John Smith, unusual location (Tokyo), off-hours (3 AM)
  Device: Unknown mobile phone
  Network: VPN (masked IP)
  Risk score: 75/100 (HIGH)
  Authentication: Password + FIDO2 + security questions + manager approval

Scenario 4: Critical-risk login
  User: John Smith, impossible travel (NYC to Tokyo in 1 hour)
  Device: Compromised device
  Network: Known malware IP
  Risk score: 95/100 (CRITICAL)
  Authentication: BLOCKED - Require user to call help desk for identity verification
```

### Use Case 3: Governance and Recertification

**Use IVIP intelligence to prioritize access reviews:**

```
Traditional Access Review:
  "Review all users' access quarterly"
  Effort: Months for large organizations
  Coverage: Limited due to time constraints
  
Efficiency: Low (reviews everything, even low-risk)

Intelligence-Driven Access Review:
  "Risk-score all users based on actual access patterns"
  Priority 1 (Critical): Users with unusual access patterns + high data sensitivity
    - Example: User with database access they rarely use
    - Review frequency: Monthly
    - Effort: 30 min per user
  
  Priority 2 (High): Users with moderate anomalies + sensitive roles
    - Example: Manager with unusual hours + bulk downloads
    - Review frequency: Quarterly
    - Effort: 15 min per user
  
  Priority 3 (Medium): Users with minor anomalies or normal access
    - Example: Typical user with occasional unusual patterns
    - Review frequency: Annually
    - Effort: 5 min per user
  
  Efficiency: HIGH (focuses effort where risk is highest)
```

## Best Practices

1. **Baseline Maturity** - Allow 30-60 days for baseline before flagging anomalies
2. **False Positive Tuning** - Adjust thresholds to minimize legitimate user disruption
3. **Contextual Analysis** - Consider user role, calendar, travel schedule
4. **Continuous Learning** - Regularly update baselines with new data
5. **Explainability** - Show users why activity flagged as anomalous
6. **Integration** - Feed intelligence to policy engine, SIEM, security team
7. **Feedback Loop** - Use incident outcomes to improve models
8. **Privacy** - Analyze patterns, not content (GDPR compliant)
9. **Incident Response** - Have playbook ready for intelligence-driven alerts
10. **Executive Visibility** - Dashboard of top risks and remediation status

## Related Documents

**Prerequisites:**
- [Risk Detection](./08-identity-risk-detection.md) - Risk concepts
- [Risk Scoring](./17d-risk-scoring-algorithm.md) - Risk algorithms
- [Reporting](./19-identity-reporting-analytics.md) - Dashboards

**Next Steps:**
- [Incident Response](./17c-incident-response.md) - Acting on intelligence
- [IGA Platforms](./17a-identity-governance-administration.md) - Governance integration

## FAQ

**Q: How does IVIP handle legitimate travel?**

A: Check calendar (flight bookings, business justifications). If user has travel event, reduce anomaly score.

**Q: Can IVIP replace security analysts?**

A: No. IVIP alerts analysts to investigate. Analysts determine context and respond.

**Q: What data does IVIP need to be effective?**

A: Sign-in logs (required), app activity logs (recommended), file access (for insider threats), calendar (for context).

## Next Steps

1. Inventory data sources (sign-ins, app activity, file access)
2. Design user baseline model
3. Implement behavioral analytics platform
4. Tune anomaly detection thresholds
5. Integrate with conditional access policies
6. Train security team on intelligence interpretation
7. Establish incident response for high-risk alerts

Identity intelligence transforms static rules to dynamic, threat-responsive security.
