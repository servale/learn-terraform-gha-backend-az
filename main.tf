data "azurerm_client_config" "current" {}

# ====================================================
# BACKEND INFRASTRUCTURE RESOURCES
# ====================================================
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}-${var.environment_name}-state"
  location = var.primary_location


  tags = merge(
    var.tags,
    {
      Environment = var.environment_name
      Project     = var.application_name
    }
  )
}
# ====================================================
# RANDOM STRING FOR STORAGE ACCOUNT NAME
# ====================================================
resource "random_string" "suffix" {
  length  = 10
  upper   = false
  special = false
}

# ====================================================
# STORAGE ACCOUNT AND BLOB CONTAINER
# ====================================================

resource "azurerm_storage_account" "main" {
  name                     = "st${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type

  # Enable secure transfer
  https_traffic_only_enabled = true

  # Minimum TLS version
  min_tls_version = "TLS1_2"

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 30
    }
  }

  tags = merge(
    var.tags,
    {
      Environment = var.environment_name
      Project     = var.application_name
    }
  )

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_storage_container" "main" {
  name                  = var.blob_container_name
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = lower(var.blob_access_type)
}
