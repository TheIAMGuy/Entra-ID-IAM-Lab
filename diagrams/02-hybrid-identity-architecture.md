# Hybrid Identity Architecture Diagrams

## Hybrid Sync Model (Most Common)

```mermaid
graph TB
    subgraph OnPrem["On-Premises"]
        A["Active Directory<br/>Users: 1,000"]
        B["Attributes:<br/>Name, Email, Phone,<br/>Department"]
    end
    
    subgraph Cloud["Azure Cloud"]
        C["Azure AD<br/>Users: 1,000"]
        D["Attributes:<br/>Name, Email, Phone,<br/>Department"]
    end
    
    subgraph Sync["Azure AD Connect<br/>(Synchronization)"]
        E["Sync Engine"]
        F["Attribute Mapping"]
    end
    
    A -->|Every 30 min| E
    E --> F
    F --> C
    B --> E
    E --> D
    
    style OnPrem fill:#e3f2fd
    style Cloud fill:#f3e5f5
    style Sync fill:#fff9c4
```

**Use Case:** 80% of enterprises  
**Benefit:** Single source of truth (on-prem), cloud backup  
**Latency:** 30 min sync interval

---

## Pass-Through Auth (Higher Security)

```mermaid
graph LR
    A["User Signs In<br/>to Cloud App<br/>user@company.com"] -->|Credentials| B["Azure AD"]
    B -->|Agent: Validate| C["On-Premises AD"]
    C -->|Valid/Invalid| D["Azure AD"]
    D -->|Token| E["Cloud App"]
    
    F["Agent 1<br/>On-Prem Server 1"] -.->|Monitor| B
    G["Agent 2<br/>On-Prem Server 2"] -.->|Monitor| B
    H["Agent 3<br/>On-Prem Server 3"] -.->|Monitor| B
    
    style A fill:#e3f2fd
    style B fill:#f3e5f5
    style C fill:#e3f2fd
    style E fill:#c8e6c9
```

**Use Case:** High-security + on-prem control  
**Benefit:** Password never in cloud, real-time validation  
**Latency:** <100ms

---

## Federated (Okta/Ping/Keycloak)

```mermaid
graph TB
    A["User Signs In<br/>to Cloud App"] -->|Redirect| B["IdP<br/>(Okta/Ping)"]
    B -->|Check User| C["On-Premises<br/>Active Directory"]
    C -->|User Valid| B
    B -->|SAML Token| D["Cloud App"]
    D --> E["Access Granted"]
    
    style A fill:#e3f2fd
    style B fill:#fff3e0
    style C fill:#e3f2fd
    style E fill:#c8e6c9
```

**Use Case:** Multi-cloud, legacy systems  
**Benefit:** Centralized authentication, advanced features  
**Latency:** Depends on IdP configuration

---

## Hybrid Sign-In Experience

```mermaid
sequenceDiagram
    participant User
    participant OnPrem as On-Prem AD
    participant Cloud as Azure AD
    participant App as Cloud App
    
    User ->> Cloud: 1. Sign in request
    Cloud ->> OnPrem: 2. Validate credentials (PTA)
    OnPrem ->> OnPrem: 3. Check AD
    OnPrem -->> Cloud: 4. Valid
    Cloud -->> User: 5. Require MFA (if policy)
    User ->> Cloud: 6. Enter MFA code
    Cloud -->> App: 7. Issue token
    App ->> User: 8. Grant access
    
    Note over OnPrem,Cloud: Credentials validated<br/>on-premises
    Note over Cloud,App: Session in cloud
```

---

## Attribute Mapping Example

| Source | Mapping | Target | Sync Status |
|--------|---------|--------|------------|
| AD: givenName | → | Azure AD: givenName | ✅ |
| AD: sn | → | Azure AD: surname | ✅ |
| AD: mail | → | Azure AD: userPrincipalName | ✅ |
| AD: dept | → | Azure AD: department | ✅ |
| AD: manager | → | Azure AD: manager | ✅ |
| AD: mobile | → | Azure AD: mobilePhone | ✅ |

**Custom Mapping Example:**
```
AD: extensionAttribute1 → Azure AD: employeeId
AD: extensionAttribute2 → Azure AD: costCenter
```

