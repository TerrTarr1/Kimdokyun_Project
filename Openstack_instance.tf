vim instance.tf

####################### create instance

resource "openstack_compute_instance_v2" "basic" {
        name            = "basic"
        image_id        = openstack_images_image_v2.cirros.id
        flavor_id       = openstack_compute_flavor_v2.flavor_c1_tiny.id
        #security_groups = [openstack_networking_secgroup_v2.private_network_SG_1.name]

        network {
                name = openstack_networking_network_v2.private_network_1.name
        }
}

:wq

tf plan
tf apply
