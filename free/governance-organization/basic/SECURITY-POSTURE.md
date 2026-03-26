# Security Controls Mapping — governance-organization

![Frameworks](https://img.shields.io/badge/Frameworks-9-success)
![Controls](https://img.shields.io/badge/Controls-20%2B-blue)
![Bricks](https://img.shields.io/badge/Modules-3-0078D4)
![Tier](https://img.shields.io/badge/Tier-basic-orange)

> **9 frameworks** · **3 modules** · **20+ controls mapped**
> Pattern: `governance-organization` (tier basic)

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
| IaC security scan | Checkov — automated security analysis, 0 failed checks | DevSecOps | .checkov.yaml |
| Module provenance | Azure Verified Modules (AVM) — Microsoft-maintained, versioned | Supply chain | README.md |
| Naming convention | CAF naming standard — consistent, auditable | Governance | All .tf files |
| Tagging policy | Mandatory tags: environment, managed_by, project | Governance | main.tf |
| Telemetry disabled | `enable_telemetry = false` on all AVM modules | Privacy | All modules |

> [!TIP]
> Firewall, Bastion, Private Endpoints, and Backup are **disabled** in tier basic (dev) to minimize costs. Enable them by deploying with tier standard or premium.

---

## Compliance Framework Mapping

### International Standards

| Framework | Controls Covered | Reference |
|:----------|:----------------|:----------|
| 🔒 **MCSB** — Microsoft Cloud Security Benchmark | AM-1, AM-2, DP-3, DS-2, DS-4, DS-6, GS-2, GS-5, LT-7, NS-8, PV-1, PV-2 | [MCSB v1](https://learn.microsoft.com/security/benchmark/azure/overview) |
| 📋 **CIS Azure** — CIS Benchmarks v2.1 | — | [CIS Azure](https://www.cisecurity.org/benchmark/azure) |
| 🏛️ **ISO 27001:2022** — Annex A | A.5.1, A.8.9 | [ISO 27001](https://www.iso.org/standard/27001) |
| 🔍 **SOC 2** — Trust Services Criteria | CC1.1, CC5.2, CC8.1 | [AICPA TSC](https://www.aicpa.org/soc2) |
| 💳 **PCI-DSS 4.0** — Payment Card Industry | 2.2, 4.2, 11.3, 12.2 | [PCI SSC](https://www.pcisecuritystandards.org/) |

### Microsoft Frameworks

| Framework | Controls Covered | Reference |
|:----------|:----------------|:----------|
| ☁️ **CAF** — Cloud Adoption Framework | GOV-1, GOV-2, NAMING-1, SEC-1 | [Microsoft CAF](https://learn.microsoft.com/azure/cloud-adoption-framework/) |
| ⚖️ **WAF** — Well-Architected Framework | — | [Azure WAF](https://learn.microsoft.com/azure/well-architected/) |

### European Regulations

| Framework | Controls Covered | Reference |
|:----------|:----------------|:----------|
| 🇪🇺 **RGPD** — EU General Data Protection Regulation | ART-25, ART-32 | [GDPR Text](https://gdpr-info.eu/) |
| 🛡️ **NIS2** — EU Directive 2022/2555 | ART-21-2a, ART-21-2f | [NIS2 Directive](https://eur-lex.europa.eu/eli/dir/2022/2555) |
| 🇫🇷 **ANSSI** — Guide cloud SecNumCloud | R1, R9 | [ANSSI Cloud](https://www.ssi.gouv.fr/guide/recommandations-cloud/) |



---

## Per-Component Compliance


#### 📦 Other

| Component | Compliance Controls |
|:----------|:-------------------|
| **management-group** | **CAF**: GOV-1, NAMING-1 · **MCSB**: GS-2, AM-2 · **RGPD**: ART-25 · **NIS2**: ART-21-2a |
| **policy-definitions** | **CAF**: GOV-2, SEC-1 · **MCSB**: PV-1, PV-2, AM-2, NS-8, DP-3 · **RGPD**: ART-25, ART-32 · **NIS2**: ART-21-2a, ART-21-2f |
| **policy-assignments** | **CAF**: GOV-2, SEC-1 · **MCSB**: PV-2, GS-5 · **RGPD**: ART-25, ART-32 · **NIS2**: ART-21-2a, ART-21-2f |

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
| Network isolation | Private endpoints (basic) | VNet mandatory? _____ | ☐ |
| Identity & Access | Managed Identity + RBAC | Conditional Access? _____ | ☐ |
| Backup & Recovery | 7d retention | Your RPO/RTO: _____ | ☐ |
| Data residency | `westeurope` | Allowed regions: _____ | ☐ |
| Logging & Monitoring | Log Analytics + App Insights | SIEM integration? _____ | ☐ |
| Vulnerability scanning | Checkov (IaC scan) | Additional scanners? _____ | ☐ |
| Tag policy | environment, managed_by, project, cost_center, owner, data_classification | Additional tags: _____ | ☐ |
| Cost management | FinOps tiers (basic/standard/premium) | Budget alert? _____ | ☐ |
| Resource locks | CanNotDelete on RG + KV | Lock level: _____ | ☐ |
| Audit immutability | WORM storage (365d) | Retention: _____ | ☐ |
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
