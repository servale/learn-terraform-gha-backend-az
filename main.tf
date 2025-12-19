resource "azurerm_resource_group" "main" {
  name       = var.resource_group_name
  location   = var.location
  depends_on = []

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type

  # Enable secure transfer
  https_traffic_only_enabled = true

  # Minimum TLS version
  min_tls_version = "TLS1_2"

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
    }
  )

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_storage_container" "main" {
  name                  = var.blob_container_name
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = lower(var.blob_access_type)
}

# Optional: Create a blob for application configuration
resource "azurerm_storage_blob" "app_config" {
  name                   = "app-config.json"
  storage_account_name   = azurerm_storage_account.main.name
  storage_container_name = azurerm_storage_container.main.name
  type                   = "Block"
  content_type           = "application/json"

  source_content = jsonencode({
    application = var.application_config
    environment = var.environment
    variables   = var.environment_variables
  })
}

# Optional: Storage account access keys output (use with caution)
resource "azurerm_storage_account_blob_container_sas" "main" {
  connection_string = azurerm_storage_account.main.primary_connection_string
  container_name    = azurerm_storage_container.main.name
  https_only        = true
  
  start  = timestamp()
  expiry = timeadd(timestamp(), "8760h") # 1 year

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = true
  }
}
