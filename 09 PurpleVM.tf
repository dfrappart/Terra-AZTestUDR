##################################################################################
#Creating purpleVM01
##################################################################################

#Availability set creation

module "AS-purpleVM" {

    #module location
    source = "./Modules/AvailabilitySet"
    

    #Module variable
    ASName                      = "purpleVM-AS"
    ASLocation                  = "${var.AzureRegion}"
    RGName                      = "${module.ResourceGroup.Name}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"
}


#NIC Creation

module "NIC-purpleVM" {

    #Module Location
    source = "./Modules/NICwithoutPIPfixedprivateIP"

    #Module variable
    NICName                 = "purpleVM-NIC"
    NICLocation             = "${var.AzureRegion}"
    RGName                  = "${module.ResourceGroup.Name}"
    SubnetId                = "${module.Purple-Network.Id}"
    SubnetRange             = "${lookup(var.SubnetAddressRange, 5)}"
    PrivateIpmodifier       = "10"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}

#Datadisk creation

module "Datadisk-purpleVM" {

    #Module Location
    source = "./Modules/ManagedDisks"    
    
    #Module variable
    ManageddiskName         = "purpleVM-Datadisk"
    RGName                  = "${module.ResourceGroup.Name}"
    ManagedDiskLocation     = "${var.AzureRegion}"
    StorageAccountType      = "${lookup(var.Manageddiskstoragetier, 1)}"
    CreateOption            = "empty"
    DiskSizeInGB            = "63"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}


#VM Creation

module "purpleVM" {

    #Module location
    source = "./Modules/VM1NICWindows"
    

    #Module variables
    VMName                      = "purpleVM"
    VMLocation                  = "${var.AzureRegion}"
    VMRG                        = "${module.ResourceGroup.Name}"
    VMNICid                     = "${module.NIC-purpleVM.Id}"
    VMSize                      = "${lookup(var.VMSize, 0)}"
    ASID                        = "${module.AS-purpleVM.Id}"
    VMStorageTier               = "${lookup(var.Manageddiskstoragetier, 1)}"
    VMAdminName                 = "${var.VMAdminName}"  
    VMAdminPassword             = "${var.VMAdminPassword}"
    DataDiskId                  = "${module.Datadisk-purpleVM.Id}"
    DataDiskName                = "${module.Datadisk-purpleVM.Name}"
    DataDiskSize                = "${module.Datadisk-purpleVM.Size}"
    VMPublisherName             = "${lookup(var.PublisherName, 0)}"
    VMOffer                     = "${lookup(var.Offer, 0)}"
    VMsku                       = "${lookup(var.sku, 0)}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"


}

