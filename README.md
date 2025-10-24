# 🚀 Deploying a Solution with Multiple Function Apps to Azure

This repository demonstrates how to deploy a solution with multiple function apps into separate Azure Function App services using the power of GitHub Actions.

The solution can be opened with Visual Studio 2022 or Visual Studio Code and it includes 3 sample function app projects (Liquid, Solid, and Solidus) written in C# and .NET 8.0.

## 💻 Usage

Feel free to explore the code, configuration files, and GitHub Actions workflows in this repository. Use them as references or starting points for your own deployments with multiple function apps.

## ⚙️ GitHub Actions

#### 🔄 Deploy All Functions to Azure

This action automates the process of building and deploying the three function app projects in the solution to Azure. Optionally, it updates the API Management API endpoints definition based on the projects' configuration using OpenAPI.

Workflow file: [deploy_all_functions.yml](.github/workflows/deploy_all_functions.yml)

[![Deploy All Functions to Azure](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_all_functions.yml/badge.svg)](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_all_functions.yml)

#### 🌊 Deploy Liquid Functions to Azure

This action builds and deploys the Liquid functions app project to Azure. Optionally, it updates the API endpoints definition based on the project configuration (HTTP Trigger with OpenAPI).

Workflow file: [deploy_liquid_functions.yml](.github/workflows/deploy_liquid_functions.yml)

[![Deploy Liquid Functions to Azure](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_liquid_functions.yml/badge.svg)](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_liquid_functions.yml)

#### 🪨 Deploy Solid Functions to Azure

This action builds and deploys the Solid functions app project to Azure. Optionally, it updates the API endpoints definition based on the project configuration (HTTP Trigger with OpenAPI).

Workflow file: [deploy_solid_functions.yml](.github/workflows/deploy_solid_functions.yml)

[![Deploy Solid Functions to Azure](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_solid_functions.yml/badge.svg)](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_solid_functions.yml)

#### 🛡️ Deploy Solidus Functions to Azure

This action builds and deploys the Solidus functions app project to Azure. Optionally, it updates the API endpoints definition based on the project configuration (HTTP Trigger with OpenAPI).

Workflow file: [deploy_solidus_functions.yml](.github/workflows/deploy_solidus_functions.yml)

[![Deploy Solidus Functions to Azure](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_solidus_functions.yml/badge.svg)](https://github.com/panchosoft/DeployMultipleFunctions/actions/workflows/deploy_solidus_functions.yml)

## 🤝 Contributing

Contributions, suggestions, and bug reports are welcome! Please open an issue or submit a pull request if you have any feedback or improvements to share.

## 📄 License

This project is licensed under the MIT License, allowing you to freely use, modify, and distribute the code provided here. See the LICENSE file for more details.
