vim network.tf

##################################################### create Public network, subnet

resource "openstack_networking_network_v2" "public_network_1" {
        name           = "public_network_1"
        admin_state_up = "true"
        external = "true"
        tenant_id = "716f2bfa1dab4414b0c5d427b2227a96"
        segments {
                physical_network = "datacentre"
                network_type = "flat"
 }
}

resource "openstack_networking_subnet_v2" "public_subnet_1" {
        name = "public_subnet_1"
        network_id = openstack_networking_network_v2.public_network_1.id
        cidr       = "192.168.108.0/24"
        gateway_ip = "192.168.108.2"
        enable_dhcp = "false"
        dns_nameservers = ["8.8.8.8"]
}


######################################################### create private network, subnet

resource "openstack_networking_network_v2" "private_network_1" {
        name           = "private_network_1"
        admin_state_up = "true"
        tenant_id = openstack_identity_project_v3.test_project.id
}

resource "openstack_networking_subnet_v2" "private_subnet_1" {
        name = "private_subnet_1"
        network_id = openstack_networking_network_v2.private_network_1.id
        cidr       = "192.168.101.0/24"
        enable_dhcp = "true"
        dns_nameservers = ["8.8.8.8"]
        tenant_id = openstack_identity_project_v3.test_project.id
}


###################################################### create router

resource "openstack_networking_router_v2" "router_1" {
        name                = "router_1"
        admin_state_up      = true
        external_network_id = openstack_networking_network_v2.public_network_1.id
        tenant_id = openstack_identity_project_v3.test_project.id
}

##################################################### add interface

resource "openstack_networking_router_interface_v2" "router_interface_1" {
        router_id = openstack_networking_router_v2.router_1.id
        subnet_id = openstack_networking_subnet_v2.private_subnet_1.id
}

:wq
tf plan
tf apply
