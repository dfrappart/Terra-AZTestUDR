##############################################################
#This module allow the creation of VMs NICs
##############################################################

#Variables for NIC creation

#The NIC name
variable "NICName" {
  type    = "string"

}



#The NIC location
variable "NICLocation" {
  type    = "string"

}

#The resource Group in which the NIC are attached to
variable "RGName" {
  type    = "string"

}

#The subnet reference
variable "SubnetId" {
  type    = "string"

}

#The subnet range to define the private IP with builtin function cidr host
variable "SubnetRange" {
  type    = "string"

}

#The modifier to use with cidr host function
variable "PrivateIpmodifier" {
  type    = "string"

}

#The status of forwarding IP, usefull in case of NAT instance
variable "IPforwardingEnabled" {
  type    = "string"
  default = "false"

}

variable "EnvironmentTag" {
  type    = "string"
  default = "Poc"
}

variable "EnvironmentUsageTag" {
  type    = "string"
  default = "Poc usage only"
}

# NIC Creation 

resource "azurerm_network_interface" "TerraNIC" {


    name                    = "${var.NICName}"
    location                = "${var.NICLocation}"
    resource_group_name     = "${var.RGName}"
    enable_ip_forwarding    = "${var.IPforwardingEnabled}"

    ip_configuration {

        name                                        = "ConfigIP-NIC-${var.NICName}"
        subnet_id                                   = "${var.SubnetId}"
        private_ip_address_allocation               = "static"
        private_ip_address                          = "${cidrhost(var.SubnetRange, var.PrivateIpmodifier)}"

        
            }

    tags {
    environment = "${var.EnvironmentTag}"
    usage       = "${var.EnvironmentUsageTag}"
    }   


}

output "Name" {

  value = "${azurerm_network_interface.TerraNIC.name}"
}

output "Id" {

  value = "${azurerm_network_interface.TerraNIC.id}"
}

output "PrivateIP" {

  value = "${azurerm_network_interface.TerraNIC.private_ip_address}"
}


output "MAC" {

  value = "${azurerm_network_interface.TerraNIC.mac_address}"
}

