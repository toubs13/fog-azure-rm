require 'fog/azurerm'
require 'yaml'

########################################################################################################################
######################                   Services object required by all actions                  ######################
######################                              Keep it Uncommented!                          ######################
########################################################################################################################

azureCredentials = YAML.load_file('credentials/azure.yml')

rs = Fog::Resources::AzureRM.new(
    tenant_id: azureCredentials['tenant_id'],
    client_id: azureCredentials['client_id'],
    client_secret: azureCredentials['client_secret'],
    subscription_id: azureCredentials['subscription_id']
)

storage = Fog::Storage::AzureRM.new(
    tenant_id: azureCredentials['tenant_id'],
    client_id: azureCredentials['client_id'],
    client_secret: azureCredentials['client_secret'],
    subscription_id: azureCredentials['subscription_id']
)

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

rg = rs.resource_groups.create(
    :name => 'TestRG-SA',
    :location => 'eastus'
)

########################################################################################################################
######################                    Check Storage Account name Availability                 ######################
########################################################################################################################

storage.storage_accounts.check_name_availability('test-storage')

########################################################################################################################
######################                             Create Storage Account                         ######################
########################################################################################################################

storage = storage.storage_accounts.create(
    :name => 'test-storage',
    :location => 'eastus',
    :resource_group => 'TestRG-SA'
)

########################################################################################################################
######################                         Get and Delete Storage Account                     ######################
########################################################################################################################

storage = storage.storage_accounts(:resource_group => 'TestRG-SA').get('test-storage')
storage.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

rg = rs.resource_groups.get('TestRG-SA')
rg.destroy