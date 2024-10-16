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