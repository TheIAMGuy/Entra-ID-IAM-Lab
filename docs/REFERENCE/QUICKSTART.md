# QUICKSTART.md — 2-Hour Fast Path

**For experienced IAM practitioners only.** This guide skips concepts and focuses on Entra ID-specific commands and patterns.

---

## Phase 1 (Skip if you have a tenant)

```powershell
# Create 5 test users
$users = @("alice.smith@contoso.com", "bob.jones@contoso.com", "charlie.brown@contoso.com", "diana.prince@contoso.com", "eve.wilson@contoso.com")
foreach ($upn in $users) {
    New-MgUser -DisplayName $upn.Split("@")[0] -UserPrincipalName $upn -PasswordProfile @{ ForceChangePasswordNextSignIn = $false; Password = "TempPassword123!" } -AccountEnabled
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

## Phase 5 (Specialist)

### Workload Identity (Managed Identity)

```powershell
# Create system-assigned managed identity for Function App
# (In Entra ID admin center: Function App → Identity → System-assigned)

# Grant permissions
$rg = "myResourceGroup"
$mi = Get-AzUserAssignedIdentity -ResourceGroupName $rg -Name "myFunctionIdentity"
New-AzRoleAssignment -ObjectId $mi.PrincipalId -RoleDefinitionName "Key Vault Secrets Officer" -Scope "/subscriptions/xxx/resourceGroups/$rg"
```

### B2B Guest User

```powershell
$invitationUrl = New-MgInvitation -InvitedUserEmailAddress "partner@externaldomain.com" `
    -SendInvitationMessage $true `
    -InviteRedirectUrl "https://myapp.azurewebsites.net" | Select-Object InviteRedeemUrl

Write-Host "Send this URL to guest: $($invitationUrl.InviteRedeemUrl)"
```

---

## Phase 6: Reference Commands

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
Connect-MgGraph -Scopes "Directory.ReadWrite.All", "Policy.ReadWrite.ConditionalAccess"
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
