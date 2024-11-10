param prefix string
param location string
param resource_group_name string
param tenant_name string
param environment_name string

resource crgar_aca_demo_tenant_storage 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: '${prefix}st'
  location: location
  resourceGroupName: resource_group_name
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  tags: {
    environment_name: environment_name
    tenant_name: tenant_name
  }
}

resource crgar_aca_demo_tenant_storage_share 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-04-01' = {
  name: 'mounted-share'
  parent: crgar_aca_demo_tenant_storage
  properties: {
    quota: 1
  }
  metadata: {
    environment_name: environment_name
    tenant_name: tenant_name
  }
}

resource crgar_aca_demo_tenant_storage_share2 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-04-01' = {
  name: 'mounted-share2'
  parent: crgar_aca_demo_tenant_storage
  properties: {
    quota: 1
  }
  metadata: {
    environment_name: environment_name
    tenant_name: tenant_name
  }
}

output storage_key string = crgar_aca_demo_tenant_storage.listKeys().keys[0].value
output storage_name string = crgar_aca_demo_tenant_storage.name
output share_name string = crgar_aca_demo_tenant_storage_share.name
