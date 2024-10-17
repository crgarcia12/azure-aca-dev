resource "azurerm_container_app_environment" "crgar-aca-demo-tenant-env" {
  name                       = "${var.prefix}-aca-env"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id

  tags = {
    environment_name = var.environment_name
    tenant_name      = var.tenant_name
  }
}

resource "azurerm_container_app_environment_storage" "storage" {
  access_key                   = var.volume_storage_key
  account_name                 = var.volume_storage_name
  share_name                   = var.volume_share_name
  access_mode                  = "ReadWrite"
  container_app_environment_id = azurerm_container_app_environment.crgar-aca-demo-tenant-env.id
  name                         = "mount"
}

resource "azurerm_container_app" "crgar-aca-demo-app" {
  name                         = "${var.prefix}-aca-app"
  container_app_environment_id = azurerm_container_app_environment.crgar-aca-demo-tenant-env.id
  resource_group_name          = var.resource_group_name

  revision_mode = "Multiple"

  template {
    container {
      name   = "processor"
      image  = "${var.image_name}:${var.image_tag}"
      cpu    = 0.25
      memory = "0.5Gi"

      volume_mounts {
        name = azurerm_container_app_environment_storage.storage.name
        path = "/mnt"
      }

      env {
        name  = "TENANT_NAME"
        value = var.tenant_name
      }
      env {
        name  = "ENVIRONMENT_NAME"
        value = var.environment_name
      }
      env {
        name  = "TIER"
        value = var.tier
      }

    }
    revision_suffix = var.image_tag
    min_replicas    = 1
    max_replicas    = 3

  }

  ingress {
    allow_insecure_connections = true
    target_port                = 8080
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
    external_enabled = true
  }

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [var.acr_identity_id]
  }

  registry {
    identity = var.acr_identity_id
    server   = var.acr_host_name
  }

  tags = {
    environment_name = var.environment_name
    tenant_name      = var.tenant_name
    revision         = var.image_tag
  }

}