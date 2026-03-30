# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Azure Functions solution demonstrating deployment of multiple independent function apps to separate Azure Function App services. The solution contains three function apps (Liquid, Solid, and Solidus), each deployed as a separate Azure resource.

## Technology Stack

- **Runtime**: .NET 8.0
- **Azure Functions**: v4 runtime
- **Infrastructure**: Azure Bicep (Infrastructure as Code)
- **Deployment**: GitHub Actions
- **API Documentation**: OpenAPI/Swagger via Microsoft.Azure.WebJobs.Extensions.OpenApi

## Repository Structure

The repository contains three independent function app projects:
- `LiquidFunctions/` - HTTP-triggered function with OpenAPI support
- `SolidFunctions/` - HTTP-triggered function with OpenAPI support
- `SolidusFunctions/` - HTTP-triggered function with OpenAPI support

Each function app is a separate .NET project with its own `.csproj` file and can be built, run, and deployed independently.

## Local Development

### Building

Build individual function apps:
```bash
dotnet build SolidFunctions/SolidFunctions.csproj
dotnet build LiquidFunctions/LiquidFunctions.csproj
dotnet build SolidusFunctions/SolidusFunctions.csproj
```

Build all function apps using VS Code task:
```bash
# Use VS Code Command Palette -> Run Build Task -> "build all"
```

### Running Locally

Start individual function apps with Azure Functions Core Tools:
```bash
# SolidFunctions (default port 7071)
cd SolidFunctions/bin/Debug/net8.0
func host start

# LiquidFunctions (port 7072)
cd LiquidFunctions/bin/Debug/net8.0
func host start --port 7072

# SolidusFunctions (port 7073)
cd SolidusFunctions/bin/Debug/net8.0
func host start --port 7073
```

Or use VS Code task "start all functions" to run all three simultaneously on different ports.

### Local Settings

Each function app requires a `local.settings.json` file with:
- `FUNCTIONS_WORKER_RUNTIME`: Set to "dotnet-isolated"
- `AzureWebJobsStorage`: For local development, use "UseDevelopmentStorage=true" (requires Azurite or Azure Storage Emulator)

## Infrastructure Deployment

Azure resources are defined in `Infrastructure/main.bicep` and include:
- 3 Azure Function Apps (one for each function project)
- 1 App Service Plan (shared across function apps)
- 1 Storage Account (shared)
- 1 API Management service (optional, for OpenAPI endpoints)

Deploy infrastructure using Azure CLI:
```bash
cd Infrastructure
az deployment group create \
  --resource-group <ResourceGroupName> \
  --template-file main.bicep \
  --parameters environment=dev location=eastus
```

## GitHub Actions Deployment

The repository includes automated deployment workflows in `.github/workflows/`:

- `deploy_all_functions.yml` - Deploys all three function apps in parallel
- `deploy_liquid_functions.yml` - Deploys only LiquidFunctions
- `deploy_solid_functions.yml` - Deploys only SolidFunctions
- `deploy_solidus_functions.yml` - Deploys only SolidusFunctions
- `create_azure_resources.yml` - Creates Azure infrastructure using Bicep

All deployment workflows:
1. Build the function app(s) using `dotnet build --configuration Release --output ./output`
2. Deploy to Azure using the Azure Functions Action
3. Optionally update API Management with OpenAPI definitions from `/api/openapi/v3.json` endpoint

## Architecture Notes

### Multi-Function App Pattern

This solution demonstrates deploying multiple function apps from a single repository. Each function app:
- Has its own Azure Function App resource in Azure
- Can be deployed independently via separate GitHub Actions workflows
- Shares the same App Service Plan and Storage Account (defined in Bicep)
- Exposes its own OpenAPI specification endpoint
- Can be optionally fronted by Azure API Management with different paths

### Function App Independence

Each function app project is completely independent:
- Separate namespaces (LiquidFunctions, DeployMultipleFunctions for Solid, SolidusFunctions)
- Own set of dependencies in `.csproj`
- Own host.json and local.settings.json configurations
- Can be developed and tested in isolation

When modifying one function app, there's no need to rebuild or redeploy the others unless you're using the "deploy all" workflow.

### VS Code Configuration

The `.vscode/settings.json` has `azureFunctions.projectSubpath` set to "SolidFunctions" - this means Azure Functions extension commands default to that project. When working with LiquidFunctions or SolidusFunctions, you may need to adjust this setting or use the tasks in `tasks.json` that target specific projects.
