locals {
  prefix          = "crgar-aca-dev-platform"
  location        = "swedencentral"
  tenant_id       = "b317d745-eb97-4068-9a14-a2e967b0b72e"
  subscription_id = "14506188-80f8-4dc6-9b28-250051fc4ee4"
}

resource "azurerm_resource_group" "crgar-aca-dev-platform-rg" {
  name     = "${local.prefix}-rg"
  location = local.location
}

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "crgar-aca-dev-platform-law"
  location            = local.location
  resource_group_name = azurerm_resource_group.crgar-aca-dev-platform-rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_registry" "acr" {
  name                = "${replace(local.prefix, "-", "")}acr"
  resource_group_name = azurerm_resource_group.crgar-aca-dev-platform-rg.name
  location            = local.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_user_assigned_identity" "acr_identity" {
  resource_group_name = azurerm_resource_group.crgar-aca-dev-platform-rg.name
  location            = local.location
  name                = "${local.prefix}-identity"
}

resource "azurerm_role_assignment" "acrpull_mi" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.acr_identity.principal_id
}

output "acr_identity_id" {
  value = azurerm_user_assigned_identity.acr_identity.id
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "law_id" {
  value = azurerm_log_analytics_workspace.log_analytics_workspace.id
}