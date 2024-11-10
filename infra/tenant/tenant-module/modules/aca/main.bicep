param prefix string
param location string
param resource_group_name string
param log_analytics_workspace_id string
param image_name string
param image_tag string
param tenant_name string
param environment_name string
param acr_identity_id string
param acr_host_name string
param tier string
param volume_storage_key string
param volume_storage_name string
param volume_share_name string

resource crgar_aca_demo_tenant_env 'Microsoft.App/managedEnvironments@2022-03-01' = {
  name: '${prefix}-aca-env'
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: log_analytics_workspace_id
      }
    }
  }
  resourceGroup: resource_group_name
}

resource crgar_aca_demo_app 'Microsoft.App/containerApps@2022-03-01' = {
  name: '${prefix}-aca-app'
  location: location
  properties: {
    managedEnvironmentId: crgar_aca_demo_tenant_env.id
    configuration: {
      ingress: {
        external: true
        targetPort: 8080
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
      registries: [
        {
          server: acr_host_name
          identity: {
            type: 'UserAssigned'
            userAssignedIdentities: [
              acr_identity_id
            ]
          }
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'processor'
          image: '${image_name}:${image_tag}'
          resources: {
            cpu: 0.25
            memory: '0.5Gi'
          }
          env: [
            {
              name: 'TENANT_NAME'
              value: tenant_name
            }
            {
              name: 'ENVIRONMENT_NAME'
              value: environment_name
            }
            {
              name: 'TIER'
              value: tier
            }
          ]
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 3
      }
    }
  }
  resourceGroup: resource_group_name
  identity: {
    type: 'SystemAssigned, UserAssigned'
    userAssignedIdentities: [
      acr_identity_id
    ]
  }
}
