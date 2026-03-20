# AethronOps — Stack Catalog

Production-ready Azure infrastructure as code. Each stack is a complete Terraform project using [Azure Verified Modules (AVM)](https://azure.github.io/Azure-Verified-Modules/) with built-in compliance mappings (CAF, WAF, MCSB, GDPR, NIS2).

All stacks include 3 tiers (Basic / Standard / Premium) in a single ZIP.

### Web Applications

| Stack | Description |
|-------|-------------|
| [App Service Web](appservice-web.md) | Azure App Service for web applications with Key Vault, Storage, and monitoring. |
| [App Service + PostgreSQL](appservice-postgresql.md) | Azure App Service with PostgreSQL Flexible Server, Key Vault, Storage, and monitoring. |
| [App Service + MySQL](appservice-mysql.md) | Azure App Service with MySQL Flexible Server, Key Vault, Storage, and monitoring. |
| [App Service + Azure SQL](appservice-sql.md) | Azure App Service with Azure SQL Database, Key Vault, Storage, and monitoring. |
| [App Service + Cosmos DB](appservice-cosmosdb.md) | Azure App Service with Cosmos DB (NoSQL), Key Vault, Storage, and monitoring. |
| [API REST Starter](api-rest-starter.md) | App Service hosting a REST API with Key Vault, Storage, monitoring, and network isolation. |
| [API Gateway Platform](api-gateway-platform.md) | Azure API Management with App Service backend, Key Vault, and monitoring. |
| [WordPress on Azure](wordpress-azure.md) | WordPress on App Service with MySQL Flexible Server, Front Door CDN, Key Vault, Storage, and monitoring. |

### Serverless

| Stack | Description |
|-------|-------------|
| [Function App Baseline](function-app-baseline.md) | Azure Functions with Key Vault, Storage, monitoring, and network isolation. |
| [Function App + PostgreSQL](function-app-postgresql.md) | Azure Functions with PostgreSQL Flexible Server, Key Vault, Storage, and monitoring. |
| [Function App + MySQL](function-app-mysql.md) | Azure Functions with MySQL Flexible Server, Key Vault, Storage, and monitoring. |
| [Function App + Azure SQL](function-app-sql.md) | Azure Functions with Azure SQL Database, Key Vault, Storage, and monitoring. |
| [Function App + Cosmos DB](function-app-cosmosdb.md) | Azure Functions with Cosmos DB, Key Vault, Storage, and monitoring. |
| [Serverless Full-Stack](serverless-fullstack.md) | Serverless full-stack application with Static Web App (frontend), Function App (API), Cosmos DB (database), and monitoring. |
| [Static Web App](static-web-app.md) | Azure Static Web App for SPA (React, Vue, Angular) and JAMstack sites. |
| [Static Website](static-website.md) | Lightweight static site hosting with Storage Account static website, Key Vault, and monitoring. |

### Containers

| Stack | Description |
|-------|-------------|
| [AKS Startup](aks-startup.md) | Lightweight AKS cluster for startups and small teams. |
| [AKS Microservices](aks-microservices.md) | Multi-node-pool AKS cluster for microservices architectures. |
| [AKS Platform](aks-platform.md) | Enterprise AKS platform with 3+ node pools, Front Door WAF, PostgreSQL, MySQL, ACR, and Firewall. |
| [Container Apps Baseline](container-apps-baseline.md) | Azure Container Apps with Container Apps Environment, ACR, Key Vault, and monitoring. |
| [Azure Container Registry](acr-registry.md) | Private container registry with geo-replication, vulnerability scanning, and network isolation. |
| [Artifact Registry](artifact-registry.md) | Azure Container Registry for storing container images, Helm charts, and OCI artifacts. |

### AI & Machine Learning

| Stack | Description |
|-------|-------------|
| [OpenAI Baseline](openai-baseline.md) | Azure OpenAI Service with Key Vault, Managed Identity, and monitoring. |
| [RAG Baseline](rag-baseline.md) | Retrieval-Augmented Generation with Azure OpenAI + AI Search + Storage. |
| [RAG + PostgreSQL (pgvector)](rag-postgresql.md) | RAG architecture using PostgreSQL pgvector as vector store. |
| [RAG + Azure SQL](rag-sql.md) | RAG architecture using Azure SQL as vector store. |
| [RAG + Cosmos DB](rag-cosmosdb.md) | RAG architecture using Cosmos DB as vector store. |
| [RAG Enterprise](rag-enterprise.md) | Enterprise RAG with Azure OpenAI, AI Search, App Service frontend, Firewall, Bastion, and full network isolation. |
| [Chatbot Enterprise](chatbot-enterprise.md) | Azure OpenAI + AI Search + App Service chatbot with RAG architecture. |
| [AI Foundry Baseline](ai-foundry-baseline.md) | Azure AI Foundry (Machine Learning workspace) with Key Vault, Storage, and monitoring. |
| [AI Foundry Enterprise](ai-foundry-enterprise.md) | Enterprise-grade AI Foundry with Container Registry, Application Insights, full network isolation, and Backup Vault. |
| [AI Multi-Service Baseline](ai-multiservice-baseline.md) | Azure AI Services (multi-service Cognitive Account) with Key Vault, monitoring, and network isolation. |
| [AI Data Platform](ai-data-platform.md) | End-to-end data and AI platform combining Azure Databricks, Data Factory, Synapse Analytics, and Machine Learning. |
| [AI Secure Regulated](ai-secure-regulated.md) | Fully isolated AI platform for regulated industries. |
| [GenAI Private Baseline](genai-private-baseline.md) | Private generative AI stack with Azure OpenAI, AI Search, Storage, behind Private Endpoints. |
| [MLOps Platform](mlops-platform.md) | Azure Machine Learning with Container Registry, Key Vault, Storage, Application Insights, and network isolation. |
| [Internal Knowledge Hub](internal-knowledge-hub.md) | RAG-based internal knowledge base with Azure OpenAI, AI Search, Storage, and App Service. |

### AI Cognitive Services

| Stack | Description |
|-------|-------------|
| [Vision Baseline](vision-baseline.md) | Azure AI Vision with Key Vault, monitoring, and network isolation. |
| [Vision Video Analytics](vision-video-analytics.md) | Video analytics with Azure AI Vision, Storage, and monitoring. |
| [Speech Baseline](speech-baseline.md) | Azure AI Speech with Key Vault, monitoring, and network isolation. |
| [Speech Call Center](speech-call-center.md) | Call center analytics with Azure AI Speech, Communication Services, Storage, and monitoring. |
| [NLP Language Baseline](nlp-language-baseline.md) | Azure AI Language service with Key Vault, monitoring, and network isolation. |
| [NLP Translator Baseline](nlp-translator-baseline.md) | Azure AI Translator with Key Vault, monitoring, and network isolation. |
| [Document Intelligence Baseline](document-intelligence-baseline.md) | Azure AI Document Intelligence (Form Recognizer) with Key Vault, monitoring, and network isolation. |
| [Document Intelligence Pipeline](document-intelligence-pipeline.md) | Document processing pipeline with AI Document Intelligence, Storage, Logic App, and monitoring. |
| [Knowledge Mining Baseline](knowledge-mining-baseline.md) | Azure AI Search with Cognitive Skills, Storage (data source), Key Vault, and monitoring. |
| [Content Safety Platform](content-safety-platform.md) | Azure AI Content Safety with OpenAI integration, monitoring, and network isolation. |

### Databases

| Stack | Description |
|-------|-------------|
| [PostgreSQL Private](postgresql-private.md) | Standalone PostgreSQL Flexible Server with full network isolation, Key Vault, monitoring, and backup. |
| [MySQL Private](mysql-private.md) | Standalone MySQL Flexible Server with full network isolation, Key Vault, monitoring, and backup. |
| [Azure SQL Private](sql-private.md) | Standalone Azure SQL Database with full network isolation, Key Vault, monitoring, and backup. |
| [Cosmos DB Baseline](cosmosdb-baseline.md) | Azure Cosmos DB (NoSQL) with Key Vault, monitoring, and network isolation. |
| [Redis Cache App](redis-cache-app.md) | Azure Cache for Redis with App Service, Key Vault, monitoring, and network isolation. |
| [Storage Baseline](storage-baseline.md) | Azure Storage Account with Key Vault, monitoring, and network isolation. |

### Database Admin Packs

| Stack | Description |
|-------|-------------|
| [DB Admin — PostgreSQL](db-admin-postgresql.md) | Administration pack for an existing PostgreSQL Flexible Server. |
| [DB Admin — MySQL](db-admin-mysql.md) | Administration pack for an existing MySQL Flexible Server. |
| [DB Admin — Azure SQL](db-admin-sql.md) | Administration pack for an existing Azure SQL Database. |
| [DB Admin — Cosmos DB](db-admin-cosmosdb.md) | Administration pack for an existing Cosmos DB account. |
| [DB Admin — Redis](db-admin-redis.md) | Administration pack for an existing Azure Cache for Redis. |
| [DB Admin — SQL Managed Instance](db-admin-sqlmi.md) | Administration pack for an existing SQL Managed Instance. |

### IaaS Databases (VM)

| Stack | Description |
|-------|-------------|
| [VM + PostgreSQL (IaaS)](vm-postgresql-iaas.md) | PostgreSQL on Azure VM with managed disks, Key Vault, monitoring, and backup. |
| [VM + MySQL (IaaS)](vm-mysql-iaas.md) | MySQL on Azure VM with managed disks, Key Vault, monitoring, and backup. |
| [VM + SQL Server (IaaS)](vm-sqlserver-iaas.md) | SQL Server on Azure VM with managed disks, Key Vault, monitoring, and backup. |
| [VM + Oracle (IaaS)](vm-oracle-iaas.md) | Oracle Database on Azure VM with managed disks, Key Vault, monitoring, and backup. |
| [VM + MongoDB (IaaS)](vm-mongodb-iaas.md) | MongoDB on Azure VM with managed disks, Key Vault, monitoring, and backup. |
| [VM + MariaDB (IaaS)](vm-mariadb-iaas.md) | MariaDB on Azure VM with managed disks, Key Vault, monitoring, and backup. |

### Virtual Machines

| Stack | Description |
|-------|-------------|
| [VM Production](vm-production.md) | Production-ready Azure VM with managed disks, Bastion access, Key Vault, monitoring, backup, and network isolation. |
| [VMSS Autoscale](vmss-autoscale.md) | VM Scale Set with autoscaling, Load Balancer, Key Vault, monitoring, and network isolation. |
| [Dev Jump Box](dev-jumpbox.md) | Secure jump box VM with Bastion access, Managed Identity, and monitoring. |

### Networking

| Stack | Description |
|-------|-------------|
| [Hub-Spoke Network](hub-spoke-network.md) | Classic hub-spoke network topology. |
| [Spoke Workload](spoke-workload.md) | Spoke VNet for workloads in a hub-spoke topology. |
| [Platform Connectivity](platform-connectivity.md) | CAF Platform connectivity with hub VNet, Firewall, Bastion, DNS Private Resolver, Private DNS Zones, and DDoS Protection. |
| [Multi-Region HA](multi-region-ha.md) | Multi-region high availability architecture with Traffic Manager, paired App Services, geo-replicated database, and Front Door. |

### Landing Zones & Governance

| Stack | Description |
|-------|-------------|
| [Landing Zone Foundation](landing-zone-fondation.md) | CAF-aligned foundation landing zone with governance, monitoring, and identity baseline. |
| [Landing Zone Enterprise](landing-zone-entreprise.md) | CAF-aligned enterprise landing zone with hub-spoke network, Firewall, Bastion, DNS Private Resolver, Policy, and centralized monitoring. |
| [Landing Zone PME](landingzone-pme.md) | Simplified landing zone for SMBs. |
| [Governance Baseline](governance-baseline.md) | Azure governance foundation with Policy assignments, budgets, and monitoring. |
| [Governance Subscription](governance-subscription.md) | Subscription-level governance with Policy assignments, RBAC, budgets, and diagnostic settings. |
| [Governance Organization](governance-organization.md) | Organization-wide governance with Management Groups, Policy initiatives, and centralized monitoring. |

### Platform & Operations

| Stack | Description |
|-------|-------------|
| [Platform Management](platform-management.md) | CAF Platform management with Log Analytics, Automation Account, and centralized monitoring. |
| [Monitoring Platform](monitoring-platform.md) | Centralized monitoring with Log Analytics, Application Insights, and Automation Account. |
| [Operations Management](ops-management.md) | Operational management stack with Automation Account, Log Analytics, and monitoring. |
| [CI/CD Runners](cicd-runners.md) | Self-hosted CI/CD runners on Azure VMs with Managed Identity, Key Vault, and monitoring. |

### Event & Messaging

| Stack | Description |
|-------|-------------|
| [Event Streaming](event-streaming.md) | Azure Event Hub with Storage Account (checkpointing), Key Vault, and monitoring. |
| [Event-Driven Platform](event-driven-platform.md) | Event-driven architecture with Event Hub, Service Bus, Function App, and monitoring. |

### Data & Analytics

| Stack | Description |
|-------|-------------|
| [Data Platform Baseline](data-platform-baseline.md) | Azure data platform with Data Factory, Databricks or Synapse, Storage (Data Lake), Key Vault, and monitoring. |
| [Secure Data Pipeline](secure-data-pipeline.md) | Secure data pipeline with Data Factory, Storage (Data Lake), Key Vault, and monitoring behind Private Endpoints. |

### Compliance & Regulated

| Stack | Description |
|-------|-------------|
| [FinTech PCI-DSS Baseline](fintech-pci-baseline.md) | Hardened App Service + PostgreSQL with Azure Firewall, Bastion, Front Door WAF, and full network isolation. |
| [Healthcare HDS](healthcare-hds.md) | Healthcare-grade infrastructure aligned with HDS (Hébergeur de Données de Santé) requirements. |
| [SaaS Multi-Tenant](saas-multitenant.md) | Multi-tenant SaaS architecture with App Service, Azure SQL, Front Door, Key Vault, and monitoring. |

### Desktop & End-User

| Stack | Description |
|-------|-------------|
| [Azure Virtual Desktop Enterprise](avd-enterprise.md) | Azure Virtual Desktop (AVD) with host pools, workspace, application groups, scaling plan, and Shared Image Gallery. |
| [Shared Image Gallery](shared-image-gallery.md) | Azure Compute Gallery for managing and distributing custom VM images. |

---

**[Browse all stacks on aethronops.com](https://aethronops.com/stacks)**
