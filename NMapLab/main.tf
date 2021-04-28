#Resources: 4 Network Interface Cards, 4 public IPs, 4 VMs, 4 NSGs, 4 Disks, 4 Disk Attachments, 1 Vnet, 1 Storage acc

provider "azurerm" {
    version="2.41.0"
    features{}
}

# create resource group (change name to duplicate instance)
resource "azurerm_resource_group" "rg"{
    name = "NMap-Scanning-Lab"
    location = var.location
}
