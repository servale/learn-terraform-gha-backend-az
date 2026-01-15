# ====================================================
# Backend Infrastructure Outputs
# ====================================================

output "Backend_Values" {
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

output "Environment_Information" {
  value = {
    environment = var.environment_name
    location    = var.primary_location
    project     = var.application_name
  }
  description = "Environment information"
}

# ====================================================
# Service principals: Apply and Plan Credentials
# ====================================================

output "Credential_Info" {
  value = {
    "1. PLAN_CLIENT_ID"       = azuread_service_principal.main_plan.client_id
    "2. Pull Request Subject" = "repo:${var.github_org}/${var.github_repo}:pull_request"
    "3. APPLY_CLIENT_ID"      = azuread_service_principal.main_apply.client_id
    "4. Main Branch Subject"  = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"

  }
  description = "Map of terraform apply service principal values"
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
