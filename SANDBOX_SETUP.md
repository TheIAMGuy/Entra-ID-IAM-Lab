# Sandbox Setup: Free Azure/AWS Environment for Identity Labs

This guide walks you through setting up a free sandbox environment to run all hands-on labs without risking production systems or incurring charges.

**Total Setup Time:** 30-45 minutes
**Cost:** $0 (free tier) for 90 days, then ~$50-100/month if you keep it running

---

## Option 1: Azure Free Tier (Recommended)

### Prerequisites
- Email address
- Credit card (won't be charged for 90 days)
- 30 minutes

### Step 1: Create Azure Account (5 minutes)

1. Go to: https://azure.microsoft.com/en-us/free/
2. Click "Start free"
3. Sign in with email or create Microsoft account
4. Verify with phone number
5. Agree to terms
6. Confirm payment method (credit card required but not charged)

**Result:** You now have:
- $200 free credits (valid 30 days)
- Free services for 12 months (VM, storage, Entra ID)
- After free tier: pay-as-you-go (~$50-100/month for labs)

### Step 2: Create Entra ID Tenant (5 minutes)

1. Go to: https://portal.azure.com
2. Search for "Entra ID" or "Azure Active Directory"
3. Click "Create" → "Create new tenant"
4. Choose "Azure AD"
5. Enter:
   - Organization name: `LabCompany` (or your choice)
   - Initial domain: `labcompany.onmicrosoft.com` (must be unique)
6. Click "Create"

**Result:** You now have an Entra ID instance for testing users, groups, policies

### Step 3: Create Test VM for On-Premises Simulation (10 minutes)

For hybrid identity lab, you need a VM to simulate on-premises Active Directory.

1. Go to: https://portal.azure.com
2. Search for "Virtual machines"
3. Click "Create" → "Azure virtual machine"
4. Configure:
   - **Resource group:** Create new: `iam-labs-rg`
   - **VM name:** `on-prem-ad` (simulates on-premises AD)
   - **Image:** Windows Server 2019 (free tier eligible)
   - **Size:** Standard_B2s (free tier $0.05/hour, ~$30/month)
   - **Username:** `labadmin`
   - **Password:** Create strong password (you'll need this)
5. Click "Review + create" → "Create"

**Result:** You have a Windows Server VM ready for Active Directory setup

Wait 5-10 minutes for VM to deploy.

### Step 4: Install Active Directory (15 minutes)

Once VM is deployed:

1. Connect to VM using RDP (Remote Desktop)
   - In Azure Portal, find VM
   - Click "Connect" → "RDP" → "Download RDP file"
   - Open RDP file, sign in with `labadmin` + password
2. Open PowerShell as Administrator
3. Run these commands:

```powershell
# Install Active Directory Domain Services
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Promote server to domain controller
Import-Module ADDSDeployment
Install-ADDSForest `
  -DomainName "labcompany.local" `
  -DomainNetBIOSName "LABCOMPANY" `
  -ForestMode "WinThreshold" `
  -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText -Force -String "SafeMode123!") `
  -Confirm:$false `
  -NoReboot:$false
```

VM will reboot. Wait 5 minutes.

**Result:** You have on-premises Active Directory running at `labcompany.local`

### Step 5: Verify Setup (5 minutes)

1. Go to Azure Portal
2. Verify you can see:
   - ✅ Entra ID tenant: `LabCompany` with domain `labcompany.onmicrosoft.com`
   - ✅ VM running: `on-prem-ad` (IP address visible)
   - ✅ Storage account created automatically for OS disk

**Checkpoint:** Azure sandbox complete. Cost so far: $0.

---

## Option 2: AWS Free Tier (Alternative)

### Prerequisites
- AWS account (https://aws.amazon.com/free)
- Email address
- 20 minutes
- Note: AWS doesn't include Entra ID equivalent; use Okta (free tier available) or simulate identity concepts

### Step 1: Create AWS Account (5 minutes)

1. Go to: https://aws.amazon.com/free/
2. Click "Create a free account"
3. Enter email, password, AWS account name
4. Verify email
5. Add payment method (won't be charged for 12 months)

**Result:** Free tier: 1 year free, 750 hours/month EC2, 5GB storage

### Step 2: Launch EC2 Instance (5 minutes)

1. Go to: https://console.aws.amazon.com
2. Go to EC2 → Instances → Launch instance
3. Choose:
   - **AMI:** Ubuntu Server 22.04 LTS (free tier eligible)
   - **Instance type:** t2.micro (free tier eligible, 0.8GB RAM)
   - **Storage:** 30GB (free tier)
4. Click "Launch"
5. Create key pair: name `iam-labs`, download `.pem` file (save it!)

**Result:** EC2 instance running with Ubuntu. Cost: $0/month (free tier).

### Step 3: Install Identity Tools (10 minutes)

Connect to instance and install:

```bash
# SSH into instance (or use EC2 Instance Connect in console)
ssh -i iam-labs.pem ubuntu@<instance-ip>

# Update system
sudo apt update && sudo apt upgrade -y

# Install LDAP (simulates directory)
sudo apt install -y slapd ldap-utils

# Install Keycloak (open-source identity provider)
sudo apt install -y default-jre-headless
wget https://github.com/keycloak/keycloak/releases/download/21.1.1/keycloak-21.1.1.tar.gz
tar -xzf keycloak-21.1.1.tar.gz
```

Start Keycloak:
```bash
cd keycloak-21.1.1/bin
./kc.sh start-dev
```

**Result:** Keycloak running at `http://<instance-ip>:8080`

---

## Cost Estimates

### Azure Setup

| Resource | Free Tier | Pay-As-You-Go Monthly |
|----------|-----------|----------------------|
| Entra ID | Free (unlimited) | Free (unlimited) |
| VM (Standard_B2s) | $200 credits (30 days) | $30-50 |
| Storage (100GB) | 5GB free | $2-5 |
| Data transfer | 1GB free | ~$0.10 per GB |
| **Total** | **$0 for 30 days** | **$50-100/month** |

### AWS Setup

| Resource | Free Tier | Pay-As-You-Go Monthly |
|----------|-----------|----------------------|
| EC2 t2.micro | 750 hours/month | $10-15 |
| Storage (30GB) | 30GB free | $0.50-1 |
| Data transfer | 15GB free | $0.10 per GB |
| **Total** | **$0 for 12 months** | **$15-25/month** |

**To minimize costs:**
- Delete resources after labs (delete VM = $0 cost)
- Stop (don't delete) VM between uses (~$2/month for storage)
- Use Azure free tier first (more generous than AWS)

---

## Lab Environment Checklist

After setup, verify you have:

### Azure Setup
- [ ] Azure subscription active
- [ ] Entra ID tenant created (`labcompany.onmicrosoft.com`)
- [ ] Windows Server VM deployed (`on-prem-ad`)
- [ ] Active Directory installed on VM
- [ ] Can RDP into VM successfully
- [ ] Can sign in to Azure Portal
- [ ] Free credits showing in Azure Portal (Settings → Subscriptions)

### AWS Setup (if using)
- [ ] AWS account created
- [ ] EC2 instance running (Ubuntu)
- [ ] Can SSH into instance
- [ ] Keycloak installed and running
- [ ] Can access Keycloak console (http://<ip>:8080)

---

## Next Steps

1. **Verify connectivity:** Ping on-prem AD from cloud
2. **Run Lab 1:** Follow `QUICKSTART_LABS.md` for first hands-on
3. **Monitor costs:** Check Azure/AWS portal monthly

---

## Cleanup (Save Money Later)

When finished with labs, delete resources:

### Azure Cleanup
```powershell
# Delete all resources in resource group
az group delete --name iam-labs-rg --yes

# Delete Entra ID tenant (if desired)
# Go to Azure Portal → Entra ID → Delete tenant
```

### AWS Cleanup
```bash
# Terminate EC2 instance
aws ec2 terminate-instances --instance-ids <instance-id> --region us-east-1

# Delete security group, key pair if desired
```

**Result:** Costs drop to $0.

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "Credit card declined" | Use different card; try clearing browser cache |
| "Cannot connect to VM" | Check Network Security Group (NSG) allows RDP (port 3389) |
| "Active Directory installation fails" | Reboot VM and retry; ensure VM has 4GB RAM |
| "Keycloak won't start" | Check Java installed (`java -version`); check port 8080 not in use |
| "Sandbox costs too much" | Delete unused resources; AWS is cheaper than Azure for long-term |

---

## What's Included After Setup

You now have:
- ✅ Cloud identity system (Entra ID or Keycloak)
- ✅ On-premises simulation (Windows AD or LDAP)
- ✅ Network connectivity between cloud ↔ on-premises
- ✅ Ready for all hands-on labs

**Estimated cost: $0 for first 30-90 days, then $15-100/month depending on which platform you choose**

Next: Follow `QUICKSTART_LABS.md` to start your first lab.
