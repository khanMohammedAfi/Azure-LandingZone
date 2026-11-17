 targetScope = 'subscription'

@description('Regions where resources are allowed')
param allowedLocations array

@description('Tag that every resource group must have')
param requiredTagName string = 'project'

@allowed([
  'Default'
  'DoNotEnforce'
])
@description('DoNotEnforce reports only; Default blocks violations')
param enforcement string = 'DoNotEnforce'

resource allowedLocationsAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'lz-allowed-locations'
  properties: {
    displayName: 'Landing zone: allowed locations'
    policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', 'e56962a6-4747-49cd-b67b-bf8b01975c4c')
    enforcementMode: enforcement
    parameters: {
      listOfAllowedLocations: {
        value: allowedLocations
      }
    }
  }
}

resource requireTagAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'lz-require-rg-tag'
  properties: {
    displayName: 'Landing zone: require tag on resource groups'
    policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', '96670d01-0a4d-4649-9c89-2d3abc0a5025')
    enforcementMode: enforcement
    parameters: {
      tagName: {
        value: requiredTagName
      }
    }
  }
}

resource denyPublicIpAssignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: 'lz-deny-public-ip'
  properties: {
    displayName: 'Landing zone: public IP addresses not allowed'
    policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', '6c112d4e-5bc7-47ae-a041-ea2d9dccd749')
    enforcementMode: enforcement
    parameters: {
      listOfResourceTypesNotAllowed: {
        value: [
          'Microsoft.Network/publicIPAddresses'
        ]
      }
    }
  }
}
