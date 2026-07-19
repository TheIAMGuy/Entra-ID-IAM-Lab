# Phase 1 Examples — Free Tier Fundamentals

This folder contains ready-to-use examples for Phase 1 (Free Tier) labs.

## Files

- **user-bulk-create.json** — Template for bulk user creation via Microsoft Graph
- **group-rbac-sample.json** — Security group structure for RBAC implementation
- **naming-conventions.txt** — Recommended naming standards for users, groups, roles

## How to Use

1. Copy the JSON examples and adapt them for your tenant
2. Use the naming conventions as a guideline for your organization
3. Test in your sandbox tenant before rolling out to production

## Example: Bulk User Creation

```powershell
$users = @(
    @{ DisplayName = "Alice Smith"; UserPrincipalName = "alice.smith@contoso.com" },
    @{ DisplayName = "Bob Jones"; UserPrincipalName = "bob.jones@contoso.com" }
)

foreach ($user in $users) {
    New-MgUser -DisplayName $user.DisplayName -UserPrincipalName $user.UserPrincipalName `
        -PasswordProfile @{ ForceChangePasswordNextSignIn = $false; Password = "TempPassword123!" } `
        -AccountEnabled
}
```

## Next Steps

See [Phase 1 Core Guide](../../docs/PHASE-1-FREE-TIER/01-environment-setup.md) for full implementation.
