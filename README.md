# AethronOps

**Production-ready Azure Terraform stacks with verifiable compliance proof.**

Built exclusively with [Azure Verified Modules (AVM)](https://azure.github.io/Azure-Verified-Modules/) — the official Microsoft-maintained Terraform modules.

---

### Why AethronOps?

- **Zero to production in 5 minutes** — `terraform init && terraform apply`, done
- **100% Azure Verified Modules** — no custom code, no community modules, no maintenance burden
- **3 tiers in every stack** — Basic (dev), Standard (production), Premium (enterprise) in a single ZIP
- **Compliance built-in** — CAF, WAF, MCSB, GDPR, NIS2 mappings with every stack
- **No access needed** — we never touch your Azure, your repo, or your credentials

### What's in every stack?

```
your-stack/
  basic/              # Dev/POC tier
  standard/           # Production tier
  premium/            # Enterprise tier (PE, Firewall, Backup, zone-redundancy)
  README.md           # Architecture guide
  COMPLIANCE.md       # Control mappings (MCSB, GDPR, NIS2, CAF, WAF)
  manifest.yaml       # Stack metadata
```

Each tier contains production-ready Terraform with:
- `terraform validate` PASSED
- `terraform plan` PASSED
- `checkov` 0 failed checks
- CAF naming convention applied
- Managed Identity (no credentials in code)
- Diagnostic settings to Log Analytics
- Key Vault for secrets management

---

## Stack Catalog

### Web Applications

| Stack | Description |
|-------|-------------|
| [App Service Web](stacks/appservice-web.md) | App Service with Key Vault, Managed Identity, Storage, and monitoring |
| [App Service + PostgreSQL](stacks/appservice-postgresql.md) | App Service with PostgreSQL Flexible Server and full wiring |
| [App Service + MySQL](stacks/appservice-mysql.md) | App Service with MySQL Flexible Server and full wiring |
| [App Service + Azure SQL](stacks/appservice-sql.md) | App Service with Azure SQL Database and full wiring |
| [App Service + Cosmos DB](stacks/appservice-cosmosdb.md) | App Service with Cosmos DB (NoSQL) and full wiring |
| [App Service HA](stacks/multi-region-ha.md) | High-availability App Service with Redis Cache, PostgreSQL, Front Door WAF |
| [API REST Starter](stacks/api-rest-starter.md) | App Service REST API with Key Vault, Storage, and network isolation |
| [API Gateway Platform](stacks/api-gateway-platform.md) | Azure API Management with App Service backend and monitoring |

### Serverless (Azure Functions)

| Stack | Description |
|-------|-------------|
| [Function App Baseline](stacks/function-app-baseline.md) | Azure Functions (Consumption Y1) with Key Vault, Storage, and monitoring |
| [Function App + PostgreSQL](stacks/function-app-postgresql.md) | Azure Functions with PostgreSQL Flexible Server |
| [Function App + MySQL](stacks/function-app-mysql.md) | Azure Functions with MySQL Flexible Server |
| [Function App + Azure SQL](stacks/function-app-sql.md) | Azure Functions with Azure SQL Database |
| [Function App + Cosmos DB](stacks/function-app-cosmosdb.md) | Azure Functions with Cosmos DB |
| [Serverless Full-Stack](stacks/serverless-fullstack.md) | Static Web App + Function App + Cosmos DB |
| [Static Web App](stacks/static-web-app.md) | Azure Static Web App for SPA and JAMstack |
| [Static Website](stacks/static-website.md) | Storage Account static site hosting |

### Container Apps

| Stack | Description |
|-------|-------------|
| [Container Apps Baseline](stacks/container-apps-baseline.md) | Container Apps Environment with Key Vault, Managed Identity, and monitoring |
| [Container Apps + PostgreSQL](stacks/container-app-postgresql.md) | Container Apps with PostgreSQL Flexible Server and full wiring |
| [Container Apps + MySQL](stacks/container-app-mysql.md) | Container Apps with MySQL Flexible Server and full wiring |
| [Container Apps + Azure SQL](stacks/container-app-sql.md) | Container Apps with Azure SQL Database and full wiring |
| [Container Apps + Cosmos DB](stacks/container-app-cosmosdb.md) | Container Apps with Cosmos DB (NoSQL) and full wiring |

### Kubernetes (AKS)

| Stack | Description |
|-------|-------------|
| [AKS Startup](stacks/aks-startup.md) | Lightweight AKS (Free tier) with ACR, VNet, Key Vault |
| [AKS Microservices](stacks/aks-microservices.md) | Multi-node-pool AKS optimized for microservices |
| [AKS Platform](stacks/aks-platform.md) | Enterprise AKS with private cluster, Azure Policy, Firewall, and GitOps |
| [Azure Container Registry](stacks/acr-registry.md) | Private ACR with geo-replication and vulnerability scanning |
| [Artifact Registry](stacks/artifact-registry.md) | ACR for container images, Helm charts, and OCI artifacts |

### Databases (PaaS)

| Stack | Description |
|-------|-------------|
| [PostgreSQL Private](stacks/postgresql-private.md) | PostgreSQL Flexible Server with Private Endpoints, Key Vault, and backup |
| [MySQL Private](stacks/mysql-private.md) | MySQL Flexible Server with Private Endpoints, Key Vault, and backup |
| [Azure SQL Private](stacks/sql-private.md) | Azure SQL Database with Private Endpoints, Key Vault, and backup |
| [Cosmos DB Baseline](stacks/cosmosdb-baseline.md) | Cosmos DB (NoSQL API) with Key Vault and network isolation |
| [Redis Cache App](stacks/redis-cache-app.md) | Azure Cache for Redis with App Service and monitoring |
| [Storage Baseline](stacks/storage-baseline.md) | Azure Storage Account with encryption, lifecycle policies, and PE |

### Database Admin Packs (PaaS only)

Brownfield monitoring and observability for **existing** Azure PaaS databases. These packs do NOT deploy the database — they add Log Analytics, diagnostic settings, alerts, and Key Vault on top.

| Stack | Description |
|-------|-------------|
| [DB Admin PostgreSQL](stacks/db-admin-postgresql.md) | Monitoring pack for existing PostgreSQL Flexible Server |
| [DB Admin MySQL](stacks/db-admin-mysql.md) | Monitoring pack for existing MySQL Flexible Server |
| [DB Admin Azure SQL](stacks/db-admin-sql.md) | Monitoring pack for existing Azure SQL Database |
| [DB Admin Cosmos DB](stacks/db-admin-cosmosdb.md) | Monitoring pack for existing Cosmos DB account |
| [DB Admin Redis](stacks/db-admin-redis.md) | Monitoring pack for existing Azure Cache for Redis |

### IaaS Databases (VM)

Self-managed databases on Azure VMs using **Azure Marketplace images** — no ISO download needed. Cloud-init auto-configures the database engine with HA and backup.

| Stack | Description |
|-------|-------------|
| [PostgreSQL on VM](stacks/vm-postgresql-iaas.md) | Ubuntu VM + PostgreSQL 17, 4 disks, Patroni HA, pgBackRest to Blob |
| [MySQL on VM](stacks/vm-mysql-iaas.md) | Ubuntu VM + MySQL 8.4 LTS, 4 disks, InnoDB Cluster HA, Percona XtraBackup |
| [SQL Server on VM](stacks/vm-sqlserver-iaas.md) | Official SQL Server Marketplace image, 5 disks, SQL IaaS Agent, PAYG/AHUB |

### Virtual Machines

| Stack | Description |
|-------|-------------|
| [VM Production](stacks/vm-production.md) | Production VM (Linux/Windows) with backup, monitoring, and update management |
| [VMSS Autoscale](stacks/vmss-autoscale.md) | VM Scale Set with autoscaling, Load Balancer, and monitoring |
| [Dev Jump Box](stacks/dev-jumpbox.md) | Secure jump box with Bastion access and Managed Identity |

### AI & Machine Learning

| Stack | Description |
|-------|-------------|
| [OpenAI Baseline](stacks/openai-baseline.md) | Azure OpenAI with Key Vault, Managed Identity, and monitoring |
| [RAG Baseline](stacks/rag-baseline.md) | RAG with Azure OpenAI + AI Search + Storage |
| [RAG + PostgreSQL (pgvector)](stacks/rag-postgresql.md) | RAG using PostgreSQL pgvector as vector store |
| [RAG + Azure SQL](stacks/rag-sql.md) | RAG using Azure SQL as vector store |
| [RAG + Cosmos DB](stacks/rag-cosmosdb.md) | RAG using Cosmos DB as vector store |
| [RAG Enterprise](stacks/rag-enterprise.md) | Enterprise RAG with full network isolation and Firewall |
| [Chatbot Enterprise](stacks/chatbot-enterprise.md) | OpenAI + AI Search + App Service chatbot |
| [AI Foundry Baseline](stacks/ai-foundry-baseline.md) | Azure AI Foundry (ML Workspace) with Key Vault and Storage |
| [AI Foundry Enterprise](stacks/ai-foundry-enterprise.md) | Enterprise AI Foundry with ACR, full network isolation, and Backup |
| [AI Multi-Service](stacks/ai-multiservice-baseline.md) | Azure AI Services (multi-service Cognitive Account) |
| [AI Data Platform](stacks/ai-data-platform.md) | Databricks + Data Factory + Synapse + ML Workspace |
| [AI Secure Regulated](stacks/ai-secure-regulated.md) | Fully isolated AI platform for regulated industries |
| [GenAI Private](stacks/genai-private-baseline.md) | Private generative AI with OpenAI + AI Search behind PE |
| [MLOps Platform](stacks/mlops-platform.md) | Azure ML with ACR, Key Vault, Storage, and monitoring |
| [Internal Knowledge Hub](stacks/internal-knowledge-hub.md) | RAG-based internal knowledge base |

### AI Cognitive Services

| Stack | Description |
|-------|-------------|
| [Vision Baseline](stacks/vision-baseline.md) | Azure AI Vision with Key Vault and monitoring |
| [Vision Video Analytics](stacks/vision-video-analytics.md) | Video analytics with AI Vision and Storage |
| [Speech Baseline](stacks/speech-baseline.md) | Azure AI Speech with Key Vault and monitoring |
| [Speech Call Center](stacks/speech-call-center.md) | Call center analytics with AI Speech and Communication Services |
| [NLP Language](stacks/nlp-language-baseline.md) | Azure AI Language with Key Vault and monitoring |
| [NLP Translator](stacks/nlp-translator-baseline.md) | Azure AI Translator with Key Vault and monitoring |
| [Document Intelligence](stacks/document-intelligence-baseline.md) | Azure AI Document Intelligence (Form Recognizer) |
| [Document Intelligence Pipeline](stacks/document-intelligence-pipeline.md) | Document processing pipeline with Logic App |
| [Knowledge Mining](stacks/knowledge-mining-baseline.md) | Azure AI Search with Cognitive Skills and Storage |
| [Content Safety](stacks/content-safety-platform.md) | Azure AI Content Safety with OpenAI integration |

### Networking

| Stack | Description |
|-------|-------------|
| [Hub-Spoke Network](stacks/hub-spoke-network.md) | Classic hub-spoke network topology |
| [Spoke Workload](stacks/spoke-workload.md) | Spoke VNet for workloads in hub-spoke topology |
| [Platform Connectivity](stacks/platform-connectivity.md) | CAF hub VNet with Firewall, Bastion, DNS, and DDoS Protection |

### Landing Zones & Governance

| Stack | Description |
|-------|-------------|
| [Landing Zone PME](stacks/landingzone-pme.md) | Simplified landing zone for SMBs, cost-optimized |
| [Landing Zone Foundation](stacks/landing-zone-fondation.md) | CAF-aligned foundation landing zone |
| [Landing Zone Enterprise](stacks/landing-zone-entreprise.md) | CAF enterprise landing zone with hub-spoke, Firewall, Bastion, Policy |
| [Governance Baseline](stacks/governance-baseline.md) | Azure governance with Policy assignments, budgets, and monitoring |
| [Governance Subscription](stacks/governance-subscription.md) | Subscription-level governance with RBAC, budgets, and Defender |
| [Governance Organization](stacks/governance-organization.md) | Organization-wide governance with Management Groups and Policy |

### Platform & Operations

| Stack | Description |
|-------|-------------|
| [Platform Management](stacks/platform-management.md) | CAF management with Log Analytics, Automation, and monitoring |
| [Monitoring Platform](stacks/monitoring-platform.md) | Centralized monitoring with Log Analytics and Application Insights |
| [Operations Management](stacks/ops-management.md) | Automation Account, Backup Vault, Logic App, and monitoring |
| [CI/CD Runners](stacks/cicd-runners.md) | Self-hosted CI/CD runners on Azure VMs |
| [Sentinel SOC](stacks/sentinel-soc-baseline.md) | Microsoft Sentinel SIEM with data connectors and analytics rules |

### Event & Messaging

| Stack | Description |
|-------|-------------|
| [Event Streaming](stacks/event-streaming.md) | Azure Event Hub with Storage and monitoring |
| [Event-Driven Platform](stacks/event-driven-platform.md) | Event Hub + Service Bus + Function App |

### Data & Analytics

| Stack | Description |
|-------|-------------|
| [Data Platform Baseline](stacks/data-platform-baseline.md) | Data Factory + Databricks/Synapse + Data Lake |
| [Secure Data Pipeline](stacks/secure-data-pipeline.md) | Data Factory + Data Lake behind Private Endpoints |

### Compliance & Regulated Industries

| Stack | Description |
|-------|-------------|
| [FinTech PCI-DSS](stacks/fintech-pci-baseline.md) | Hardened App Service + PostgreSQL with Firewall, Bastion, Front Door WAF |
| [Healthcare HDS](stacks/healthcare-hds.md) | Infrastructure aligned with HDS requirements |
| [SaaS Multi-Tenant](stacks/saas-multitenant.md) | Multi-tenant SaaS with App Service, Azure SQL, Front Door |

### Desktop & End-User

| Stack | Description |
|-------|-------------|
| [Azure Virtual Desktop](stacks/avd-enterprise.md) | AVD with host pools, FSLogix, scaling plan, and Shared Image Gallery |
| [Shared Image Gallery](stacks/shared-image-gallery.md) | Azure Compute Gallery for custom VM images |

---

### Compliance Frameworks

Every stack includes documented control mappings for:

| Framework | Scope |
|-----------|-------|
| **CAF** | Cloud Adoption Framework — naming, tagging, resource organization |
| **WAF** | Well-Architected Framework — Security, Reliability, Cost, Operations, Performance |
| **MCSB** | Microsoft Cloud Security Benchmark v1 — 60+ security controls |
| **GDPR** | General Data Protection Regulation — Art. 25, 30, 32, 33 |
| **NIS2** | Network and Information Security Directive — Art. 21(2) measures |
| **DORA** | Digital Operational Resilience Act (financial services stacks) |

### How it works

```
1. Choose your stack          (e.g. "App Service + PostgreSQL")
2. Pick your tier             (Basic / Standard / Premium)
3. Set your project name      (e.g. "myapp")
4. terraform init && apply    (5 minutes, done)
```

### Built with

- [Azure Verified Modules (AVM)](https://azure.github.io/Azure-Verified-Modules/) — official Microsoft Terraform modules
- [Terraform](https://www.terraform.io/) — infrastructure as code
- [Checkov](https://www.checkov.io/) — static analysis for compliance

---

**[Browse all stacks on aethronops.com](https://aethronops.com)**
