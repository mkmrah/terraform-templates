variable "vpcid" {
  description = "Enter the vpc id"
}

variable "region" {
  description = "Enter the vpc region"
  default = "eu-de"
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

variable "imageid" {
  description = "Enter the image id for the VSI"
}

data "ibm_is_ssh_key" "testacc_sshkey" {
  name = var.sshkey
}

resource "random_id" "name" {
  byte_length = 4
}

resource "ibm_is_instance" "testacc_instance" {
  name    = "${var.instance_name}${random_id.name.hex}"
  image   = var.imageid
  profile = "cx2-2x4"

  primary_network_interface {
    subnet = var.subnetid
  }

  vpc  = var.vpcid
  zone = "${var.region}"
  keys = [data.ibm_is_ssh_key.testacc_sshkey.id]
}

resource "null_resource" "sleep" {
  triggers = {
    uuid = uuid()
  }

  provisioner "local-exec" {
    command = "sleep ${var.sleepy_time}"
  } 
  depends_on = [ibm_is_instance.testacc_instance]
}
