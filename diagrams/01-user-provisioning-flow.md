# User Provisioning Flow Diagram

## Joiner Workflow (Complete User Lifecycle)

```mermaid
graph TD
    A[HR Creates Hire<br/>in Workday] -->|Trigger| B[Provisioning Workflow Starts]
    B -->|Validate| C{Data<br/>Complete?}
    C -->|No| D[Notify HR<br/>Complete Form]
    D --> A
    C -->|Yes| E[Create Azure AD User]
    E --> F[Create Email Account]
    F --> G[Create Groups]
    G --> H[Provision Apps]
    H --> I[Request Hardware]
    I --> J[Send Welcome Email]
    J --> K[Verify Everything Works]
    K -->|Success| L[Onboarding Complete]
    K -->|Failure| M[Alert Help Desk<br/>Investigate]
    M --> N[Remediate Issues]
    N --> K
    
    style A fill:#e1f5ff
    style L fill:#c8e6c9
    style M fill:#ffccbc
```

**Timeline:** 1-2 hours total  
**Manual effort:** ~10 minutes

---

## Mover Workflow (Role Change)

```mermaid
graph LR
    A[Employee Changes<br/>Department] -->|Trigger| B[Mover Workflow]
    B -->|Step 1| C[Remove Old Access]
    C --> C1[Remove from Sales group]
    C --> C2[Revoke Salesforce access]
    C --> C3[Remove distribution list]
    B -->|Step 2| D[Grant New Access]
    D --> D1[Add to Engineering group]
    D --> D2[Provision GitHub access]
    D --> D3[Add to new distribution list]
    B -->|Step 3| E[Notify Stakeholders]
    E --> F[Update Manager Relationship]
    F -->|Complete| G[Mover Finished]
    
    style A fill:#fff3e0
    style G fill:#c8e6c9
```

**Timeline:** 30-45 minutes  
**Manual effort:** 0 minutes

---

## Leaver Workflow (Offboarding)

```mermaid
graph TD
    A[Employee Terminated] -->|T+0| B[Immediate Lockdown]
    B --> B1[Disable Azure AD Account]
    B --> B2[Terminate Active Sessions]
    B --> B3[Revoke OAuth Tokens]
    B --> B4[Disable Email]
    B --> B5[Revoke VPN Access]
    
    A -->|T+4h| C[Access Revocation]
    C --> C1[Remove All Groups]
    C --> C2[Revoke App Access]
    C --> C3[Disable Database Access]
    
    A -->|T+8h| D[Data Handling]
    D --> D1[Archive Mailbox]
    D --> D2[Convert OneDrive Inactive]
    D --> D3[Transfer Ownership]
    
    A -->|T+24h| E[Final Cleanup]
    E --> E1[Remove Service Subscriptions]
    E --> E2[Deactivate Network Access]
    
    A -->|T+90d| F[Archive Complete]
    
    style A fill:#ffebee
    style B fill:#ffccbc
    style C fill:#ffccbc
    style F fill:#f3e5f5
```

**Timeline:** Critical access removed within 4 hours  
**Manual effort:** 30 minutes verification

---

## Access Review Cycle

```mermaid
graph TD
    A[Schedule Review] --> B[Send to Managers]
    B --> C{Manager<br/>Reviews}
    C -->|Approve| D[Access Retained]
    C -->|Deny| E[Access Marked for Removal]
    C -->|No Response| F[Escalate to Director]
    F --> G{Director<br/>Responds?}
    G -->|Yes| C
    G -->|No| H[Timeout<br/>Auto-Deny]
    H --> E
    E --> I[Revoke Access]
    D --> J[Review Complete]
    I --> J
    J --> K[Generate Audit Report]
```

**Frequency:** Quarterly for all users  
**Effort:** 10 min per manager per review

