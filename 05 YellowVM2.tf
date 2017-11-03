##################################################################################
#Creating yellowVM02
##################################################################################

#Availability set creation

module "AS-yellowVM02" {

    #module location
    source = "./Modules/AvailabilitySet"
    

    #Module variable
    ASName                      = "yellowVM02-AS"
    ASLocation                  = "${var.AzureRegion}"
    RGName                      = "${module.ResourceGroup.Name}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"
}


#NIC Creation

module "NIC-yellowVM02" {

    #Module Location
    source = "./Modules/NICwithoutPIP"

    #Module variable
    NICName                 = "yellowVM02-NIC"
    NICLocation             = "${var.AzureRegion}"
    RGName                  = "${module.ResourceGroup.Name}"
    SubnetId                = "${module.Yellow-Network.Id}"
    SubnetRange             = "${lookup(var.SubnetAddressRange, 4)}"
    PrivateIpmodifier       = "11"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}

#Datadisk creation

module "Datadisk-yellowVM02" {

    #Module Location
    source = "./Modules/ManagedDisks"    
    
    #Module variable
    ManageddiskName         = "yellowVM02-Datadisk"
    RGName                  = "${module.ResourceGroup.Name}"
    ManagedDiskLocation     = "${var.AzureRegion}"
    StorageAccountType      = "${lookup(var.Manageddiskstoragetier, 1)}"
    CreateOption            = "empty"
    DiskSizeInGB            = "63"
    EnvironmentTag          = "${var.EnvironmentTag}"
    EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}


#VM Creation

module "yellowVM02" {

    #Module location
    source = "./Modules/VM1NICWindows"
    

    #Module variables
    VMName                      = "yellowVM02"
    VMLocation                  = "${var.AzureRegion}"
    VMRG                        = "${module.ResourceGroup.Name}"
    VMNICid                     = "${module.NIC-yellowVM02.Id}"
    VMSize                      = "${lookup(var.VMSize, 0)}"
    ASID                        = "${module.AS-yellowVM02.Id}"
    VMStorageTier               = "${lookup(var.Manageddiskstoragetier, 1)}"
    VMAdminName                 = "${var.VMAdminName}"  
    VMAdminPassword             = "${var.VMAdminPassword}"
    DataDiskId                  = "${module.Datadisk-yellowVM02.Id}"
    DataDiskName                = "${module.Datadisk-yellowVM02.Name}"
    DataDiskSize                = "${module.Datadisk-yellowVM02.Size}"
    VMPublisherName             = "${lookup(var.PublisherName, 0)}"
    VMOffer                     = "${lookup(var.Offer, 0)}"
    VMsku                       = "${lookup(var.sku, 0)}"
    EnvironmentTag              = "${var.EnvironmentTag}"
    EnvironmentUsageTag         = "${var.EnvironmentUsageTag}"


}

