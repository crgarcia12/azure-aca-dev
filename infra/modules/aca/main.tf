resource "azurerm_container_registry" "acr" {
  name                = "${replace(var.prefix, "-", "")}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_container_app_environment" "example" {
    name                = "${replace(var.prefix, "-", "")}aca-env"
    location            = var.location
    resource_group_name = var.resource_group_name
}

resource "azurerm_container_app" "example" {
    name                = "${replace(var.prefix, "-", "")}aca-app"
    container_app_environment_id = azurerm_container_app_environment.example.id
    resource_group_name = var.resource_group_name
    location            = var.location

    template {
        container {
            name   = "myapp"
            image  = var.image_name
            cpu    = 0.25
            memory = "0.5Gi"
        }

        scale {
            min_replicas = 1
            max_replicas = 5
        }
    }
}