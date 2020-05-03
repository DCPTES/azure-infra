data "azurerm_subnet" "search_subnet" {
  name                 = var.cb_subnet_id               
  virtual_network_name = var.cb_vnet_name                
  resource_group_name  = var.vnet_resource_groupname       
} 

resource "azurerm_resource_group" "couch_clu"{
    name = "couch_vm_rg1"   
    location = var.locname                                                                  
}

resource "azurerm_public_ip" "couch_public_ip" {
  name                = "couch-public-ip"
  location            = var.locname
  resource_group_name = azurerm_resource_group.couch_clu.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "couch_nic"{
    name = "${var.cb_name}-nic"                                     
    location = var.locname                                          
    resource_group_name = azurerm_resource_group.couch_clu.name

    ip_configuration{
        name = "${var.cb_name}-ip"                                           
        subnet_id = data.azurerm_subnet.search_subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.couch_public_ip.id  
    }
}

resource "azurerm_linux_virtual_machine" "couch_vm"{
    name = var.cb_name                                             
    resource_group_name = azurerm_resource_group.couch_clu.name     
    location = var.locname                                        
    size = "Standard_D2_v3"
    admin_username = var.username                                    
    admin_password = var.admin_pass                                  

    disable_password_authentication = "false"

    network_interface_ids = [ azurerm_network_interface.couch_nic.id,]

    os_disk{
      name = "${var.cb_name}-osdisk"                                                    
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference {
      publisher = "OpenLogic"
      offer     = "CentOS"
      sku       = "7.5"
      version   = "latest"
    }
  
  provisioner "file" {
    source      = "pre-provision.sh"
    destination = "/tmp/pre-provision.sh"
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = azurerm_public_ip.couch_public_ip.ip_address
      user     =  var.username                                       
      password =  var.admin_pass                                   
    }
    inline = [
      "chmod +x /tmp/pre-provision.sh",
      "/tmp/pre-provision.sh",
    ]                         
  }
}
