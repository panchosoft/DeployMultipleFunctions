@description('Name of the Resource Group')
param rgName string

@description('Location for the resources')
param location string = resourceGroup().location

@description('Environment for the deployment (e.g., dev, prod)')
param environment string = 'dev'

@description('Name of the API Management service')
param apimName string = 'apim-mgs-${environment}'

@description('Sku for API Management')
param apimSku string = 'Developer'

@description('Function App name for Solid')
param functionAppNameSolid string = 'fn-solid-${environment}'

@description('Function App name for Liquid')
param functionAppNameLiquid string = 'fn-liquid-${environment}'

@description('Function App name for Solidus')
param functionAppNameSolidus string = 'fn-solidus-${environment}'

@description('App Service plan for the Function Apps')
param appServicePlanName string = 'asp-functions-${environment}'

@description('Sku for App Service Plan')
param appServicePlanSku string = 'Y1' // Use 'Y1' for Consumption, or 'F1' for Free

@description('Storage account name for Function Apps')
param storageAccountName string = 'safunctionsdemo${environment}'

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

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku
  }
  kind: 'functionapp'
}

resource functionAppSolid 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppNameSolid
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, '2022-09-01').keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, '2022-09-01').keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: functionAppNameSolid
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4' // Azure Functions runtime version 4.x (supports .NET 8)
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet' // Specifies the .NET runtime
        }
      ]
      netFrameworkVersion: 'v8.0' // Use .NET 8 runtime
      use32BitWorkerProcess: false // Use 64-bit worker process for better performance
    }
    clientAffinityEnabled: false
  }
  kind: 'functionapp'
}

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
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, '2022-09-01').keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, '2022-09-01').keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: functionAppNameLiquid
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4' // Azure Functions runtime version 4.x (supports .NET 8)
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet' // Specifies the .NET runtime
        }
      ]
      netFrameworkVersion: 'v8.0' // Use .NET 8 runtime
      use32BitWorkerProcess: false // Use 64-bit worker process for better performance
    }
    clientAffinityEnabled: false
  }
  kind: 'functionapp'
}

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
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, '2022-09-01').keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, '2022-09-01').keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: functionAppNameSolidus
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4' // Azure Functions runtime version 4.x (supports .NET 8)
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet' // Specifies the .NET runtime
        }
      ]
      netFrameworkVersion: 'v8.0' // Use .NET 8 runtime
      use32BitWorkerProcess: false // Use 64-bit worker process for better performance
    }
    clientAffinityEnabled: false
  }
  kind: 'functionapp'
}

resource apiManagement 'Microsoft.ApiManagement/service@2022-09-01-preview' = {
  name: apimName
  location: location
  sku: {
    name: apimSku
    capacity: 1
  }
  properties: {
    publisherEmail: 'admin@panchosoft.com'
    publisherName: 'The Boss'
  }
}
