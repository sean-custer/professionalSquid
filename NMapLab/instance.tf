#This holds all the resources required per instance. (4 VMs, 4 Public IPs, 4 Disks, 3 Snapshots)

#Virtual Machines (4)

# Data template Bash bootstrapping file
data "template_file" "linux-vm-cloud-init" {
  template = file("azure-install-rdp.sh")
}
resource "azurerm_virtual_machine" "guac-vm" {
  name                  = "guac-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.guac-instance.id]
  vm_size               = "Standard_A1_v2"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name = "myosdisk15"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "guac-nmap-instance"
    admin_username = "arsiem"
    admin_password = "Arsiem2020!!"
    custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  }
  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      # Note: If you did ssh-keygen and used a different name, replace mykey.pub with the new public key name
      key_data = file("mykey.pub")
      path     = "/home/arsiem/.ssh/authorized_keys"
    }
  }
  tags = {
    environment = "NMap Lab"
  }
}


/*resource "azurerm_linux_virtual_machine" "kali-vm" {
  name                = "Packet-Kali-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "arsiem"
  admin_password = "Arsiem2020!!"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.kali-instance.id,
  ]
    custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  plan {
    name      = "kali"
    product   = "kali-linux"
    publisher = "kali-linux"
  }
}*/
resource "azurerm_virtual_machine" "ubuntu-vm" {
  name                  = "NMap-Ubuntu-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.ubuntu-instance.id]
  vm_size               = "Standard_A1_v2"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk3"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "ubuntu-nmap-instance"
    admin_username = "arsiem"
    admin_password = "Arsiem2020!!"
    custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  }
  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      # Note: If you did ssh-keygen and used a different name, replace mykey.pub with the new public key name
      key_data = file("mykey.pub")
      path     = "/home/arsiem/.ssh/authorized_keys"
    }
  }
  tags = {
    environment = "NMap Lab"
  }
}

resource "azurerm_virtual_machine" "windows-vm" {
  name                  = "NMap-Win-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.windows-instance.id]
  vm_size               = "Standard_A1_v2"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk4"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "windows-vm"
    admin_username = "arsiem"
    admin_password = "Arsiem2020!!"
  }
  os_profile_windows_config {
    /*disable_password_authentication = false
    ssh_keys {
      # Note: If you did ssh-keygen and used a different name, replace mykey.pub with the new public key name
      key_data = file("mykey.pub")
      path     = "/home/arsiem/.ssh/authorized_keys"
    }*/
    enable_automatic_upgrades = false
  }
  tags = {
    environment = "NMap Lab"
  }
}

#Public IPs (4)

resource "azurerm_public_ip" "guac-instance" {
    name                         = "GuacMaster-ip"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.rg.name
    allocation_method            = "Static"
}

resource "azurerm_public_ip" "kali-instance" {
    name                         = "kali-instance1-public-ip"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.rg.name
    allocation_method            = "Static"
}

resource "azurerm_public_ip" "ubuntu-instance" {
    name                         = "ubuntu-instance1-public-ip"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.rg.name
    allocation_method            = "Static"
}

resource "azurerm_public_ip" "windows-instance" {
    name                         = "windows-instance1-public-ip"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.rg.name
    allocation_method            = "Static"
}


#Managed Disks (4)

resource "azurerm_managed_disk" "guac-disk" {
  name                 = "Guac-Disk"
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb         = "1"

  tags = {
    environment = "Nmap Lab"
  }
}

resource "azurerm_managed_disk" "kali-disk" {
  name                 = "Kali-Disk"
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb         = "1"

  tags = {
    environment = "Nmap Lab"
  }
}

resource "azurerm_managed_disk" "ubuntu-disk" {
  name                 = "Ubuntu-Disk"
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb         = "1"

  tags = {
    environment = "Nmap Lab"
  }
}

resource "azurerm_managed_disk" "windows-disk" {
  name                 = "Windows-Disk"
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb         = "1"

  tags = {
    environment = "Nmap Lab"
  }
}
