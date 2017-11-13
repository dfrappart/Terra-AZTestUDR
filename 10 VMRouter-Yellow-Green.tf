##################################################################################
#Creating RouterYellowGreen VM
##################################################################################

#Availability set creation

#Availability set creation for RouterYellowGreen VM

module "AS-RouterYellowGreen" {

    #module location
    source = "./Modules/AvailabilitySet"
    

    #Module variable
    ASName                      = "RouterYellowGreen-AS"
    ASLocation                  = "${var.AzureRegion}"
    RGName                      = "${module.ResourceGroup.Name}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"
}


#NIC Creation

###################################################################################
#RouterYellowGreen NIC Creation
###################################################################################

module "NIC-RouterYellowGreen-Yellow-Network" {

    #Module Location
    source = "./Modules/NICwithoutPIP"

    #Module variable
    NICName                 = "RouterYellowGreen-Yellow-Network-NIC"
    NICLocation             = "${var.AzureRegion}"
    RGName                  = "${module.ResourceGroup.Name}"
    SubnetId                = "${module.Yellow-Network.Id}"
    SubnetRange             = "${lookup(var.SubnetAddressRange, 4)}"
    PrivateIpmodifier       = "6"
    IPforwardingEnabled     = "true"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}

module "NIC-RouterYellowGreen-Green-Network" {

    #Module Location
    source = "./Modules/NICwithoutPIPfixedprivateIP"

    #Module variable
    NICName                 = "RouterYellowGreen-Green-Network-NIC"
    NICLocation             = "${var.AzureRegion}"
    RGName                  = "${module.ResourceGroup.Name}"
    SubnetId                = "${module.Green-Network.Id}"
    SubnetRange             = "${lookup(var.SubnetAddressRange, 3)}"
    PrivateIpmodifier       = "6"
    IPforwardingEnabled     = "true"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}


#Datadisk creation

#Datadisk creation for RouterYellowGreen VM

module "Datadisk-RouterYellowGreen" {

    #Module Location
    source = "./Modules/ManagedDisks"    
    
    #Module variable
    ManageddiskName         = "RouterYellowGreen-Datadisk"
    RGName                  = "${module.ResourceGroup.Name}"
    ManagedDiskLocation     = "${var.AzureRegion}"
    StorageAccountType      = "${lookup(var.Manageddiskstoragetier, 1)}"
    CreateOption            = "empty"
    DiskSizeInGB            = "63"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}

#VM Creation

module "VM-RouterYellowGreen" {

    #Module Location
    source = "./Modules/LinuxVMWith2Nics"

    #Module Variable
    VMName                  = "RouterYellowGreen"
    VMLocation              = "${var.AzureRegion}"
    VMRG                    = "${module.ResourceGroup.Name}"
    VMSize                  = "${lookup(var.VMSize, 2)}"
    VM-ASID                 = "${module.AS-RouterYellowGreen.Id}"
    VMPublisher             = "${lookup(var.PublisherName, 4)}"
    VMOffer                 = "${lookup(var.Offer, 4)}"
    VMSku                   = "${lookup(var.sku, 4)}"
    VMStorageTier           = "${lookup(var.Manageddiskstoragetier, 1)}"
    DataDiskName            = "${module.Datadisk-RouterYellowGreen.Name}"
    VMDatadiskId            = "${module.Datadisk-RouterYellowGreen.Id}"
    VMDataDiskSize          = "${module.Datadisk-RouterYellowGreen.Size}"
    VMAdminName             = "${var.VMAdminName}"
    VMAdminPassword         = "${var.VMAdminPassword}"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
    NicId1                  = "${module.NIC-RouterYellowGreen-Yellow-Network.Id}"
    NicId2                  = "${module.NIC-RouterYellowGreen-Green-Network.Id}"
    SSHKey                  = "${var.AzurePublicSSHKey}"

}


module "VM-RouterYellowGreenConfig" {

    #Module Location
    source = "./Modules/CustomLinuxExtension"


    #Module Variable
    AgentName       = "RouterYellowGreenAgent"
    AgentLocation   = "${var.AzureRegion}"
    RGName          = "${module.ResourceGroup.Name}"
    VMName          = "${module.VM-RouterYellowGreen.Name}"
    
}

