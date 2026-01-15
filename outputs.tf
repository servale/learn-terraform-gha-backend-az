# ====================================================
# Backend Infrastructure Outputs
# ====================================================
/*
output "resource_group_name" {
  value       = azurerm_resource_group.state.name
  description = "The name of the created resource group"
}

output "storage_account_name" {
  value       = azurerm_storage_account.state.name
  description = "The name of the created storage account"
}

output "blob_container_name" {
  value       = azurerm_storage_container.state.name
  description = "The name of the created blob container"
}
*/
output "Backend Values" {
  value = {
    "1. ARM_TENANT_ID"        = data.azurerm_client_config.current.tenant_id
    "2. ARM_SUBSCRIPTION_ID"  = data.azurerm_client_config.current.subscription_id
    "3. RESOURCE_GROUP_NAME"  = azurerm_resource_group.state.name
    "4. STORAGE_ACCOUNT_NAME" = azurerm_storage_account.state.name
    "5. CONTAINER_NAME"       = azurerm_storage_container.state.name
  }
  description = "Map of backend values (Add to GitHub Secrets)"
}


# ====================================================
# Environment Information
# ====================================================

output "Environment Information" {
  value = {
    environment = var.environment_name
    location    = var.primary_location
    project     = var.application_name
  }
  description = "Environment information"
}

# ====================================================
# Azure Context (Shared by Both SPs)
# ====================================================
/*
output "azure_tenant_id" {
  description = "Azure Tenant ID (use in GitHub secret: AZURE_TENANT_ID)"
  value       = data.azurerm_client_config.current.tenant_id
}

output "azure_subscription_id" {
  description = "Azure Subscription ID (use in GitHub secret: AZURE_SUBSCRIPTION_ID)"
  value       = data.azurerm_subscription.current.subscription_id
}
*/
# ====================================================
# SP1: Main Branch Apply Credentials
# ====================================================
/*
output "main_apply_client_id" {
  description = "Service Principal Client ID for main branch apply operations (use in GitHub secret: APPLY_CLIENT_ID)"
  value       = azuread_service_principal.main_apply.client_id
  sensitive   = true
}

output "main_apply_object_id" {
  description = "Service Principal Object ID for main branch SP (used for RBAC assignments)"
  value       = azuread_service_principal.main_apply.object_id
}
*/
output "OIDC Apply and Plan values" {
  value = {
    "1. PLAN_CLIENT_ID"       = azuread_service_principal.main_plan.client_id
    "2. PLAN_OBJECT_ID"       = azuread_service_principal.main_plan.object_id
    "3. Pull Request Subject" = "repo:${var.github_org}/${var.github_repo}:pull_request"
    "4. APPLY_CLIENT_ID"      = azuread_service_principal.main_apply.client_id
    "5. APPLY_OBJECT_ID"      = azuread_service_principal.main_apply.object_id
    "6. Main Branch Subject"  = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"

  }
  description = "Map of terraform apply service principal values"
}

# ====================================================
# SP2: All Branches Plan-Only Credentials
# ====================================================
/*
output "plan_client_id" {
  description = "Service Principal Client ID for plan operations on all main (use in GitHub secret: PLAN_CLIENT_ID)"
  value       = azuread_service_principal.main_plan.client_id
  sensitive   = true
}

output "plan_object_id" {
  description = "Service Principal Object ID for plan SP (used for RBAC assignments)"
  value       = azuread_service_principal.main_plan.object_id
}
*/
# ====================================================
# GitHub Federated Credential Info (for reference)
# ====================================================
/*
output "main_branch_pr_subject" {
  description = "Federated credential subject for main branch"
  value       = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"
}

output "pull_request_subject" {
  description = "Federated credential subject for pull requests"
  value       = "repo:${var.github_org}/${var.github_repo}:pull_request"
}
*/

# ====================================================
# Summary Instructions
# ====================================================

output "github_secrets_setup" {
  description = "Instructions for setting up GitHub secrets"
  value       = <<-EOT
  
  ================================
  GitHub Secrets Setup Instructions
  ================================
  
  Add these secrets to your GitHub repository:
  Settings → Secrets and variables → Actions → New repository secret
  
  Required Secrets:
  -----------------
  1. APPLY_CLIENT_ID = ${azuread_service_principal.main_apply.client_id}
  2. PLAN_CLIENT_ID = ${azuread_service_principal.main_plan.client_id}
  3. AZURE_TENANT_ID = ${data.azurerm_client_config.current.tenant_id}
  4. AZURE_SUBSCRIPTION_ID = ${data.azurerm_subscription.current.subscription_id}
  
  Workflow Usage:
  ---------------
  - Main branch pushes: Uses APPLY_CLIENT_ID (Contributor role)
  - Other branches/PRs: Uses PLAN_CLIENT_ID (Reader role)
  
  Verification:
  -------------
  Run: terraform output -json | jq
  
  EOT
  sensitive   = true
}
