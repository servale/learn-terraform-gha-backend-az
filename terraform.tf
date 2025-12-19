terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Uncomment below to use Azure Storage backend for remote state
  # backend "azurerm" {
  #   resource_group_name  = "your-rg-name"
  #   storage_account_name = "your-storage-name"
  #   container_name       = "tfstate"
  #   key                  = "terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}
