# Create public IPs
resource "azurerm_public_ip" "swa_pip" {
  name                         = "swa-${random_id.instance_id.hex}-pip"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "static"

  tags {
    X-Name        = "swa-${random_id.instance_id.hex}-pip"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

# Create network interface
resource "azurerm_network_interface" "swa_nic" {
  name                      = "swa-${random_id.instance_id.hex}-nic"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.chef_automate.id}"

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = "${azurerm_subnet.backend.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.swa_pip.id}"
  }

  tags {
    X-Name        = "swa-${random_id.instance_id.hex}-nic"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

resource "azurerm_virtual_machine" "vm-swa" {
  name                          = "swa-${random_id.instance_id.hex}"
  location                      = "${azurerm_resource_group.rg.location}"
  resource_group_name           = "${azurerm_resource_group.rg.name}"
  vm_size                       = "Standard_DS3_v2"
  network_interface_ids         = ["${azurerm_network_interface.swa_nic.id}"]
  delete_os_disk_on_termination = true
  depends_on = ["azurerm_virtual_machine.initial-peer"]
  
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name          = "${var.tag_application}-initialpeer-osdisk"
    vhd_uri       = "${azurerm_storage_account.stor.primary_blob_endpoint}${azurerm_storage_container.storcont.name}/${var.tag_application}-swa-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "swa-${random_id.instance_id.hex}"
    admin_username = "${var.azure_image_user}"
    admin_password = "${var.azure_image_password}"
    custom_data    = "${data.template_cloudinit_config.swa-config.rendered}"
  }

  tags {
    X-Name        = "swa-${random_id.instance_id.hex}"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }

  os_profile_windows_config {}

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.stor.primary_blob_endpoint}"
  }

  provisioner "local-exec" {
    command = "sleep 210"
  }

  provisioner "file" {
    content     = "${data.template_file.hab_sqlwebadmin.rendered}"
    destination = "c:\\hab.ps1"
  }

  provisioner "file" {
    content     = "${data.template_file.win_service.rendered}"
    destination = "c:\\HabService.exe.config"
  }

  provisioner "remote-exec" {
    inline = [
      "powershell c:\\hab.ps1",
    ]
  }
  
}

data "template_cloudinit_config" "swa-config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = <<EOF
<script>
  winrm quickconfig -q & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}

</script>
<powershell>
  netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
  # Set Administrator password
  $admin = [adsi]("WinNT://./administrator, user")
  $admin.psbase.invoke("SetPassword", "${var.azure_image_password}")
  $newname = "swa-${random_id.instance_id.hex}"
  [Environment]::SetEnvironmentVariable("HAB_UPDATE_STRATEGY_FREQUENCY_MS", "20000", "Machine")
  Rename-Computer -NewName $newname -Force
  Restart-Computer
</powershell>
EOF
  }
}

data "template_file" "hab_sqlwebadmin" {
  template = "${file("${path.module}/templates/hab.ps1")}"
  vars {
    release_channel = "${var.hab_sqlwebadmin_channel}"
    package_name = "${var.hab_sqlwebadmin_package}"
    bindings  = "${var.hab_sqlwebadmin_bindings}"
  }
}

variable "hab_sqlwebadmin_channel" {
  default = "stable"
  description = ""
}

variable "hab_sqlwebadmin_package" {
  default = "mwrock/sqlwebadmin"
  description = "Origin + Package for sqlwebadmin"
}

variable "hab_sqlwebadmin_bindings" {
  default =  "--bind database:sqlserver2005.stable"
  description = "Example: --bind database:sqlserver2005.default"
}
