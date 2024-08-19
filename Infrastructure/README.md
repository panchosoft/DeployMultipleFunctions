# 🚀 Azure Deployment with Bicep

This guide explains how to deploy Azure resources using a Bicep script.

## ✅ Prerequisites

- **Azure CLI** installed ([Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli))
- Logged in to Azure CLI: `az login`

## 🛠️ Steps

### 1. Clone the Repo

```bash
git clone <repository-url>
cd <repository-folder>
```

### 2. Validate the Bicep Script

Check for errors in the script:

```bash
az deployment group validate \
  --resource-group <ResourceGroupName> \
  --template-file main.bicep \
  --parameters rgName=<ResourceGroupName> location=<AzureRegion> environment=<EnvironmentName>
```
- Replace <ResourceGroupName> with the name of your resource group.
- Replace <AzureRegion> with the desired Azure region (e.g., eastus).
- Replace <EnvironmentName> with the deployment environment (e.g., dev, prod).

### 3. Deploy the Resources

Once validated, you can deploy the resources using the following command:

```bash
az deployment group create \
  --resource-group <ResourceGroupName> \
  --template-file main.bicep \
  --parameters rgName=<ResourceGroupName> \
               location=<AzureRegion> \
               environment=<EnvironmentName>
```

### 4. Verify Deployment

After deployment, verify that the resources have been created by navigating to the Azure Portal or using the Azure CLI:

```bash
az resource list --resource-group <ResourceGroupName>
```

### 🛠️ Troubleshooting

If you encounter any issues during the deployment, ensure that:

- You have sufficient permissions to create resources in the specified resource group.
- The parameter values are correctly provided.
- You are logged in to the correct Azure subscription.