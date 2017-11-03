###################################################################################
#This module allow the creation of 1 Windows VM with 1 NIC
###################################################################################

#Variable declaration for Module

#The VM name
variable "VMName" {
  type    = "string"

}


#The VM location
variable "VMLocation" {
  type    = "string"

}

#The RG in which the VMs are located
variable "VMRG" {
  type    = "string"

}

#The NIC to associate to the VM
variable "VMNICid" {
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

# Managed Data Disk reference

variable "DataDiskId" {
  type    = "string"

  
}

# Managed Data Disk Name

variable "DataDiskName" {
  type    = "string"

  
}

# Managed Data Disk size

variable "DataDiskSize" {
  type    = "string"
  
}

# VM images info
#get appropriate image info with the following command
#Get-AzureRMVMImagePublisher -location WestEurope
#Get-AzureRMVMImageOffer -location WestEurope -PublisherName <PublisherName>
#Get-AzureRmVMImageSku -Location westeurope -Offer <OfferName> -PublisherName <PublisherName>

variable "VMPublisherName" {
  type    = "string"
  
}


variable "VMOffer" {
  type    = "string"
  
}

variable "VMsku" {
  type    = "string"
  
}

#Tag info

variable "EnvironmentTag" {
  type    = "string"
  default = "Poc"
}

variable "EnvironmentUsageTag" {
  type    = "string"
  default = "Poc usage only"
}



#VM Creation


resource "azurerm_virtual_machine" "TerraVM" {

    name                    = "${var.VMName}"
    location                = "${var.VMLocation}"
    resource_group_name     = "${var.VMRG}"
    network_interface_ids   = ["${var.VMNICid}"]
    vm_size                 = "${var.VMSize}"
    availability_set_id     = "${var.ASID}"
    


    storage_image_reference {
        #get appropriate image info with the following command
        #Get-AzureRmVMImageSku -Location westeurope -Offer windowsserver -PublisherName microsoftwindowsserver
        publisher   = "${var.VMPublisherName}"
        offer       = "${var.VMOffer}"
        sku         = "${var.VMsku}"
        version     = "latest"

    }

    storage_os_disk {

        name                = "${var.VMName}OSDisk"
        caching             = "ReadWrite"
        create_option       = "FromImage"
        managed_disk_type   = "${var.VMStorageTier}"

    }

    storage_data_disk {

        name                = "${var.DataDiskName}"
        managed_disk_id     = "${var.DataDiskId}"
        create_option       = "Attach"
        lun                 = 0
        disk_size_gb        = "${var.DataDiskSize}"
        

    }

    os_profile {

        computer_name   = "${var.VMName}"
        admin_username  = "${var.VMAdminName}"
        admin_password  = "${var.VMAdminPassword}"

    }

    os_profile_linux_config {

        disable_password_authentication = "false"

    ssh_keys {
      path     = "/home/${var.VMAdminName}/.ssh/authorized_keys"
      key_data = "${var.AzurePublicSSHKey}"
    }
    }
    

    tags {
    environment = "${var.EnvironmentTag}"
    usage       = "${var.EnvironmentUsageTag}"
    }   
    

}


output "Name" {

  value = "${azurerm_virtual_machine.TerraVM.name}"
}

output "Id" {

  value = "${azurerm_virtual_machine.TerraVM.id}"
}

