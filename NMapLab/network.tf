#This holds all of the network information required. 1 VNet, 4 NSGs, 4 NICs, 1 Storage Acc

# Network Interface Cards (4)

resource "azurerm_network_interface" "guac-instance" {
  name                      = "guac-instance1"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "instance1"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.nmap-instance.id
    public_ip_address_id          = azurerm_public_ip.guac-instance.id
  }
}

resource "azurerm_network_interface" "kali-instance" {
  name                      = "kali-instance1"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "instance1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.kali-instance.id
    subnet_id                 = azurerm_subnet.nmap-instance.id
  }
}

resource "azurerm_network_interface" "ubuntu-instance" {
  name                      = "ubuntu-instance1"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "instance1"
    private_ip_address_allocation = "Dynamic"
    subnet_id                 = azurerm_subnet.nmap-instance.id
    public_ip_address_id          = azurerm_public_ip.ubuntu-instance.id
  }
}

resource "azurerm_network_interface" "windows-instance" {
  name                      = "windows-instance1"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name


  ip_configuration {
    name                          = "instance1"
    private_ip_address_allocation = "Dynamic"
    subnet_id                 = azurerm_subnet.nmap-instance.id
    public_ip_address_id          = azurerm_public_ip.windows-instance.id
  }
}

#Network Security Group (1)

resource "azurerm_network_security_group" "nmap-instance" {
  name                = "guac-instance-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name


  security_rule {
    name                       = "Allow-SSH"
    description                = "Allow SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-RDP"
    description                = "Allow RDP"
    priority                   = 299
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
   security_rule {
    name                       = "allow-http"
    description                = "allow-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-Guac"
    description                = "Allow Guac"
    priority                   = 310
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "Allow-4822"
    description                = "Allow 4822"
    priority                   = 298
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "4822"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1-nmap-lab"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.17.0/24"]

}

resource "azurerm_subnet" "nmap-instance" {
  name                 = "nmap-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.17.0/24"]
}

resource "azurerm_storage_account" "storageacc" {
  name                     = "nmapstorageacc125876"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#NIC -> NSG Association (4)

resource "azurerm_network_interface_security_group_association" "guac-instance" {
  network_interface_id      = azurerm_network_interface.guac-instance.id
  network_security_group_id = azurerm_network_security_group.nmap-instance.id
}

resource "azurerm_network_interface_security_group_association" "kali-instance" {
  network_interface_id      = azurerm_network_interface.kali-instance.id
  network_security_group_id = azurerm_network_security_group.nmap-instance.id
}

resource "azurerm_network_interface_security_group_association" "ubuntu-instance" {
  network_interface_id      = azurerm_network_interface.ubuntu-instance.id
  network_security_group_id = azurerm_network_security_group.nmap-instance.id
}

resource "azurerm_network_interface_security_group_association" "windows-instance" {
  network_interface_id      = azurerm_network_interface.windows-instance.id
  network_security_group_id = azurerm_network_security_group.nmap-instance.id
}