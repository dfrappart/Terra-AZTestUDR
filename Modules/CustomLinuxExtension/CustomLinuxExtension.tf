##############################################################
#This module allow the creation of a custom VM linux extension
##############################################################

#Variable declaration for Module

#The Agent Name
variable "AgentName" {
  type    = "string"

}

#The Agent Location
variable "AgentLocation" {
  type    = "string"

}

#The RG Name
variable "RGName" {
  type    = "string"

}

#The VM Name
variable "VMName" {
  type    = "string"

}



variable "EnvironmentTag" {
  type    = "string"
  default = "Poc"
}

variable "EnvironmentUsageTag" {
  type    = "string"
  default = "Poc usage only"
}

# Creating virtual machine extension for Backend

resource "azurerm_virtual_machine_extension" "Terra-CustomLinuxExtension" {
  

  name                 = "${var.AgentName}"
  location             = "${var.AgentLocation}"
  resource_group_name  = "${var.RGName}"
  virtual_machine_name = "${var.VMName}"
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "CustomScriptForLinux"
  type_handler_version = "1.5"
  #depends_on           = ["${var.VMId}"]

      settings = <<SETTINGS
        {   
        "fileUris": [ "https://raw.githubusercontent.com/dfrappart/Terra-AZBasiclinux/master/installmysql.sh" ],
        "commandToExecute": "bash installmysql.sh"
        }
SETTINGS
    
  tags {
    environment = "${var.EnvironmentTag}"
    usage       = "${var.EnvironmentUsageTag}"
  }
}