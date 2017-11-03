# Cred for VM
$username = "vmadmin"
$password = "Devoteam75!"
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$creds = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureStringPwd

Login-AzureRmAccount

# resource group Name
$RSGroupName = “RG-ADMSprint1”     

# Location Name
$location = “westeurope”

# Vnet                               
$vnetname = Get-AzureRmVirtualNetwork  -ResourceGroupName $RSGroupName

$vnetname.Subnets[0].ID

#subnet1                         
$BlueNetwork = $vnetname.Subnets[0].ID  

#subnet2                         
$RedNetwork = $vnetname.Subnets[1].ID 

#subnet3                         
$SW_A_Red = $vnetname.Subnets[2].ID 

#subnet4                         
$ATS_Network = $vnetname.Subnets[3].ID 

#subnet5                         
$SIG_Blue_Network  = $vnetname.Subnets[4].ID
                      



Get-AzureRmResourceGroup -Name $RSGroupName



# List of NIC

#$vm.NetworkProfile.NetworkInterfaces[0].Primary = $true

$nic_Serv_ATS = Get-AzureRmNetworkInterface -ResourceGroupName $RSGroupName -Name "SERV-ATS-01-NIC"
$nic_routeur1 = Get-AzureRmNetworkInterface -ResourceGroupName $RSGroupName -Name "Router-Blue-Network-NIC"
$nic_routeur2 = Get-AzureRmNetworkInterface -ResourceGroupName $RSGroupName -Name "Router-SIG-Blue-Network-NIC"
$nic_simulator = Get-AzureRmNetworkInterface -ResourceGroupName $RSGroupName -Name "Simulator-NIC"
$nic_WRS_HMI = Get-AzureRmNetworkInterface -ResourceGroupName $RSGroupName -Name "WRS-HMI-A-NIC"

$nicFEP1 = Get-AzureRmNetworkInterface -ResourceGroupName $RSGroupName -Name "FEP-ATS-01-Red-Network-NIC1"
$nicFEP2 = Get-AzureRmNetworkInterface -ResourceGroupName $RSGroupName -Name "FEP-ATS-01-ATS-Network-NIC2"
$nicFEP3 = Get-AzureRmNetworkInterface -ResourceGroupName $RSGroupName -Name "FEP-ATS-01-SW-A-Red-NIC3"
$nicFEP4 = Get-AzureRmNetworkInterface -ResourceGroupName $RSGroupName -Name "FEP-ATS-01-ATS-Network-NIC4"
$nicFEP5 = Get-AzureRmNetworkInterface -ResourceGroupName $RSGroupName -Name "FEP-ATS-01-SW-A-Red-NIC5"
$nicFEP6 = Get-AzureRmNetworkInterface -ResourceGroupName $RSGroupName -Name "FEP-ATS-01-Blue-Network-NIC5"







$vmConfigFEP = New-AzureRmVMConfig -VMName FEP-ATS-01 -VMSize Standard_F8s | `
    Set-AzureRmVMOperatingSystem -Linux -ComputerName FEPATS01 -Credential $Creds | `
    Set-AzureRmVMSourceImage -PublisherName Canonical -Offer UbuntuServer `
    -Skus 17.04 -Version latest | Add-AzureRmVMNetworkInterface -Id $nicFEP1.Id -Primary | Add-AzureRmVMNetworkInterface -Id $nicFEP2.Id `
    | Add-AzureRmVMNetworkInterface -Id $nicFEP3.Id | Add-AzureRmVMNetworkInterface -Id $nicFEP4.Id | Add-AzureRmVMNetworkInterface -Id $nicFEP5.Id | Add-AzureRmVMNetworkInterface -Id $nicFEP6.Id

    New-AzureRmVM -ResourceGroupName $RSGroupName  -Location $location -VM $vmConfigFEP

    #Create VM 1 VM Windows 2012 R2 avec 1 NIC - Serv_ATS

#$vmConfigSERV = New-AzureRmVMConfig -VMName SERV-ATS-01 -VMSize $size | `
   # Set-AzureRmVMOperatingSystem -Windows -ComputerName SERV_ATS_01 -Credential $cred | `
    #Set-AzureRmVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer `
    #-Skus 2012-R2-Datacenter -Version latest | Add-AzureRmVMNetworkInterface -Id $nic_Serv_ATS

    #Create 1 VM Debian with 2 NIC
$vmConfigrouteur = New-AzureRmVMConfig -VMName routeur -VMSize Standard_F4S | `
    Set-AzureRmVMOperatingSystem -linux -ComputerName routeur -Credential $Creds | `
    Set-AzureRmVMSourceImage -PublisherName credativ -Offer Debian `
    -Skus 7 -Version latest | Add-AzureRmVMNetworkInterface -Id $nic_routeur1.Id -Primary |  Add-AzureRmVMNetworkInterface -Id $nic_routeur2.Id

    New-AzureRmVM -ResourceGroupName $RSGroupName  -Location $location -VM $vmConfigrouteur

    # create 2 VM Windows 7 with 1 NIC
 #$vmConfigsimulator = New-AzureRmVMConfig -VMName Simulator -VMSize $size | `
   # Set-AzureRmVMOperatingSystem -Windows -ComputerName Simulator -Credential $cred | `
   # Set-AzureRmVMSourceImage -PublisherName MicrosoftVisualStudio -Offer windows `
   # -Skus Win7-SP1-Ent-N-x64 -Version latest | Add-AzureRmVMNetworkInterface -Id $nic_simulator.Id

    
# $vmConfigWRS_HMI = New-AzureRmVMConfig -VMName WRS-HMI-A -VMSize $size | `
   # Set-AzureRmVMOperatingSystem -Windows -ComputerName WRS_HMI -Credential $cred | `
    #Set-AzureRmVMSourceImage -PublisherName MicrosoftVisualStudio -Offer windows `
    #-Skus Win7-SP1-Ent-N-x64 -Version latest | Add-AzureRmVMNetworkInterface -Id $nic_WRS_HMI.Id



