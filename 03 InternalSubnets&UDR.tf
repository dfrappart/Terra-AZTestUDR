##################################################################################
#This file allow the creation of the subnet as described in ADM documentation
#The identified required subnet are
#      "0" = "RDSSubnet"
#      "1" = "Blue-Network"
#      "2" = "Red-Network"
#      "3" = "Green-Red"
#      "4" = "Yellow-Network"
#      "5" = "Purple-Network"
##################################################################################


##################################################################################
#Subnets and associated NSG creation
##################################################################################


#Subnet Blue_Network Creation

module "NSGBlue-Network" {

    #Module location
    source = "./Modules/NSG"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//NSG/"

    #Module variable
    NSGName                 = "NSG${lookup(var.SubnetName, 1)}"
    RGName                  = "${module.ResourceGroup.Name}"
    NSGLocation             = "${var.AzureRegion}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"


}

module "Blue-Network" {

    #Module location
    source = "./Modules/Subnet"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//Subnet/"

    #Module variable
    SubnetName                  = "${lookup(var.SubnetName, 1)}"
    RGName                      = "${module.ResourceGroup.Name}"
    vNetName                    = "${module.vNet.Name}"
    Subnetaddressprefix         = "${lookup(var.SubnetAddressRange, 1)}"
    NSGid                       = "${module.NSGBlue-Network.Id}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"

}

#Subnet Red_Network Creation

module "NSGRed-Network" {

    #Module location
    source = "./Modules/NSG"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//NSG/"

    #Module variable
    NSGName                 = "NSG${lookup(var.SubnetName, 2)}"
    RGName                  = "${module.ResourceGroup.Name}"
    NSGLocation             = "${var.AzureRegion}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"


}

module "Red-Network" {

    #Module location
    source = "./Modules/Subnet"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//Subnet/"

    #Module variable
    SubnetName                  = "${lookup(var.SubnetName, 2)}"
    RGName                      = "${module.ResourceGroup.Name}"
    vNetName                    = "${module.vNet.Name}"
    Subnetaddressprefix         = "${lookup(var.SubnetAddressRange, 2)}"
    NSGid                       = "${module.NSGRed-Network.Id}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"

}

#Subnet Green Creation

module "NSGGreen-Network" {

    #Module location
    source = "./Modules/NSG"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//NSG/"

    #Module variable
    NSGName                 = "NSG${lookup(var.SubnetName, 3)}"
    RGName                  = "${module.ResourceGroup.Name}"
    NSGLocation             = "${var.AzureRegion}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"


}

module "Green-Network" {

    #Module location
    source = "./Modules/Subnet"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//Subnet/"

    #Module variable
    SubnetName                  = "${lookup(var.SubnetName, 3)}"
    RGName                      = "${module.ResourceGroup.Name}"
    vNetName                    = "${module.vNet.Name}"
    Subnetaddressprefix         = "${lookup(var.SubnetAddressRange, 3)}"
    NSGid                       = "${module.NSGGreen-Network.Id}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"

}

#Subnet Yellow Creation

module "NSGYellow-Network" {

    #Module location
    source = "./Modules/NSG"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//NSG/"

    #Module variable
    NSGName                 = "NSG${lookup(var.SubnetName, 4)}"
    RGName                  = "${module.ResourceGroup.Name}"
    NSGLocation             = "${var.AzureRegion}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"


}

module "Yellow-Network" {

    #Module location
    source = "./Modules/Subnet"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//Subnet/"

    #Module variable
    SubnetName                  = "${lookup(var.SubnetName, 4)}"
    RGName                      = "${module.ResourceGroup.Name}"
    vNetName                    = "${module.vNet.Name}"
    Subnetaddressprefix         = "${lookup(var.SubnetAddressRange, 4)}"
    NSGid                       = "${module.NSGYellow-Network.Id}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"

}

#Subnet purple Creation

module "NSGPurple-Network" {

    #Module location
    source = "./Modules/NSG"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//NSG/"

    #Module variable
    NSGName                 = "NSG${lookup(var.SubnetName, 5)}"
    RGName                  = "${module.ResourceGroup.Name}"
    NSGLocation             = "${var.AzureRegion}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"


}

module "Purple-Network" {

    #Module location
    source = "./Modules/Subnet"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//Subnet/"

    #Module variable
    SubnetName                  = "${lookup(var.SubnetName, 5)}"
    RGName                      = "${module.ResourceGroup.Name}"
    vNetName                    = "${module.vNet.Name}"
    Subnetaddressprefix         = "${lookup(var.SubnetAddressRange, 5)}"
    NSGid                       = "${module.NSGPurple-Network.Id}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"

}

##################################################################################
#NSG Rules
#By default, block traffic to internet, allow trafic between subnet
##################################################################################

module "NSGRulesBlue-Network-default" {

    #Module location
    source = "./Modules/NSGRules-Default"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//NSGRule/"

    #Module variable
    RGName                              = "${module.ResourceGroup.Name}"
    NSGReference                        = "${module.NSGBlue-Network.Name}"
    NSGRuleFEAddressPrefix              = "${lookup(var.SubnetAddressRange, 0)}"
    NSGRuleSubnetAddressPrefix          = "${lookup(var.SubnetAddressRange, 1)}"
}

module "NSGRulesRed-Network-default" {

    #Module location
    source = "./Modules/NSGRules-Default"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//NSGRule/"

    #Module variable
    RGName                              = "${module.ResourceGroup.Name}"
    NSGReference                        = "${module.NSGRed-Network.Name}"
    NSGRuleFEAddressPrefix              = "${lookup(var.SubnetAddressRange, 0)}"
    NSGRuleSubnetAddressPrefix          = "${lookup(var.SubnetAddressRange, 2)}"
}

module "NSGRulesGreen-Network-default" {

    #Module location
    source = "./Modules/NSGRules-default"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//NSGRule/"

    #Module variable
    RGName                              = "${module.ResourceGroup.Name}"
    NSGReference                        = "${module.NSGGreen-Network.Name}"
    NSGRuleFEAddressPrefix              = "${lookup(var.SubnetAddressRange, 0)}"
    NSGRuleSubnetAddressPrefix          = "${lookup(var.SubnetAddressRange, 3)}"
}

module "NSGRulesYellow-Network-default" {

    #Module location
    source = "./Modules/NSGRules-default"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//NSGRule/"

    #Module variable
    RGName                              = "${module.ResourceGroup.Name}"
    NSGReference                        = "${module.NSGYellow-Network.Name}"
    NSGRuleFEAddressPrefix              = "${lookup(var.SubnetAddressRange, 0)}"
    NSGRuleSubnetAddressPrefix          = "${lookup(var.SubnetAddressRange, 4)}"
}

module "NSGRulesPurple-Network-default" {

    #Module location
    source = "./Modules/NSGRules-default"
    #source = "github.com/dfrappart/Terra-AZModuletest//Modules//NSGRule/"

    #Module variable
    RGName                              = "${module.ResourceGroup.Name}"
    NSGReference                        = "${module.NSGPurple-Network.Name}"
    NSGRuleFEAddressPrefix              = "${lookup(var.SubnetAddressRange, 0)}"
    NSGRuleSubnetAddressPrefix          = "${lookup(var.SubnetAddressRange, 5)}"
}

##################################################################################
#Route and route table
##################################################################################

module "CustomRouteTable" {

    #Module Location
    source = "./Modules/Routetable"

    #Module Variables
    RouteTableName      = "CustomRouteTable"
    RGName              = "${module.ResourceGroup.Name}"
    RouteTableLocation  = "${var.AzureRegion}"
    EnvironmentTag      = "${var.EnvironmentTag}"
    EnvironmentUsageTag = "${var.EnvironmentUsageTag}"

}



module "GreenToYellowRoute" {

    #Module location
    source = "./Modules/Routetoappliance"

    #Module variable
    RouteName           = "${module.CustomRouteTable.Name}"
    RGName              = "${module.ResourceGroup.Name}"
    SubnetAddressPrefix = "${lookup(var.SubnetAddressRange, 3)}"
    NextHopIPAddress    = "${module.NIC-RouterYellowGreen-Green-Network.PrivateIP}"
    RouteTableName      = "${module.CustomRouteTable.Name}"

}

module "YellowToGreenRoute" {

    #Module location
    source = "./Modules/Routetoappliance"

    #Module variable
    RouteName           = "${module.CustomRouteTable.Name}"
    RGName              = "${module.ResourceGroup.Name}"
    SubnetAddressPrefix = "${lookup(var.SubnetAddressRange, 4)}"
    NextHopIPAddress    = "${module.NIC-RouterYellowGreen-Yellow-Network.PrivateIP}"
    RouteTableName      = "${module.CustomRouteTable.Name}"


}

/*
module "RedToGreenRoute" {

    #Module location


    #Module variable

    
}

module "GreenToRedRoute" {

    #Module location


    #Module variable


}

module "PurpleToGreenRoute" {

    #Module location


    #Module variable

    
}

module "GreenToPurpleRoute" {

    #Module location


    #Module variable


}

module "BlueToGreenRoute" {

    #Module location


    #Module variable

    
}

module "GreenToBlueRoute" {

    #Module location


    #Module variable


}

module "RedToBlueRoute" {

    #Module location


    #Module variable

    
}

module "BlueToRedRoute" {

    #Module location


    #Module variable


}

module "RedToPurpleRoute" {

    #Module location


    #Module variable

    
}

module "PurpleToRedRoute" {

    #Module location


    #Module variable


}

module "PurpleToBlueRoute" {

    #Module location


    #Module variable

    
}

module "BlueToPurpleRoute" {

    #Module location


    #Module variable


}

*/