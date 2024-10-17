locals {
  tenants = {
    tenant1 = {
      type = "standard"
      image_tag = "002"
    }
    tenant2 = {
      type = "premium"
      image_tag = "002"
    }
  }
}

module "tenant" {
  for_each = local.tenants

  source           = "./tenant-module"
  project_name     = "crgar-aca-dev"
  tenant_name      = each.key
  environment_name = "dev"
  tier             = each.value.type
  image_tag        = each.value.image_tag
}
