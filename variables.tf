variable "environment_name" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment_name)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "primary_location" {
  type        = string
  description = "Azure region for resources"
  default     = "canadacentral"
}

variable "application_name" {
  type        = string
  description = "Application name for resource naming"
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
variable "tags" {
  type        = map(string)
  description = "Default tags to apply to all resources"
  default = {
    managed_by = "terraform"
  }
}
