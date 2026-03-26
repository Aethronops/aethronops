# Security Controls Mapping — governance-subscription

![Frameworks](https://img.shields.io/badge/Frameworks-9-success)
![Controls](https://img.shields.io/badge/Controls-41%2B-blue)
![Bricks](https://img.shields.io/badge/Modules-8-0078D4)
![Tier](https://img.shields.io/badge/Tier-standard-orange)

> **9 frameworks** · **8 modules** · **41+ controls mapped**
> Pattern: `governance-subscription` (tier standard)

> [!IMPORTANT]
> **DISCLAIMER — READ BEFORE USE**
>
> This document maps the technical security controls implemented in the Terraform code to recognized compliance frameworks. **It is provided for informational purposes only as an aid for audit preparation. It does NOT constitute:**
> - A compliance certification or attestation
> - A guarantee of conformity with any law, regulation, or standard
> - Legal or regulatory advice
> - A substitute for a formal audit by accredited assessors
>
> Regulatory compliance (NIS2, RGPD, DORA, PCI-DSS, HDS, ISO 27001, SOC 2, etc.) depends on organizational, procedural, and contextual factors beyond infrastructure code.
> **You must engage qualified legal counsel and/or accredited auditors to validate compliance for your specific context.** AethronOps provides technical foundations aligned with these frameworks but does not certify, attest, or guarantee compliance.
>
> See the Disclaimer section in README.md for full terms.

---

## Security Controls Configured in Code

> [!NOTE]
> All controls below are **configurations defined in the Terraform code**, verifiable via `terraform plan`. Their effectiveness depends on proper deployment, ongoing management, and organizational security practices by the Buyer.

| Control | Configuration | Scope | Evidence |
|:--------|:--------------|:------|:---------|
| Encryption at rest | AES-256 via Azure platform | All services | All .tf files |
| Encryption in transit | TLS 1.2 minimum configured | All services | All .tf files |
| Zero secrets | Managed Identity (no API keys/passwords stored) | Authentication | identity.tf |
| Centralized logging | Log Analytics Workspace — audit trail, diagnostics, alerts | Monitoring | monitoring.tf |
| IaC security scan | Checkov — automated security analysis, 0 failed checks | DevSecOps | .checkov.yaml |
| Module provenance | Azure Verified Modules (AVM) — Microsoft-maintained, versioned | Supply chain | README.md |
| Naming convention | CAF naming standard — consistent, auditable | Governance | All .tf files |
| Tagging policy | Mandatory tags: environment, managed_by, project | Governance | main.tf |
| Telemetry disabled | `enable_telemetry = false` on all AVM modules | Privacy | All modules |

> [!TIP]
> All network security controls are **enabled** in tier standard.

---

## Compliance Framework Mapping

### International Standards

| Framework | Controls Covered | Reference |
|:----------|:----------------|:----------|
| 🔒 **MCSB** — Microsoft Cloud Security Benchmark | AM-1, AM-3, DP-2, DS-2, DS-4, DS-6, ES-1, IM-1, IM-3, IM-4, IR-1, IR-2, IR-4, LT-1, LT-3, LT-4, LT-5, LT-6, LT-7, PA-7, PV-1, PV-2 | [MCSB v1](https://learn.microsoft.com/security/benchmark/azure/overview) |
| 📋 **CIS Azure** — CIS Benchmarks v2.1 | 1.1, 5.1.1, 5.1.4, 5.1.5 | [CIS Azure](https://www.cisecurity.org/benchmark/azure) |
| 🏛️ **ISO 27001:2022** — Annex A | A.5.1, A.5.15, A.8.15, A.8.16, A.8.3, A.8.5, A.8.9 | [ISO 27001](https://www.iso.org/standard/27001) |
| 🔍 **SOC 2** — Trust Services Criteria | CC1.1, CC5.2, CC6.1, CC6.3, CC7.1, CC7.2, CC7.3, CC8.1 | [AICPA TSC](https://www.aicpa.org/soc2) |
| 💳 **PCI-DSS 4.0** — Payment Card Industry | 2.2, 4.2, 7.2, 8.3, 8.6, 10.2, 10.3, 10.7, 11.3, 12.2 | [PCI SSC](https://www.pcisecuritystandards.org/) |

### Microsoft Frameworks

| Framework | Controls Covered | Reference |
|:----------|:----------------|:----------|
| ☁️ **CAF** — Cloud Adoption Framework | FINOPS-1, GOV-1, GOV-3, ID-1, ID-2, MON-1, OPS-1, OPS-2, RG-1, RG-2, SEC-1 | [Microsoft CAF](https://learn.microsoft.com/azure/cloud-adoption-framework/) |
| ⚖️ **WAF** — Well-Architected Framework | — | [Azure WAF](https://learn.microsoft.com/azure/well-architected/) |

### European Regulations

| Framework | Controls Covered | Reference |
|:----------|:----------------|:----------|
| 🇪🇺 **RGPD** — EU General Data Protection Regulation | ART-25, ART-30, ART-32, ART-33 | [GDPR Text](https://gdpr-info.eu/) |
| 🛡️ **NIS2** — EU Directive 2022/2555 | ART-21-2b, ART-21-2e, ART-21-2f, ART-21-2i | [NIS2 Directive](https://eur-lex.europa.eu/eli/dir/2022/2555) |
| 🇫🇷 **ANSSI** — Guide cloud SecNumCloud | R1, R4, R5, R6, R9, R10 | [ANSSI Cloud](https://www.ssi.gouv.fr/guide/recommandations-cloud/) |


### DORA — Digital Operational Resilience Act (EU 2022/2554)

> In force since **17 January 2025**. Lex specialis for financial entities.


| Article | Requirement | Implementation |
|:--------|:-----------|:---------------|
| Art. 9 | Protection & prevention | Firewall, Key Vault, TLS 1.2, PE, Managed Identity |
| Art. 10 | Detection | Log Analytics, Application Insights, diagnostic settings |
| Art. 13 | Logging | Log Analytics retention (30-730 days), tamper-evident WORM |

#### Incident Reporting Timelines (DORA Art. 19)

| Phase | Deadline | Content |
|:------|:---------|:--------|
| Initial notification | **4 hours** after classification as major, max **24 hours** after discovery | Classification, initial impact, affected services |
| Intermediate report | **72 hours** | Root cause analysis, impact assessment, recovery measures |
| Final report | **1 month** | Full post-incident review, lessons learned, remediation plan |

> [!NOTE]
> Automated alerting via Log Analytics + Action Groups can accelerate initial notification.
> Integration with Azure Sentinel recommended for SOC automation (not included in this stack).

#### Crypto-Agility Plan (DORA RTS Art. 6)

DORA RTS explicitly mentions **post-quantum cryptographic risks**. Organizations must maintain:

1. **Inventory** of all cryptographic algorithms in use (TLS versions, key sizes, hash functions)
2. **Migration plan** for transitioning to post-quantum algorithms when NIST standards are finalized
3. **Key management** via Azure Key Vault with documented rotation policies
4. **Minimum key sizes**: RSA-3072/4096 for asymmetric, AES-256 for symmetric

> Current stack uses **AES-256** (at rest) and **TLS 1.3** (in transit on App Service, Functions, PostgreSQL, MySQL) / **TLS 1.2** minimum on all other services — above MCSB DP-3 requirements.
> Post-quantum migration will require updating TLS configurations when Azure supports PQ algorithms.



---

## Per-Component Compliance


#### 🛡️ Identity

| Component | Compliance Controls |
|:----------|:-------------------|
| **managed-identity** | **CAF**: ID-1, ID-2 · **MCSB**: IM-1, IM-3 · **RGPD**: ART-25, ART-32 · **NIS2**: ART-21-2i |

#### 📊 Monitoring

| Component | Compliance Controls |
|:----------|:-------------------|
| **log-analytics** | **CAF**: OPS-1, OPS-2, GOV-3 · **MCSB**: LT-1, LT-3, LT-4, LT-5, LT-6, IR-1 · **RGPD**: ART-30, ART-32, ART-33 · **NIS2**: ART-21-2b, ART-21-2f · **DORA**: ART-10, ART-13, ART-17 |

#### 📋 Governance

| Component | Compliance Controls |
|:----------|:-------------------|
| **resource-group** | **CAF**: RG-1, RG-2, GOV-1 |

#### 📦 Other

| Component | Compliance Controls |
|:----------|:-------------------|
| **subscription-diagnostic** | **CAF**: MON-1, SEC-1 · **MCSB**: LT-3, LT-5 · **RGPD**: ART-30, ART-33 · **NIS2**: ART-21-2b |
| **subscription-budget** | **CAF**: FINOPS-1, GOV-1 · **MCSB**: AM-3 |
| **security-contact** | **CAF**: SEC-1 · **MCSB**: IR-2 · **RGPD**: ART-33 · **NIS2**: ART-21-2b |
| **defender-plans** | **CAF**: SEC-1, MON-1 · **MCSB**: LT-1, ES-1, DP-2 · **RGPD**: ART-32, ART-33 · **NIS2**: ART-21-2b, ART-21-2e |
| **rbac-assignments** | **CAF**: SEC-1, GOV-1 · **MCSB**: PA-7, IM-1 · **RGPD**: ART-25, ART-32 · **NIS2**: ART-21-2i |

---

## Platform-Level Security Controls

> [!NOTE]
> These controls are provided by the **AethronOps generation platform**, not by individual Azure resources. They apply to all stacks regardless of which modules are included.

| MCSB Control | Description | Evidence |
|:-------------|:-----------|:---------|
| AM-1 | CAF tags on all resources (environment, managed_by, project) | AethronOps platform |
| DS-2 | AVM verified modules — Microsoft-maintained supply chain | AethronOps platform |
| DS-4 | Checkov SAST integrated in CI/CD pipeline | AethronOps platform |
| DS-6 | IaC with hardened defaults, checkov pre-deployment scan | AethronOps platform |
| IM-4 | Managed Identity — strong auth without credentials | AethronOps platform |
| IR-4 | Log Analytics — centralized investigation data | AethronOps platform |
| LT-7 | Azure platform NTP guarantee (time.windows.com) | AethronOps platform |
| PV-1 | Secure configuration baselines via tier system | AethronOps platform |
| PV-2 | Checkov audit + terraform validate enforcement | AethronOps platform |

---

## Limitations & Exclusions

> [!WARNING]
> The following items are **not covered** by this stack and must be addressed separately.

- Azure AD Conditional Access policies are NOT configured (organizational policy)
- Azure DDoS Protection Plan is NOT included (cost: ~2 700€/month)
- Microsoft Defender for Cloud is NOT enabled (requires tenant-level configuration)
- Custom DNS, hybrid connectivity (ExpressRoute/VPN) require additional configuration

These items are **organizational or tenant-level responsibilities** and must be addressed separately as part of your compliance program.

---

## Enterprise Requirements Checklist

<details open>
<summary><strong>Map your organization's security requirements to this stack</strong></summary>

| Requirement | AethronOps Default | Your Enterprise Policy | Status |
|:------------|:-------------------|:-----------------------|:------:|
| Data encryption at rest | AES-256 (Azure managed keys) | CMEK required? _____ | ☐ |
| Data encryption in transit | TLS 1.2 configured | mTLS required? _____ | ☐ |
| Network isolation | Private endpoints (standard) | VNet mandatory? _____ | ☐ |
| Identity & Access | Managed Identity + RBAC | Conditional Access? _____ | ☐ |
| Backup & Recovery | 30d retention | Your RPO/RTO: _____ | ☐ |
| Data residency | `westeurope` | Allowed regions: _____ | ☐ |
| Logging & Monitoring | Log Analytics + App Insights | SIEM integration? _____ | ☐ |
| Vulnerability scanning | Checkov (IaC scan) | Additional scanners? _____ | ☐ |
| Tag policy | environment, managed_by, project, cost_center, owner, data_classification | Additional tags: _____ | ☐ |
| Cost management | FinOps tiers (basic/standard/premium) | Budget alert? _____ | ☐ |
| Resource locks | CanNotDelete on RG + KV | Lock level: _____ | ☐ |
| Audit immutability | WORM storage (90d) | Retention: _____ | ☐ |
| Secret rotation | Key Vault expiry + rotation | Rotation cycle: _____ | ☐ |

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
<sub>Generated by <strong>AethronOps v2</strong> — Security controls are embedded in the Terraform code and verifiable via <code>terraform plan</code>.</sub><br>
<sub><strong>IMPORTANT: This document is an audit preparation aid only. It does not constitute a compliance certification, attestation, or guarantee of conformity with any law, regulation, or standard. Regulatory compliance requires formal audits by accredited assessors and depends on organizational, procedural, and contextual factors beyond infrastructure code. Consult qualified legal counsel for regulatory matters.</strong></sub>
</p>
