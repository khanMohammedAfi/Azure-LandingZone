 @description('Object ID of the Entra ID group that gets Reader access')
param readersGroupObjectId string

var readerRoleId = 'acdd72a7-3385-48ef-bd42-f606fba81ae7'

resource readerAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(readersGroupObjectId)) {
  name: guid(resourceGroup().id, readersGroupObjectId, readerRoleId)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', readerRoleId)
    principalId: readersGroupObjectId
    principalType: 'Group'
  }
}
