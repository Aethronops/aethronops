# AethronOps

> **Important:** AethronOps generates Terraform code aligned with Azure security best practices. The included compliance mappings (SECURITY-POSTURE.md) are provided as audit preparation aids only. They do not constitute compliance certification, legal advice, or guarantee of regulatory conformity. You are solely responsible for validating compliance in your own environment.

> **Production-ready Azure infrastructure — validated, compliant, ready to deploy.**

AethronOps generates complete Terraform projects built exclusively on [Azure Verified Modules (AVM)](https://azure.github.io/Azure-Verified-Modules/). Each stack is wired end-to-end: networking, identity, monitoring, secrets management, and security — with compliance documentation mapped to 9 frameworks (CAF, WAF, MCSB, GDPR, NIS2, CIS, ISO 27001, SOC 2, ANSSI, plus DORA and EU AI Act for regulated/AI stacks).

No access to your Azure subscription, your repo, or your credentials.

---

## 78 Stacks — 5 Free

### Free Stacks (download without account)

| Stack | Description | Resources (premium) |
|-------|-------------|-------------------|
| **[Governance Organization](stacks/governance-organization.md)** | Management Groups, Policy initiatives, centralized monitoring | 12 |
| **[Governance Subscription](stacks/governance-subscription.md)** | Subscription-level Policy, RBAC, budgets, diagnostic settings | 37 |
| **[Platform Management](stacks/platform-management.md)** | Log Analytics, Automation Account, centralized monitoring | 26 |
| **[Storage Baseline](stacks/storage-baseline.md)** | Storage Account with Key Vault, monitoring, network isolation | 36 |
| **[Static Web App](stacks/static-web-app.md)** | Azure Static Web App (SPA/JAMstack) with Key Vault, Storage, monitoring | 41 |

### Paid Stacks (73)

| Category | Stacks | Examples |
|----------|--------|---------|
| Web Applications | 7 | App Service + PostgreSQL/MySQL/SQL/CosmosDB, API Gateway |
| Serverless | 7 | Function App + databases, Serverless Full-Stack |
| Container Apps | 5 | Container Apps + PostgreSQL/MySQL/SQL/CosmosDB |
| Kubernetes (AKS) | 5 | AKS Startup, Microservices, Platform, ACR, Artifact Registry |
| Databases | 6 | PostgreSQL, MySQL, SQL, CosmosDB, Redis, Storage |
| Database Admin | 5 | Monitoring packs for existing databases |
| IaaS (VM) | 4 | VM Production, Jump Box, VM + PostgreSQL/MySQL/SQL Server |
| AI & ML | 14 | OpenAI, RAG (5 variants), AI Foundry, MLOps, Document Intelligence |
| AI Cognitive | 10 | Vision, Speech, NLP, Content Safety, Knowledge Mining |
| Networking | 2 | Platform Connectivity, Multi-Region HA |
| Landing Zones | 2 | Foundation, Enterprise |
| Operations | 1 | Ops Management |
| Regulated | 3 | FinTech PCI, Healthcare HDS, SaaS Multi-Tenant |
| Event & Messaging | 2 | Event Streaming, Event-Driven Platform |

Full catalog: **[stacks/README.md](stacks/README.md)**

---

## What you get in each ZIP

```
my-project/
├── basic/                  ← Minimal (dev, POC)
├── standard/               ← Production (VNet, NSG, Private Endpoints)
├── premium/                ← Enterprise (Firewall, Bastion, Front Door, Backup)
│   ├── main.tf
│   ├── resource_group.tf
│   ├── networking.tf
│   ├── identity.tf
│   ├── keyvault.tf
│   ├── monitoring.tf
│   ├── database.tf
│   ├── app.tf
│   ├── wiring.tf           ← All resources wired together
│   ├── finops.tf            ← Budget alerts, auto-shutdown
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   ├── .checkov.yaml        ← Security rules + justifications
│   ├── README.md            ← 3-step deployment guide
│   ├── SECURITY-POSTURE.md  ← CAF / WAF / MCSB / GDPR / NIS2 mapping
│   └── manifest.yaml
└── backend.tf.example
```

---

## Validation

Every stack is validated before shipping:

| Check | Coverage |
|-------|----------|
| `terraform validate` | 83/83 premium |
| `terraform plan` | 83/83 premium (12–107 resources) |
| `checkov` | 83/83 premium (0 failed) |
| `terraform apply` (real Azure) | 43+ stacks deployed and destroyed |

---

## Security Frameworks

Each stack includes a `SECURITY-POSTURE.md` mapping implemented controls to 9 frameworks:

| Framework | Scope |
|-----------|-------|
| **CAF** | Cloud Adoption Framework — naming, organization, governance |
| **WAF** | Well-Architected Framework — 5 pillars |
| **MCSB** | Microsoft Cloud Security Benchmark — Azure security controls |
| **GDPR** | Encryption, audit, data residency |
| **NIS2** | EU cybersecurity directive — risk management, incident reporting |
| **DORA** | Digital Operational Resilience (fintech stacks) |
| **EU AI Act** | AI transparency and compliance (AI stacks) |
| **CIS Azure** | CIS Benchmarks v2.1 — hardening controls |
| **ISO 27001** | Annex A controls — information security management |
| **SOC 2** | Trust Services Criteria — security, availability, confidentiality |
| **PCI-DSS 4.0** | Payment card industry (fintech stacks) |
| **ANSSI** | French cloud security guidelines (SecNumCloud) |

> These mappings help prepare for audits — they do not constitute a compliance certification.

---

## Need a custom stack?

Our engine can compose any combination of Azure Verified Modules into a fully wired, compliance-mapped infrastructure. If your use case isn't covered by the catalog, we build it for you — same quality, same validation, same security posture documentation.

**[Request a custom stack →](https://aethronops.com/contact/)**

---

## Links

- Website: [aethronops.com](https://aethronops.com)
- Stack catalog: [stacks/README.md](stacks/README.md)
