# AethronOps — Stack Catalog

**78 production-ready Azure infrastructure stacks** built on [Azure Verified Modules (AVM)](https://azure.github.io/Azure-Verified-Modules/).

Every stack ships with:

- All module dependencies resolved and tested (`terraform plan` verified, Checkov: 0 failed)
- Managed Identity on every resource (no credentials in code)
- Diagnostic settings to Log Analytics on every resource
- Key Vault for secrets management
- Security posture report (SECURITY-POSTURE.md) mapping resources to CAF, WAF, MCSB, GDPR and NIS2
- 3 tiers (Basic / Standard / Premium) — pick the security level that matches your environment

### Free Stacks

Download these 5 stacks for free — no account needed:

| Stack | Description |
|-------|-------------|
| [Governance Organization](governance-organization.md) | Management Groups, Policy initiatives, and centralized monitoring for multi-subscription Azure estates. |
| [Governance Subscription](governance-subscription.md) | Subscription-level governance with Policy assignments, RBAC, budgets, and diagnostic settings. |
| [Platform Management](platform-management.md) | Log Analytics, Automation Account, and centralized monitoring. |
| [Storage Baseline](storage-baseline.md) | Azure Storage Account with Key Vault and monitoring. |
| [Static Web App](static-web-app.md) | Azure Static Web App for SPA and JAMstack with Key Vault, Storage, and monitoring. |

### Why AethronOps exists

AVM modules are great — but wiring them together is the hard part. Each module has its own interface, naming conventions, version constraints, and dependency chain. Getting 40–100+ resources to work together with proper network isolation, identity, monitoring, and secrets management takes days of engineering work.

We did that work once. You deploy in minutes.

### Web Applications

| Stack | Description |
|-------|-------------|
| [App Service Web](appservice-web.md) | Azure App Service for web applications with Key Vault, Storage, and monitoring. |
| [App Service + PostgreSQL](appservice-postgresql.md) | Azure App Service with PostgreSQL Flexible Server, Key Vault, Storage, and monitoring. |
| [App Service + MySQL](appservice-mysql.md) | Azure App Service with MySQL Flexible Server, Key Vault, Storage, and monitoring. |
| [App Service + Azure SQL](appservice-sql.md) | Azure App Service with Azure SQL Database, Key Vault, Storage, and monitoring. |
| [App Service + Cosmos DB](appservice-cosmosdb.md) | Azure App Service with Cosmos DB (NoSQL), Key Vault, Storage, and monitoring. |
| [API REST Starter](api-rest-starter.md) | App Service hosting a REST API with Key Vault, Storage, and monitoring. |
| [API Gateway Platform](api-gateway-platform.md) | Azure API Management with App Service backend, Key Vault, and monitoring. |

### Serverless (Azure Functions)

| Stack | Description |
|-------|-------------|
| [Function App Baseline](function-app-baseline.md) | Azure Functions with Key Vault, Storage, and monitoring. |
| [Function App + PostgreSQL](function-app-postgresql.md) | Azure Functions with PostgreSQL Flexible Server, Key Vault, Storage, and monitoring. |
| [Function App + MySQL](function-app-mysql.md) | Azure Functions with MySQL Flexible Server, Key Vault, Storage, and monitoring. |
| [Function App + Azure SQL](function-app-sql.md) | Azure Functions with Azure SQL Database, Key Vault, Storage, and monitoring. |
| [Function App + Cosmos DB](function-app-cosmosdb.md) | Azure Functions with Cosmos DB, Key Vault, Storage, and monitoring. |
| [Serverless Full-Stack](serverless-fullstack.md) | Static Web App (frontend) + Function App (API) + Cosmos DB (database) + monitoring. |
| [Static Web App](static-web-app.md) | Azure Static Web App for SPA and JAMstack. |
| [Static Website](static-website.md) | Storage Account static site hosting with Key Vault and monitoring. |

### Container Apps

| Stack | Description |
|-------|-------------|
| [Container Apps Baseline](container-apps-baseline.md) | Azure Container Apps with Container Apps Environment, ACR, Key Vault, and monitoring. |
| [Container Apps + PostgreSQL](container-app-postgresql.md) | Azure Container Apps with PostgreSQL Flexible Server, PgBouncer connection pooling, Key Vault, and monitoring. |
| [Container Apps + MySQL](container-app-mysql.md) | Azure Container Apps with MySQL Flexible Server, Key Vault, Managed Identity, and monitoring. |
| [Container Apps + Azure SQL](container-app-sql.md) | Azure Container Apps with Azure SQL Database, Key Vault, Managed Identity, and monitoring. |
| [Container Apps + Cosmos DB](container-app-cosmosdb.md) | Azure Container Apps with Cosmos DB for distributed applications and event-driven microservices. |

### Kubernetes (AKS)

| Stack | Description |
|-------|-------------|
| [AKS Startup](aks-startup.md) | Lightweight AKS cluster with a single node pool, ACR, Key Vault, and monitoring. |
| [AKS Microservices](aks-microservices.md) | Multi-node-pool AKS cluster with system and user node pools, ACR, and monitoring. |
| [AKS Platform](aks-platform.md) | AKS platform with 3+ node pools, Front Door, PostgreSQL, MySQL, ACR, and Firewall. |
| [Azure Container Registry](acr-registry.md) | Private container registry with geo-replication, vulnerability scanning, and network isolation. |
| [Artifact Registry](artifact-registry.md) | Azure Container Registry for container images, Helm charts, and OCI artifacts with geo-replication and vulnerability scanning. |

### Databases (PaaS)

| Stack | Description |
|-------|-------------|
| [PostgreSQL Private](postgresql-private.md) | PostgreSQL Flexible Server with network isolation, Key Vault, monitoring, and backup. |
| [MySQL Private](mysql-private.md) | MySQL Flexible Server with network isolation, Key Vault, monitoring, and backup. |
| [Azure SQL Private](sql-private.md) | Azure SQL Database with network isolation, Key Vault, monitoring, and backup. |
| [Cosmos DB Baseline](cosmosdb-baseline.md) | Azure Cosmos DB (NoSQL) with Key Vault and monitoring. |
| [Redis Cache App](redis-cache-app.md) | Azure Cache for Redis with App Service, Key Vault, and monitoring. |
| [Storage Baseline](storage-baseline.md) | Azure Storage Account with Key Vault and monitoring. |

### Database Admin Packs

| Stack | Description |
|-------|-------------|
| [DB Admin — PostgreSQL](db-admin-postgresql.md) | Monitoring pack for an existing PostgreSQL Flexible Server. |
| [DB Admin — MySQL](db-admin-mysql.md) | Monitoring pack for an existing MySQL Flexible Server. |
| [DB Admin — Azure SQL](db-admin-sql.md) | Monitoring pack for an existing Azure SQL Database. |
| [DB Admin — Cosmos DB](db-admin-cosmosdb.md) | Monitoring pack for an existing Cosmos DB account. |
| [DB Admin — Redis](db-admin-redis.md) | Monitoring pack for an existing Azure Cache for Redis. |

### IaaS Databases (VM)

| Stack | Description |
|-------|-------------|
| [VM + PostgreSQL (IaaS)](vm-postgresql-iaas.md) | PostgreSQL on Azure VM with managed disks, Key Vault, monitoring, and backup. |
| [VM + MySQL (IaaS)](vm-mysql-iaas.md) | MySQL on Azure VM with managed disks, Key Vault, monitoring, and backup. |
| [VM + SQL Server (IaaS)](vm-sqlserver-iaas.md) | SQL Server on Azure VM with managed disks, Key Vault, monitoring, and backup. |

### Virtual Machines

| Stack | Description |
|-------|-------------|
| [VM Production](vm-production.md) | Production Azure VM with managed disks, Bastion access, Key Vault, monitoring, backup, and network isolation. |
| [Dev Jump Box](dev-jumpbox.md) | Secure jump box VM with Bastion access, Managed Identity, and monitoring. |

### AI & Machine Learning

| Stack | Description |
|-------|-------------|
| [OpenAI Baseline](openai-baseline.md) | Azure OpenAI Service with Key Vault, Managed Identity, and monitoring. |
| [RAG Baseline](rag-baseline.md) | Azure OpenAI + AI Search + Storage. |
| [RAG + PostgreSQL (pgvector)](rag-postgresql.md) | Azure OpenAI + PostgreSQL pgvector as vector store. |
| [RAG + Azure SQL](rag-sql.md) | Azure OpenAI + Azure SQL as vector store. |
| [RAG + Cosmos DB](rag-cosmosdb.md) | Azure OpenAI + AI Search + Cosmos DB as vector store. |
| [RAG Enterprise](rag-enterprise.md) | Azure OpenAI, AI Search, App Service frontend, Firewall, Bastion, and full network isolation. |
| [Chatbot Enterprise](chatbot-enterprise.md) | Azure OpenAI + AI Search + App Service chatbot with RAG architecture and monitoring. |
| [AI Foundry Baseline](ai-foundry-baseline.md) | Azure AI Foundry (Machine Learning workspace) with Key Vault, Storage, and monitoring. |
| [AI Foundry Enterprise](ai-foundry-enterprise.md) | AI Foundry with Container Registry, Application Insights, full network isolation, and Backup Vault. |
| [AI Multi-Service Baseline](ai-multiservice-baseline.md) | Azure AI Services (multi-service Cognitive Account) with Key Vault and monitoring. |
| [AI Secure Regulated](ai-secure-regulated.md) | Fully isolated AI platform: Azure OpenAI + AI Search + Machine Learning behind Azure Firewall, Bastion, and Private Endpoints. |
| [GenAI Private Baseline](genai-private-baseline.md) | Azure OpenAI, AI Search, Storage, all behind Private Endpoints. |
| [MLOps Platform](mlops-platform.md) | Azure Machine Learning with Container Registry, Key Vault, Storage, Application Insights, and network isolation. |
| [Internal Knowledge Hub](internal-knowledge-hub.md) | Azure OpenAI, AI Search, Storage, and App Service. |

### AI Cognitive Services

| Stack | Description |
|-------|-------------|
| [Vision Baseline](vision-baseline.md) | Azure AI Vision with Key Vault and monitoring. |
| [Vision Video Analytics](vision-video-analytics.md) | AI Vision, Storage, and monitoring. |
| [Speech Baseline](speech-baseline.md) | Azure AI Speech with Key Vault and monitoring. |
| [Speech Call Center](speech-call-center.md) | AI Speech, Communication Services, Storage, and monitoring. |
| [NLP Language Baseline](nlp-language-baseline.md) | Azure AI Language with Key Vault and monitoring. |
| [NLP Translator Baseline](nlp-translator-baseline.md) | Azure AI Translator with Key Vault and monitoring. |
| [Document Intelligence Baseline](document-intelligence-baseline.md) | Azure AI Document Intelligence (Form Recognizer) with Key Vault and monitoring. |
| [Document Intelligence Pipeline](document-intelligence-pipeline.md) | Document processing pipeline with AI Document Intelligence, Storage, Logic App, and monitoring. |
| [Knowledge Mining Baseline](knowledge-mining-baseline.md) | Azure AI Search with Cognitive Skills, Storage, Key Vault, and monitoring. |
| [Content Safety Platform](content-safety-platform.md) | Azure AI Content Safety with OpenAI integration and monitoring. |

### Networking

| Stack | Description |
|-------|-------------|
| [Hub-Spoke Network](hub-spoke-network.md) | Hub VNet with Bastion, optional Azure Firewall, and spoke peering. |
| [Spoke Workload](spoke-workload.md) | Spoke VNet peered to hub with NSG, Route Table, and subnets. |
| [Platform Connectivity](platform-connectivity.md) | Hub VNet, Firewall, Bastion, DNS Private Resolver, Private DNS Zones, and DDoS Protection. |
| [Multi-Region HA](multi-region-ha.md) | Traffic Manager, paired App Services, geo-replicated database, and Front Door. |

### Landing Zones & Governance

| Stack | Description |
|-------|-------------|
| [Landing Zone Foundation](landing-zone-fondation.md) | Governance, monitoring, and identity baseline. |
| [Landing Zone Enterprise](landing-zone-entreprise.md) | Hub-spoke network, Firewall, Bastion, DNS Private Resolver, Policy, and centralized monitoring. |
| [Governance Baseline](governance-baseline.md) | Azure Policy assignments, budgets, and monitoring at the subscription level. |
| [Governance Subscription](governance-subscription.md) | Subscription-level governance with Policy assignments, RBAC, budgets, and diagnostic settings. |
| [Governance Organization](governance-organization.md) | Management Groups, Policy initiatives, and centralized monitoring for multi-subscription Azure estates. |

### Platform & Operations

| Stack | Description |
|-------|-------------|
| [Platform Management](platform-management.md) | Log Analytics, Automation Account, and centralized monitoring. |
| [Monitoring Platform](monitoring-platform.md) | Log Analytics, Application Insights, and Automation Account. |
| [Operations Management](ops-management.md) | Automation Account, Log Analytics, and monitoring. |

### Event & Messaging

| Stack | Description |
|-------|-------------|
| [Event Streaming](event-streaming.md) | Azure Event Hub with Storage Account (checkpointing), Key Vault, and monitoring. |
| [Event-Driven Platform](event-driven-platform.md) | Event Hub, Service Bus, Function App, and monitoring. |

### Regulated Industries

| Stack | Description |
|-------|-------------|
| [FinTech Baseline](fintech-pci-baseline.md) | Hardened App Service + PostgreSQL with Azure Firewall, Bastion, Front Door WAF, and full network isolation. |
| [Healthcare HDS](healthcare-hds.md) | App Service + PostgreSQL + Firewall + Bastion with extended audit logging. |
| [SaaS Multi-Tenant](saas-multitenant.md) | App Service, Azure SQL, Front Door, Key Vault, and monitoring. |

### Desktop & Images

| Stack | Description |
|-------|-------------|
| [Shared Image Gallery](shared-image-gallery.md) | Azure Compute Gallery for custom VM images. |

---

**78 stacks** available — 5 free, 73 paid. [Browse all stacks on aethronops.com](https://aethronops.com/stacks)
