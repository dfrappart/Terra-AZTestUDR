##############################################################
#This module allow the creation of a Netsork Security Group Rule
##############################################################

#Variable declaration for Module


# The NSG rule requires a RG location in which the NSG for which the rule is created is located
variable "RGName" {
  type    = "string"
  default = "DefaultRSG"
}

#The NSG rule requires a reference to a NSG 
variable "NSGReference" {
  type    = "string"

}



#The NSG rule source port range define the port(s) from which the trafic origing is allowed/blocked
variable "NSGRuleSourcePortRange" {
  type    = "string"
  default = "*"

} 

#The NSG rule destination port range define the port(s) on which the trafic destination is allowed/blocked
variable "NSGRuleDestinationPortRange" {
  type    = "string"
  default = "*"

} 

#The NSG rule address preifx defines the source address(es) from whichthe trafic origin is allowed/blocked
variable "NSGRuleFEAddressPrefix" {
  type    = "string"

} 

#The NSG rule address preifx defines the source address(es) from whichthe trafic origin is allowed/blocked
variable "NSGRuleSubnetAddressPrefix" {
  type    = "string"

} 

# creation of the rule denying outgoing traffic to Internet

# creation of the rule allowing SSH From FE

resource "azurerm_network_security_rule" "Terra-NSGRule1" {


    name                            = "allowSSHfromFE"
    priority                        = "101"
    direction                       = "inbound"
    access                          = "allow"
    protocol                        = "tcp"
    source_port_range               = "*"
    destination_port_range          = "22"
    source_address_prefix           = "${var.NSGRuleFEAddressPrefix}"
    destination_address_prefix      = "${var.NSGRuleSubnetAddressPrefix}"
    resource_group_name             = "${var.RGName}"
    network_security_group_name     = "${var.NSGReference}"

}

# creation of the rule allowing RDP From FE

resource "azurerm_network_security_rule" "Terra-NSGRule2" {


    name                            = "allowRDPfromFE"
    priority                        = "102"
    direction                       = "inbound"
    access                          = "allow"
    protocol                        = "tcp"
    source_port_range               = "*"
    destination_port_range          = "3389"
    source_address_prefix           = "${var.NSGRuleFEAddressPrefix}"
    destination_address_prefix      = "${var.NSGRuleSubnetAddressPrefix}"
    resource_group_name             = "${var.RGName}"
    network_security_group_name     = "${var.NSGReference}"

}

/*
resource "azurerm_network_security_rule" "Terra-NSGRule3" {


    name                            = "Denyalltointernet"
    priority                        = "4096"
    direction                       = "outbound"
    access                          = "deny"
    protocol                        = "*"
    source_port_range               = "*"
    destination_port_range          = "*"
    source_address_prefix           = "${var.NSGRuleSubnetAddressPrefix}"
    destination_address_prefix      = "Internet"
    resource_group_name             = "${var.RGName}"
    network_security_group_name     = "${var.NSGReference}"

}
*/
resource "azurerm_network_security_rule" "Terra-NSGRule3" {


    name                            = "Allowalltointernet"
    priority                        = "103"
    direction                       = "outbound"
    access                          = "allow"
    protocol                        = "*"
    source_port_range               = "*"
    destination_port_range          = "*"
    source_address_prefix           = "${var.NSGRuleSubnetAddressPrefix}"
    destination_address_prefix      = "Internet"
    resource_group_name             = "${var.RGName}"
    network_security_group_name     = "${var.NSGReference}"

}

# creation of the rule allowing traffic between all subnets

resource "azurerm_network_security_rule" "Terra-NSGRule4" {


    name                            = "allowallfromvnet"
    priority                        = "104"
    direction                       = "inbound"
    access                          = "allow"
    protocol                        = "*"
    source_port_range               = "*"
    destination_port_range          = "*"
    source_address_prefix           = "VirtualNetwork"
    destination_address_prefix      = "${var.NSGRuleSubnetAddressPrefix}"
    resource_group_name             = "${var.RGName}"
    network_security_group_name     = "${var.NSGReference}"

}

resource "azurerm_network_security_rule" "Terra-NSGRule5" {


    name                            = "allowalltovnet"
    priority                        = "105"
    direction                       = "outbound"
    access                          = "allow"
    protocol                        = "*"
    source_port_range               = "*"
    destination_port_range          = "*"
    source_address_prefix           = "${var.NSGRuleSubnetAddressPrefix}"
    destination_address_prefix      = "VirtualNetwork"
    resource_group_name             = "${var.RGName}"
    network_security_group_name     = "${var.NSGReference}"

}

# Module output


output "Rule1Name" {

  value = "${azurerm_network_security_rule.Terra-NSGRule1.name}"
}

output "Rule1Id" {

  value ="${azurerm_network_security_rule.Terra-NSGRule1.id}"
}

output "Rule1Priority" {

  value ="${azurerm_network_security_rule.Terra-NSGRule1.priority}"
}

output "Rule2Name" {

  value = "${azurerm_network_security_rule.Terra-NSGRule2.name}"
}

output "Rule2Id" {

  value ="${azurerm_network_security_rule.Terra-NSGRule2.id}"
}

output "Rule2Priority" {

  value ="${azurerm_network_security_rule.Terra-NSGRule2.priority}"
}

output "Rule3Name" {

  value = "${azurerm_network_security_rule.Terra-NSGRule3.name}"
}

output "Rule3Id" {

  value ="${azurerm_network_security_rule.Terra-NSGRule3.id}"
}

output "Rule3Priority" {

  value ="${azurerm_network_security_rule.Terra-NSGRule3.priority}"
}

output "Rule4Name" {

  value = "${azurerm_network_security_rule.Terra-NSGRule3.name}"
}

output "Rule4Id" {

  value ="${azurerm_network_security_rule.Terra-NSGRule3.id}"
}

output "Rule4Priority" {

  value ="${azurerm_network_security_rule.Terra-NSGRule3.priority}"
}

output "Rule5Name" {

  value = "${azurerm_network_security_rule.Terra-NSGRule3.name}"
}

output "Rule5Id" {

  value ="${azurerm_network_security_rule.Terra-NSGRule3.id}"
}

output "Rule5Priority" {

  value ="${azurerm_network_security_rule.Terra-NSGRule3.priority}"
}