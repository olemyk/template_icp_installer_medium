provider "vsphere" {
  version              = "~> 1.3"
  allow_unverified_ssl = "true"
}

provider "random" {
  version = "~> 1.0"
}

provider "local" {
  version = "~> 1.1"
}

provider "null" {
  version = "~> 1.0"
}

provider "tls" {
  version = "~> 1.0"
}

resource "random_string" "random-dir" {
  length  = 8
  special = false
}

resource "tls_private_key" "generate" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "null_resource" "create-temp-random-dir" {
  provisioner "local-exec" {
    command = "${format("mkdir -p  /tmp/%s" , "${random_string.random-dir.result}")}"
  }
}

module "deployVM_boot" {
  source = "github.com/IBM-CAMHub-Open/template_icp_modules//vmware_provision"

  #######
  vsphere_datacenter    = "${var.vsphere_datacenter}"
  vsphere_resource_pool = "${var.vsphere_resource_pool}"
  count                 = "${length(var.boot_vm_ipv4_address)}"

  #######
  // vm_folder = "${module.createFolder.folderPath}"

  vm_vcpu                    = "${var.boot_vcpu}"                                                                                                           // vm_number_of_vcpu
  vm_name                    = "${var.boot_prefix_name}"
  vm_memory                  = "${var.boot_memory}"
  vm_template                = "${var.vm_template}"
  vm_os_password             = "${var.vm_os_password}"
  vm_os_user                 = "${var.vm_os_user}"
  vm_domain                  = "${var.vm_domain}"
  vm_folder                  = "${var.vm_folder}"
  vm_private_ssh_key         = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${var.icp_private_ssh_key}"}"
  vm_public_ssh_key          = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_network_interface_label = "${var.vm_network_interface_label}"
  vm_ipv4_gateway            = "${var.boot_vm_ipv4_gateway}"
  vm_ipv4_address            = "${var.boot_vm_ipv4_address}"
  vm_ipv4_prefix_length      = "${var.boot_vm_ipv4_prefix_length}"
  vm_adapter_type            = "${var.vm_adapter_type}"
  vm_disk1_size              = "${var.boot_vm_disk1_size}"
  vm_disk1_datastore         = "${var.vm_disk1_datastore}"
  vm_disk1_keep_on_remove    = "${var.boot_vm_disk1_keep_on_remove}"
  vm_disk2_enable            = "${var.boot_vm_disk2_enable}"
  vm_disk2_size              = "${var.boot_vm_disk2_size}"
  vm_disk2_datastore         = "${var.vm_disk2_datastore}"
  vm_disk2_keep_on_remove    = "${var.boot_vm_disk2_keep_on_remove}"
  vm_dns_servers             = "${var.vm_dns_servers}"
  vm_dns_suffixes            = "${var.vm_dns_suffixes}"
  random                     = "${random_string.random-dir.result}"
}

module "deployVM_master" {
  source = "github.com/IBM-CAMHub-Open/template_icp_modules//vmware_provision"

  #######
  vsphere_datacenter    = "${var.vsphere_datacenter}"
  vsphere_resource_pool = "${var.vsphere_resource_pool}"
  count                 = "${length(var.master_vm_ipv4_address)}"

  #######
  // vm_folder = "${module.createFolder.folderPath}"

  vm_vcpu                    = "${var.master_vcpu}"                                                                                                         // vm_number_of_vcpu
  vm_name                    = "${var.master_prefix_name}"
  vm_memory                  = "${var.master_memory}"
  vm_template                = "${var.vm_template}"
  vm_os_password             = "${var.vm_os_password}"
  vm_os_user                 = "${var.vm_os_user}"
  vm_domain                  = "${var.vm_domain}"
  vm_folder                  = "${var.vm_folder}"
  vm_private_ssh_key         = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${var.icp_private_ssh_key}"}"
  vm_public_ssh_key          = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_network_interface_label = "${var.vm_network_interface_label}"
  vm_ipv4_gateway            = "${var.master_vm_ipv4_gateway}"
  vm_ipv4_address            = "${var.master_vm_ipv4_address}"
  vm_ipv4_prefix_length      = "${var.master_vm_ipv4_prefix_length}"
  vm_adapter_type            = "${var.vm_adapter_type}"
  vm_disk1_size              = "${var.master_vm_disk1_size}"
  vm_disk1_datastore         = "${var.vm_disk1_datastore}"
  vm_disk1_keep_on_remove    = "${var.master_vm_disk1_keep_on_remove}"
  vm_disk2_enable            = "${var.master_vm_disk2_enable}"
  vm_disk2_size              = "${var.master_vm_disk2_size}"
  vm_disk2_datastore         = "${var.vm_disk2_datastore}"
  vm_disk2_keep_on_remove    = "${var.master_vm_disk2_keep_on_remove}"
  vm_dns_servers             = "${var.vm_dns_servers}"
  vm_dns_suffixes            = "${var.vm_dns_suffixes}"
  random                     = "${random_string.random-dir.result}"
}

module "deployVM_manage" {
  source = "github.com/IBM-CAMHub-Open/template_icp_modules//vmware_provision"

  #######
  vsphere_datacenter    = "${var.vsphere_datacenter}"
  vsphere_resource_pool = "${var.vsphere_resource_pool}"
  count                 = "${length(var.master_vm_ipv4_address)}"

  #######
  // vm_folder = "${module.createFolder.folderPath}"

  vm_vcpu                    = "${var.manage_vcpu}"                                                                                                         // vm_number_of_vcpu
  vm_name                    = "${var.manage_prefix_name}"
  vm_memory                  = "${var.manage_memory}"
  vm_template                = "${var.vm_template}"
  vm_os_password             = "${var.vm_os_password}"
  vm_os_user                 = "${var.vm_os_user}"
  vm_domain                  = "${var.vm_domain}"
  vm_folder                  = "${var.vm_folder}"
  vm_private_ssh_key         = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${var.icp_private_ssh_key}"}"
  vm_public_ssh_key          = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_network_interface_label = "${var.vm_network_interface_label}"
  vm_ipv4_gateway            = "${var.manage_vm_ipv4_gateway}"
  vm_ipv4_address            = "${var.manage_vm_ipv4_address}"
  vm_ipv4_prefix_length      = "${var.manage_vm_ipv4_prefix_length}"
  vm_adapter_type            = "${var.vm_adapter_type}"
  vm_disk1_size              = "${var.manage_vm_disk1_size}"
  vm_disk1_datastore         = "${var.vm_disk1_datastore}"
  vm_disk1_keep_on_remove    = "${var.manage_vm_disk1_keep_on_remove}"
  vm_disk2_enable            = "${var.manage_vm_disk2_enable}"
  vm_disk2_size              = "${var.manage_vm_disk2_size}"
  vm_disk2_datastore         = "${var.vm_disk2_datastore}"
  vm_disk2_keep_on_remove    = "${var.manage_vm_disk2_keep_on_remove}"
  vm_dns_servers             = "${var.vm_dns_servers}"
  vm_dns_suffixes            = "${var.vm_dns_suffixes}"
  random                     = "${random_string.random-dir.result}"
  enable_vm                  = "${var.enable_vm_management}"
}

module "deployVM_proxy" {
  source = "github.com/IBM-CAMHub-Open/template_icp_modules//vmware_provision"

  #######
  vsphere_datacenter    = "${var.vsphere_datacenter}"
  vsphere_resource_pool = "${var.vsphere_resource_pool}"
  count                 = "${length(var.proxy_vm_ipv4_address)}"

  #######
  // vm_folder = "${module.createFolder.folderPath}"

  vm_vcpu                    = "${var.proxy_vcpu}"                                                                                                          // vm_number_of_vcpu
  vm_name                    = "${var.proxy_prefix_name}"
  vm_memory                  = "${var.proxy_memory}"
  vm_template                = "${var.vm_template}"
  vm_os_password             = "${var.vm_os_password}"
  vm_os_user                 = "${var.vm_os_user}"
  vm_domain                  = "${var.vm_domain}"
  vm_folder                  = "${var.vm_folder}"
  vm_private_ssh_key         = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${var.icp_private_ssh_key}"}"
  vm_public_ssh_key          = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_network_interface_label = "${var.vm_network_interface_label}"
  vm_ipv4_gateway            = "${var.proxy_vm_ipv4_gateway}"
  vm_ipv4_address            = "${var.proxy_vm_ipv4_address}"
  vm_ipv4_prefix_length      = "${var.proxy_vm_ipv4_prefix_length}"
  vm_adapter_type            = "${var.vm_adapter_type}"
  vm_disk1_size              = "${var.proxy_vm_disk1_size}"
  vm_disk1_datastore         = "${var.vm_disk1_datastore}"
  vm_disk1_keep_on_remove    = "${var.proxy_vm_disk1_keep_on_remove}"
  vm_disk2_enable            = "${var.proxy_vm_disk2_enable}"
  vm_disk2_size              = "${var.proxy_vm_disk2_size}"
  vm_disk2_datastore         = "${var.vm_disk2_datastore}"
  vm_disk2_keep_on_remove    = "${var.proxy_vm_disk2_keep_on_remove}"
  vm_dns_servers             = "${var.vm_dns_servers}"
  vm_dns_suffixes            = "${var.vm_dns_suffixes}"
  random                     = "${random_string.random-dir.result}"
}

module "deployVM_worker" {
  source = "github.com/IBM-CAMHub-Open/template_icp_modules//vmware_provision"

  #######
  vsphere_datacenter    = "${var.vsphere_datacenter}"
  vsphere_resource_pool = "${var.vsphere_resource_pool}"
  count                 = "${length(var.worker_vm_ipv4_address)}"

  #######
  // vm_folder = "${module.createFolder.folderPath}"

  vm_vcpu                    = "${var.worker_vcpu}"                                                                                                         // vm_number_of_vcpu
  vm_name                    = "${var.worker_prefix_name}"
  vm_memory                  = "${var.worker_memory}"
  vm_template                = "${var.vm_template}"
  vm_os_password             = "${var.vm_os_password}"
  vm_os_user                 = "${var.vm_os_user}"
  vm_domain                  = "${var.vm_domain}"
  vm_folder                  = "${var.vm_folder}"
  vm_private_ssh_key         = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${var.icp_private_ssh_key}"}"
  vm_public_ssh_key          = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_network_interface_label = "${var.vm_network_interface_label}"
  vm_ipv4_gateway            = "${var.worker_vm_ipv4_gateway}"
  vm_ipv4_address            = "${var.worker_vm_ipv4_address}"
  vm_ipv4_prefix_length      = "${var.worker_vm_ipv4_prefix_length}"
  vm_adapter_type            = "${var.vm_adapter_type}"
  vm_disk1_size              = "${var.worker_vm_disk1_size}"
  vm_disk1_datastore         = "${var.vm_disk1_datastore}"
  vm_disk1_keep_on_remove    = "${var.worker_vm_disk1_keep_on_remove}"
  vm_disk2_enable            = "${var.worker_vm_disk2_enable}"
  vm_disk2_size              = "${var.worker_vm_disk2_size}"
  vm_disk2_datastore         = "${var.vm_disk2_datastore}"
  vm_disk2_keep_on_remove    = "${var.worker_vm_disk2_keep_on_remove}"
  vm_dns_servers             = "${var.vm_dns_servers}"
  vm_dns_suffixes            = "${var.vm_dns_suffixes}"
  random                     = "${random_string.random-dir.result}"
}

module "deployVM_VA_Server" {
  source = "github.com/IBM-CAMHub-Open/template_icp_modules//vmware_provision"

  #######
  vsphere_datacenter    = "${var.vsphere_datacenter}"
  vsphere_resource_pool = "${var.vsphere_resource_pool}"
  count                 = "${length(var.va_vm_ipv4_address)}"

  #######
  // vm_folder = "${module.createFolder.folderPath}"

  vm_vcpu                    = "${var.va_vcpu}"                                                                                                             // vm_number_of_vcpu
  vm_name                    = "${var.va_prefix_name}"
  vm_memory                  = "${var.va_memory}"
  vm_template                = "${var.vm_template}"
  vm_os_password             = "${var.vm_os_password}"
  vm_os_user                 = "${var.vm_os_user}"
  vm_domain                  = "${var.vm_domain}"
  vm_folder                  = "${var.vm_folder}"
  vm_private_ssh_key         = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${var.icp_private_ssh_key}"}"
  vm_public_ssh_key          = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_network_interface_label = "${var.vm_network_interface_label}"
  vm_ipv4_gateway            = "${var.va_vm_ipv4_gateway}"
  vm_ipv4_address            = "${var.va_vm_ipv4_address}"
  vm_ipv4_prefix_length      = "${var.va_vm_ipv4_prefix_length}"
  vm_adapter_type            = "${var.vm_adapter_type}"
  vm_disk1_size              = "${var.va_vm_disk1_size}"
  vm_disk1_datastore         = "${var.vm_disk1_datastore}"
  vm_disk1_keep_on_remove    = "${var.va_vm_disk1_keep_on_remove}"
  vm_disk2_enable            = "${var.va_vm_disk2_enable}"
  vm_disk2_size              = "${var.va_vm_disk2_size}"
  vm_disk2_datastore         = "${var.vm_disk2_datastore}"
  vm_disk2_keep_on_remove    = "${var.va_vm_disk2_keep_on_remove}"
  vm_dns_servers             = "${var.vm_dns_servers}"
  vm_dns_suffixes            = "${var.vm_dns_suffixes}"
  random                     = "${random_string.random-dir.result}"
  enable_vm                  = "${var.enable_vm_va}"
}

module "deployVM_NFS_Server" {
  source = "github.com/IBM-CAMHub-Open/template_icp_modules//vmware_provision"

  #######
  vsphere_datacenter    = "${var.vsphere_datacenter}"
  vsphere_resource_pool = "${var.vsphere_resource_pool}"
  count                 = "${length(var.nfs_server_vm_ipv4_address)}"

  // vm_folder = "${module.createFolder.folderPath}"

  vm_vcpu                    = "${var.nfs_server_vcpu}"                                                                                                     // vm_number_of_vcpu
  vm_name                    = "${var.nfs_server_prefix_name}"
  vm_memory                  = "${var.nfs_server_memory}"
  vm_template                = "${var.vm_template}"
  vm_os_password             = "${var.vm_os_password}"
  vm_os_user                 = "${var.vm_os_user}"
  vm_domain                  = "${var.vm_domain}"
  vm_folder                  = "${var.vm_folder}"
  vm_private_ssh_key         = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${var.icp_private_ssh_key}"}"
  vm_public_ssh_key          = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_network_interface_label = "${var.vm_network_interface_label}"
  vm_ipv4_gateway            = "${var.nfs_server_vm_ipv4_gateway}"
  vm_ipv4_address            = "${var.nfs_server_vm_ipv4_address}"
  vm_ipv4_prefix_length      = "${var.nfs_server_vm_ipv4_prefix_length}"
  vm_adapter_type            = "${var.vm_adapter_type}"
  vm_disk1_size              = "${var.nfs_server_vm_disk1_size}"
  vm_disk1_datastore         = "${var.vm_disk1_datastore}"
  vm_disk1_keep_on_remove    = "${var.nfs_server_vm_disk1_keep_on_remove}"
  vm_disk2_enable            = "${var.nfs_server_vm_disk2_enable}"
  vm_disk2_size              = "${var.nfs_server_vm_disk2_size}"
  vm_disk2_datastore         = "${var.vm_disk2_datastore}"
  vm_disk2_keep_on_remove    = "${var.nfs_server_vm_disk2_keep_on_remove}"
  vm_dns_servers             = "${var.vm_dns_servers}"
  vm_dns_suffixes            = "${var.vm_dns_suffixes}"
  random                     = "${random_string.random-dir.result}"
  enable_vm                  = "${var.enable_nfs}"
}

module "icphosts" {
  source                = "github.com/IBM-CAMHub-Open/template_icp_modules//config_icphosts"
  master_public_ips     = "${join(",", var.master_vm_ipv4_address)}"
  management_public_ips = "${join(",", var.manage_vm_ipv4_address)}"
  proxy_public_ips      = "${join(",", var.proxy_vm_ipv4_address)}"
  worker_public_ips     = "${join(",", var.worker_vm_ipv4_address)}"
  va_public_ips         = "${join(",", var.va_vm_ipv4_address)}"
  enable_vm_management  = "${var.enable_vm_management}"
  enable_vm_va          = "${var.enable_vm_va}"
  random                = "${random_string.random-dir.result}"
}

module "icp_prereqs" {
  source               = "github.com/IBM-CAMHub-Open/template_icp_modules//config_icp_prereqs"
  private_key          = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${var.icp_private_ssh_key}"}"
  vm_os_user           = "${var.vm_os_user}"
  vm_os_password       = "${var.vm_os_password}"
  vm_ipv4_address_list = "${compact(concat(var.boot_vm_ipv4_address, var.master_vm_ipv4_address, var.proxy_vm_ipv4_address, var.manage_vm_ipv4_address, var.worker_vm_ipv4_address, var.nfs_server_vm_ipv4_address, var.va_vm_ipv4_address))}"
  random               = "${random_string.random-dir.result}"
  dependsOn            = "${module.deployVM_VA_Server.dependsOn}+${module.deployVM_NFS_Server.dependsOn}+${module.deployVM_manage.dependsOn}+${module.deployVM_boot.dependsOn}+${module.deployVM_master.dependsOn}+${module.deployVM_proxy.dependsOn}+${module.deployVM_worker.dependsOn}"
}

module "push_hostfile" {
  source               = "github.com/IBM-CAMHub-Open/template_icp_modules//config_hostfile"
  private_key          = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${var.icp_private_ssh_key}"}"
  vm_os_user           = "${var.vm_os_user}"
  vm_os_password       = "${var.vm_os_password}"
  vm_ipv4_address_list = "${compact(concat(var.boot_vm_ipv4_address, var.master_vm_ipv4_address, var.proxy_vm_ipv4_address, var.manage_vm_ipv4_address, var.worker_vm_ipv4_address, var.nfs_server_vm_ipv4_address, var.va_vm_ipv4_address))}"
  random               = "${random_string.random-dir.result}"
  dependsOn            = "${module.icp_prereqs.dependsOn}"
}

module "NFSServer-Setup" {
  source               = "github.com/IBM-CAMHub-Open/template_icp_modules//config_nfs_server"
  vm_ipv4_address_list = "${var.nfs_server_vm_ipv4_address}"
  vm_os_private_key    = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${var.icp_private_ssh_key}"}"
  vm_os_user           = "${var.vm_os_user}"
  vm_os_password       = "${var.vm_os_password}"
  nfs_drive            = "/dev/sdb"
  enable_nfs           = "${var.enable_nfs}"
  dependsOn            = "${module.push_hostfile.dependsOn}"
}

module "NFSClient-Setup" {
  source               = "github.com/IBM-CAMHub-Open/template_icp_modules//config_nfs_client"
  vm_ipv4_address_list = "${var.master_vm_ipv4_address}"
  vm_os_private_key    = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${var.icp_private_ssh_key}"}"
  vm_os_user           = "${var.vm_os_user}"
  vm_os_password       = "${var.vm_os_password}"
  nfs_server           = "${var.nfs_server_vm_ipv4_address}"
  nfs_folder           = "${var.nfs_server_folder}"
  nfs_mount_point      = "${var.nfs_server_mount_point}"
  nfs_link_folders     = "${join(",", var.master_nfs_folders)}"
  enable_nfs           = "${var.enable_nfs}"
  dependsOn            = "${module.NFSServer-Setup.dependsOn}"
}

module "glusterFS" {
  source                  = "github.com/IBM-CAMHub-Open/template_icp_modules//config_glusterFS"
  vm_ipv4_address_list    = "${var.worker_vm_ipv4_address}"
  vm_ipv4_address_str     = "${join(" ", var.worker_vm_ipv4_address)}"
  enable_glusterFS        = "${var.worker_enable_glusterFS}"
  random                  = "${random_string.random-dir.result}"
  private_key             = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${var.icp_private_ssh_key}"}"
  vm_os_user              = "${var.vm_os_user}"
  vm_os_password          = "${var.vm_os_password}"
  boot_vm_ipv4_address    = "${var.boot_vm_ipv4_address[0]}"
  gluster_volumetype_none = "${var.gluster_volumetype_none}"
  dependsOn               = "${module.NFSClient-Setup.dependsOn}"
}

module "icp_download_load" {
  source               = "github.com/IBM-CAMHub-Open/template_icp_modules//config_icp_download"
  private_key          = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${var.icp_private_ssh_key}"}"
  vm_os_user           = "${var.vm_os_user}"
  vm_os_password       = "${var.vm_os_password}"
  vm_ipv4_address_list = "${concat(var.boot_vm_ipv4_address)}"
  docker_url           = "${var.docker_binary_url}"
  icp_url              = "${var.icp_binary_url}"
  icp_version          = "${var.icp_version}"

  # icp_cluster_name       = "${var.icp_cluster_name}"
  download_user          = "${var.download_user}"
  download_user_password = "${var.download_user_password}"
  enable_bluemix_install = "${var.enable_bluemix_install}"

  random    = "${random_string.random-dir.result}"
  dependsOn = "${module.glusterFS.dependsOn}"
}

module "icp_config_yaml" {
  source                 = "github.com/IBM-CAMHub-Open/template_icp_modules//config_icp_boot_medium"
  private_key            = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${var.icp_private_ssh_key}"}"
  vm_os_user             = "${var.vm_os_user}"
  vm_os_password         = "${var.vm_os_password}"
  vm_ipv4_address_list   = "${concat(var.boot_vm_ipv4_address)}"
  enable_kibana          = "${lower(var.enable_kibana)}"
  enable_metering        = "${lower(var.enable_metering)}"
  icp_version            = "${var.icp_version}"
  kub_version            = "${var.kub_version}"
  vm_domain              = "${var.vm_domain}"
  icp_cluster_name       = "${var.icp_cluster_name}"
  icp_admin_user         = "${var.icp_admin_user}"
  icp_admin_password     = "${var.icp_admin_password}"
  enable_bluemix_install = "${var.enable_bluemix_install}"
  bluemix_token          = "${var.bluemix_token}"
  random                 = "${random_string.random-dir.result}"
  dependsOn              = "${module.icp_download_load.dependsOn}+${module.icp_prereqs.dependsOn}+${module.push_hostfile.dependsOn}+${module.glusterFS.dependsOn}"
}

# resource "null_resource" "Cleanup RANDOM Temp"{
#   depends_on = "${module.icp_config_yaml.dependsOn}"
#   provisioner "local-exec" {
# 	  command = "rm -rf /tmp/${random_string.random-dir.result}"
#   }
# }

