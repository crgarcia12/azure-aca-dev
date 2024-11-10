param location string = 'swedencentral'
param prefix string = 'crgar-aca-dev-tenant'

resource crgar_aca_dev_tenant_rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${prefix}-rg'
  location: location
}

module storage 'modules/storage/main.bicep' = {
  name: 'storage'
  params: {
    prefix: prefix
    location: location
    resource_group_name: crgar_aca_dev_tenant_rg.name
    tenant_name: 'tenant1'
    environment_name: 'dev'
  }
}

module aca 'modules/aca/main.bicep' = {
  name: 'aca'
  params: {
    prefix: prefix
    location: location
    resource_group_name: crgar_aca_dev_tenant_rg.name
    log_analytics_workspace_id: 'log_analytics_workspace_id'
    image_name: 'image_name'
    image_tag: 'image_tag'
    tenant_name: 'tenant1'
    environment_name: 'dev'
    acr_identity_id: 'acr_identity_id'
    acr_host_name: 'acr_host_name'
    tier: 'basic'
    volume_storage_key: 'volume_storage_key'
    volume_storage_name: 'volume_storage_name'
    volume_share_name: 'volume_share_name'
  }
}
