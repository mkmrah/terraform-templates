provider "ibm" {
  region = "eu-de"
}

variable "vpcid" {
  description = "Enter the vpc id"
  default = "r010-06a1153a-a34c-41ee-9ab7-dc713b97c2af"
}

variable "region" {
  description = "Enter the vpc region"
  default = "eu-de"
}

variable "subnetid" {
  description = "Enter the subnet id"
  default = "02d7-9cdb9e45-51a8-4b99-8eb0-4637616fb298"
}

variable "sshkey" {
  description = "Enter the ssh key name"
  default = "smfr-2ops"
}

variable "instance_name" {
  default = "testvsi-"
  description = "Prefix to the name of the vsi"
}

variable "imageid" {
  description = "Enter the image id for the VSI"
  default = "r006-ed3f775f-ad7e-4e37-ae62-7199b4988b00"
}

data "ibm_is_ssh_key" "testacc_sshkey" {
  name = "smfr-2ops"
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
