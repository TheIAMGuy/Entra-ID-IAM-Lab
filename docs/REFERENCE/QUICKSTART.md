# QUICKSTART.md — 2-Hour Fast Path

**For experienced IAM practitioners only.** This guide skips concepts and focuses on Entra ID-specific commands and patterns.

---

## Phase 1 (Skip if you have a tenant)

```powershell
# Create 5 test users (lab only). Each gets a unique random password, and must change it at first sign-in.
# Passwords are printed once so you can hand them out; do not reuse or commit them.
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All"
$users = @("alice.smith@contoso.com", "bob.jones@contoso.com", "charlie.brown@contoso.com", "diana.prince@contoso.com", "eve.wilson@contoso.com")
foreach ($upn in $users) {
    $pw = -join ((48..57) + (65..90) + (97..122) + (33,35,36,37,42) | Get-Random -Count 20 | ForEach-Object { [char]$_ })
    New-MgUser -DisplayName $upn.Split("@")[0] -UserPrincipalName $upn -MailNickname $upn.Split("@")[0] -PasswordProfile @{ ForceChangePasswordNextSignIn = $true; Password = $pw } -AccountEnabled
    Write-Host "$upn : $pw"
}

# Create security groups
New-MgGroup -DisplayName "Finance Team" -GroupTypes @() -SecurityEnabled -MailEnabled $false
New-MgGroup -DisplayName "IT Admins" -GroupTypes @() -SecurityEnabled -MailEnabled $false
```

---

## Phase 2 (P1 License Required)

### Assign Privileged Roles

```powershell
# Get role IDs
$userAdminRole = Get-MgDirectoryRole | Where-Object { $_.DisplayName -eq "User Administrator" }
$globalReaderRole = Get-MgDirectoryRole | Where-Object { $_.DisplayName -eq "Global Reader" }

# Assign user to role
$user = Get-MgUser -Filter "userPrincipalName eq 'alice.smith@contoso.com'"
New-MgDirectoryRoleMember -DirectoryRoleId $userAdminRole.Id -DirectoryObjectId $user.Id
```

### Add Enterprise Application

```powershell
# Get ServicePrincipal for Salesforce
$app = Get-MgServicePrincipal -Filter "displayName eq 'Salesforce'"
if (-not $app) {
    Write-Host "Salesforce not found in tenant gallery"
}

# Assign user to app
$user = Get-MgUser -Filter "userPrincipalName eq 'bob.jones@contoso.com'"
New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $app.Id -AppRoleId "00000000-0000-0000-0000-000000000001" -PrincipalId $user.Id
```

---

## Phase 3 (P2 License Required)

### Enable MFA

```powershell
# Register MFA for user
$user = Get-MgUser -Filter "userPrincipalName eq 'charlie.brown@contoso.com'"
Update-MgUser -UserId $user.Id -StrongAuthenticationRequirements @{
    State = "Required"
}
```

### Create Conditional Access Policy

```powershell
$policy = @{
    displayName = "Require MFA for risky sign-ins"
    state = "enabled"
    conditions = @{
        signInRiskLevels = @("high", "medium")
        applications = @{
            includeApplications = @("All")
        }
        users = @{
            includeUsers = @("All")
            excludeUsers = @("GuestUser")
        }
    }
    grantControls = @{
        operator = "OR"
        builtInControls = @("mfa")
    }
}
New-MgIdentityConditionalAccessPolicy -BodyParameter $policy
```

---

## Phase 4 (Governance License Required)

### Create Access Review

```powershell
$accessReview = @{
    displayName = "Q4 Access Review - Finance Team"
    descriptionForAdmins = "Review access for Finance Team members"
    scope = @{
        query = "/me/memberOf/microsoft.graph.group?`$filter=displayName eq 'Finance Team'"
        queryType = "MicrosoftGraphQuery"
    }
    reviewers = @(
        @{
            query = "/me/manager"
            queryType = "MicrosoftGraphQuery"
        }
    )
    settings = @{
        accessReviewTimeoutBehavior = "keepAccess"
        autoApplyReviewsToReviewers = $false
        defaultDecisionEnabled = $true
        defaultDecision = "Deny"
        justificationRequiredOnApproval = $true
        mailNotificationsEnabled = $true
    }
    startDate = (Get-Date).AddDays(1)
    endDate = (Get-Date).AddDays(30)
}
New-MgIdentityGovernanceAccessReviewDefinition -BodyParameter $accessReview
```

---

## Reference Commands

### Get All Users
```powershell
Get-MgUser -All -PageSize 999 | Select-Object DisplayName, UserPrincipalName, CreatedDateTime, LastSignInDateTime
```

### Get All Groups and Members
```powershell
$groups = Get-MgGroup -All
foreach ($group in $groups) {
    $members = Get-MgGroupMember -GroupId $group.Id
    Write-Host "$($group.DisplayName): $($members.Count) members"
}
```

### Export Audit Logs
```powershell
Get-MgAuditLogDirectoryAudit -All -PageSize 999 | Select-Object ActivityDateTime, ActivityDisplayName, Result, TargetResources | Export-Csv -Path "audit_logs.csv" -NoTypeInformation
```

### List Service Principals (Apps)
```powershell
Get-MgServicePrincipal -All -PageSize 999 | Select-Object DisplayName, AppId, CreatedDateTime, LastModifiedDateTime | Sort-Object CreatedDateTime -Descending
```

### Check Conditional Access Policies
```powershell
Get-MgIdentityConditionalAccessPolicy -All | Select-Object DisplayName, State, CreatedDateTime | Format-Table
```

---

## Troubleshooting

**Module not found:** 
```powershell
Install-Module Microsoft.Graph.Identity.Governance -Scope CurrentUser
# Request only the scopes the lab step needs. Directory.ReadWrite.All is broader than any lab here requires.
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All", "RoleManagement.ReadWrite.Directory", "Policy.ReadWrite.ConditionalAccess"
```

**Permission denied on role assignment:**
- Ensure you have Global Administrator role
- Check `Get-MgDirectoryRole` to verify role exists

**Access Review not creating:**
- Entra ID Governance license required
- Ensure users in scope exist

---

## Next Steps

- Full guides: [PHASE-2-ENTRA-P1](../PHASE-2-ENTRA-P1/04-privileged-access-management.md)
- Concepts: [IAM_GLOSSARY.md](IAM_GLOSSARY.md)
- Troubleshooting: Check specific phase doc
