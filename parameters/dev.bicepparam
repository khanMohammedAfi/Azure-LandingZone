 using '../main.bicep'

param location = 'centralindia'
param envName = 'dev'

param readersGroupObjectId = readEnvironmentVariable('READERS_GROUP_ID', '')
