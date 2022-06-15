vim sec.tf
########################################################## security group - private network

resource "openstack_networking_secgroup_v2" "private_network_SG_1" {
        name        = "private_network_SG_1"
        description = "private network SG - neutron"
        tenant_id = openstack_identity_project_v3.test_project.id
}



resource "openstack_networking_secgroup_rule_v2" "private_network_ICMP_ingress" {
        direction = "ingress"
        ethertype = "IPv4"
        protocol = "icmp"
        remote_ip_prefix = "0.0.0.0/0"
        security_group_id = openstack_networking_secgroup_v2.private_network_SG_1.id
        tenant_id = openstack_identity_project_v3.test_project.id
}

resource "openstack_networking_secgroup_rule_v2" "private_network_SSH_ingress" {
        direction = "ingress"
        ethertype = "IPv4"
        protocol = "tcp"
        port_range_min = 22
        port_range_max = 22
        remote_ip_prefix = "0.0.0.0/0"
        security_group_id = openstack_networking_secgroup_v2.private_network_SG_1.id
        tenant_id = openstack_identity_project_v3.test_project.id
}

resource "openstack_networking_secgroup_rule_v2" "private_network_HTTP_ingress" {
        direction = "ingress"
        ethertype = "IPv4"
        protocol = "tcp"
        port_range_min = 80
        port_range_max = 80
        remote_ip_prefix = "0.0.0.0/0"
        security_group_id = openstack_networking_secgroup_v2.private_network_SG_1.id
        tenant_id = openstack_identity_project_v3.test_project.id
}

:wq

tf plan
tf apply
