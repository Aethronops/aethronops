# AethronOps — Open Source Dev Stacks

Ten free, MIT-licensed Terraform stacks for Azure, built on [Azure Verified Modules](https://azure.github.io/Azure-Verified-Modules/) and ready to `terraform apply` from your laptop. Each stack provisions a complete workload (web/API tier + database + Key Vault + monitoring + managed identity) with **public network access** so you can iterate fast on prototypes, demos, and learning environments.

These dev stacks are deliberately lean: no VNet, no Private Endpoints, no Backup Vault, no FinOps automation, no Defender plans, no resource locks. They are **for prototyping only** — do not use them in production.

Production-ready versions — VNet isolation, Private Endpoints, MCSB / CAF / WAF mappings, Backup Vault, FinOps automation, brownfield wiring on a shared Platform Baseline — are sold at **[aethronops.com](https://aethronops.com)**.

---

## Catalogue

| Stack ID | Description | Production version |
|---|---|---|
| `app-service-postgresql` | App Service + PostgreSQL Flexible Server, with dedicated Key Vault, Storage, Log Analytics, Application Insights, Backup Vault, and Managed Identity. Ideal for Django, Rails, Laravel, Next.js. | [aethronops.com/stacks/app-service-postgresql/](https://aethronops.com/stacks/app-service-postgresql/) |
| `app-service-sql` | App Service + Azure SQL Database, with dedicated Key Vault, Storage, Log Analytics, Application Insights, Backup Vault, and Managed Identity. Ideal for .NET, ASP.NET Core, Entity Framework. | [aethronops.com/stacks/app-service-sql/](https://aethronops.com/stacks/app-service-sql/) |
| `app-service-cosmosdb` | App Service + Azure Cosmos DB (NoSQL API), with dedicated Key Vault, Storage, Log Analytics, Application Insights, Backup Vault, and Managed Identity. Ideal for NoSQL, multi-region, real-time apps. | [aethronops.com/stacks/app-service-cosmosdb/](https://aethronops.com/stacks/app-service-cosmosdb/) |
| `app-service-mysql` | App Service + MySQL Flexible Server, with dedicated Key Vault, Storage, Log Analytics, Application Insights, Backup Vault, and Managed Identity. Ideal for WordPress, PHP, Drupal, Laravel. | [aethronops.com/stacks/app-service-mysql/](https://aethronops.com/stacks/app-service-mysql/) |
| `app-service-mongodb` | App Service + Azure DocumentDB (MongoDB vCore), with dedicated Key Vault, Storage, Log Analytics, Application Insights, Backup Vault, and Managed Identity. Compatible with any MongoDB framework (MEAN, MERN, Spring + Mongo). | [aethronops.com/stacks/app-service-mongodb/](https://aethronops.com/stacks/app-service-mongodb/) |
| `container-apps-postgresql` | Container App Environment + Container App + PostgreSQL Flexible Server, with dedicated Key Vault, Storage, Log Analytics, Application Insights, and Managed Identity. Ideal for containerised microservices in Node.js, Python, Go. | [aethronops.com/stacks/container-apps-postgresql/](https://aethronops.com/stacks/container-apps-postgresql/) |
| `container-apps-sql` | Container App Environment + Container App + Azure SQL Database, with dedicated Key Vault, Storage, Log Analytics, Application Insights, and Managed Identity. Ideal for containerised .NET, Java, Node.js workloads. | [aethronops.com/stacks/container-apps-sql/](https://aethronops.com/stacks/container-apps-sql/) |
| `container-apps-cosmosdb` | Container App Environment + Container App + Azure Cosmos DB (NoSQL API), with dedicated Key Vault, Storage, Log Analytics, Application Insights, and Managed Identity. Ideal for event-driven microservices and distributed apps. | [aethronops.com/stacks/container-apps-cosmosdb/](https://aethronops.com/stacks/container-apps-cosmosdb/) |
| `container-apps-mysql` | Container App Environment + Container App + MySQL Flexible Server, with dedicated Key Vault, Storage, Log Analytics, Application Insights, and Managed Identity. No built-in connection pooler — pool on the application side. | [aethronops.com/stacks/container-apps-mysql/](https://aethronops.com/stacks/container-apps-mysql/) |
| `container-apps-mongodb` | Container App Environment + Container App + Azure DocumentDB (MongoDB vCore), with dedicated Key Vault, Storage, Log Analytics, Application Insights, Backup Vault, and Managed Identity. Compatible with any MongoDB framework. | [aethronops.com/stacks/container-apps-mongodb/](https://aethronops.com/stacks/container-apps-mongodb/) |

---

## Quick start

Prerequisites:

- Terraform `>= 1.6`
- Azure CLI (`az login`) with **Owner** on the target subscription (Key Vault role assignments require it)
- An Azure subscription ID

```bash
# 1. Clone the catalogue
git clone https://github.com/Aethronops/aethronops.git
cd aethronops/stacks/app-service-postgresql   # pick any of the 10 stacks

# 2. Edit the dev variables (subscription_id and project_name are mandatory)
$EDITOR envs/dev.tfvars

# 3. Deploy
terraform init
terraform plan  -var-file=envs/dev.tfvars
terraform apply -var-file=envs/dev.tfvars
```

Required variables in `envs/dev.tfvars`:

- `subscription_id` — your Azure subscription GUID (`az account show --query id -o tsv`)
- `project_name` — short identifier, max 8 characters, lowercase + hyphens only (Key Vault name limit)

Other variables (region, runtime version, database SKU, retention, etc.) come with sensible dev defaults — adjust as needed. See each stack's `README.md` for full details.

To tear everything down:

```bash
terraform destroy -var-file=envs/dev.tfvars
```

---

## What's NOT in the dev version

The dev stacks in this repo are intentionally minimal. The following capabilities ship only with the paid production version on [aethronops.com](https://aethronops.com):

- **Network isolation** — VNet integration, dedicated subnets, NSGs, NAT Gateway, Route Tables
- **Private Endpoints** — Key Vault, Storage, database, App Service / Container Apps all locked to private DNS
- **Platform Baseline** — shared hub VNet, Redis cache, Log Analytics workspace, Backup Vault, Private DNS Zones, reused brownfield by every workload
- **Backup Vault** — long-term backup with `ImmutabilityState=Locked` and soft-delete
- **FinOps automation** — budgets, anomaly alerts, scheduled stop/start runbooks
- **Resource Locks** — `CanNotDelete` on production resource groups
- **Defender for Cloud plans** — Defender for App Service / SQL / Storage / Containers / Key Vault
- **Compliance mappings** — controls aligned with Microsoft Cloud Security Benchmark (MCSB), Cloud Adoption Framework (CAF), Well-Architected Framework (WAF), and traceability for GDPR / NIS2 readiness

If any of those are on your roadmap, head to **[aethronops.com](https://aethronops.com)**.

---

## Built on

These stacks delegate every Azure resource to official **Azure Verified Modules** (AVM) — Microsoft-curated, telemetry-disabled Terraform modules:

- `Azure/avm-res-resources-resourcegroup/azurerm`
- `Azure/avm-res-web-site/azurerm` (App Service plan + site)
- `Azure/avm-res-app-managedenvironment/azurerm` (Container App Environment)
- `Azure/avm-res-app-containerapp/azurerm`
- `Azure/avm-res-dbforpostgresql-flexibleserver/azurerm`
- `Azure/avm-res-dbformysql-flexibleserver/azurerm`
- `Azure/avm-res-sql-server/azurerm`
- `Azure/avm-res-documentdb-databaseaccount/azurerm` (Cosmos DB NoSQL)
- `Azure/avm-res-documentdb-mongocluster/azurerm` (MongoDB vCore)
- `Azure/avm-res-keyvault-vault/azurerm`
- `Azure/avm-res-managedidentity-userassignedidentity/azurerm`
- `Azure/avm-res-operationalinsights-workspace/azurerm` (Log Analytics)
- `Azure/avm-res-insights-component/azurerm` (Application Insights)

Provider constraints: `azurerm ~> 4.64`, `azapi ~> 2.4`. AVM telemetry is disabled (`enable_telemetry = false`) on every module call.

---

## License

This catalogue is released under the **MIT License** — see [LICENSE](./LICENSE).

The **AethronOps** brand, name, and logo are trademarks of **PROJECTYL SASU** and are **not** covered by the MIT license. You are free to fork, modify, and redistribute the code; please don't ship derivatives under the AethronOps name.

---

## Links

- Production catalogue: [aethronops.com](https://aethronops.com)
- Contact: [contact@aethronops.com](mailto:contact@aethronops.com)
- Issues: [github.com/Aethronops/aethronops/issues](https://github.com/Aethronops/aethronops/issues)
