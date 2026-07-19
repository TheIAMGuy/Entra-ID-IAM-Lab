---
title: Enterprise Maturity Assessment - Identity Program Maturity Evaluation
part: 10
section: Enterprise Program & Strategy
difficulty: Advanced
estimated_reading_time: 30
estimated_lab_time: N/A
prerequisites:
  - 00b-enterprise-iam-maturity.md
  - 20-governance-structure.md
learning_objectives:
  - Assess current identity maturity across domains
  - Identify gaps against target maturity
  - Prioritize improvement initiatives
  - Track maturity progression over time
  - Align maturity with business needs
---

# Enterprise Maturity Assessment: Identity Program Maturity Evaluation

## Introduction

Maturity assessment measures where an organization is today on the identity journey (Level 1: Ad-hoc, Level 5: Intelligent) and where it needs to be. Without assessment: efforts are unfocused, investments scattered. With assessment: clear picture of gaps, targeted improvements, measured progress. This document explains maturity assessment framework, evaluation methodology, and roadmap to target maturity.

**Learning Objectives:**
- Conduct comprehensive maturity assessment
- Assess maturity across 17 identity domains
- Identify improvement priorities
- Track progress over time
- Align maturity investment with business strategy

## Maturity Model Framework

### Five Maturity Levels

```
Level 1: Ad-Hoc (Reactive)
  Characteristics:
    ✗ No documented processes (everything is manual)
    ✗ No automation (relying on manual steps)
    ✗ Reactive to incidents (no prevention)
    ✗ Siloed teams (no coordination)
    ✗ Minimal governance (if any)
  
  Example: "IT admin manually creates users, no process documentation"
  
  Identity impact:
    - Long onboarding (2-3 days)
    - High error rates (10-15% missing access)
    - Poor compliance posture
    - Reactive incident response

Level 2: Managed (Process-Focused)
  Characteristics:
    ✓ Documented processes (repeatable)
    ✓ Basic automation (some manual steps)
    ✓ Manual controls (reviews, audits)
    ✓ Team governance (basic policies)
    ✓ Annual reviews
  
  Example: "IT has documented provisioning steps, runs quarterly access reviews"
  
  Identity impact:
    - Consistent onboarding (2 days, repeatable)
    - Moderate quality (85-90% correct access)
    - Adequate compliance (meets minimum)
    - Documented incident process

Level 3: Optimized (Automated & Integrated)
  Characteristics:
    ✓ Automated workflows (end-to-end)
    ✓ Integrated systems (HR → AD → Apps)
    ✓ Proactive monitoring (alerts)
    ✓ IGA platform (access reviews, analytics)
    ✓ Continuous improvement
  
  Example: "HR creates hire → Automated provisioning → User can sign in in 1 hour"
  
  Identity impact:
    - Fast onboarding (1 hour)
    - High quality (95%+ correct)
    - Strong compliance (mapped to frameworks)
    - Proactive risk detection

Level 4: Advanced (Intelligence-Driven)
  Characteristics:
    ✓ Intelligence-driven decisions (ML, behavioral analytics)
    ✓ Real-time risk scoring
    ✓ Automated remediation
    ✓ Predictive capabilities
    ✓ Enterprise-wide governance
  
  Example: "Anomaly detection identifies account compromise, auto-disables account"
  
  Identity impact:
    - Immediate provisioning (minutes)
    - Excellent quality (99%+)
    - Advanced compliance (continuous monitoring)
    - Real-time incident response

Level 5: Intelligent (Predictive & Autonomous)
  Characteristics:
    ✓ Predictive models (forecast risks)
    ✓ Autonomous response (minimal human intervention)
    ✓ Self-healing (system auto-corrects issues)
    ✓ Continuous learning (model improvements)
    ✓ Organizational resilience
  
  Example: "System predicts account compromise before attack occurs"
  
  Identity impact:
    - Instant provisioning (seconds)
    - Perfect quality (99.9%+)
    - Predictive compliance (prevent violations)
    - Autonomous incident response
```

## Domain-Level Maturity Assessment

### 17 Identity Domains Maturity Matrix

```
| Domain | Level 1 | Level 2 | Level 3 | Level 4 | Level 5 |
|--------|---------|---------|---------|---------|---------|
| Provisioning | Manual, 3-day | Documented, 2-day | Automated, 1-hour | Instant, 0-error | Predictive |
| RBAC | Ad-hoc | Defined roles | Role hierarchy, SoD | Risk-based | Adaptive |
| PAM | Shared accounts | Documented, manual | Automated JIT | Risk-based JIT | Predictive |
| App Access | Ad-hoc | Documented, manual | SCIM sync | Intelligent provisioning | Predictive |
| Least Privilege | No review | Annual review | Quarterly review | Continuous monitoring | Predictive removal |
| MFA | None | SMS/TOTP | FIDO2, conditional | Risk-based strength | Behavioral MFA |
| Password-less | Not used | Pilot phase | 40% adoption | 80% adoption | 100% adoption |
| Adaptive Auth | No policies | Basic rules | Risk-based CA | ML-based risk | Predictive auth |
| Risk Detection | None | Manual alerts | Rule-based detection | ML anomalies | Predictive threat intel |
| Access Reviews | None | Annual | Quarterly | Continuous | Autonomous |
| IGA | Spreadsheets | Manual process | Platform-based | Advanced analytics | Autonomous governance |
| Audit Logging | Basic logs | Centralized logs | Correlated events | Alert-based | Behavioral baselines |
| Zero Trust | None | Perimeter focus | Least privilege | Assume breach | Autonomous trust |
| Workload Identity | Secrets | Service principals | Managed identity | SPIFFE/federation | Autonomous cert mgmt |
| Compliance | Manual mapping | Documented | GRC integrated | Continuous monitoring | Predictive compliance |
| Data Quality | Inconsistent | Standardized | Validated | Monitored | Self-healing |
| Intelligence | None | Basic reports | Analytics, dashboards | UEBA, IVIP | Predictive models |
```

## Assessment Methodology

### Scoring Framework

```
For each domain, rate 1-5 across these dimensions:

Dimension 1: Process Maturity
  1 = Ad-hoc, undocumented
  2 = Documented, manual
  3 = Documented, some automation
  4 = Mostly automated, monitored
  5 = Fully automated, intelligent

Dimension 2: Technology Support
  1 = Manual tools only
  2 = Single system
  3 = Integrated systems
  4 = Advanced platform
  5 = AI/ML-enabled platform

Dimension 3: Governance & Controls
  1 = No formal governance
  2 = Basic policies
  3 = Defined policies, enforcement
  4 = Continuous monitoring
  5 = Predictive controls

Dimension 4: Metrics & Visibility
  1 = No metrics
  2 = Manual reporting
  3 = Dashboards
  4 = Automated alerts
  5 = Predictive analytics

Overall Domain Maturity = Average of four dimensions

Example: RBAC Assessment
  Process maturity: 2 (documented but manual)
  Technology: 2 (Azure AD configured)
  Governance: 2 (basic policy, no enforcement)
  Metrics: 1 (no reporting)
  
  Overall RBAC maturity: (2+2+2+1)/4 = 1.75 ≈ Level 2 (Managed)
```

### Assessment Checklist (Domain Example: MFA)

```
Process Maturity:
  ☐ MFA policy documented
  ☐ MFA enrollment process defined
  ☐ MFA methods specified (which ones allowed)
  ☐ Enforcement rules documented
  ☐ User communication plan in place

Technology:
  ☐ MFA methods available (SMS, TOTP, hardware key, etc.)
  ☐ Conditional Access configured
  ☐ FIDO2 security keys supported
  ☐ Device registration enabled
  ☐ Passwordless phone sign-in available

Governance:
  ☐ MFA required for all users (or phased timeline)
  ☐ Exceptions documented and approved
  ☐ Regular policy review (annual)
  ☐ Compliance audit of MFA status
  ☐ Incident response if MFA bypass detected

Metrics & Visibility:
  ☐ MFA adoption tracked (% of users)
  ☐ MFA method breakdown (SMS %, TOTP %, hardware %)
  ☐ Failed authentication trends
  ☐ User complaints tracking
  ☐ Device registration health

Scoring:
  If 10/15 checklist items complete → Level 2 (Managed)
  If 12/15 → Level 3 (Optimized)
  If 14/15 → Level 4 (Advanced)
  If 15/15 + intelligence features → Level 5 (Intelligent)
```

## Enterprise Maturity Assessment Example

### Current State Assessment (Real Org)

```
Organization: Mid-size healthcare provider (5,000 employees)
Current year: 2024
Assessment period: Q1 2024

Domain Maturity Scores:

Provisioning:     Level 2 (documented, 2-day process)
RBAC:            Level 2 (basic roles, no hierarchy)
PAM:             Level 1 (no privilege mgmt, shared admin accounts)
App Access:      Level 2 (manual provisioning per app)
Least Privilege: Level 1 (no reviews, excessive access common)
MFA:             Level 1 (SMS optional, low adoption)
Password-less:   Level 0 (not implemented)
Adaptive Auth:   Level 0 (no conditional access)
Risk Detection:  Level 1 (no automated detection)
Access Reviews:  Level 1 (annual, incomplete)
IGA:             Level 1 (no platform, spreadsheet-based)
Audit Logging:   Level 2 (logs collected, minimal analysis)
Zero Trust:      Level 1 (no policies)
Workload Ident:  Level 1 (service accounts)
Compliance:      Level 2 (mapped, manual tracking)
Data Quality:    Level 2 (inconsistent attributes)
Intelligence:    Level 0 (no analytics)

Overall Average: 1.35 (between Level 1 and 2)
Assessment: "Ad-hoc with basic managed processes"
```

### Target State Vision (Year 3)

```
Target Maturity: Level 3-4 across all domains

Strategy:
  Phases 1-2: Improve foundational domains to Level 2
    - Governance, processes, basic automation
  
  Phases 3-4: Advance to Level 3-4
    - Automation, integration, advanced controls
  
  Phase 5+: Selective Level 4-5
    - Intelligence, predictive capabilities

Target 2027 Maturity Scores:

Provisioning:     Level 4 (automated, <1 hour, <1% error)
RBAC:            Level 3 (defined hierarchy, SoD)
PAM:             Level 3 (automated JIT, monitored)
App Access:      Level 3 (SCIM sync, automated)
Least Privilege: Level 3 (quarterly reviews, automated)
MFA:             Level 4 (phishing-resistant, risk-based)
Password-less:   Level 3 (40%+ adoption)
Adaptive Auth:   Level 3 (risk-based policies)
Risk Detection:  Level 3 (ML-based anomalies)
Access Reviews:  Level 3 (automated, continuous)
IGA:            Level 4 (SailPoint, advanced analytics)
Audit Logging:   Level 3 (correlated events, alerts)
Zero Trust:      Level 3 (least privilege, policies)
Workload Ident:  Level 3 (managed identities)
Compliance:      Level 3 (mapped, monitored, GRC)
Data Quality:    Level 3 (validated, monitored)
Intelligence:    Level 3 (UEBA, dashboards)

Overall Target: 3.2 (Level 3-4)
Vision: "Optimized and intelligent identity program"
```

### Improvement Plan

```
Year 1 (2024): Level 1→2 in foundational domains
  Priorities:
    1. Provisioning automation (Level 2→3)
    2. MFA enforcement (Level 1→2)
    3. RBAC documentation (Level 2→3)
    4. Governance structure (new)
  
  Investments: $500K, 5 FTE
  Expected outcome: Manual work reduced 30%

Year 2 (2025): Level 2→3 across all domains
  Priorities:
    1. IGA platform implementation (Level 1→3)
    2. Conditional Access policies (Level 0→2)
    3. Risk detection (Level 1→2)
    4. Automation expansion
  
  Investments: $1.2M, 8 FTE
  Expected outcome: Incident response time <1 hour

Year 3 (2027): Level 3-4 selective domains
  Priorities:
    1. Identity Intelligence (UEBA)
    2. Advanced Conditional Access (Level 2→4)
    3. Predictive risk models
    4. Autonomous remediation
  
  Investments: $800K, 6 FTE
  Expected outcome: Real-time threat detection

Total investment Year 1-3: $2.5M
Target Year 3 maturity: 3.2 (Level 3-4)
Estimated ROI: 40-60% (labor savings, risk reduction)
```

## Maturity Tracking

### Annual Assessment Template

```
Assessment date: Q1 2024
Assessor: IAM Director, Security Lead
Review period: Jan-Mar 2024

Domain scores (1-5):
Provisioning:     2.0 → 2.5 (improved from 2.0)
RBAC:            2.0 (unchanged)
MFA:             1.2 → 1.8 (improved from 1.2)
Governance:      1.0 → 2.5 (new, governance established)
(... more domains)

Overall maturity: 1.35 → 1.9 (improvement in Year 1)

Key improvements:
  ✓ Governance structure established
  ✓ Provisioning automation 50% complete
  ✓ MFA pilot successful, expanding
  ✓ Compliance framework mapping started

Remaining gaps:
  ✗ IGA platform not yet selected
  ✗ Conditional Access limited
  ✗ Risk detection not implemented
  ✗ Workload identity in pilot stage

Adjustments for Year 2:
  - Accelerate Conditional Access implementation
  - Start IGA platform selection immediately
  - Expand workload identity pilots
  - Initiate risk detection POC

Next assessment: Q1 2025
```

## Best Practices

1. **Realistic Assessment** - Be honest about current state, don't inflate scores
2. **Multi-Stakeholder** - Involve security, operations, compliance in assessment
3. **Benchmark** - Compare against industry maturity levels
4. **Actionable** - Use assessment to drive improvement roadmap
5. **Regular Reviews** - Assess annually, track progress
6. **Celebrate Wins** - Recognize improvement over time

## Related Documents

**Prerequisites:**
- [Maturity Model](./00b-enterprise-iam-maturity.md)
- [Governance](./20-governance-structure.md)

**Next Steps:**
- [Implementation Roadmap](./20a-implementation-roadmap.md)
- [Migration Strategy](./20c-migration-strategy.md)

## FAQ

**Q: How long to improve from Level 1 to Level 3?**

A: Typically 18-24 months with sustained investment and focus.

**Q: Should all domains target Level 5?**

A: No. Target Level 3-4 for most; selective Level 5 for high-value domains.

## Next Steps

1. Conduct initial maturity assessment
2. Define target maturity (Year 3)
3. Identify gaps (current vs. target)
4. Develop improvement roadmap
5. Allocate resources and budget
6. Execute improvements
7. Track progress annually

Maturity assessment provides roadmap from ad-hoc to intelligent identity management.
