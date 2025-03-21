module "agent" {
  source             = "../node"
  name_prefix        = "${var.node_config.cluster_name}-${var.name_prefix}"
  nodes_count        = var.nodes_count
  image_id           = var.image_id
  image_name         = var.image_name
  flavor_name        = var.flavor_name
  assign_floating_ip = var.assign_floating_ip
  keypair_name       = var.node_config.keypair_name
  ssh_key_file       = var.node_config.ssh_key_file
  system_user        = var.node_config.system_user
  use_ssh_agent      = var.node_config.use_ssh_agent
  network_id         = var.node_config.network_id
  subnet_id          = var.node_config.subnet_id
  secgroup_id        = var.node_config.secgroup_id
  server_affinity    = var.server_group_affinity
  config_drive       = var.node_config.config_drive
  floating_ip_pool   = var.node_config.floating_ip_pool
  user_data          = var.node_config.user_data
  boot_from_volume   = var.node_config.boot_from_volume
  boot_volume_size   = var.node_config.boot_volume_size
  availability_zones = var.node_config.availability_zones
  bootstrap_server   = var.node_config.bootstrap_server
  bastion_host       = var.node_config.bastion_host
  is_server          = false
  rke2_version       = var.rke2_version
  rke2_config_file   = var.rke2_config_file
  registries_conf    = var.node_config.registries_conf
  rke2_token         = var.node_config.rke2_token
  do_upgrade         = var.do_upgrade
}
