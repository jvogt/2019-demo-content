terraform {
  required_version = "> 0.11.0"
}

# Create public IPs
resource "azurerm_public_ip" "ipeer_pip" {
  name                         = "ipeer-${random_id.instance_id.hex}-pip"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "static"

  tags {
    X-Name        = "ipeer-${random_id.instance_id.hex}-pip"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

# Create network interface
resource "azurerm_network_interface" "ipeer_nic" {
  name                      = "ipeer-${random_id.instance_id.hex}-nic"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.chef_automate.id}"

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = "${azurerm_subnet.backend.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.ipeer_pip.id}"
  }

  tags {
    X-Name        = "ipeer-${random_id.instance_id.hex}-nic"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

//////INSTANCES///////
//////////////////////
resource "azurerm_virtual_machine" "initial-peer" {
  name                          = "ipeer-${random_id.instance_id.hex}"
  location                      = "${azurerm_resource_group.rg.location}"
  resource_group_name           = "${azurerm_resource_group.rg.name}"
  network_interface_ids         = ["${azurerm_network_interface.ipeer_nic.id}"]
  vm_size                       = "Standard_DS1_v2"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  connection {
    type        = "ssh"
    user        = "${var.azure_image_user}"
    private_key = "${file("${var.azure_private_key_path}")}"
  }

  storage_os_disk {
    name          = "${var.tag_application}-initialpeer-osdisk"
    vhd_uri       = "${azurerm_storage_account.stor.primary_blob_endpoint}${azurerm_storage_container.storcont.name}/${var.tag_application}-initialpeer-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.tag_application}-initialpeer"
    admin_username = "${var.azure_image_user}"
    admin_password = "${var.azure_image_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false

    ssh_keys {
      path     = "/home/${var.azure_image_user}/.ssh/authorized_keys"
      key_data = "${file("${var.azure_public_key_path}")}"
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.stor.primary_blob_endpoint}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname permanentpeer",
    ]
  }

  provisioner "habitat" {
    permanent_peer = true
    use_sudo     = true
    service_type = "systemd"
  }

  tags {
    X-Name        = "initialpeer-${random_id.instance_id.hex}"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

data "template_file" "win_service" {
  template = "${file("${path.module}/templates/HabService.exe.config")}"

  vars {
    flags = "--auto-update --peer ${azurerm_network_interface.ipeer_nic.private_ip_address} --listen-gossip 0.0.0.0:9638 --listen-http 0.0.0.0:9631"
  }
}