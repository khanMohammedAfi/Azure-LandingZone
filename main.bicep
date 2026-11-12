targetScope = 'subscription'




@description( 'Azure Region for all resources')
param location string = 'centralindia'

@description('Environment name, used in resource name')
@minLength(1)
@maxLength(9)
param envName string = 'dev'

var rgName = 'RG-LandingZone-${envName}'
var tags = {
  project: 'LandingZone'
  environment: envName
  owner: 'Afi'
} 

resource rg  'microsoft.Resources/resourceGroups@2021-04-01' = {
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
  }
}

output resourceGroupName string = rg.name
output storageAccountName string = storage.outputs.storageAccountName
