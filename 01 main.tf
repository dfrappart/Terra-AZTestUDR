#This template aimed to build the following environment
#1RG
#1 vNET
#
#5 subnet for applications VMs
#traffic between those subnet is tbd
#
#1 subnet for RDS access - this subnet should be able to access all vms in all subnet
# RDS should be allowed only from specific addresses
#
#user defined route should be defined regarding the rooter VMs
#5VMS deployed
#1 with 6 NIC
#1 with 2 nic
#3 with 1 Nic

######################################################################
# Access to Azure
######################################################################


# Configure the Microsoft Azure Provider with Azure provider variable defined in AzureDFProvider.tf

provider "azurerm" {

    subscription_id = "${var.AzureSubscriptionID}"
    client_id       = "${var.AzureClientID}"
    client_secret   = "${var.AzureClientSecret}"
    tenant_id       = "${var.AzureTenantID}"
}


######################################################################
# Foundations resources, including ResourceGroup and vNET
######################################################################

# Creating the ResourceGroup


module "ResourceGroup" {

    #Module Location
    source = "./Modules/ResourceGroup"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//ResourceGroup/"
    #Module variable
    RGName                  = "${var.RGName}"
    RGLocation              = "${var.AzureRegion}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}
/*
#Creating a Resource Group
resource "azurerm_resource_group" "Terra-RG" {

    
    name        = "${var.RGName}"
    location    = "${var.AzureRegion}"

    tags {
    environment = "${var.EnvironmentTag}"
    usage       = "${var.EnvironmentUsageTag}"
    }

}
*/

# Creating vNET

module "vNet" {

    #Module location
    source = "./Modules/vNet"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//vNet/"

    #Module variable
    vNetName                = "vNetADMSprint1"
    RGName                  = "${module.ResourceGroup.Name}"
    vNetLocation            = "${var.AzureRegion}"
    vNetAddressSpace        = "${var.vNetIPRange}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"


}

