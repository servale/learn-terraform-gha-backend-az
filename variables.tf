variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
  sensitive   = true
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "location" {
  type        = string
  description = "Azure region for resources"
  default     = "East US"
}

variable "project_name" {
  type        = string
  description = "Project name for resource naming"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account (must be globally unique, lowercase, 3-24 characters)"
  validation {
    condition     = length(var.storage_account_name) >= 3 && length(var.storage_account_name) <= 24 && can(regex("^[a-z0-9]+$", var.storage_account_name))
    error_message = "Storage account name must be 3-24 characters, lowercase letters and numbers only."
  }
}

variable "storage_account_tier" {
  type        = string
  description = "Storage account tier (Standard or Premium)"
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "Storage account tier must be Standard or Premium."
  }
}

variable "storage_replication_type" {
  type        = string
  description = "Storage replication type (LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS)"
  default     = "LRS"
}

variable "blob_container_name" {
  type        = string
  description = "Name of the blob container"
}

variable "blob_access_type" {
  type        = string
  description = "Blob container access type (Private, Blob, Container)"
  default     = "Private"
  validation {
    condition     = contains(["Private", "Blob", "Container"], var.blob_access_type)
    error_message = "Access type must be Private, Blob, or Container."
  }
}

variable "application_config" {
  type = object({
    name    = string
    version = string
    tier    = string
  })
  description = "Application configuration"
}

variable "environment_variables" {
  type        = map(string)
  description = "Environment variables for the application"
  sensitive   = true
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply to all resources"
  default = {
    managed_by = "terraform"
  }
}
