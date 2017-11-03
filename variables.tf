######################################################
# Variables for Template
######################################################

# Variable to define the Azure Region

variable "AzureRegion" {

    type    = "string"
    default = "westeurope"
}


# Variable to define the Tag

variable "EnvironmentTag" {

    type    = "string"
    default = "TestUDR"
}

variable "EnvironmentUsageTag" {

    type    = "string"
    default = "PoC"
}

# Variable to define the Resource Group Name

variable "RGName" {

    type    = "string"
    default = "RG-TestUDR"
}

#Variable defining the vnet ip range


variable "vNetIPRange" {

    type = "list"
    default = ["10.0.0.0/8","192.168.0.0/20"]
}

variable "SubnetAddressRange" {
#Note: Subnet must be in range included in the vNET Range
    
    default = {
      "0" = "10.0.0.0/24"
      "1" = "192.168.4.0/24"
      "2" = "192.168.2.0/24"
      "3" = "10.6.10.0/24"
      "4" = "10.5.10.0/24"
      "5" = "10.1.32.0/24"

    }
}


variable "SubnetName" {
#RDSSubnet
#Blue_Network
#Red_Network
#SW_A_Red
#ATS_Network
#SIG_Blue_Network
    
    default = {
      "0" = "RDSFE-Network"
      "1" = "Blue-Network"
      "2" = "Red-Network"
      "3" = "Green-Network"
      "4" = "Yellow-Network"
      "5" = "Purple-Network"

    }
}

#variable defining VM size
variable "VMSize" {
 
  default = {
      "0" = "Standard_F1S"
      "1" = "Standard_F2s"
      "2" = "Standard_F4S"
      "3" = "Standard_F8S"

  }
}

# variable defining storage account tier

variable "storageaccounttier" {

    
    default = {
      "0" = "standard_lrs"
      "1" = "premium_lrs"
      "2" = "standard_grs"
      "3" = "premium_grs"
     }
}

# variable defining storage account tier for managed disk

variable "Manageddiskstoragetier" {

    
    default = {
      "0" = "standard_lrs"
      "1" = "premium_lrs"

    }
}


# variable defining VM image 

# variable defining VM image 

variable "PublisherName" {

    
    default = {
      "0" = "microsoftwindowsserver"
      "1" = "MicrosoftVisualStudio"
      "2" = "canonical"
      "3" = "credativ"
      "4" = "Openlogic"
      "5" = "RedHat"

    }
}

variable "Offer" {

    
    default = {
      "0" = "WindowsServer"
      "1" = "Windows"
      "2" = "ubuntuserver"
      "3" = "debian"
      "4" = "CentOS"
      "5" = "RHEL"

    }
}

variable "sku" {

    
    default = {
      "0" = "2016-Datacenter"
      "1" = "Windows-10-N-x64"
      "2" = "16.04.0-LTS"
      "3" = "9"
      "4" = "7.3"
      "5" = "7.3"
    

    }
}