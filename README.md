# Secure Azure Landing Zone with Bicep IaC

A secure, governed Azure landing zone built entirely with **Bicep** (Infrastructure as Code). It is the foundation for hosting a **Premier League player market value and league table website**, and covers networking, identity, policy and monitoring.

Built as a semester cloud project and deployed on an Azure Free Trial subscription.

---

## Architecture

> Add your architecture diagram here, e.g. `docs/architecture.png`.

```
Subscription
└── Resource Group: RG-LandingZone-dev (Central India)
    ├── Virtual Network
    │   ├── Subnet(s) protected by NSGs
    ├── Storage Account (diagnostic logging enabled)
    ├── Log Analytics Workspace
    ├── Azure Policy assignments (allowed locations, required tags, deny public IP)
    └── RBAC role assignments (least privilege)
```

## What is deployed

| Module | Purpose |
|---|---|
| `main.bicep` | Subscription-level entry point. Creates the resource group with tags and wires in all modules. |
| `modules/storage.bicep` | Storage account for the platform. |
| `modules/network.bicep` | Virtual network, subnets and network security groups (NSGs). |
| `modules/monitoring.bicep` | Log Analytics workspace and diagnostic settings. |
| `modules/policy.bicep` | Azure Policy: allowed locations, required project tag, deny public IP. |
| `modules/rbac.bicep` | Least-privilege role assignments (Reader for the `LandingZone-Readers` group). |

> Adjust the file names above to match your `modules/` folder.

## Security design decisions

- **Least-privilege RBAC.** Access is granted to an Entra ID security group (`LandingZone-Readers`) with the **Reader** role scoped to the resource group, not to individual users and not at subscription level.
- **Network segmentation.** Workloads sit in separate subnets, each protected by an NSG so traffic is denied unless explicitly allowed.
- **Deny public IP.** A policy blocks public IP addresses on resources, so nothing is exposed to the internet by accident.
- **Region restriction.** A policy limits deployments to approved regions (Central India) to keep data residency and cost under control.
- **Mandatory tagging.** A policy requires a project tag on resource groups, which keeps ownership and cost tracking consistent.
- **Policies in audit-only mode.** Policies are assigned with `DoNotEnforce`, so they report non-compliance without blocking deployments. This is a deliberate choice during development; switching to enforcement is a one-line change.
- **Everything as code.** Every resource is defined in Bicep, so the environment is repeatable, reviewable in Git and free of manual portal drift.

## Monitoring

Diagnostic settings send storage logs to Log Analytics. Example KQL query to see recent blob operations:

```kusto
StorageBlobLogs
| project TimeGenerated, OperationName, StatusText
| order by TimeGenerated desc
| take 50
```

This surfaces operations such as `CreateContainer`, `PutBlob` and `GetBlob`.

## Getting started

### Prerequisites

- An Azure subscription (Free Trial works)
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
- [Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install) (`az bicep install`)

### Deploy

```bash
# Log in
az login

# Preview the changes
az deployment sub what-if \
  --location centralindia \
  --template-file main.bicep \
  --parameters parameters/dev.bicepparam

# Deploy
az deployment sub create \
  --location centralindia \
  --template-file main.bicep \
  --parameters parameters/dev.bicepparam
```

> Replace `parameters/dev.bicepparam` with your actual parameters file name.

## Project structure

```
azure-landing-zone/
├── main.bicep
├── modules/
│   ├── storage.bicep
│   ├── network.bicep
│   ├── monitoring.bicep
│   ├── policy.bicep
│   └── rbac.bicep
├── parameters/
└── README.md
```

## Future work

- Switch policies from audit-only to enforced
- Host the Premier League market value website inside the landing zone
- Add a background AI agent that keeps player data updated from an API
- Add a CI pipeline to validate and deploy Bicep on every push

## Tech stack

Azure, Bicep, Azure Policy, Entra ID, Azure RBAC, Log Analytics, KQL, Git and GitHub

## Author

**Afi**, Computer Science student, building toward a cloud engineering career.
