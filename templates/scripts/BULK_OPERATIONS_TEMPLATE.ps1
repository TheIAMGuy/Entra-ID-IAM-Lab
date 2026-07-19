# Bulk Operations Template — Entra ID Administration
# Use this as a starting point for common bulk tasks

# ============================================================================
# PREREQUISITES
# ============================================================================

# Install required modules (run once)
# Install-Module Microsoft.Graph.Users -Scope CurrentUser
# Install-Module Microsoft.Graph.Groups -Scope CurrentUser
# Install-Module Microsoft.Graph.Identity.DirectoryManagement -Scope CurrentUser

# Connect to Entra ID
Connect-MgGraph -Scopes "Directory.ReadWrite.All", "User.ReadWrite.All"

# ============================================================================
# EXAMPLE 1: BULK CREATE USERS
# ============================================================================

$newUsers = @(
    @{ DisplayName = "John Doe"; UserPrincipalName = "john.doe@contoso.com"; Department = "Finance" },
    @{ DisplayName = "Jane Smith"; UserPrincipalName = "jane.smith@contoso.com"; Department = "Marketing" },
    @{ DisplayName = "Bob Wilson"; UserPrincipalName = "bob.wilson@contoso.com"; Department = "IT" }
)

$tempPassword = "TempPassword@12345"

foreach ($user in $newUsers) {
    try {
        $newMgUser = New-MgUser `
            -DisplayName $user.DisplayName `
            -UserPrincipalName $user.UserPrincipalName `
            -PasswordProfile @{
                ForceChangePasswordNextSignIn = $false
                Password = $tempPassword
            } `
            -AccountEnabled `
            -Department $user.Department

        Write-Host "✓ Created user: $($user.DisplayName)" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed to create user: $($user.DisplayName) - $_" -ForegroundColor Red
    }
}

# ============================================================================
# EXAMPLE 2: BULK ADD USERS TO GROUPS
# ============================================================================

$groupName = "Finance-Team"
$userEmails = @("john.doe@contoso.com", "jane.smith@contoso.com")

# Get the group
$group = Get-MgGroup -Filter "displayName eq '$groupName'"
if (-not $group) {
    Write-Host "Group not found: $groupName" -ForegroundColor Yellow
} else {
    foreach ($email in $userEmails) {
        $user = Get-MgUser -Filter "userPrincipalName eq '$email'"
        if ($user) {
            try {
                New-MgGroupMember -GroupId $group.Id -DirectoryObjectId $user.Id
                Write-Host "✓ Added $email to $groupName" -ForegroundColor Green
            } catch {
                Write-Host "✗ Failed to add $email: $_" -ForegroundColor Red
            }
        } else {
            Write-Host "User not found: $email" -ForegroundColor Yellow
        }
    }
}

# ============================================================================
# EXAMPLE 3: BULK UPDATE USER PROPERTIES
# ============================================================================

$updates = @(
    @{ Email = "john.doe@contoso.com"; JobTitle = "Senior Accountant"; Manager = "jane.smith@contoso.com" }
)

foreach ($update in $updates) {
    $user = Get-MgUser -Filter "userPrincipalName eq '$($update.Email)'"
    if ($user) {
        try {
            Update-MgUser -UserId $user.Id -JobTitle $update.JobTitle
            Write-Host "✓ Updated $($update.Email)" -ForegroundColor Green
        } catch {
            Write-Host "✗ Failed to update $($update.Email): $_" -ForegroundColor Red
        }
    }
}

# ============================================================================
# EXAMPLE 4: EXPORT ALL USERS TO CSV
# ============================================================================

$allUsers = Get-MgUser -All -PageSize 999 | Select-Object DisplayName, UserPrincipalName, JobTitle, Department, CreatedDateTime

$allUsers | Export-Csv -Path "entra_users_export.csv" -NoTypeInformation
Write-Host "✓ Exported $($allUsers.Count) users to entra_users_export.csv" -ForegroundColor Green

# ============================================================================
# EXAMPLE 5: LIST ALL GROUPS AND MEMBER COUNT
# ============================================================================

$allGroups = Get-MgGroup -All | Select-Object DisplayName, Id

$groupReport = @()
foreach ($group in $allGroups) {
    $memberCount = (Get-MgGroupMember -GroupId $group.Id).Count
    $groupReport += [PSCustomObject]@{
        GroupName   = $group.DisplayName
        MemberCount = $memberCount
    }
}

$groupReport | Export-Csv -Path "group_membership_report.csv" -NoTypeInformation
Write-Host "✓ Exported group report to group_membership_report.csv" -ForegroundColor Green

# ============================================================================
# EXAMPLE 6: DISABLE MULTIPLE USERS
# ============================================================================

$usersToDisable = @("bob.wilson@contoso.com")

foreach ($email in $usersToDisable) {
    $user = Get-MgUser -Filter "userPrincipalName eq '$email'"
    if ($user) {
        try {
            Update-MgUser -UserId $user.Id -AccountEnabled $false
            Write-Host "✓ Disabled user: $email" -ForegroundColor Green
        } catch {
            Write-Host "✗ Failed to disable $email: $_" -ForegroundColor Red
        }
    }
}

# ============================================================================
# DISCONNECT
# ============================================================================

Disconnect-MgGraph
Write-Host "`n✓ Disconnected from Entra ID" -ForegroundColor Green
