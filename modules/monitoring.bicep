 @description('Azure region')
param location string

@description('Name of the Log Analytics workspace')
@minLength(4)
@maxLength(63)
param workspaceName string

@description('Tags to apply')
param tags object = {}

@description('How many days to keep logs')
@minValue(30)
@maxValue(730)
param retentionInDays int = 30

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: workspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: retentionInDays
    workspaceCapping: {
      dailyQuotaGb: json('0.5')
    }
  }
}

output workspaceId string = workspace.id
output workspaceName string = workspace.name
