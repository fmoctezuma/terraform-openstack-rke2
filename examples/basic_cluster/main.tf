module "controlplane" {
  source           = "remche/rke2/openstack"
  cluster_name     = "rke2"
  dns_servers      = var.dns_servers
  nodes_count      = 3
  write_kubeconfig = true
  image_name       = "Ubuntu 20.04 Cloudimage"
  flavor_name      = "demo01-mk8s-small"
  public_net_name  = "GATEWAY_NET"
  rke2_config_file = "server.yaml"
  manifests_path   = "./manifests"
}

module "worker_node" {
  source           = "remche/rke2/openstack//modules/agent"
  image_name       = "Ubuntu 20.04 Cloudimage"
  nodes_count      = 3
  name_prefix      = "demo"
  flavor_name      = "demo01-mk8s-small"
  node_config      = module.controlplane.node_config
  rke2_config_file = "agent.yaml"
}

output "controlplane_floating_ip" {
  value     = module.controlplane.floating_ip
  sensitive = true
}
