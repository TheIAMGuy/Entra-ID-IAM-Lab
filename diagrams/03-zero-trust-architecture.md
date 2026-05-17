# Zero Trust Architecture Diagrams

## Zero Trust Principles vs Traditional Perimeter

```mermaid
graph TB
    subgraph Traditional["Traditional (Perimeter-based)"]
        A["Inside Network<br/>= Trusted"]
        B["Outside Network<br/>= Untrusted"]
        C["User has VPN access?<br/>→ Full network access"]
    end
    
    subgraph ZeroTrust["Zero Trust (Verify Everything)"]
        D["User identity: Verify"]
        E["Device health: Verify"]
        F["Network location: Verify"]
        G["Access level: Verify"]
        H["Everything verified?<br/>→ Grant access"]
    end
    
    style Traditional fill:#ffebee
    style ZeroTrust fill:#c8e6c9
```

---

## Zero Trust Authentication Flow

```mermaid
graph TD
    A["User Requests Access"] -->|1. Identify| B["Who are you?<br/>Prove with MFA"]
    B -->|2. Device Health| C["Is device secure?<br/>Check: patch level, encryption, AV"]
    C -->|3. Context| D["Where are you?<br/>Location, time, network"]
    D -->|4. Behavior| E["Is this normal?<br/>Risk scoring"]
    E -->|5. Policy| F{All Checks<br/>Pass?}
    F -->|No| G["Block or<br/>Require stronger auth"]
    F -->|Yes| H["Grant access<br/>with restrictions"]
    
    style A fill:#e3f2fd
    style G fill:#ffccbc
    style H fill:#c8e6c9
```

---

## Conditional Access Policy Examples

### Policy 1: Baseline (Standard User)
```
Condition: User risk = LOW, Sign-in risk = LOW
Result: Allow (no MFA required)
```

### Policy 2: Elevated Risk
```
Condition: User risk = MEDIUM OR Sign-in risk = MEDIUM
Result: Require MFA (TOTP or SMS)
```

### Policy 3: High Risk
```
Condition: User risk = HIGH OR Sign-in risk = HIGH
Result: Require FIDO2 hardware key + security questions
```

### Policy 4: Critical Risk
```
Condition: Impossible travel OR Multiple high-risk signals
Result: Block + Require admin approval
```

---

## Risk Scoring Components

```mermaid
graph LR
    A["Location<br/>40%"] -->|+| Score["Risk Score<br/>0-100"]
    B["Device<br/>25%"] -->|+| Score
    C["Time<br/>15%"] -->|+| Score
    D["User Behavior<br/>15%"] -->|+| Score
    E["Network<br/>5%"] -->|+| Score
    
    Score -->|0-20| F["LOW<br/>Allow"]
    Score -->|21-40| G["MED-LOW<br/>MFA"]
    Score -->|41-60| H["MEDIUM<br/>Strong MFA"]
    Score -->|61-80| I["HIGH<br/>Block + Challenge"]
    Score -->|81-100| J["CRITICAL<br/>Block"]
    
    style F fill:#c8e6c9
    style G fill:#fff9c4
    style H fill:#ffe0b2
    style I fill:#ffccbc
    style J fill:#ffccbc
```

