provider "azurerm" {
   version="2.41.0"
    features{}
}

# create resource group
resource "azurerm_resource_group" "rg"{
    name = "Packet-Analysis-Test"
    location = var.location
}
