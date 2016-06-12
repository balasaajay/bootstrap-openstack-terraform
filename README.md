[![Gitter](https://badges.gitter.im/balasaajay/bootstrap-openstack-terraform.svg)](https://gitter.im/balasaajay/bootstrap-openstack-terraform?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

# bootstrap-openstack-terraform
Bootstrapping an openstack tenant using terraform with some basic elements.

Terraform openstack script that creates a simple network, two servers with different flavors, gets a floating IP and assigns it to one of the server.

#### Openstack services created by this script are:

- Key pair

- Network

- Subnet with CIDR from variables file as defined

- Router with gateway and interface

- Floating IP

- Security groups

- Two servers with different flavors and configurations

## Prerequisites:

- **Opensatck tenant** with sufficient resources.

- **Terraform** <https://www.terraform.io/downloads.html> installed.

## How to? 

Basic commands to deploy above mentioned openstack services:

1) `terraform plan` :  Generates, shows execution plan and does a syntax check.

2) `terraform apply` : Builds or changes infrastructure according to terraform scripts.

3) `terraform destroy` : Destroys Terraform managed infrastructure.

