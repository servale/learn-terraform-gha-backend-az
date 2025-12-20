# Terraform for Azure - Resource Group, Storage Account & Blob Container for the backend

This Terraform workspace provisions Azure resources including a resource group, storage account, and blob container with support for application and environment variables.

## Resources Created

- **Azure Resource Group**: Container for all resources
- **Azure Storage Account**: Blob storage with configurable tier and replication
- **Azure Blob Container**: For storing application data
- **Storage Blob**: JSON configuration file with app config and environment variables
- **SAS Token**: Time-limited access to the blob container

## Prerequisites

- Terraform >= 1.0
- Azure CLI installed and authenticated
- Azure subscription

## Setup

1. **Authenticate with Azure**:
   ```bash
   az login
   az account list
   az account set --subscription "YOUR_SUBSCRIPTION_ID"
   ```
2.  **Create Service Principal with Contributor Role in current subscription**:
   ```bash
   az ad sp create-for-rbac --name "terraform-sp-$(date +%s)" --role Contributor --scopes /subscriptions/$(az account show --query id -o tsv)
   ```

3. **Initialize Terraform**:
   ```bash
   terraform init
   ```

4. **Create variables file**:
   ```bash
   cp terraform.example.tfvars terraform.dev.tfvars
   ```

5. **Update `terraform.dev.tfvars`** with your values:
   - Set your subscription ID
   - Choose appropriate names and configuration

## Usage

### Plan deployment:
```bash
terraform plan -var-file="terraform.dev.tfvars"
```

### Apply configuration:
```bash
terraform apply -var-file="terraform.dev.tfvars"
```

### Destroy resources:
```bash
terraform destroy -var-file="terraform.dev.tfvars"
```

## Variables

### Required
- `subscription_id`: Azure subscription ID
- `project_name`: Project name for resource naming
- `resource_group_name`: Name of the resource group
- `storage_account_name`: Storage account name (3-24 chars, lowercase alphanumeric)
- `blob_container_name`: Name of the blob container
- `application_config`: Application configuration object

### Optional
- `environment`: Environment name (dev, staging, prod) - default: dev
- `location`: Azure region - default: East US
- `storage_account_tier`: Standard or Premium - default: Standard
- `storage_replication_type`: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS - default: LRS
- `blob_access_type`: Private, Blob, Container - default: Private
- `environment_variables`: Map of environment variables (sensitive)
- `tags`: Common tags for all resources

## Outputs

The Terraform configuration outputs:
- Resource group ID and name
- Storage account details (ID, name, endpoints)
- Blob container details (ID, name, URL)
- Connection string and access keys (sensitive)
- SAS URL with 1-year expiry (sensitive)
- Application configuration and environment info

## Remote State (Optional)

To use Azure Storage for remote state management:

1. Create a storage account and container for Terraform state
2. Uncomment the `backend` block in `terraform.tf`
3. Update with your storage account details
4. Run `terraform init` again

## Security Best Practices

- Store sensitive values (subscription ID, connection strings) in `.tfvars` file
- Add `terraform.*.tfvars` and `*.tfstate` to `.gitignore`
- Use Azure Key Vault for sensitive environment variables in production
- Enable storage account firewalls and restrict access
- Use SAS tokens with minimal required permissions and expiry
- Enable HTTPS-only traffic on storage accounts
- Set minimum TLS version to 1.2

## File Structure

```
.
├── terraform.tf              # Provider and backend configuration
├── variables.tf              # Variable definitions
├── main.tf                   # Resource definitions
├── outputs.tf                # Output definitions
├── terraform.example.tfvars  # Example variables file
└── README.md                 # This file
```

## Troubleshooting

### Storage account name already exists
Storage account names must be globally unique. Try a different name with random characters.

### Authentication errors
Ensure you're logged in with `az login` and have permissions in the subscription.

### State lock issues
If state is locked, you may need to unlock manually:
```bash
terraform force-unlock <LOCK_ID>
```

## References

- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
- [Azure Resource Group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal)
- [Azure Storage Account](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview)
- [Azure Blob Storage](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-overview)
