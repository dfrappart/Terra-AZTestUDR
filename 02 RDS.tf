##################################################################################
#Creating subnet for RDS Access
##################################################################################


module "NSGRDSFE-Network" {

    #Module location
    source = "./Modules/NSG"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//NSG/"

    #Module variable
    NSGName                 = "NSG${lookup(var.SubnetName, 0)}"
    RGName                  = "${module.ResourceGroup.Name}"
    NSGLocation             = "${var.AzureRegion}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"


}



module "RDSFE-Network" {

    #Module location
    source = "./Modules/Subnet"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//Subnet/"

    #Module variable
    SubnetName                  = "${lookup(var.SubnetName, 0)}"
    RGName                      = "${module.ResourceGroup.Name}"
    vNetName                    = "${module.vNet.Name}"
    Subnetaddressprefix         = "${lookup(var.SubnetAddressRange, 0)}"
    NSGid                       = "${module.NSGRDSFE-Network.Id}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"

}




module "NSGRule-RDSFE-Network-AllowRDP" {

    #Module location
    source = "./Modules/NSGRule"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//NSGRule/"

    #Module variable
    RGName                              = "${module.ResourceGroup.Name}"
    NSGReference                        = "${module.NSGRDSFE-Network.Name}"
    NSGRuleName                         = "NSGRule-RDSFE-Network-AllowRDP"
    NSGRulePriority                     = "101"
    NSGRuleDirection                    = "inbound"
    NSGRuleProtocol                     = "tcp"
    NSGRuleSourcePortRange              = "*"
    NSGRuleDestinationPortRange         = "3389"
    NSGRuleSourceAddressPrefix          = "*"
    NSGRuleDestinationAddressPrefix     = "${lookup(var.SubnetAddressRange, 0)}"
}

module "NSGRule-RDSFE-Network-AllowAllTovNet" {

    #Module location
    source = "./Modules/NSGRule"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//NSGRule/"

    #Module variable
    RGName                              = "${module.ResourceGroup.Name}"
    NSGReference                        = "${module.NSGRDSFE-Network.Name}"
    NSGRuleName                         = "NSGRule-RDSFE-Network-AllowAllTovNet"
    NSGRulePriority                     = "102"
    NSGRuleDirection                    = "outbound"
    NSGRuleProtocol                     = "*"
    NSGRuleSourcePortRange              = "*"
    NSGRuleDestinationPortRange         = "*"
    NSGRuleSourceAddressPrefix          = "${lookup(var.SubnetAddressRange, 0)}"
    NSGRuleDestinationAddressPrefix     = "virtualnetwork"
}




module "AS-RDS" {

    #module location
    source = "./Modules/AvailabilitySet"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//AvailabilitySet/"

    #Module variable
    ASName                      = "RDS-AS"
    ASLocation                  = "${var.AzureRegion}"
    RGName                      = "${module.ResourceGroup.Name}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"
}

module "VM-RDSFE" {

    #Module location
    source = "./Modules/WindowsServerVMswithcountoption"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//CentOSVM/"

    #Module variables
    VMName                      = "rdsfe-vm"
    VMcount                     = 2
    VMLocation                  = "${var.AzureRegion}"
    VMRG                        = "${module.ResourceGroup.Name}"
    VMSize                      = "${lookup(var.VMSize, 0)}"
    VMAdminPassword             = "${var.VMAdminPassword}"
    ASID                        = "${module.AS-RDS.Id}"
    VMStorageTier               = "${lookup(var.Manageddiskstoragetier, 1)}"
    DataDiskSize                = "127"
    TargetSubnetId              = "${module.RDSFE-Network.Id}"
    TargetSubnetRange           = "${lookup(var.SubnetAddressRange, 0)}"
    IsaccessiblefromInternet    = 1

}

