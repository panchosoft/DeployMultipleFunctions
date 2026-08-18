# Deploy Multiple Functions to Azure

Deploy multiple independent Azure Function Apps from a single repository using GitHub Actions and Bicep.

[![Deploy All Functions to Azure](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_all_functions.yml/badge.svg)](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_all_functions.yml)
![.NET](https://img.shields.io/badge/.NET-10.0-512BD4?logo=dotnet)
![Azure Functions](https://img.shields.io/badge/Azure%20Functions-v4-0062AD?logo=azurefunctions)
![License: MIT](https://img.shields.io/badge/license-MIT-green)

## Overview

This repository demonstrates a pattern for deploying **multiple, independently deployable Azure Function Apps** from a single solution. It includes three sample HTTP-triggered function apps — **Liquid**, **Solid**, and **Solidus** — each with its own OpenAPI specification, and shows how to:

- Provision shared Azure infrastructure (Function Apps, App Service Plan, Storage Account, API Management) with Bicep
- Build and deploy each function app independently, or all at once, via GitHub Actions
- Publish OpenAPI definitions to API Management automatically on deployment

## Table of Contents

- [Repository Structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Infrastructure Deployment](#infrastructure-deployment)
- [CI/CD Workflows](#cicd-workflows)
- [Contributing](#contributing)
- [License](#license)

## Repository Structure

| Path | Description |
|---|---|
| `LiquidFunctions/` | HTTP-triggered function app with OpenAPI support |
| `SolidFunctions/` | HTTP-triggered function app with OpenAPI support |
| `SolidusFunctions/` | HTTP-triggered function app with OpenAPI support |
| `Infrastructure/` | Bicep templates for provisioning Azure resources |
| `.github/workflows/` | GitHub Actions workflows for CI/CD |

Each function app is a fully independent .NET project with its own dependencies, `host.json`, and `local.settings.json`, and can be built, run, and deployed on its own.

## Prerequisites

- [.NET 10.0 SDK](https://dotnet.microsoft.com/download)
- [Azure Functions Core Tools v4](https://learn.microsoft.com/azure/azure-functions/functions-run-local)
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
- [Azurite](https://learn.microsoft.com/azure/storage/common/storage-use-azurite) or an Azure Storage account, for local development
- Visual Studio 2026 or Visual Studio Code (with the Azure Functions extension)

## Getting Started

### Build

```bash
dotnet build SolidFunctions/SolidFunctions.csproj
dotnet build LiquidFunctions/LiquidFunctions.csproj
dotnet build SolidusFunctions/SolidusFunctions.csproj
```

Or, in VS Code, run the **"build all"** task from the Command Palette (`Tasks: Run Build Task`).

### Configure local settings

Each function app needs a `local.settings.json` file:

```json
{
  "IsEncrypted": false,
  "Values": {
    "FUNCTIONS_WORKER_RUNTIME": "dotnet-isolated",
    "AzureWebJobsStorage": "UseDevelopmentStorage=true"
  }
}
```

### Run locally

Each function app runs on its own port so all three can be started side by side:

```bash
# SolidFunctions — port 7071 (default)
cd SolidFunctions/bin/Debug/net10.0
func host start

# LiquidFunctions — port 7072
cd LiquidFunctions/bin/Debug/net10.0
func host start --port 7072

# SolidusFunctions — port 7073
cd SolidusFunctions/bin/Debug/net10.0
func host start --port 7073
```

Or run the VS Code task **"start all functions"** to launch all three at once.

## Infrastructure Deployment

Azure resources are defined in [`Infrastructure/main.bicep`](Infrastructure/main.bicep):

- 3 Azure Function Apps (one per function project)
- 1 shared App Service Plan
- 1 shared Storage Account
- 1 API Management service (optional, for OpenAPI endpoints)

Deploy with the Azure CLI:

```bash
cd Infrastructure
az deployment group create \
  --resource-group <ResourceGroupName> \
  --template-file main.bicep \
  --parameters environment=dev location=eastus
```

See [`Infrastructure/README.md`](Infrastructure/README.md) for validation steps and additional details.

## CI/CD Workflows

| Workflow | Description | Status |
|---|---|---|
| [`create_azure_resources.yml`](.github/workflows/create_azure_resources.yml) | Validates and deploys the Bicep infrastructure | — |
| [`deploy_all_functions.yml`](.github/workflows/deploy_all_functions.yml) | Builds and deploys all three function apps | [![Deploy All Functions to Azure](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_all_functions.yml/badge.svg)](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_all_functions.yml) |
| [`deploy_liquid_functions.yml`](.github/workflows/deploy_liquid_functions.yml) | Builds and deploys LiquidFunctions | [![Deploy Liquid Functions to Azure](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_liquid_functions.yml/badge.svg)](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_liquid_functions.yml) |
| [`deploy_solid_functions.yml`](.github/workflows/deploy_solid_functions.yml) | Builds and deploys SolidFunctions | [![Deploy Solid Functions to Azure](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_solid_functions.yml/badge.svg)](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_solid_functions.yml) |
| [`deploy_solidus_functions.yml`](.github/workflows/deploy_solidus_functions.yml) | Builds and deploys SolidusFunctions | [![Deploy Solidus Functions to Azure](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_solidus_functions.yml/badge.svg)](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_solidus_functions.yml) |

Each deploy workflow builds with `dotnet build --configuration Release --output ./output`, publishes to Azure using the Azure Functions Action, and can optionally sync the API Management definition from the app's `/api/openapi/v3.json` endpoint.

## Contributing

Contributions, suggestions, and bug reports are welcome. Please open an issue or submit a pull request with your feedback or improvements.

## License

This project is licensed under the MIT License.
