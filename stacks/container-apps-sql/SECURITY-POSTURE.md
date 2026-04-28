# Security Controls Mapping — container-apps-sql

![Frameworks](https://img.shields.io/badge/Frameworks-6-success)
![Controls](https://img.shields.io/badge/Controls-57-blue)
![Bricks](https://img.shields.io/badge/Modules-7-0078D4)
![Tier](https://img.shields.io/badge/Tier-dev-orange)

> **6 frameworks** · **7 modules** · **57 controls mapped**
> Pattern: `container-apps-sql` (tier dev)

> [!IMPORTANT]
> **DISCLAIMER — READ BEFORE USE**
>
> This document maps the technical security controls implemented in the Terraform code to recognized compliance frameworks. **It is provided for informational purposes only as an aid for audit preparation. It does NOT constitute:**
> - A compliance certification or attestation
> - A guarantee of conformity with any law, regulation, or standard
> - Legal or regulatory advice
> - A substitute for a formal audit by accredited assessors
>
> Regulatory compliance (NIS2, GDPR, DORA, PCI-DSS, HDS, ISO 27001, SOC 2, etc.) depends on organizational, procedural, and contextual factors beyond infrastructure code.
> **You must engage qualified legal counsel and/or accredited'auditors to validate compliance for your specific context.** AethronOps provides technical foundations aligned with these frameworks but does not certify, attest, or guarantee compliance.
>
> See the Disclaimer section in README.md for full terms.

---

## Security Controls Configured in Code

> [!NOTE]
> All controls below are **configurations defined in the Terraform code**, verifiable via `terraform plan`. Their effectiveness depends on proper deployment, ongoing management, and organizational security practices by the Buyer.

| Control | Configuration | Scope | Evidence |
|:--------|:--------------|:------|:---------|
| Encryption at rest | AES-256 (Azure platform default — platform-managed keys, CMK not configured by default) | All services | — |
| TLS Policy (audit) | Azure Policy "Latest TLS version" assigned in Audit mode (flags non-compliant Storage/App Service, no blocking by default) | Governance | governance.tf |
| Zero secrets | Managed Identity (no API keys/passwords stored) | Authentication | identity.tf |
| Secret management | Azure Key Vault with RBAC access policies | Secrets & certificates | keyvault.tf |
| Centralized logging | Log Analytics Workspace — audit trail, diagnostics, alerts | Monitoring | monitoring.tf |
| Checkov config shipped | .checkov.yaml shipped in the pack — reproducible scan via `checkov -d .` on the Terraform code | DevSecOps | .checkov.yaml |
| Module provenance | Azure Verified Modules (AVM) — Microsoft-maintained, versioned | Supply chain | README.md |
| Naming convention | CAF naming standard — consistent, auditable | Governance | All .tf files |
| Tagging policy | Mandatory tags: environment, managed_by, project | Governance | main.tf |
| Telemetry disabled | `enable_telemetry = false` on all AVM modules | Privacy | All modules |

> [!TIP]
> Tier **dev**: Private Endpoints, Backup Vault, and full hardening are disabled to minimize costs. Use tier **production** for a production-grade deployment.

---

## Framework Alignment Mapping

> [!IMPORTANT]
> The frameworks below are used as **technical references** in the design of this pack. AethronOps does NOT certify compliance with these standards — certification requires formal audits by accredited assessors.

### Microsoft Frameworks (technical reference)

| Framework | Technical Controls Covered | Reference |
|:----------|:----------------|:----------|
| 🔒 **MCSB** — Microsoft Cloud Security Benchmark | AM-1, DP-1, DP-2, DP-3, DP-4, DP-6, DP-7, DP-8, DS-2, DS-4, DS-6, GS-3, IM-1, IM-3, IM-4, IR-1, IR-4, LT-1, LT-3, LT-4, LT-5, LT-6, LT-7, NS-2, PV-1, PV-2 | [MCSB](https://learn.microsoft.com/security/benchmark/azure/overview) |
| ☁️ **CAF** — Cloud Adoption Framework | APP-2, DATA-1, DATA-2, GOV-1, GOV-3, ID-1, ID-2, NET-1, OPS-1, OPS-2, RG-1, RG-2, SEC-3, SEC-4 | [Microsoft CAF](https://learn.microsoft.com/azure/cloud-adoption-framework/) |
| ⚖️ **WAF** — Well-Architected Framework | IM-1, IM-3, LT-1, NS-1 | [Azure WAF](https://learn.microsoft.com/azure/well-architected/) |

### European Regulations (technical measures)

> [!NOTE]
> The columns below list **technical measures** this pack implements that are **commonly expected** under these regulations. Regulatory compliance itself remains the customer's responsibility (organization, procedures, third-party audits).

| Framework | Technical measures aligned | Reference |
|:----------|:----------------|:----------|
| 🇪🇺 **RGPD** — EU General Data Protection Regulation | ART-21-2a, ART-21-2b, ART-21-2h, ART-25, ART-30, ART-32, ART-33 | [GDPR Text](https://gdpr-info.eu/) |
| 🛡️ **NIS2** — EU Directive 2022/2555 | ART-21-2b, ART-21-2c, ART-21-2e, ART-21-2f, ART-21-2h, ART-21-2i | [NIS2 Directive](https://eur-lex.europa.eu/eli/dir/2022/2555) |


### EU AI Act — Regulation (EU) 2024/1689

> GPAI obligations active since **August 2025**. High-risk AI system requirements applicable **August 2026**.

> [!NOTE]
> AethronOps provides **infrastructure foundations** for AI Act compliance. The AI Act classification
> (minimal / limited / high-risk / unacceptable) depends on the **use case**, not the infrastructure.
> Risk classification per Annex III is the deployer's responsibility.

| Article | Requirement | Infrastructure Support |
|:--------|:-----------|:----------------------|
| Art. 26 | Deployer obligations | Audit trail via Log Analytics, Managed Identity for access control |
| Art. 50 | Transparency (GPAI) | Log Analytics: generation logs, token usage, model versioning |
| Art. 15 | Accuracy, robustness, cybersecurity | Key Vault: API key management, endpoint security |

#### AI Infrastructure Best Practices (aligned with EU AI Act)

| Practice | Implementation | Status |
|:---------|:--------------|:------:|
| Model versioning | ML Workspace experiment tracking / container image tags | ⚠️ Manual |
| Audit trail | Log Analytics diagnostic settings on all AI services | ✅ |
| Access control | Managed Identity + RBAC (no API keys in code) | ✅ |
| Data protection | Key Vault for API keys + VNet isolation | ⚠️ Partial |
| Incident detection | Application Insights + Log Analytics alerts | ✅ |


---

## Per-Component Alignment


#### 🛡️ Identity

| Component | Alignment Controls |
|:----------|:-------------------|
| **managed-identity** | **CAF**: ID-1, ID-2 · **MCSB**: IM-1, IM-3 · **RGPD**: ART-25, ART-32 · **NIS2**: ART-21-2i |
| **key-vault** | **CAF**: SEC-3, SEC-4 · **MCSB**: DP-1, DP-2, DP-3, DP-4, DP-6, DP-7, DP-8 · **RGPD**: ART-32 · **NIS2**: ART-21-2h |

#### 💾 Data

| Component | Alignment Controls |
|:----------|:-------------------|
| **sql-database** | **CAF**: DATA-1, DATA-2 · **MCSB**: DP-4, NS-2, DP-3 · **RGPD**: ART-32, ART-25 · **NIS2**: ART-21-2c, ART-21-2e |

#### 📊 Monitoring

| Component | Alignment Controls |
|:----------|:-------------------|
| **log-analytics** | **CAF**: OPS-1, OPS-2, GOV-3 · **MCSB**: LT-1, LT-3, LT-4, LT-5, LT-6, IR-1 · **RGPD**: ART-30, ART-32, ART-33 · **NIS2**: ART-21-2b, ART-21-2f |

#### ⚙️ Compute

| Component | Alignment Controls |
|:----------|:-------------------|
| **container-app-environment** | **CAF**: APP-2, NET-1 · **WAF**: NS-1, LT-1, IM-1 · **RGPD**: ART-21-2a, ART-21-2b |
| **container-app** | **CAF**: APP-2, SEC-3 · **WAF**: IM-1, IM-3, NS-1 · **RGPD**: ART-21-2a, ART-21-2h |

#### 📋 Governance

| Component | Alignment Controls |
|:----------|:-------------------|
| **resource-group** | **CAF**: RG-1, RG-2, GOV-1 |

---

## Platform-Level Security Controls

> [!NOTE]
> These controls are provided by the **AethronOps generation platform**, not by individual Azure resources. They apply to all stacks regardless of which modules are included.

| MCSB Control | Description | Evidence |
|:-------------|:-----------|:---------|
| AM-1 | CAF tags on all resources (environment, managed_by, project, stack_type, tier) | AethronOps platform |
| DS-2 | AVM verified modules — Microsoft-maintained, Checkov-tested at publication per AVM spec TFNFR5 (https://azure.github.io/Azure-Verified-Modules/spec/TFNFR5/) | AethronOps platform |
| DS-4 | Checkov 3.2.508 configuration shipped (`.checkov.yaml`) — scan reproducible via `checkov -d .` | AethronOps platform |
| DS-6 | IaC with hardened defaults — `terraform validate` passes, Checkov static analysis available pre-deployment | AethronOps platform |
| GS-3 | Data protection strategy (encryption, KV, PE) | AethronOps platform |
| IM-4 | Managed Identity — strong auth without credentials | AethronOps platform |
| IR-4 | Log Analytics — centralized investigation data | AethronOps platform |
| LT-7 | Azure platform NTP guarantee (time.windows.com) | AethronOps platform |
| PV-1 | Secure configuration baselines via tier system (dev / production) | AethronOps platform |
| PV-2 | `.checkov.yaml` + `terraform validate` included — customer can integrate in their CI/CD pipeline | AethronOps platform |

---

## Limitations & Exclusions

> [!WARNING]
> The following items are **not covered** by this stack and must be addressed separately.

- Entra ID Conditional Access policies are NOT configured (Entra ID tenant responsibility)
- Azure DDoS Protection Plan is NOT included by default (~2 700€/month additional if enabled)
- Microsoft Sentinel (SIEM) is NOT enabled — Log Analytics delivered ready to ingest into Sentinel if subscribed separately
- Custom DNS, hybrid connectivity (ExpressRoute/VPN), AMPLS for on-premises agents: additional configurations out of scope
- Multi-User Authorization (MUA) / Resource Guard on Backup Vault: manually activatable if DORA/NIS2 regulated sector requirement
- CMK (Customer-Managed Keys): Azure platform keys used by default — can be added if regulated requirement

These items are **organizational or tenant-level responsibilities** and must be addressed separately as part of your compliance program.

---

## Enterprise Requirements Checklist

<details open>
<summary><strong>Map your organization's security requirements to this stack</strong></summary>

| Requirement | AethronOps Default | Your Enterprise Policy | Status |
|:------------|:-------------------|:-----------------------|:------:|
| Data encryption at rest | AES-256 (Azure platform-managed keys — CMK not enabled) | CMK required? _____ | ☐ |
| Data encryption in transit | TLS 1.2 minimum enforced on KV + Redis (bricks present in pack) | mTLS required? _____ | ☐ |
| Network isolation | Pas de PE (tier dev) | VNet mandatory? _____ | ☐ |
| Identity & Access | Managed Identity + Azure RBAC (pas de legacy access policies) | Conditional Access? _____ | ☐ |
| Backup Vault | Pas de Backup Vault dans ce pack | Your RPO/RTO: _____ | ☐ |
| Data residency | `francecentral` | Allowed regions: _____ | ☐ |
| Logging | Log Analytics Workspace | SIEM integration? _____ | ☐ |
| Static IaC scan | .checkov.yaml shipped (v3.2.508, 0 failed at session 37 scan) | Additional scanners? _____ | ☐ |
| Tag policy | environment, project, stack_type, tier, owner, cost_center, data_classification, confidentiality_level | Additional tags: _____ | ☐ |
| Cost management | RG Budget + Action Group + cost anomaly alert | Budget threshold: _____ | ☐ |
| Resource locks | CanNotDelete enabled by default in production (RG, VNet, KV, Redis, LAW, Backup Vault, NAT GW) | Lock level: _____ | ☐ |
| Backup immutability | Backup Vault immutability=Unlocked (reversible). Promote to Locked (IRREVERSIBLE) manually if regulated requirement | Level required: _____ | ☐ |
| Secret expiry notification | Event Grid + 30-day KQL expiry alert — secret rotation itself to be implemented by customer | Rotation cycle: _____ | ☐ |

</details>

---

## Recommended Azure Policies

<details>
<summary><strong>Post-deployment policy assignments</strong></summary>

Apply these Azure Policies to strengthen security controls at the subscription/management group level:

| # | Policy | Purpose | Policy ID |
|:-:|:-------|:--------|:----------|
| 1 | Secure transfer to storage accounts | Require HTTPS | `404c3081-a854-4457-ae30-26a93ef643f9` |
| 2 | Latest TLS version | Require TLS 1.2 | `f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b` |
| 3 | Require a tag on resources | Enforce tagging | `871b6d14-10aa-478d-b590-94f262ecfa99` |
| 4 | Allowed locations | Data residency | `e56962a6-4747-49cd-b67b-bf8b01975c4c` |
| 5 | No public IPs on NICs | Network security | `83a86a26-fd1f-447c-b59d-e51f44264114` |
| 6 | Key Vault soft delete | Secret protection | `1e66c121-a66a-4b1f-9b83-0fd5c6d73f60` |
| 7 | Diagnostic settings for KV | Audit logging | `951af2fa-529b-416e-ab6e-066fd85ac459` |

> For a full initiative, see [MCSB policy initiative](https://learn.microsoft.com/azure/governance/policy/samples/azure-security-benchmark).

</details>

---

## How to Add Custom Requirements

| # | Area | How |
|:-:|:-----|:----|
| 1 | **Azure Policy** | Create a `custom_policies.tf` file with your policy assignments |
| 2 | **Checkov** | Add custom checks in `.checkov.yaml` or a `custom_checks/` directory |
| 3 | **Tags** | Set `custom_tags` variable with your mandatory tags |
| 4 | **Network** | Set `require_private_endpoints = true` for zero-trust mode |
| 5 | **CMEK** | Add `disk-encryption-set` brick for customer-managed keys |
| 6 | **SIEM** | Export Log Analytics to Azure Sentinel or your SIEM via diagnostic settings |

---

<p align="center">
<sub>Generated by <strong>AethronOps v3</strong> — Security controls are embedded in the Terraform code and verifiable via <code>terraform plan</code>.</sub><br>
<sub><strong>IMPORTANT: This document is an audit preparation aid only. It does not constitute a compliance certification, attestation, or guarantee of conformity with any law, regulation, or standard. Regulatory compliance requires formal audits by accredited assessors and depends on organizational, procedural, and contextual factors beyond infrastructure code. Consult qualified legal counsel for regulatory matters.</strong></sub>
</p>
