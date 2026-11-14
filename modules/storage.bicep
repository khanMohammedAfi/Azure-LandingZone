@description('Azure region for all resources')
param location string = 'centralindia'

@description('short prefix for storage account name')
@minLength(3)
@maxLength(11)
param namePrefix string

@description('Tags to apply')
param tags object = {}

@description('Log Analytics workspace ID to send logs to')
param workspaceId string

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

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' existing = {
  parent: stg
  name: 'default'
}

resource diag 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'send-to-log-analytics'
  scope: blobService
  properties: {
    workspaceId: workspaceId
    logs: [
      { category: 'StorageRead', enabled: true }
      { category: 'StorageWrite', enabled: true }
      { category: 'StorageDelete', enabled: true }
    ]
    metrics: [
      { category: 'Transaction', enabled: true }
    ]
  }
}

output storageAccountName string = stg.name
output storageAccountId string = stg.id
