output "resource_group_id" {
  value       = azurerm_resource_group.main.id
  description = "The ID of the created resource group"
}

output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "The name of the created resource group"
}

output "storage_account_id" {
  value       = azurerm_storage_account.main.id
  description = "The ID of the created storage account"
}

output "storage_account_name" {
  value       = azurerm_storage_account.main.name
  description = "The name of the created storage account"
}

output "storage_primary_blob_endpoint" {
  value       = azurerm_storage_account.main.primary_blob_endpoint
  description = "The primary blob endpoint of the storage account"
}

output "blob_container_id" {
  value       = azurerm_storage_container.main.id
  description = "The ID of the created blob container"
}

output "blob_container_name" {
  value       = azurerm_storage_container.main.name
  description = "The name of the created blob container"
}

output "blob_container_url" {
  value       = "${azurerm_storage_account.main.primary_blob_endpoint}${azurerm_storage_container.main.name}"
  description = "The URL of the blob container"
}

output "app_config_blob_url" {
  value       = azurerm_storage_blob.app_config.url
  description = "The URL of the app config blob"
}

output "storage_account_primary_connection_string" {
  value       = azurerm_storage_account.main.primary_connection_string
  description = "The primary connection string of the storage account"
  sensitive   = true
}

output "storage_account_access_key" {
  value       = azurerm_storage_account.main.primary_access_key
  description = "The primary access key of the storage account"
  sensitive   = true
}

output "blob_sas_url" {
  value       = "${azurerm_storage_account.main.primary_blob_endpoint}${azurerm_storage_container.main.name}?${azurerm_storage_account_blob_container_sas.main.sas}"
  description = "SAS URL for the blob container (1 year validity)"
  sensitive   = true
}

output "application_config" {
  value       = var.application_config
  description = "Application configuration"
}

output "environment_info" {
  value = {
    environment = var.environment
    location    = var.location
    project     = var.project_name
  }
  description = "Environment information"
}
