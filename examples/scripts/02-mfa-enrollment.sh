#!/bin/bash
# Lab 2: MFA Enrollment - Enable Multi-Factor Authentication
#
# This script demonstrates MFA setup:
# 1. Creates a Conditional Access policy requiring MFA
# 2. Enrolls a test user in MFA
# 3. Verifies sign-in requires MFA
#
# Time: ~30 minutes
# Prerequisites: Lab 1 complete, test user created

set -e

echo "=========================================="
echo "Lab 2: MFA Enrollment"
echo "=========================================="
echo ""

TENANT_ID="your-tenant-id"
EMAIL="john.smith@labcompany.onmicrosoft.com"

echo "Step 1: Create Conditional Access policy"
echo "  This policy requires MFA for all users signing into cloud apps"
echo ""
echo "  ⚠️  Manual step required:"
echo "    1. Go to: Azure Portal → Entra ID → Security → Conditional Access"
echo "    2. Click 'New policy'"
echo "    3. Configure:"
echo "       Name: 'Require MFA for all cloud apps'"
echo "       Users and groups: All users"
echo "       Cloud apps or actions: All cloud apps"
echo "       Grant: Require MFA"
echo "    4. Click 'Create'"
echo ""
read -p "  Press Enter once you've created the policy..."

echo ""
echo "Step 2: Enroll user in MFA"
echo "  Instructing user to enroll in authenticator app..."
echo ""
echo "  User instructions:"
echo "    1. Go to: https://myaccount.microsoft.com"
echo "    2. Sign in with: $EMAIL"
echo "    3. Click 'Security info' → 'Add sign-in method'"
echo "    4. Choose 'Authenticator app'"
echo "    5. Click 'Add'"
echo "    6. Scan QR code with Microsoft Authenticator or Google Authenticator"
echo "    7. Confirm by entering 6-digit code from app"
echo ""
read -p "  Press Enter once MFA is enrolled..."

echo ""
echo "Step 3: Test MFA sign-in"
echo "  Testing that sign-in now requires MFA..."
echo ""
echo "  Test procedure:"
echo "    1. Go to: https://login.microsoft.com"
echo "    2. Enter email: $EMAIL"
echo "    3. Enter password"
echo "    4. App opens authenticator → requires 6-digit code"
echo "    5. Enter code from authenticator app"
echo "    6. ✅ Sign-in succeeds"
echo ""
echo "  If MFA not required:"
echo "    - Policy may take 5 minutes to apply"
echo "    - Try incognito/private browser window"
echo "    - Check policy is 'On' (not Report-only)"
echo ""
read -p "  Press Enter once you've tested MFA..."

echo ""
echo "=========================================="
echo "✅ Lab 2 Complete!"
echo "=========================================="
echo ""
echo "Summary:"
echo "  MFA policy created: 'Require MFA for all cloud apps'"
echo "  User enrolled: $EMAIL"
echo "  Authentication method: TOTP (Authenticator app)"
echo ""
echo "Best practices:"
echo "  • Require MFA for all users (not just executives)"
echo "  • Use authenticator app (TOTP) instead of SMS when possible"
echo "  • For high-risk roles: use hardware keys (FIDO2)"
echo "  • Gradual rollout: 1-2 months for full adoption"
echo ""
