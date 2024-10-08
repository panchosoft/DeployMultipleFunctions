// Parameter to specify the location of the resources. Defaults to the resource group's location.
@description('Location for the resources')
param location string = resourceGroup().location

// Parameter to specify the environment for the deployment (e.g., dev, prod). Defaults to 'dev'.
@description('Environment for the deployment (e.g., dev, prod)')
param environment string = 'dev'

// Parameter to specify the name of the API Management service, with an environment-based suffix.
@description('Name of the API Management service')
param apimName string = 'apim-mgs-${environment}'

// Parameter to specify the SKU (pricing tier) for the API Management service. Defaults to 'Developer'.
@description('Sku for API Management')
param apimSku string = 'Developer'

// Parameter to specify the name of the first Function App (Solid), with an environment-based suffix.
@description('Function App name for Solid')
param functionAppNameSolid string = 'fn-solid-${environment}'

// Parameter to specify the name of the second Function App (Liquid), with an environment-based suffix.
@description('Function App name for Liquid')
param functionAppNameLiquid string = 'fn-liquid-${environment}'

// Parameter to specify the name of the third Function App (Solidus), with an environment-based suffix.
@description('Function App name for Solidus')
param functionAppNameSolidus string = 'fn-solidus-${environment}'

// Parameter to specify the name of the App Service Plan that will host the Function Apps, with an environment-based suffix.
@description('App Service plan for the Function Apps')
param appServicePlanName string = 'asp-functions-${environment}'

// Parameter to specify the SKU (pricing tier) for the App Service Plan. Defaults to 'Y1' for Consumption plan.
@description('Sku for App Service Plan')
param appServicePlanSku string = 'Y1' // Use 'Y1' for Consumption, or 'F1' for Free

// Parameter to specify the name of the storage account used by the Function Apps, with an environment-based suffix.
@description('Storage account name for Function Apps')
param storageAccountName string = 'safunctionsdemo${environment}'

// Resource declaration for a storage account with standard locally-redundant storage (LRS) in the specified location.
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

// Resource declaration for an App Service Plan to host the Function Apps, using the specified SKU.
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku
  }
  kind: 'functionapp'
}

// Resource declaration for the Solid Function App, with application settings configured to connect to the storage account.
resource functionAppSolid 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppNameSolid
  location: location
  properties: {
    serverFarmId: appServicePlan.id // Link to the App Service Plan
    httpsOnly: true // Enforce HTTPS only
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: functionAppNameSolid // Content share for the function app
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4' // Azure Functions runtime version 4.x (supports .NET 8)
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet' // Specifies the .NET runtime
        }
        {
          name: 'FUNCTIONS_INPROC_NET8_ENABLED'
          value: '1' // Enable in-process mode
        }
      ]
      netFrameworkVersion: 'v8.0' // Use .NET 8 runtime
      use32BitWorkerProcess: false // Use 64-bit worker process for better performance
    }
    clientAffinityEnabled: false // Disable client affinity for load balancing
  }
  kind: 'functionapp'
}

// Resource declaration for the Liquid Function App, with similar configuration as the Solid Function App.
resource functionAppLiquid 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppNameLiquid
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: functionAppNameLiquid // Content share for the function app
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4' // Azure Functions runtime version 4.x (supports .NET 8)
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet' // Specifies the .NET runtime
        }
        {
          name: 'FUNCTIONS_INPROC_NET8_ENABLED'
          value: '1' // Enable in-process mode
        }
      ]
      netFrameworkVersion: 'v8.0' // Use .NET 8 runtime
      use32BitWorkerProcess: false // Use 64-bit worker process for better performance
    }
    clientAffinityEnabled: false // Disable client affinity for load balancing
  }
  kind: 'functionapp'
}

// Resource declaration for the Solidus Function App, with similar configuration as the Solid and Liquid Function Apps.
resource functionAppSolidus 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppNameSolidus
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: functionAppNameSolidus // Content share for the function app
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4' // Azure Functions runtime version 4.x (supports .NET 8)
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet' // Specifies the .NET runtime
        }
        {
          name: 'FUNCTIONS_INPROC_NET8_ENABLED'
          value: '1' // Enable in-process mode
        }
      ]
      netFrameworkVersion: 'v8.0' // Use .NET 8 runtime
      use32BitWorkerProcess: false // Use 64-bit worker process for better performance
    }
    clientAffinityEnabled: false // Disable client affinity for load balancing
  }
  kind: 'functionapp'
}

// Resource declaration for the API Management service, using the specified SKU and setting the publisher details.
resource apiManagement 'Microsoft.ApiManagement/service@2022-09-01-preview' = {
  name: apimName
  location: location
  sku: {
    name: apimSku
    capacity: 1
  }
  properties: {
    publisherEmail: 'admin@panchosoft.com' // Email of the API publisher
    publisherName: 'The Boss' // Name of the API publisher
  }
}
