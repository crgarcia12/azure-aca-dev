terraform {
  required_version = ">= 1.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "crgar-aca-demo-terraform-rg"
    storage_account_name = "crgaracademotfm"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "14506188-80f8-4dc6-9b28-250051fc4ee4"
}