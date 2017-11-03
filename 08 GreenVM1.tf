##################################################################################
#Creating greenVM
##################################################################################

#Availability set creation

module "AS-greenVM" {

    #module location
    source = "./Modules/AvailabilitySet"
    

    #Module variable
    ASName                      = "greenVM-AS"
    ASLocation                  = "${var.AzureRegion}"
    RGName                      = "${module.ResourceGroup.Name}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"
}


#NIC Creation

module "NIC-greenVM" {

    #Module Location
    source = "./Modules/NICwithoutPIP"

    #Module variable
    NICName                 = "greenVM-NIC"
    NICLocation             = "${var.AzureRegion}"
    RGName                  = "${module.ResourceGroup.Name}"
    SubnetId                = "${module.Green-Network.Id}"
    SubnetRange             = "${lookup(var.SubnetAddressRange, 3)}"
    PrivateIpmodifier       = "10"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}

#Datadisk creation

module "Datadisk-greenVM" {

    #Module Location
    source = "./Modules/ManagedDisks"    
    
    #Module variable
    ManageddiskName         = "greenVM-Datadisk"
    RGName                  = "${module.ResourceGroup.Name}"
    ManagedDiskLocation     = "${var.AzureRegion}"
    StorageAccountType      = "${lookup(var.Manageddiskstoragetier, 1)}"
    CreateOption            = "empty"
    DiskSizeInGB            = "63"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}


#VM Creation

module "VM-greenVM" {

    #Module location
    source = "./Modules/VM1NICWindows"
    

    #Module variables
    VMName                      = "greenVM"
    VMLocation                  = "${var.AzureRegion}"
    VMRG                        = "${module.ResourceGroup.Name}"
    VMNICid                     = "${module.NIC-greenVM.Id}"
    VMSize                      = "${lookup(var.VMSize, 0)}"
    ASID                        = "${module.AS-greenVM.Id}"
    VMStorageTier               = "${lookup(var.Manageddiskstoragetier, 1)}"
    VMAdminName                 = "${var.VMAdminName}"  
    VMAdminPassword             = "${var.VMAdminPassword}"
    DataDiskId                  = "${module.Datadisk-greenVM.Id}"
    DataDiskName                = "${module.Datadisk-greenVM.Name}"
    DataDiskSize                = "${module.Datadisk-greenVM.Size}"
    VMPublisherName             = "${lookup(var.PublisherName, 0)}"
    VMOffer                     = "${lookup(var.Offer, 0)}"
    VMsku                       = "${lookup(var.sku, 0)}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"


}