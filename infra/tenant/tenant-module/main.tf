data "terraform_remote_state" "platform" {
  backend = "azurerm"
  config = {
    resource_group_name  = "crgar-aca-demo-terraform-rg"
    storage_account_name = "crgaracademotfm"
    container_name       = "platformtfstate"
    key                  = "terraform.tfstate"
  }
}

locals {
  prefix   = "${var.project_name}-${var.tenant_name}"
  location = "swedencentral"
}

resource "azurerm_resource_group" "crgar-aca-dev-tenant-rg" {
  name     = "${local.prefix}-rg"
  location = local.location

  tags = {
    "environment_name" = var.environment_name
    "tenant_name"      = var.tenant_name
  }
}

module "aca" {
  source                     = "./modules/aca"
  prefix                     = local.prefix
  location                   = local.location
  resource_group_name        = azurerm_resource_group.crgar-aca-dev-tenant-rg.name
  log_analytics_workspace_id = data.terraform_remote_state.platform.outputs.law_id
  image_name                 = "${data.terraform_remote_state.platform.outputs.acr_login_server}/webapp"
  image_tag                  = var.image_tag
  tenant_name                = var.tenant_name
  environment_name           = var.environment_name
  acr_host_name              = data.terraform_remote_state.platform.outputs.acr_login_server
  acr_identity_id            = data.terraform_remote_state.platform.outputs.acr_identity_id
  tier                       = var.tier
}
