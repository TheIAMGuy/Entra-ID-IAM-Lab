---
title: Risk Scoring Algorithm - Advanced Identity Risk Analytics
part: 8
section: Compliance & Audit
difficulty: Advanced
estimated_reading_time: 30
estimated_lab_time: N/A
prerequisites:
  - 08-identity-risk-detection.md
  - 17a-identity-governance-administration.md
  - 16-data-quality-management.md
learning_objectives:
  - Understand risk scoring concepts and algorithms
  - Implement user risk and sign-in risk scoring
  - Apply risk scoring to access control decisions
  - Integrate risk scoring with governance
  - Monitor and tune risk models
---

# Risk Scoring Algorithm: Advanced Identity Risk Analytics

## Introduction

Risk scoring quantifies threat likelihood as a numeric score (0-100 or 0-5 scale). Instead of binary "allowed/blocked," risk scoring enables nuanced decisions: "This sign-in is 35% risky (low), allow but require MFA. That sign-in is 85% risky (high), block and re-authenticate." Risk models combine signals: location anomalies, device risk, user behavior, network risk, time of day, historical patterns. This document explains risk scoring concepts, algorithms, and implementation.

**Learning Objectives:**
- Design risk scoring model
- Implement user risk and sign-in risk algorithms
- Apply risk scores to policy decisions
- Integrate with IGA and governance
- Monitor model performance and adjust

## Risk Scoring Fundamentals

### Risk Score Components

**Three scoring approaches:**

```
Approach 1: Signal-Based Scoring
  Input: Individual signals (location, device, time)
  Output: Numeric score (0-100)
  Calculation: Weighted sum of signals
  Example: 20 (location signal) + 15 (device signal) + 5 (time signal) = 40 total
  
Approach 2: Machine Learning Scoring
  Input: Historical patterns, user baseline, anomaly detection
  Output: Probability score (0-1.0 or 0-100%)
  Training: ML model trained on historical data
  Example: ML model outputs 65% probability of compromise based on patterns
  
Approach 3: Behavioral Analytics Scoring
  Input: User baseline, deviations from baseline
  Output: Anomaly score (0-100)
  Baseline: Historical user behavior (locations, times, apps, data access)
  Example: User never accesses database, now accessing database = +40 anomaly score
```

### Score Interpretation

**What does each score mean?**

```
Score Range: 0-100 (or 0-5 scale)

0-20 (Low Risk):
  ✓ Expected behavior pattern
  ✓ Normal location, normal time, expected device
  ✓ Trusted network
  ✓ Action: Allow, no MFA challenge

21-40 (Low-Medium Risk):
  ⚠ Slightly unusual but explainable
  ⚠ New location but plausible (business travel)
  ⚠ Normal device, normal time
  ⚠ Action: Allow, but prompt for MFA

41-60 (Medium Risk):
  ⚠⚠ Notable anomalies
  ⚠⚠ Unusual location, unexpected device, off-hours
  ⚠⚠ User hasn't seen this pattern before
  ⚠⚠ Action: Allow, require strong MFA (FIDO2)

61-80 (High Risk):
  ❌ Significant anomalies, likely unauthorized
  ❌ Impossible travel, risky device, multiple signals
  ❌ Pattern inconsistent with user behavior
  ❌ Action: Block and challenge user to verify identity

81-100 (Critical Risk):
  ❌❌ Very strong indicators of compromise or attack
  ❌❌ Multiple high-confidence signals
  ❌❌ Clear attack pattern (brute force, impossible travel)
  ❌❌ Action: Block immediately, initiate incident response
```

## User Risk Scoring

### User Risk Model

**Persistent risk indicators for a user:**

```
User risk captures: "Is this user's account likely compromised?"

Signals contributing to user risk:

1. Leaked Credentials
   - User's password found in breach database
   - Severity: Very high
   - Weight: 35 points
   - Action: Require password reset, MFA

2. Suspicious Sign-In Activity
   - Multiple failed sign-ins from suspicious locations
   - Multiple sign-ins with impossible travel pattern
   - Severity: High
   - Weight: 25 points
   - Action: Block, investigate account

3. Risk Event Alerts
   - Multiple sign-in risk alerts (5+ in 24 hours)
   - Admin actions from unusual location
   - Severity: High
   - Weight: 20 points
   - Action: Require re-authentication, escalate

4. Unusual Admin Activity
   - Admin role newly granted
   - Config changes from unusual location
   - Severity: Medium
   - Weight: 15 points
   - Action: Investigate, may revoke if unauthorized

5. Inactivity Then Activity (post-compromise pattern)
   - No sign-in for 30 days
   - Suddenly sign-in from new location
   - Access to sensitive resources
   - Severity: Medium
   - Weight: 10 points
   - Action: Contact user to verify

User Risk Score Calculation:
  = 35 (leaked creds) + 25 (suspicious signin) + 20 (risk alerts)
  = 80 / 100 (High risk)
  Action: User blocked until issues resolved
```

### User Risk Remediation

**How to reduce user risk score:**

```
Leaked credentials:
  - User resets password
  - User enables MFA
  - Score reduces to 20 (resolved)

Suspicious activity:
  - Investigate and verify (was user traveling?)
  - If confirmed legitimate: Reduce score
  - If confirmed malicious: Block account, incident response

Admin role granted:
  - Verify with manager (was this authorized?)
  - If yes: Reduce score
  - If no: Remove role, investigate

Inactivity then activity:
  - Contact user directly
  - Verify activity was user
  - If yes: Reduce score
  - If no: Initiate incident response
```

## Sign-In Risk Scoring

### Sign-In Risk Model

**Real-time risk assessment of a specific sign-in:**

```
Sign-in risk captures: "Is THIS sign-in attempt legitimate?"

Signals analyzed at sign-in time:

1. Location Anomaly (0-40 points)
   - Normal location: 0 points
   - Slightly unusual (different city, same country): 5 points
   - Very unusual (different country): 15 points
   - Impossible travel (can't physically reach location): 40 points

2. Device Risk (0-25 points)
   - Managed device (corporate laptop): 0 points
   - Unknown device (first time seen): 10 points
   - Unmanaged device (personal computer): 5 points
   - Risky device (malware detected): 25 points
   - Compromised device (listed in threat intelligence): 25 points

3. User Risk (0-20 points)
   - Normal user risk: 0 points
   - Medium user risk (leaked password): 10 points
   - High user risk (suspicious activity): 20 points

4. Network Anomaly (0-15 points)
   - Trusted corporate network: 0 points
   - Public WiFi: 5 points
   - Botnet/proxy IP: 15 points
   - Geolocation mismatch (IP says Russia, device says NYC): 10 points

5. Time-Based Anomaly (0-10 points)
   - Business hours, business day: 0 points
   - After hours: 3 points
   - Weekend: 5 points
   - 3 AM on Sunday: 10 points
   - (Customized per user's typical usage pattern)

6. Authentication Method (0-10 points)
   - Password + FIDO2 (phishing-resistant): 0 points
   - Password + TOTP (time-based code): 2 points
   - Password + SMS: 5 points
   - Password only: 10 points

7. Multi-Factor Required Anomaly (0-10 points)
   - User normally uses MFA, has MFA enabled: 0 points
   - User normally uses MFA, MFA not available: 10 points (suggests attack)

Sign-In Risk Score Example:
  Location anomaly (different country): 15 points
  + Device risk (unknown device): 10 points
  + Network anomaly (public WiFi): 5 points
  + Time-based anomaly (3 AM): 10 points
  + Authentication (password + SMS): 5 points
  = 45 points (Medium risk)
  
  Action: Require stronger MFA (FIDO2), allow sign-in
```

### Risk-Based Conditional Access

**How to use risk scores in Conditional Access policies:**

```
Policy 1: Low-Risk Baseline
Conditions:
  - User risk: Low
  - Sign-in risk: Low
  - Device: Any
Grant: Allow
Effect: User signs in without MFA challenge

Policy 2: Elevated Sign-In Risk
Conditions:
  - Sign-in risk: Medium
  - Device: Any
Grant: Require MFA
Effect: User must complete MFA to proceed

Policy 3: High Risk Requires Strong MFA
Conditions:
  - Sign-in risk: High (>60)
Grant: Require FIDO2 + Conditional Access re-auth
Effect: User must use hardware key + answer security questions

Policy 4: Critical Risk - Block
Conditions:
  - Sign-in risk: Critical (>85)
  - User risk: High
Grant: Block access
Effect: User cannot sign in until verified by admin
Message: "Sign-in blocked due to security concern. Contact help desk."

Policy 5: Impossible Travel - Block
Conditions:
  - Impossible travel detected
  - Location anomaly: 40 points
Grant: Block + require re-authentication
Effect: User must re-authenticate and verify identity
```

## Risk Scoring Algorithms

### Algorithm 1: Weighted Signal Scoring (Simple)

**Weighted sum of individual signals:**

```
Algorithm:
  risk_score = sum(signal_weight * signal_value) / total_weight
  
Example: Sign-in risk
  location_risk = 15 (location weight = 4)
  device_risk = 10 (device weight = 2.5)
  network_risk = 5 (network weight = 1.5)
  total_weight = 4 + 2.5 + 1.5 = 8
  
  risk_score = (15*4 + 10*2.5 + 5*1.5) / 8
             = (60 + 25 + 7.5) / 8
             = 92.5 / 8
             = 11.6 (normalized to 0-100)

Advantages:
  ✓ Simple, interpretable
  ✓ Fast computation
  ✓ Easy to adjust weights
  
Disadvantages:
  ✗ Doesn't capture signal interactions
  ✗ Linear assumption (may miss complex patterns)
```

### Algorithm 2: Machine Learning Scoring

**ML model trained on historical data:**

```
Training Data:
  Historical sign-ins labeled as:
    - Legitimate (label = 0)
    - Compromised (label = 1)
  
  Features:
    - Location, device, network, time, user risk, auth method
    - Plus derived features (time since last sign-in, location frequency, etc.)

Model:
  Input: Sign-in features
  Algorithm: Random Forest or Gradient Boosting
  Output: Probability of compromise (0-1.0 or 0-100%)
  
Example:
  Input: Location=Tokyo, Device=Unknown, Time=3AM, Network=WiFi
  Model output: 0.72 probability (72% risk) = HIGH RISK
  
Advantages:
  ✓ Captures complex interactions
  ✓ Learns from historical patterns
  ✓ Adapts as new data arrives
  ✓ More accurate than linear models
  
Disadvantages:
  ✗ Requires training data (historical incidents)
  ✗ "Black box" (hard to explain why score is high)
  ✗ Requires ongoing model maintenance and updates
```

### Algorithm 3: Behavioral Baseline Scoring

**Compare current behavior to user's historical baseline:**

```
Baseline Calculation (build on first 30 days of user data):
  User John Smith baseline:
    - Typical locations: New York (95%), San Francisco (5%)
    - Typical times: 8 AM - 6 PM, Monday-Friday
    - Typical devices: Laptop (corporate)
    - Typical apps: Outlook, Teams, SharePoint, Salesforce
    - Never accesses: Database, financial systems, HR records

Current Sign-In Assessment:
  Sign-in event: Tokyo at 3 AM on Sunday
  
  Deviations from baseline:
    - Location: Tokyo ≠ New York/San Francisco → Anomaly score: 30
    - Time: 3 AM ≠ 8 AM - 6 PM → Anomaly score: 20
    - Day: Sunday ≠ Monday-Friday → Anomaly score: 10
    - Device: Mobile ≠ Laptop → Anomaly score: 10
    
  Total anomaly score: 30 + 20 + 10 + 10 = 70 (HIGH)
  
  But: Device=Mobile, accessing Teams (normal app)
  Explanation: User likely traveling (legitimate business trip)
  Risk reduction: -10 points = 60 (MEDIUM)
  
  Final decision: Allow with MFA requirement

Advantages:
  ✓ Personalized (each user has own baseline)
  ✓ Detects deviation from personal norms
  ✓ Good for insider threat detection
  
Disadvantages:
  ✗ Requires 30+ days baseline data (new users have no baseline)
  ✗ Must account for seasonal patterns (summer vacation)
```

## Risk Score Monitoring and Tuning

### Monitoring Metrics

**Track model performance:**

```
Metric 1: True Positive Rate (TPR)
  Definition: % of actual attacks detected
  Target: >90% (catch most attacks)
  Calculation: Detected attacks / Total attacks = TPR
  
Metric 2: False Positive Rate (FPR)
  Definition: % of legitimate sign-ins flagged as risky
  Target: <5% (minimize disruption)
  Calculation: Legitimate sign-ins flagged / Total legitimate = FPR
  
Metric 3: Precision
  Definition: % of flagged sign-ins that are actually attacks
  Target: >80% (most alerts are real)
  Calculation: Actual attacks flagged / Total flagged = Precision
  
Metric 4: Recall (same as TPR)
  Definition: % of all attacks detected
  Target: >90%

Model Performance Example:
  100 sign-ins analyzed:
    - 2 actual attacks (ground truth)
    - 3 flagged as risky
  
  Metrics:
    - True Positives (correctly flagged): 2
    - False Positives (incorrectly flagged): 1
    - True Negatives (correctly allowed): 97
    - False Negatives (missed attacks): 0
    
    TPR = 2/2 = 100% ✓ (caught both attacks)
    FPR = 1/97 = 1.0% ✓ (minimal false positives)
    Precision = 2/3 = 67% ⚠ (1 of 3 flags was false alarm)
```

### Model Tuning

**Adjust thresholds and weights to improve performance:**

```
Tuning Goal: Maximize TPR while minimizing FPR

Scenario: Model FPR is 20% (too many legitimate users blocked)

Action 1: Lower risk thresholds
  Before: Sign-in risk > 60 → Block
  After: Sign-in risk > 70 → Block
  Effect: Fewer legitimate users blocked, but more attacks pass through
  
Action 2: Add context-aware exceptions
  Before: Any device anomaly adds 25 points
  After: Device anomaly adds 25 points, BUT
         If device is in trusted device list: reduce 10 points
  Effect: Known devices less likely to trigger block
  
Action 3: Adjust signal weights
  Before: Location weight = 4, Time weight = 1
  After: Location weight = 3, Time weight = 0.5 (reduce time sensitivity)
  Effect: Time-of-day anomalies less impactful

Action 4: Train new ML model
  Before: Model trained on 6 months of data (Q1-Q2)
  After: Retrain on 12 months (Q1-Q4) including seasonal patterns
  Effect: Model learns summer travel patterns, fewer false positives in June-Aug

Post-tuning metrics:
  TPR: 90% → 88% (small tradeoff)
  FPR: 20% → 5% ✓ (major improvement)
  Precision: 50% → 85% ✓
```

## Best Practices

1. **Baseline First** - Establish user baselines before flagging deviations
2. **Context Matters** - Integrate user context (calendar, location, role)
3. **Transparency** - Explain why a sign-in is risky to user
4. **Continuous Learning** - Update models monthly with new data
5. **False Positive Tolerance** - Accept some false positives to catch attacks
6. **Tuning Cadence** - Review thresholds monthly, retrain models quarterly
7. **Feedback Loop** - Use incident outcomes to improve model
8. **Test Changes** - Canary new thresholds on subset before rollout
9. **Monitoring** - Track TPR, FPR, precision in production
10. **Integration** - Feed risk scores to policy engine for real-time decisions

## Related Documents

**Prerequisites:**
- [Risk Detection](./08-identity-risk-detection.md) - Risk concepts
- [IGA Platforms](./17a-identity-governance-administration.md) - Risk in governance

**Next Steps:**
- [Incident Response](./17c-incident-response.md) - Handling high-risk incidents
- [Reporting](./19-identity-reporting-analytics.md) - Risk dashboards

## FAQ

**Q: What's the difference between user risk and sign-in risk?**

A: User risk = persistent (account likely compromised), Sign-in risk = transient (this login suspicious).

**Q: Should we block all high-risk sign-ins?**

A: No. Require strong MFA instead. Block only if multiple signals align.

**Q: How often should we retrain models?**

A: Monthly review of metrics, quarterly model retraining, daily threshold adjustments.

## Next Steps

1. Design risk model (weighted signals vs. ML)
2. Implement risk scoring in identity platform
3. Set up monitoring dashboards
4. Establish tuning cadence
5. Test risk-based conditional access policies
6. Measure and optimize TPR/FPR

Risk scoring enables dynamic, threat-informed access control.
