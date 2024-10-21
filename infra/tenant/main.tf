module "tenant" {
  for_each = local.rings

  source           = "./tenant-module"
  project_name     = "crgar-aca-dev"
  tenant_name      = each.key
  environment_name = "dev"
  tier             = each.value.tier
  image_tag        = each.value.app_version
}
