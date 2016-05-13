# bootstrap-openstack-terraform
Bootstrapping an openstack tenant using terraform with some basic elements

Terraform openstack script that creates a simple network, two servers with different flavors, gets a floating IP and assigns it to one of the server.

Openstack services **created** by this script are:

1) Key

2) Netowrk

3) Subnet with CIDR from variables file as defined

4) Router with gateway and interface

5) Floating IP

6) Security groups

7) Two servers with different flavors and configurations

Prerequisites:

1) **Opensatck tenant** with sufficient resources

2) **Terraform** installed

Basic commands to deploy above mentioned openstack servces:

1) ```terraform plan``` :  Generates and shows execution plan and also any if there are any syntactical errors

2) ```terraform apply``` : Builds or changes infrastructure according to terraform scripts

3) ```terraform destroy``` : Destroys Terraform managed infrastructure

