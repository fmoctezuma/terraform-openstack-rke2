locals {
  node_config = {
    cluster_name       = var.cluster_name
    keypair_name       = module.keypair.keypair_name
    ssh_key_file       = var.ssh_key_file
    system_user        = var.system_user
    use_ssh_agent      = var.use_ssh_agent
    network_id         = module.network.nodes_net_id
    subnet_id          = module.network.nodes_subnet_id
    secgroup_id        = module.secgroup.secgroup_id
    server_affinity    = var.server_group_affinity
    config_drive       = var.nodes_config_drive
    floating_ip_pool   = var.public_net_name
    user_data          = var.user_data_file != null ? file(var.user_data_file) : null
    boot_from_volume   = var.boot_from_volume
    boot_volume_size   = var.boot_volume_size
    availability_zones = var.availability_zones
    bootstrap_server   = module.server.internal_ip[0]
    bastion_host       = module.server.floating_ip[0]
    rke2_token         = random_string.rke2_token.result
    registries_conf    = var.registries_conf
  }
  tmpdir           = "${path.root}/.terraform/tmp/rke2"
  ssh              = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
  scp              = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
  remote_rke2_yaml = "${var.system_user}@${module.server.floating_ip[0]}:/etc/rancher/rke2/rke2-remote.yaml"
}

module "keypair" {
  source           = "./modules/keypair"
  cluster_name     = var.cluster_name
  ssh_key_file     = var.ssh_key_file
  ssh_keypair_name = var.ssh_keypair_name
}

module "network" {
  source          = "./modules/network"
  network_name    = "${var.cluster_name}-nodes-net"
  subnet_name     = "${var.cluster_name}-nodes-subnet"
  router_name     = "${var.cluster_name}-router"
  nodes_net_cidr  = var.nodes_net_cidr
  public_net_name = var.public_net_name
  dns_servers     = var.dns_servers
  dns_domain      = var.dns_domain
}

module "secgroup" {
  source      = "./modules/secgroup"
  name_prefix = var.cluster_name
  rules       = var.secgroup_rules
}

module "server" {
  source             = "./modules/node"
  name_prefix        = "${var.cluster_name}-server"
  nodes_count        = var.nodes_count
  image_name         = var.image_name
  image_id           = var.image_id
  flavor_name        = var.flavor_name
  keypair_name       = module.keypair.keypair_name
  ssh_key_file       = var.ssh_key_file
  system_user        = var.system_user
  use_ssh_agent      = var.use_ssh_agent
  network_id         = module.network.nodes_net_id
  subnet_id          = module.network.nodes_subnet_id
  secgroup_id        = module.secgroup.secgroup_id
  server_affinity    = var.server_group_affinity
  assign_floating_ip = "true"
  config_drive       = var.nodes_config_drive
  floating_ip_pool   = var.public_net_name
  user_data          = var.user_data_file != null ? file(var.user_data_file) : null
  boot_from_volume   = var.boot_from_volume
  boot_volume_size   = var.boot_volume_size
  availability_zones = var.availability_zones
  rke2_version       = var.rke2_version
  rke2_config_file   = var.rke2_config_file
  registries_conf    = var.registries_conf
  rke2_token         = random_string.rke2_token.result
  additional_san     = var.additional_san
  manifests_path     = var.manifests_path
  manifests_gzb64    = var.manifests_gzb64
  do_upgrade         = var.do_upgrade
}

resource "local_file" "tmpdirfile" {
  content  = ""
  filename = "${local.tmpdir}/placeholder"
}

resource "random_string" "rke2_token" {
  length = 64
}
