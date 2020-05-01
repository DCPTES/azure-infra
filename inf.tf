resource "azurerm_resource_group" "vnet_rg"{
    name = "vnet-rg"
    location = "East US 2"
}

resource "azurerm_virtual_network" "couch_net"{
    name = "couch-vnet"
    address_space = ["11.0.0.0/16"]
    location = azurerm_resource_group.vnet_rg.location
    resource_group_name = azurerm_resource_group.vnet_rg.name
}

resource "azurerm_subnet" "couch_sub"{
    name = "couch-subnet"
    resource_group_name = azurerm_resource_group.vnet_rg.name
    virtual_network_name = azurerm_virtual_network.couch_net.name
    address_prefixes = ["11.0.2.0/24"]
}