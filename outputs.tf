# ====================================================
# Backend Infrastructure Outputs
# ====================================================

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

output "test_out_map" {
  value = {
    resource_group_name  = azurerm_resource_group.state.name
    container_name       = azurerm_storage_container.state.name
    storage_account_name = azurerm_storage_account.state.name
  }
  description = "Map of backend infrastructure names"
}
# ====================================================
# Environment Information
# ====================================================

output "environment_info" {
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

output "azure_tenant_id" {
  description = "Azure Tenant ID (use in GitHub secret: AZURE_TENANT_ID)"
  value       = data.azurerm_client_config.current.tenant_id
}

output "azure_subscription_id" {
  description = "Azure Subscription ID (use in GitHub secret: AZURE_SUBSCRIPTION_ID)"
  value       = data.azurerm_subscription.current.subscription_id
}

# ====================================================
# SP1: Main Branch Apply Credentials
# ====================================================

output "main_apply_client_id" {
  description = "Service Principal Client ID for main branch apply operations (use in GitHub secret: MAIN_APPLY_CLIENT_ID)"
  value       = azuread_service_principal.main_apply.client_id
  sensitive   = true
}

output "main_apply_object_id" {
  description = "Service Principal Object ID for main branch SP (used for RBAC assignments)"
  value       = azuread_service_principal.main_apply.object_id
}

# ====================================================
# SP2: All Branches Plan-Only Credentials
# ====================================================

output "plan_client_id" {
  description = "Service Principal Client ID for plan operations on all branches/PRs (use in GitHub secret: PLAN_CLIENT_ID)"
  value       = azuread_service_principal.all_branches_plan.client_id
  sensitive   = true
}

output "plan_object_id" {
  description = "Service Principal Object ID for plan SP (used for RBAC assignments)"
  value       = azuread_service_principal.all_branches_plan.object_id
}

# ====================================================
# GitHub Federated Credential Info (for reference)
# ====================================================

output "main_branch_subject" {
  description = "Federated credential subject for main branch"
  value       = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"
}

output "all_branches_subject" {
  description = "Federated credential subject for all branches"
  value       = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/*"
}

output "pull_request_subject" {
  description = "Federated credential subject for pull requests"
  value       = "repo:${var.github_org}/${var.github_repo}:pull_request"
}

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
  1. MAIN_APPLY_CLIENT_ID = ${azuread_service_principal.main_apply.client_id}
  2. PLAN_CLIENT_ID = ${azuread_service_principal.all_branches_plan.client_id}
  3. AZURE_TENANT_ID = ${data.azurerm_client_config.current.tenant_id}
  4. AZURE_SUBSCRIPTION_ID = ${data.azurerm_subscription.current.subscription_id}
  
  Workflow Usage:
  ---------------
  - Main branch pushes: Uses MAIN_APPLY_CLIENT_ID (Contributor role)
  - Other branches/PRs: Uses PLAN_CLIENT_ID (Reader role)
  
  Verification:
  -------------
  Run: terraform output -json | jq
  
  EOT
  sensitive   = true
}
