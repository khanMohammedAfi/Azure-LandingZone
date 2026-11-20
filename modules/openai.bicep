 @description('Name of the Azure OpenAI account. Also becomes its subdomain, so it must be globally unique.')
param accountName string

param location string
param tags object = {}

param modelName string = 'gpt-4.1-mini'
param modelVersion string = '2025-04-14'
param deploymentName string = 'summary-model'

@description('Capacity in thousands of tokens per minute')
param capacity int = 10

resource account 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: accountName
  location: location
  tags: tags
  kind: 'OpenAI'
  sku: {
    name: 'S0'
  }
  properties: {
    customSubDomainName: accountName
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: true
  }
}

resource deployment 'Microsoft.CognitiveServices/accounts/deployments@2024-10-01' = {
  parent: account
  name: deploymentName
  sku: {
    name: 'GlobalStandard'
    capacity: capacity
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: modelName
      version: modelVersion
    }
  }
}

output endpoint string = account.properties.endpoint
output accountName string = account.name
