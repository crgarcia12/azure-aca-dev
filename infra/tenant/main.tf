locals {
  project_name     = "crgar-aca-dev"
  tenant_name      = "carlos"
  prefix           = "${local.project_name}-${local.tenant_name}"
  location         = "swedencentral"
  tenant_id        = "b317d745-eb97-4068-9a14-a2e967b0b72e"
  subscription_id  = "14506188-80f8-4dc6-9b28-250051fc4ee4"
  environment_name = "dev"
}
data "terraform_remote_state" "platform" {
  backend = "azurerm"
  config = {
    resource_group_name  = "crgar-aca-demo-terraform-rg"
    storage_account_name = "crgaracademotfm"
    container_name       = "platformtfstate"
    key                  = "terraform.tfstate"
  }
}

resource "azurerm_resource_group" "crgar-aca-dev-rg" {
  name     = "${local.prefix}-rg"
  location = local.location

  tags = {
    "environment_name" = local.environment_name
    "tenant_name"      = local.tenant_name
  }
}

module "aca" {
  source                     = "./modules/aca"
  prefix                     = local.prefix
  location                   = local.location
  resource_group_name        = azurerm_resource_group.crgar-aca-dev-rg.name
  log_analytics_workspace_id = data.terraform_remote_state.platform.outputs.law_id
  image_name                 = "${data.terraform_remote_state.platform.outputs.acr_login_server}/webapp"
  image_tag                  = "latest"
  tenant_name                = local.tenant_name
  environment_name           = local.environment_name
  acr_host_name              = data.terraform_remote_state.platform.outputs.acr_login_server
  acr_identity_id            = data.terraform_remote_state.platform.outputs.acr_identity_id
}
