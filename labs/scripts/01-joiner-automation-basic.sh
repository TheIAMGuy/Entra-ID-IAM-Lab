#!/bin/bash
# Lab 1: Joiner Automation - Basic User Provisioning
# 
# This script demonstrates automated user provisioning:
# 1. Simulates HR creating a new hire
# 2. Creates user in Azure AD
# 3. Creates email account
# 4. Assigns to groups
# 5. Verifies everything works
#
# Time: ~30 minutes
# Prerequisites: Azure CLI installed, logged in, test tenant created

set -e  # Exit on error

echo "=========================================="
echo "Lab 1: Joiner Automation"
echo "=========================================="
echo ""

# Configuration
TENANT_ID="your-tenant-id"  # Replace with your tenant ID
RESOURCE_GROUP="iam-labs-rg"
DOMAIN="labcompany.onmicrosoft.com"

# Test user info (simulating HR data)
FIRST_NAME="John"
LAST_NAME="Smith"
EMAIL="${FIRST_NAME,,}.${LAST_NAME,,}@${DOMAIN}"
DISPLAY_NAME="${FIRST_NAME} ${LAST_NAME}"
DEPARTMENT="Sales"
JOB_TITLE="Sales Representative"

echo "Step 1: Validate prerequisites"
echo "  Checking Azure CLI..."
if ! command -v az &> /dev/null; then
    echo "  ❌ Azure CLI not found. Install it: https://learn.microsoft.com/cli/azure"
    exit 1
fi
echo "  ✅ Azure CLI found"

echo ""
echo "Step 2: Check Entra ID tenant"
echo "  Connecting to tenant: $TENANT_ID"
az account set --subscription "$TENANT_ID" || {
    echo "  ❌ Cannot access tenant. Is your tenant ID correct?"
    exit 1
}
echo "  ✅ Connected to tenant"

echo ""
echo "Step 3: Create user account"
echo "  Creating user: $EMAIL"
TEMP_PASSWORD=$(openssl rand -base64 12)

# Create user
az ad user create \
    --display-name "$DISPLAY_NAME" \
    --user-principal-name "$EMAIL" \
    --password "$TEMP_PASSWORD" \
    --force-change-password-next-login true \
    --given-name "$FIRST_NAME" \
    --surname "$LAST_NAME" || {
    echo "  ❌ User creation failed"
    exit 1
}

echo "  ✅ User created: $EMAIL"
echo "  📝 Temporary password: $TEMP_PASSWORD (user must change on first login)"

echo ""
echo "Step 4: Assign to security groups"
echo "  Assigning to groups..."

# Create groups if they don't exist
GROUPS=("All Employees" "Sales Team" "New Hires")
for GROUP in "${GROUPS[@]}"; do
    GROUP_ID=$(az ad group list --filter "displayName eq '$GROUP'" --query "[0].id" -o tsv)
    if [ -z "$GROUP_ID" ]; then
        echo "    Creating group: $GROUP"
        GROUP_ID=$(az ad group create --display-name "$GROUP" --mail-nickname "${GROUP,,}" --query "id" -o tsv)
    fi
    
    az ad group member add --group "$GROUP_ID" --member-id "$EMAIL" || true
    echo "    ✅ Added to: $GROUP"
done

echo ""
echo "Step 5: Set user attributes"
echo "  Setting department and job title..."
az ad user update --id "$EMAIL" \
    --set "department=$DEPARTMENT" || true

echo "  ✅ Attributes set"

echo ""
echo "Step 6: Verify user was created"
USER=$(az ad user show --id "$EMAIL" --query '{displayName, userPrincipalName, department}' -o json)
echo "  User details:"
echo "$USER" | jq '.' || echo "$USER"

echo ""
echo "Step 7: Verify group membership"
echo "  Groups assigned:"
az ad group member list --group "All Employees" --query "[].displayName" -o tsv || true

echo ""
echo "=========================================="
echo "✅ Lab 1 Complete!"
echo "=========================================="
echo ""
echo "Summary:"
echo "  User created: $EMAIL"
echo "  Temporary password: $TEMP_PASSWORD"
echo "  Department: $DEPARTMENT"
echo "  Groups: All Employees, Sales Team, New Hires"
echo ""
echo "Next steps:"
echo "  1. Have the user sign in at https://login.microsoft.com"
echo "  2. User will be prompted to change temporary password"
echo "  3. User can then access cloud applications"
echo ""
echo "To clean up:"
echo "  az ad user delete --id '$EMAIL'"
echo ""

