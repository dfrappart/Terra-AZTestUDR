##################################################################################
#Creating redVM
##################################################################################

#Availability set creation

module "AS-redVM" {

    #module location
    source = "./Modules/AvailabilitySet"
    

    #Module variable
    ASName                      = "redVM-AS"
    ASLocation                  = "${var.AzureRegion}"
    RGName                      = "${module.ResourceGroup.Name}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"
}


#NIC Creation

module "NIC-redVM" {

    #Module Location
    source = "./Modules/NICwithoutPIP"

    #Module variable
    NICName                 = "redVM-NIC"
    NICLocation             = "${var.AzureRegion}"
    RGName                  = "${module.ResourceGroup.Name}"
    SubnetId                = "${module.Red-Network.Id}"
    SubnetRange             = "${lookup(var.SubnetAddressRange, 2)}"
    PrivateIpmodifier       = "10"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}

#Datadisk creation

module "Datadisk-redVM" {

    #Module Location
    source = "./Modules/ManagedDisks"    
    
    #Module variable
    ManageddiskName         = "redVM-Datadisk"
    RGName                  = "${module.ResourceGroup.Name}"
    ManagedDiskLocation     = "${var.AzureRegion}"
    StorageAccountType      = "${lookup(var.Manageddiskstoragetier, 1)}"
    CreateOption            = "empty"
    DiskSizeInGB            = "63"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}


#VM Creation

module "VM-redVM" {

    #Module location
    source = "./Modules/VM1NICWindows"
    

    #Module variables
    VMName                      = "redVM"
    VMLocation                  = "${var.AzureRegion}"
    VMRG                        = "${module.ResourceGroup.Name}"
    VMNICid                     = "${module.NIC-redVM.Id}"
    VMSize                      = "${lookup(var.VMSize, 0)}"
    ASID                        = "${module.AS-redVM.Id}"
    VMStorageTier               = "${lookup(var.Manageddiskstoragetier, 1)}"
    VMAdminName                 = "${var.VMAdminName}"  
    VMAdminPassword             = "${var.VMAdminPassword}"
    DataDiskId                  = "${module.Datadisk-redVM.Id}"
    DataDiskName                = "${module.Datadisk-redVM.Name}"
    DataDiskSize                = "${module.Datadisk-redVM.Size}"
    VMPublisherName             = "${lookup(var.PublisherName, 0)}"
    VMOffer                     = "${lookup(var.Offer, 0)}"
    VMsku                       = "${lookup(var.sku, 0)}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"


}

