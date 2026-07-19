---
title: Pass-Through Authentication - Real-Time Validation
part: 4
section: Hybrid & Cloud Identity
difficulty: Advanced
estimated_reading_time: 35
estimated_lab_time: 45
prerequisites:
  - 10-hybrid-identity-architecture.md
learning_objectives:
  - Understand pass-through authentication architecture
  - Implement pass-through agents for security
  - Configure authentication policies
  - Monitor authentication health
---

# Pass-Through Authentication: Real-Time Validation

## Introduction

Pass-through authentication validates user credentials in real-time against on-premises Active Directory. Unlike password hash synchronization, the password never leaves the on-premises network. This approach provides maximum security for organizations requiring that passwords never be stored in the cloud.

**Learning Objectives:**
- Understand PTA architecture and data flow
- Implement pass-through authentication agents
- Configure Conditional Access with PTA
- Monitor and troubleshoot PTA
- Understand security and performance trade-offs

## Architecture

**Data Flow:**

```
User signs in to cloud app
  ↓ (enters username/password)
Cloud app
  ↓ (sends to Entra ID)
Entra ID
  ↓ (not storing password)
Pass-Through Auth Agent (on-premises, installed on DC or member server)
  ↓ (validates against on-premises AD)
On-Premises AD
  ↓ ("valid" or "invalid")
Pass-Through Auth Agent
  ↓ (sends response to Entra ID)
Entra ID
  ↓ (user authenticated)
Cloud app
  ↓ (user signed in)
```

**Key Design:**
- Password never stored in cloud
- Agents are stateless (can deploy multiple)
- Encrypted channel between cloud and agents
- Agents use service accounts (not user accounts)

## Implementing Pass-Through Authentication

### Prerequisites

- Azure AD Connect installed
- At least 2 agents (3+ recommended for redundancy)
- Network connectivity from on-premises to Entra ID
- On-premises AD accessible to agents

### Installation Steps

1. **Install First Agent:**
   - Azure AD Connect → Configure → Authentication
   - Enable "Pass-through authentication"
   - Auto-installs on same server

2. **Install Additional Agents:**
   - Azure AD Connect → Configure → Manage agents
   - Download agent installer
   - Run on additional domain-joined machines
   - Agents auto-register with Entra ID

3. **Verify Agents:**
   - Entra ID → Hybrid identity → Pass-through auth
   - Should show 2+ agents as "Active"

### Configuration

**Conditional Access with PTA:**

```
Policy: "Require MFA for high-risk sign-ins with PTA"
- Condition: Sign-in risk = High
- Action: Require MFA (even with PTA)
- Result: PTA handles password validation, CA layer requires MFA
```

## Monitoring Pass-Through Authentication

**Metrics:**
- Agent availability (should be 100%)
- Authentication latency (typical: 100-200ms)
- Failed authentication rate (track unusual spikes)
- Agent sync with Entra ID (should be current)

**Audit Logs:**
- Sign-in logs show "Pass-through authentication" method
- Failed authentications logged by reason
- Track by user and agent

## Comparison: PTA vs. Password Hash Sync

| Aspect | PTA | Hash Sync |
|--------|-----|-----------|
| **Cloud Password Storage** | Never | Hash only |
| **On-Premises Dependency** | Required online | Not needed |
| **Offline Access** | Not available | Available |
| **Authentication Latency** | 100-200ms | Immediate |
| **Complexity** | Medium | Low |
| **Cost** | Agents required | No additional agents |
| **Security** | Higher | High |

## Troubleshooting PTA

| Issue | Solution |
|-------|----------|
| "Agent not available" | Check agent service running, network connectivity |
| "Authentication fails for all users" | Verify agent can reach on-premises AD |
| "High latency" | Add more agents, optimize network |
| "Agent offline" | Restart service, check SSL certificate |

## FAQ

**Q: How many agents do we need?**

A: Minimum 2 (failover), recommended 3+ for 1000+ users.

**Q: What if agents fail?**

A: Users can't authenticate until agents recover. Plan redundancy.

**Q: Is PTA more secure than hash sync?**

A: Yes, password never in cloud. But requires more infrastructure.

## Next Steps

1. Evaluate security requirements (PTA vs. hash sync)
2. If PTA required, install agents
3. Configure Conditional Access
4. Monitor agent health
5. Test failover scenarios

PTA provides maximum cloud security for on-premises identity. Trade off infrastructure complexity for maximum password security.
