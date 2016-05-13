# Configure the OpenStack Provider
provider "openstack" {
    user_name  = "XXXX"
    tenant_name = "XXXX"
    password  = "XXXX"
    auth_url  = "XXXX"  #keystone URL here
}

#get a floating IP
resource "openstack_compute_floatingip_v2" "floatingip-test1" {
  pool = "public-floating"
  depends_on = ["openstack_networking_router_interface_v2.router-test1-if"]
}

#add a public key
resource "openstack_compute_keypair_v2" "jumphost_key"
{
   name = "jumphost_key"
   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/+7W99Nsv23V4msjd7z/77awcy28+so19eW57nELrMhi/r+EIT2z7opVeeKmvMKWqRFi3JIvUvIettrHBwLpDO87WkRdFLUm4qHiWeLwiNUVE1Euz5/eQmb4WeGDGPRIkG/7RIlOPPihDX9f5P9QJmBfEgLmOKTS1L1hucmm7IM2eL3y0JVZekgmHTMi9RDGrYwaXRE4Snu3Zv9+oU0uTAK/oiiKIl8WjzOiuMtvNZAqMHUb9CvMdi2/oPSa8nAqVLMnhTxjpCU4ziypMhx8f+JNQ6Yz0zufY8owiUC7y9PZXDFDr17i+amkS3c+2tavrTb4s3OZJyoZgKcoY6HC/ XXXYYYYXXYY@XXYYYY"
}

#Create network
resource "openstack_networking_network_v2" "network-test1" {
  name = "network-aj"
  admin_state_up = "true"
}

#Create subnet
resource "openstack_networking_subnet_v2" "subnet-test1" {
  name = "subnet-1"
  network_id = "${openstack_networking_network_v2.network-test1.id}"
  cidr = "${var.subnet_cidr}"
  ip_version = 4
  allocation_pools = {
    start = "${var.dhcp_min}"
    end = "${var.dhcp_max}"
  }
}

#Create a router
resource "openstack_networking_router_v2" "router-test1" {
  name = "router-test1"
  admin_state_up = "true"
  external_gateway = "XXXXXXXX-XXXXXXX" #public floating network UUID here
}

#Create Router interfaces
resource "openstack_networking_router_interface_v2" "router-test1-if" {
  router_id = "${openstack_networking_router_v2.router-test1.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet-test1.id}"
}

#Create a security group
resource "openstack_compute_secgroup_v2" "secgroups-test1" {
  name = "secgroups-test1"
  description = "Allow SSH access to a jumphost"
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
  rule {
    from_port = -1
    to_port = -1
    ip_protocol = "icmp"
    cidr = "0.0.0.0/0"
  }
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
}

#Create block storage volume
resource "openstack_blockstorage_volume_v1" "volume-test1" {
  name = "volume-test1"
  description = "first test volume"
  size = 10
}

#Create two instances 
resource "openstack_compute_instance_v2" "test-server-ajay" {
  name = "server-test1"
  image_name = "CentOS-6"
  region="RegionOne"
  flavor_name = "m1.medium"
  admin_pass = "helloworld"
  metadata {
    this = "that"
	hi = "hello"
  }
  floating_ip = "${openstack_compute_floatingip_v2.floatingip-test1.address}"
  network {
	uuid = "${openstack_networking_network_v2.network-test1.id}"
	fixed_ip_v4 = "${var.jh-ip}"
  }
}
resource "openstack_compute_instance_v2" "test-server-jh" {
  name = "server-test2"
  image_name = "CentOS-6"
  flavor_name = "m1.large"
  key_pair = "${openstack_compute_keypair_v2.jumphost_key.name}"
  security_groups = [ "${openstack_compute_secgroup_v2.secgroups-test1.name}" ]
  network = {
    uuid = "${openstack_networking_network_v2.network-test1.id}"
	fixed_ip_v4 = "192.168.80.150"
  }
  metadata {
    ssh_user = "cloud-user"
    role = "jumphost"
  }
  volume = {
    volume_id = "${openstack_blockstorage_volume_v1.volume-test1.id}"
  }
}

#Prints the values required
output "test-server-jh"
{
  value = "${openstack_compute_instance_v2.test-server-jh.access_ip_v4}"
}
output "test-server-ajay"
{
  value = "${openstack_compute_instance_v2.test-server-ajay.access_ip_v4}"
}
