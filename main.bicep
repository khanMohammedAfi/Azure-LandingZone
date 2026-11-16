targetScope = 'subscription'




@description( 'Azure Region for all resources')
param location string = 'centralindia'

@description('Environment name, used in resource name')
@minLength(1)
@maxLength(9)
param envName string = 'dev'

@description('Regions where resources are allowed')
param allowedLocations array = [
  'centralindia'
  'uaenorth'
]

@description('Entra ID group object ID that gets Reader on the resource group')
param readersGroupObjectId string = ''

@allowed([
  'Default'
  'DoNotEnforce'
])
param policyEnforcement string = 'DoNotEnforce'


var rgName = 'RG-LandingZone-${envName}'
var tags = {
  project: 'LandingZone'
  environment: envName
  owner: 'Afi'
} 

resource rg  'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
  tags: {
    project: 'LandingZone'
    environment: envName
    owner: 'Afi'
  }
}

module storage 'modules/storage.bicep' ={
  name:'storage-deployment'
  scope:rg
  params:{
    location:location
    namePrefix:'lz${envName}'
    tags: tags
    workspaceId: monitoring.outputs.workspaceId
  }
}
module policy 'modules/policy.bicep' = {
  name: 'policy-deployment'
  params: {
    allowedLocations: allowedLocations
    enforcement: policyEnforcement
  }
}

module monitoring 'modules/monitoring.bicep' = {
  name: 'monitoring-deployment'
  scope: rg
  params: {
    location: location
    workspaceName: 'law-landingzone-${envName}'
    tags: tags
  }
}

module network 'modules/network.bicep' = {
  name: 'network-deployment'
  scope: rg
  params: {
    location: location
    vnetName: 'vnet-landingzone-${envName}'
    tags: tags
  }
}


module rbac 'modules/rbac.bicep' = {
  name: 'rbac-deployment'
  scope: rg
  params: {
    readersGroupObjectId: readersGroupObjectId
  }
}



output resourceGroupName string = rg.name
output storageAccountName string = storage.outputs.storageAccountName
output logAnalyticsWorkspaceName string = monitoring.outputs.workspaceName
output vnetName string = network.outputs.vnetName
