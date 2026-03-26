# AethronOps — Stack Catalog

Production-ready Azure infrastructure as code.

Every stack is a complete Terraform project built on [Azure Verified Modules (AVM)](https://azure.github.io/Azure-Verified-Modules/) — Microsoft's official Terraform modules. Managed Identity, Key Vault, Log Analytics, and network isolation are built into every stack.

Each stack comes in 3 tiers (Basic / Standard / Premium) so you pick the security level that matches your environment.

### Web Applications

| Stack | Description |
|-------|-------------|
| [App Service Web](stacks/appservice-web.md) | Azure App Service for web applications with Key Vault, Storage, and monitoring. |
| [App Service + PostgreSQL](stacks/appservice-postgresql.md) | Azure App Service with PostgreSQL Flexible Server, Key Vault, Storage, and monitoring. |
| [App Service + MySQL](stacks/appservice-mysql.md) | Azure App Service with MySQL Flexible Server, Key Vault, Storage, and monitoring. |
| [App Service + Azure SQL](stacks/appservice-sql.md) | Azure App Service with Azure SQL Database, Key Vault, Storage, and monitoring. |
| [App Service + Cosmos DB](stacks/appservice-cosmosdb.md) | Azure App Service with Cosmos DB (NoSQL), Key Vault, Storage, and monitoring. |
| [API REST Starter](stacks/api-rest-starter.md) | App Service hosting a REST API with Key Vault, Storage, and monitoring. |
| [API Gateway Platform](stacks/api-gateway-platform.md) | Azure API Management with App Service backend, Key Vault, and monitoring. |

### Serverless (Azure Functions)

| Stack | Description |
|-------|-------------|
| [Function App Baseline](stacks/function-app-baseline.md) | Azure Functions with Key Vault, Storage, and monitoring. |
| [Function App + PostgreSQL](stacks/function-app-postgresql.md) | Azure Functions with PostgreSQL Flexible Server, Key Vault, Storage, and monitoring. |
| [Function App + MySQL](stacks/function-app-mysql.md) | Azure Functions with MySQL Flexible Server, Key Vault, Storage, and monitoring. |
| [Function App + Azure SQL](stacks/function-app-sql.md) | Azure Functions with Azure SQL Database, Key Vault, Storage, and monitoring. |
| [Function App + Cosmos DB](stacks/function-app-cosmosdb.md) | Azure Functions with Cosmos DB, Key Vault, Storage, and monitoring. |
| [Serverless Full-Stack](stacks/serverless-fullstack.md) | Static Web App (frontend) + Function App (API) + Cosmos DB (database) + monitoring. |
| [Static Web App](stacks/static-web-app.md) | Azure Static Web App for SPA and JAMstack. |
| [Static Website](stacks/static-website.md) | Storage Account static site hosting with Key Vault and monitoring. |

### Container Apps

| Stack | Description |
|-------|-------------|
| [Container Apps Baseline](stacks/container-apps-baseline.md) | Azure Container Apps with Container Apps Environment, ACR, Key Vault, and monitoring. |
| [Container Apps + PostgreSQL](stacks/container-app-postgresql.md) | Azure Container Apps with PostgreSQL Flexible Server, PgBouncer connection pooling, Key Vault, and monitoring. |
| [Container Apps + MySQL](stacks/container-app-mysql.md) | Azure Container Apps with MySQL Flexible Server, Key Vault, Managed Identity, and monitoring. |
| [Container Apps + Azure SQL](stacks/container-app-sql.md) | Azure Container Apps with Azure SQL Database, Key Vault, Managed Identity, and monitoring. |
| [Container Apps + Cosmos DB](stacks/container-app-cosmosdb.md) | Azure Container Apps with Cosmos DB for distributed applications and event-driven microservices. |

### Kubernetes (AKS)

| Stack | Description |
|-------|-------------|
| [AKS Startup](stacks/aks-startup.md) | Lightweight AKS cluster with a single node pool, ACR, Key Vault, and monitoring. |
| [AKS Microservices](stacks/aks-microservices.md) | Multi-node-pool AKS cluster with system and user node pools, ACR, and monitoring. |
| [AKS Platform](stacks/aks-platform.md) | AKS platform with 3+ node pools, Front Door, PostgreSQL, MySQL, ACR, and Firewall. |
| [Azure Container Registry](stacks/acr-registry.md) | Private container registry with geo-replication, vulnerability scanning, and network isolation. |
| [Artifact Registry](stacks/artifact-registry.md) | Azure Container Registry for container images, Helm charts, and OCI artifacts with geo-replication and vulnerability scanning. |

### Databases (PaaS)

| Stack | Description |
|-------|-------------|
| [PostgreSQL Private](stacks/postgresql-private.md) | PostgreSQL Flexible Server with network isolation, Key Vault, monitoring, and backup. |
| [MySQL Private](stacks/mysql-private.md) | MySQL Flexible Server with network isolation, Key Vault, monitoring, and backup. |
| [Azure SQL Private](stacks/sql-private.md) | Azure SQL Database with network isolation, Key Vault, monitoring, and backup. |
| [Cosmos DB Baseline](stacks/cosmosdb-baseline.md) | Azure Cosmos DB (NoSQL) with Key Vault and monitoring. |
| [Redis Cache App](stacks/redis-cache-app.md) | Azure Cache for Redis with App Service, Key Vault, and monitoring. |
| [Storage Baseline](stacks/storage-baseline.md) | Azure Storage Account with Key Vault and monitoring. |

### Database Admin Packs

| Stack | Description |
|-------|-------------|
| [DB Admin — PostgreSQL](stacks/db-admin-postgresql.md) | Monitoring pack for an existing PostgreSQL Flexible Server. |
| [DB Admin — MySQL](stacks/db-admin-mysql.md) | Monitoring pack for an existing MySQL Flexible Server. |
| [DB Admin — Azure SQL](stacks/db-admin-sql.md) | Monitoring pack for an existing Azure SQL Database. |
| [DB Admin — Cosmos DB](stacks/db-admin-cosmosdb.md) | Monitoring pack for an existing Cosmos DB account. |
| [DB Admin — Redis](stacks/db-admin-redis.md) | Monitoring pack for an existing Azure Cache for Redis. |

### IaaS Databases (VM)

| Stack | Description |
|-------|-------------|
| [VM + PostgreSQL (IaaS)](stacks/vm-postgresql-iaas.md) | PostgreSQL on Azure VM with managed disks, Key Vault, monitoring, and backup. |
| [VM + MySQL (IaaS)](stacks/vm-mysql-iaas.md) | MySQL on Azure VM with managed disks, Key Vault, monitoring, and backup. |
| [VM + SQL Server (IaaS)](stacks/vm-sqlserver-iaas.md) | SQL Server on Azure VM with managed disks, Key Vault, monitoring, and backup. |

### Virtual Machines

| Stack | Description |
|-------|-------------|
| [VM Production](stacks/vm-production.md) | Production Azure VM with managed disks, Bastion access, Key Vault, monitoring, backup, and network isolation. |
| [Dev Jump Box](stacks/dev-jumpbox.md) | Secure jump box VM with Bastion access, Managed Identity, and monitoring. |

### AI & Machine Learning

| Stack | Description |
|-------|-------------|
| [OpenAI Baseline](stacks/openai-baseline.md) | Azure OpenAI Service with Key Vault, Managed Identity, and monitoring. |
| [RAG Baseline](stacks/rag-baseline.md) | Azure OpenAI + AI Search + Storage. |
| [RAG + PostgreSQL (pgvector)](stacks/rag-postgresql.md) | Azure OpenAI + PostgreSQL pgvector as vector store. |
| [RAG + Azure SQL](stacks/rag-sql.md) | Azure OpenAI + Azure SQL as vector store. |
| [RAG + Cosmos DB](stacks/rag-cosmosdb.md) | Azure OpenAI + AI Search + Cosmos DB as vector store. |
| [RAG Enterprise](stacks/rag-enterprise.md) | Azure OpenAI, AI Search, App Service frontend, Firewall, Bastion, and full network isolation. |
| [Chatbot Enterprise](stacks/chatbot-enterprise.md) | Azure OpenAI + AI Search + App Service chatbot with RAG architecture and monitoring. |
| [AI Foundry Baseline](stacks/ai-foundry-baseline.md) | Azure AI Foundry (Machine Learning workspace) with Key Vault, Storage, and monitoring. |
| [AI Foundry Enterprise](stacks/ai-foundry-enterprise.md) | AI Foundry with Container Registry, Application Insights, full network isolation, and Backup Vault. |
| [AI Multi-Service Baseline](stacks/ai-multiservice-baseline.md) | Azure AI Services (multi-service Cognitive Account) with Key Vault and monitoring. |
| [AI Secure Regulated](stacks/ai-secure-regulated.md) | Fully isolated AI platform: Azure OpenAI + AI Search + Machine Learning behind Azure Firewall, Bastion, and Private Endpoints. |
| [AI Data Platform](stacks/ai-data-platform.md) | Azure Databricks, Data Factory, Synapse Analytics, and Machine Learning workspace. |
| [GenAI Private Baseline](stacks/genai-private-baseline.md) | Azure OpenAI, AI Search, Storage, all behind Private Endpoints. |
| [MLOps Platform](stacks/mlops-platform.md) | Azure Machine Learning with Container Registry, Key Vault, Storage, Application Insights, and network isolation. |
| [Internal Knowledge Hub](stacks/internal-knowledge-hub.md) | Azure OpenAI, AI Search, Storage, and App Service. |

### AI Cognitive Services

| Stack | Description |
|-------|-------------|
| [Vision Baseline](stacks/vision-baseline.md) | Azure AI Vision with Key Vault and monitoring. |
| [Vision Video Analytics](stacks/vision-video-analytics.md) | AI Vision, Storage, and monitoring. |
| [Speech Baseline](stacks/speech-baseline.md) | Azure AI Speech with Key Vault and monitoring. |
| [Speech Call Center](stacks/speech-call-center.md) | AI Speech, Communication Services, Storage, and monitoring. |
| [NLP Language Baseline](stacks/nlp-language-baseline.md) | Azure AI Language with Key Vault and monitoring. |
| [NLP Translator Baseline](stacks/nlp-translator-baseline.md) | Azure AI Translator with Key Vault and monitoring. |
| [Document Intelligence Baseline](stacks/document-intelligence-baseline.md) | Azure AI Document Intelligence (Form Recognizer) with Key Vault and monitoring. |
| [Document Intelligence Pipeline](stacks/document-intelligence-pipeline.md) | Document processing pipeline with AI Document Intelligence, Storage, Logic App, and monitoring. |
| [Knowledge Mining Baseline](stacks/knowledge-mining-baseline.md) | Azure AI Search with Cognitive Skills, Storage, Key Vault, and monitoring. |
| [Content Safety Platform](stacks/content-safety-platform.md) | Azure AI Content Safety with OpenAI integration and monitoring. |

### Networking

| Stack | Description |
|-------|-------------|
| [Platform Connectivity](stacks/platform-connectivity.md) | Hub VNet, Firewall, Bastion, DNS Private Resolver, Private DNS Zones, and DDoS Protection. |
| [Multi-Region HA](stacks/multi-region-ha.md) | Traffic Manager, paired App Services, geo-replicated database, and Front Door. |

### Governance

| Stack | Description |
|-------|-------------|
| [Governance Subscription](stacks/governance-subscription.md) | Subscription-level governance with Policy assignments, RBAC, budgets, and diagnostic settings. |
| [Governance Organization](stacks/governance-organization.md) | Management Groups, Policy initiatives, and centralized monitoring for multi-subscription Azure estates. |

### Platform & Operations

| Stack | Description |
|-------|-------------|
| [Platform Management](stacks/platform-management.md) | Log Analytics, Automation Account, and centralized monitoring. |
| [Operations Management](stacks/ops-management.md) | Automation Account, Log Analytics, and monitoring. |

### Event & Messaging

| Stack | Description |
|-------|-------------|
| [Event Streaming](stacks/event-streaming.md) | Azure Event Hub with Storage Account (checkpointing), Key Vault, and monitoring. |
| [Event-Driven Platform](stacks/event-driven-platform.md) | Event Hub, Service Bus, Function App, and monitoring. |

### Regulated Industries

| Stack | Description |
|-------|-------------|
| [FinTech Baseline](stacks/fintech-pci-baseline.md) | Hardened App Service + PostgreSQL with Azure Firewall, Bastion, Front Door WAF, and full network isolation. |
| [Healthcare HDS](stacks/healthcare-hds.md) | App Service + PostgreSQL + Firewall + Bastion with extended audit logging. |
| [SaaS Multi-Tenant](stacks/saas-multitenant.md) | App Service, Azure SQL, Front Door, Key Vault, and monitoring. |

### Desktop & Images

| Stack | Description |
|-------|-------------|
| [Shared Image Gallery](stacks/shared-image-gallery.md) | Azure Compute Gallery for custom VM images. |

---

**78 stacks** available. [Browse all stacks on aethronops.com](https://aethronops.com/stacks)
