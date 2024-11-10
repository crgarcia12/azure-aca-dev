param location string = 'swedencentral'
param prefix string = 'crgar-aca-dev-platform'

resource crgar_aca_dev_platform_rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${prefix}-rg'
  location: location
}

resource log_analytics_workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: 'crgar-aca-dev-platform-law'
  location: location
  resourceGroupName: crgar_aca_dev_platform_rg.name
  sku: {
    name: 'PerGB2018'
  }
  retentionInDays: 30
}

resource acr 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: '${prefix}acr'
  location: location
  resourceGroupName: crgar_aca_dev_platform_rg.name
  sku: {
    name: 'Standard'
  }
  adminUserEnabled: true
}

resource acr_identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: '${prefix}-identity'
  location: location
  resourceGroupName: crgar_aca_dev_platform_rg.name
}

resource acrpull_mi 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(acr.id, acr_identity.id, 'AcrPull')
  scope: acr.id
  properties: {
    roleDefinitionName: 'AcrPull'
    principalId: acr_identity.properties.principalId
  }
}

output acr_identity_id string = acr_identity.id
output acr_login_server string = acr.properties.loginServer
output law_id string = log_analytics_workspace.id
