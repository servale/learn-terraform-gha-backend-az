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

output "blob_container_id" {
  value       = azurerm_storage_container.main.id
  description = "The ID of the created blob container"
}
output "blob_container_name" {
  value       = azurerm_storage_container.main.name
  description = "The name of the created blob container"
}
output "environment_info" {
  value = {
    environment = var.environment_name
    location    = var.primary_location
    project     = var.application_name
  }
  description = "Environment information"
}
