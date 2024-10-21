resource "azurerm_storage_account" "crgar-aca-demo-tenant-storage" {
  name                     = replace("${var.prefix}st", "-", "")
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment_name = var.environment_name
    tenant_name      = var.tenant_name
  }
}

resource "azurerm_storage_share" "crgar-aca-demo-tenant-storage-share" {
  name                 = "mounted-share"
  storage_account_name = azurerm_storage_account.crgar-aca-demo-tenant-storage.name
  quota                = 1

  metadata = {
    environment_name = var.environment_name
    tenant_name      = var.tenant_name
  }
}


resource "azurerm_storage_share" "crgar-aca-demo-tenant-storage-share2" {
  name                 = "mounted-share2"
  storage_account_name = azurerm_storage_account.crgar-aca-demo-tenant-storage.name
  quota                = 1

  metadata = {
    environment_name = var.environment_name
    tenant_name      = var.tenant_name
  }
}
resource "azurerm_storage_share" "crgar-aca-demo-tenant-storage-share3" {
  name                 = "mounted-share3"
  storage_account_name = azurerm_storage_account.crgar-aca-demo-tenant-storage.name
  quota                = 1

  metadata = {
    environment_name = var.environment_name
    tenant_name      = var.tenant_name
  }
}
output "storage_key" {
  value = azurerm_storage_account.crgar-aca-demo-tenant-storage.primary_access_key
}

output "storage_name" {
  value = azurerm_storage_account.crgar-aca-demo-tenant-storage.name
}

output "share_name" {
  value = azurerm_storage_share.crgar-aca-demo-tenant-storage-share.name
}