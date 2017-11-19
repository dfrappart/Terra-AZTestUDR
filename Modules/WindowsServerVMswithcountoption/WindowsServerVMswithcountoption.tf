###################################################################################
#This module allow the creation of Windows VMs with associated NICs
# Those are 1 NIC VMS. Please use another module for VMs requireing more than 1 NIC
###################################################################################

#Variable declaration for Module

#The VM name
variable "VMName" {
  type    = "string"

}

#The VM count
variable "VMcount" {
  type    = "string"
  default = "1"

}

#The VM location
variable "VMLocation" {
  type    = "string"

}

#The RG in which the VMs are located
variable "VMRG" {
  type    = "string"

}


#The VM size
variable "VMSize" {
  type    = "string"
  default = "Standard_F1"

}


#The Availability set reference

variable "ASID" {
  type    = "string"
  
}

#The Managed Disk Storage tier

variable "VMStorageTier" {
  type    = "string"
  default = "Premium_LRS"
  
}

#The VM Admin Name

variable "VMAdminName" {
  type    = "string"
  default = "VMAdmin"
  
}

#The VM Admin Password

variable "VMAdminPassword" {
  type    = "string"
  
}



# Managed Data Disk size

variable "DataDiskSize" {
  type    = "string"
  default = "127"
  
}



#The target subnet reference
variable "TargetSubnetId" {
  type    = "string"

}


#The target subnet range
variable "TargetSubnetRange" {
  type    = "string"

}



#define availability on Internet
variable "IsaccessiblefromInternet" {
  type    = "string"
  default = 1

}


variable "EnvironmentTag" {
  type    = "string"
  default = "Poc"
}

variable "EnvironmentUsageTag" {
  type    = "string"
  default = "Poc usage only"
}



#VM Creation

# Creating Public IP 

resource "random_string" "PublicIPfqdnprefix" {


    length = 5
    special = false
    upper = false
    number = false
}

resource "azurerm_public_ip" "TerraPublicIP" {

    count                           = "${var.IsaccessiblefromInternet ? var.VMcount : 0}"
    name                            = "${var.VMName}${count.index +1}"
    location                        = "${var.VMLocation}"
    resource_group_name             = "${var.VMRG}"
    public_ip_address_allocation    = "static"
    domain_name_label               = "${random_string.PublicIPfqdnprefix.result}${var.VMName}${count.index +1}"

    tags {
    environment = "${var.EnvironmentTag}"
    usage       = "${var.EnvironmentUsageTag}"
    }   

}


resource "azurerm_network_interface" "TerraNIC" {

    count                   = "${var.VMcount}"
    name                    = "NIC${var.VMName}${count.index +1}"
    location                = "${var.VMLocation}"
    resource_group_name     = "${var.VMRG}"

    ip_configuration {

        name                                        = "ConfigIP-NIC${count.index + 1}-${var.VMName}${count.index + 1}"
        subnet_id                                   = "${var.TargetSubnetId}"
        #private_ip_address_allocation               = "dynamic"
        private_ip_address_allocation               = "static"
        private_ip_address                          = "${cidrhost(var.TargetSubnetRange,count.index+6)}"
        public_ip_address_id                        = "${element(azurerm_public_ip.TerraPublicIP.*.id, count.index)}"
            }

    tags {
    environment = "${var.EnvironmentTag}"
    usage       = "${var.EnvironmentUsageTag}"
    }   


}

resource "azurerm_managed_disk" "TerraManagedDisk" {

    count                   = "${var.VMcount}"
    name                    = "${var.VMName}DataDisk${count.index+1}"
    location                = "${var.VMLocation}"
    resource_group_name     = "${var.VMRG}"
    storage_account_type    = "${var.VMStorageTier}"
    create_option           = "empty"
    disk_size_gb            = "${var.DataDiskSize}"

    tags {
    environment = "${var.EnvironmentTag}"
    usage       = "${var.EnvironmentUsageTag}"
  }
    
}


resource "azurerm_virtual_machine" "TerraVM" {

    count                   = "${var.VMcount}"
    name                    = "${var.VMName}${count.index +1}"
    location                = "${var.VMLocation}"
    resource_group_name     = "${var.VMRG}"
    network_interface_ids   = ["${element(azurerm_network_interface.TerraNIC.*.id, count.index)}"]
    vm_size                 = "${var.VMSize}"
    availability_set_id     = "${var.ASID}"
    depends_on              = ["azurerm_network_interface.TerraNIC","azurerm_managed_disk.TerraManagedDisk"]


    storage_image_reference {
        #get appropriate image info with the following command
        #Get-AzureRmVMImageSku -Location westeurope -Offer windowsserver -PublisherName microsoftwindowsserver
        publisher   = "MicrosoftWindowsServer"
        offer       = "WindowsServer"
        sku         = "2016-Datacenter"
        version     = "latest"

    }

    storage_os_disk {

        name                = "${var.VMName}${count.index + 1}"
        caching             = "ReadWrite"
        create_option       = "FromImage"
        managed_disk_type   = "${var.VMStorageTier}"

    }

    storage_data_disk {

        name                = "${element(azurerm_managed_disk.TerraManagedDisk.*.name, count.index)}"
        managed_disk_id     = "${element(azurerm_managed_disk.TerraManagedDisk.*.id, count.index)}"
        create_option       = "Attach"
        lun                 = 0
        disk_size_gb        = "${var.DataDiskSize}"
        

    }

    os_profile {

        computer_name   = "${var.VMName}${count.index + 1}"
        admin_username  = "${var.VMAdminName}"
        admin_password  = "${var.VMAdminPassword}"

    }

    os_profile_windows_config {

        provision_vm_agent = "true"
        enable_automatic_upgrades = "false"
    }
    

    tags {
    environment = "${var.EnvironmentTag}"
    usage       = "${var.EnvironmentUsageTag}"
    }   
    

}


output "PublicIP" {
    
    value = ["${element(azurerm_network_interface.TerraNIC.*.public_ip_address, 0)}","${element(azurerm_network_interface.TerraNIC.*.public_ip_address, 1)}","${element(azurerm_network_interface.TerraNIC.*.public_ip_address, 2)}"]

}

output "Fqdns" {
    
    value = ["${element(azurerm_network_interface.TerraNIC.*.fqdn, 0)}","${element(azurerm_network_interface.TerraNIC.*.fqdn, 1)}","${element(azurerm_network_interface.TerraNIC.*.public_ip_address, 2)}"]

}


