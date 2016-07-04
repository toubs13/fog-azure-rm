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

network = Fog::Network::AzureRM.new(
    tenant_id: azureCredentials['tenant_id'],
    client_id: azureCredentials['client_id'],
    client_secret: azureCredentials['client_secret'],
    subscription_id: azureCredentials['subscription_id']
)

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

rg = rs.resource_groups.create(
    :name => 'TestRG-PB',
    :location => 'eastus'
)

########################################################################################################################
######################                             Check if PublicIP exists                       ######################
########################################################################################################################

network.public_ips.check_if_exists('mypubip','TestRG-PB')

########################################################################################################################
######################                               Create Public IP                             ######################
########################################################################################################################

pubip = network.public_ips.create(
    name: 'mypubip',
    resource_group: 'TestRG-PB',
    location: 'eastus',
    public_ip_allocation_method: 'Static'
)

########################################################################################################################
######################                           Get and Delete Public IP                         ######################
########################################################################################################################

pubip = network.public_ips(resource_group: 'TestRG-PB').get('mypubip')
pubip.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

rg = rs.resource_groups.get('TestRG-PB')
rg.destroy
