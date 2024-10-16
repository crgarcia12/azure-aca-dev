locals {
  prefix          = "crgar-aca-dev"
  location        = "swedencentral"
  tenant_id       = "b317d745-eb97-4068-9a14-a2e967b0b72e"
  subscription_id = "14506188-80f8-4dc6-9b28-250051fc4ee4"
}

resource "azurerm_resource_group" "crgar-aca-dev-rg" {
  name     = "${local.prefix}-rg"
  location = local.location
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "acctest-01"
  location            = azurerm_resource_group.spoke_rg.location
  resource_group_name = azurerm_resource_group.spoke_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

module "aca" {
  source                     = "./modules/aca"
  prefix                     = local.prefix
  location                   = local.location
  resource_group_name        = azurerm_resource_group.spoke_rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
  image_name                 = "myimage"
}
