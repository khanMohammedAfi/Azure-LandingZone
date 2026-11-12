targetScope = 'subscription'

@description( 'Azure Region for all resources')
param location string = 'centralindia'

@description('Environment name, used in resource name')
param envName string = 'dev'

var rgName = 'RG-LandingZone-${envName}'

resource rg  'microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
  tags: {
    project: 'LandingZone'
    environment: envName
    owner: 'Afi'
  }
}

output resourceGroupName string = rg.name
