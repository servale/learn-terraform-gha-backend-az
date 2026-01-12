
data "azurerm_client_config" "current" {}

# ==============================================
# SP1: Main Branch Apply (Contributor Role)
# ==============================================

resource "azuread_application" "main_apply" {
  display_name = "github-${var.github_org}-${var.github_repo}-main-apply"
  description  = "GitHub main branch Terraform apply (Contributor)"
}

resource "azuread_service_principal" "main_apply" {
  client_id = azuread_application.main_apply.client_id
}

# Main branch only: repo:org/repo:ref:refs/heads/main
resource "azuread_application_federated_identity_credential" "main_apply_main_branch" {
  application_id = azuread_application.main_apply.id
  display_name   = "${var.github_org}-${var.github_repo}-main-branch"
  description    = "GitHub main branch only"

  audiences = ["api://AzureADTokenExchange"]
  issuer    = "https://token.actions.githubusercontent.com"
  subject   = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"
}

# RBAC: Contributor for apply operations
resource "azurerm_role_assignment" "main_apply_contributor" {
  scope                = data.azurerm_client_config.current.subscription_id
  principal_id         = azuread_service_principal.main_apply.object_id
  role_definition_name = "Contributor"
}

# ===============================================
# SP2: All Branches Plan (Reader Role)
# ===============================================

resource "azuread_application" "all_branches_plan" {
  display_name = "github-${var.github_org}-${var.github_repo}-plan-only"
  description  = "GitHub all branches/PRs Terraform plan (Reader)"
}

resource "azuread_service_principal" "all_branches_plan" {
  client_id = azuread_application.all_branches_plan.client_id
}

# Pull requests: repo:org/repo:pull_request
resource "azuread_application_federated_identity_credential" "all_branches_plan_pr" {
  application_id = azuread_application.all_branches_plan.id
  display_name   = "${var.github_org}-${var.github_repo}-pull-requests"
  description    = "GitHub pull requests (plan only)"

  audiences = ["api://AzureADTokenExchange"]
  issuer    = "https://token.actions.githubusercontent.com"
  subject   = "repo:${var.github_org}/${var.github_repo}:pull_request"
}

# RBAC: Reader for plan operations only
resource "azurerm_role_assignment" "all_branches_plan_reader" {
  scope                = data.azurerm_client_config.current.subscription_id
  principal_id         = azuread_service_principal.all_branches_plan.object_id
  role_definition_name = "Reader"
}
