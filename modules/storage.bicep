@description('Azure region for all resources')
param location string = 'centralindia'

@description('short prefix for storage account name')
@minLength(3)
@maxLength(11)
param namePrefix string

@description('Tags to apply')
param tags object = {}

var storageName = '${namePrefix}${uniqueString(resourceGroup().id)}'

resource stg 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageName
  location: location
  tags: tags 
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
  
}

output storageAccountName string = stg.name
output storageAccountId string = stg.id
