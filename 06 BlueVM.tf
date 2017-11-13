##################################################################################
#Creating blueVM
##################################################################################

#Availability set creation

module "AS-blueVM" {

    #module location
    source = "./Modules/AvailabilitySet"
    

    #Module variable
    ASName                      = "blueVM-AS"
    ASLocation                  = "${var.AzureRegion}"
    RGName                      = "${module.ResourceGroup.Name}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"
}


#NIC Creation

module "NIC-blueVM" {

    #Module Location
    source = "./Modules/NICwithoutPIPfixedprivateIP"

    #Module variable
    NICName                 = "blueVM-NIC"
    NICLocation             = "${var.AzureRegion}"
    RGName                  = "${module.ResourceGroup.Name}"
    SubnetId                = "${module.Blue-Network.Id}"
    SubnetRange             = "${lookup(var.SubnetAddressRange, 1)}"
    PrivateIpmodifier       = "10"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}

#Datadisk creation

module "Datadisk-blueVM" {

    #Module Location
    source = "./Modules/ManagedDisks"    
    
    #Module variable
    ManageddiskName         = "blueVM-Datadisk"
    RGName                  = "${module.ResourceGroup.Name}"
    ManagedDiskLocation     = "${var.AzureRegion}"
    StorageAccountType      = "${lookup(var.Manageddiskstoragetier, 1)}"
    CreateOption            = "empty"
    DiskSizeInGB            = "63"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}


#VM Creation

module "VM-blueVM" {

    #Module location
    source = "./Modules/VM1NICWindows"
    

    #Module variables
    VMName                      = "blueVM"
    VMLocation                  = "${var.AzureRegion}"
    VMRG                        = "${module.ResourceGroup.Name}"
    VMNICid                     = "${module.NIC-blueVM.Id}"
    VMSize                      = "${lookup(var.VMSize, 0)}"
    ASID                        = "${module.AS-blueVM.Id}"
    VMStorageTier               = "${lookup(var.Manageddiskstoragetier, 1)}"
    VMAdminName                 = "${var.VMAdminName}"  
    VMAdminPassword             = "${var.VMAdminPassword}"
    DataDiskId                  = "${module.Datadisk-blueVM.Id}"
    DataDiskName                = "${module.Datadisk-blueVM.Name}"
    DataDiskSize                = "${module.Datadisk-blueVM.Size}"
    VMPublisherName             = "${lookup(var.PublisherName, 0)}"
    VMOffer                     = "${lookup(var.Offer, 0)}"
    VMsku                       = "${lookup(var.sku, 0)}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"


}

