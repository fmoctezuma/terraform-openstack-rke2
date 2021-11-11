variable "cluster_name" {
  type    = string
  default = "rke2"
}

variable "dns_servers" {
  type    = list(string)
  default = ["1.1.1.1"]
}
