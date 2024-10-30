module "tenant" {
  for_each = local.tenants

  source           = "./tenant-module"
  project_name     = "crgar-aca-prod"
  tenant_name      = each.key
  environment_name = "prod"
  tier             = each.value.tier
  image_tag        = each.value.app_version
}
