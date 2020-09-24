variable "vpcid" {
  description = "Enter the vpc id"
}

variable "subnetid" {
  description = "Enter the subnet id"
}

variable "sshkey" {
  description = "Enter the ssh key name"
}

variable "instance_name" {
  default = "testvsi-"
  description = "Prefix to the name of the vsi"
}

data "ibm_is_ssh_key" "testacc_sshkey" {
  name = var.sshkey
}

resource "random_id" "name" {
  byte_length = 4
}

resource "ibm_is_instance" "testacc_instance" {
  name    = "${var.instance_name}${random_id.name.hex}"
  image   = "r006-ed3f775f-ad7e-4e37-ae62-7199b4988b00"
  profile = "cx2-2x4"

  primary_network_interface {
    subnet = var.subnetid
  }

  vpc  = var.vpcid
  zone = "us-south-3"
  keys = [data.ibm_is_ssh_key.testacc_sshkey.id]
}
