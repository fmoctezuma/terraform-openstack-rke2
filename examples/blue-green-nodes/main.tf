module "controlplane" {
  source           = "remche/rke2/openstack"
  cluster_name     = var.cluster_name
  dns_servers      = var.dns_servers
  nodes_count      = 3
  write_kubeconfig = true
  image_name       = "ubuntu-20.04-focal-x86_64"
  flavor_name      = "cpuX2"
  public_net_name  = "dmz"
  rke2_config_file = "server.yaml"
  manifests_path   = "./manifests"
}

module "blue_node" {
  source           = "remche/rke2/openstack//modules/agent"
  image_name       = "ubuntu-20.04-focal-x86_64"
  nodes_count      = 1
  name_prefix      = "blue"
  flavor_name      = "cpuX2"
  node_config      = module.controlplane.node_config
  rke2_config_file = "agent.yaml"
}

module "green_node" {
  source      = "remche/rke2/openstack//modules/agent"
  image_name  = "ubuntu-20.04-focal-x86_64"
  nodes_count = 1
  name_prefix = "green"
  flavor_name = "cpuX2"
  node_config = module.controlplane.node_config
}

output "controlplane_floating_ip" {
  value     = module.controlplane.floating_ip
  sensitive = true
}
