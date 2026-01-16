
data "azurerm_subscription" "current" {}

# ==============================================
# SP1: Main Branch Apply (Contributor Role)
# ==============================================

resource "azuread_application" "main_apply" {
  display_name = "github-${var.github_org}-${var.github_repo}-${var.environment_name}-main-apply"
  description  = "GitHub main branch Terraform apply (Contributor)"
}

resource "azuread_service_principal" "main_apply" {
  client_id = azuread_application.main_apply.client_id
}

# Main branch only: repo:org/repo:ref:refs/heads/main
resource "azuread_application_federated_identity_credential" "main_apply" {
  application_id = azuread_application.main_apply.id
  display_name   = "${var.github_org}-${var.github_repo}-${var.environment_name}-main-apply"
  description    = "For terraform apply on GitHub main branch (when merged)"

  audiences = ["api://AzureADTokenExchange"]
  issuer    = "https://token.actions.githubusercontent.com"
  subject   = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"
}

# RBAC: Contributor for apply operations
resource "azurerm_role_assignment" "main_apply_contributor" {
  scope                = data.azurerm_subscription.current.id
  principal_id         = azuread_service_principal.main_apply.object_id
  role_definition_name = "Contributor"
}

# ===============================================
# SP2: All Branches Plan (Reader Role)
# ===============================================

resource "azuread_application" "main_plan" {
  display_name = "github-${var.github_org}-${var.github_repo}-${var.environment_name}-main-plan"
  description  = "GitHub main branch Terraform plan (Reader)"
}

resource "azuread_service_principal" "main_plan" {
  client_id = azuread_application.main_plan.client_id
}

# Pull requests: repo:org/repo:pull_request
resource "azuread_application_federated_identity_credential" "main_plan" {
  application_id = azuread_application.main_plan.id
  display_name   = "${var.github_org}-${var.github_repo}-${var.environment_name}-main-plan"
  description    = "For terraform plan on GitHub main branch (when making pull request)"

  audiences = ["api://AzureADTokenExchange"]
  issuer    = "https://token.actions.githubusercontent.com"
  subject   = "repo:${var.github_org}/${var.github_repo}:pull_request"
}

# RBAC: Reader for plan operations only
resource "azurerm_role_assignment" "main_plan_reader" {
  scope                = data.azurerm_subscription.current.id
  principal_id         = azuread_service_principal.main_plan.object_id
  role_definition_name = "Reader"
}

# RBAC: Storage Blob Contributor for terraform backend initialization
resource "azurerm_role_assignment" "main_plan_storage_contributor" {
  scope                = azurerm_storage_container.state.id
  principal_id         = azuread_service_principal.main_plan.object_id
  role_definition_name = "Storage Blob Data Contributor"
}
