vim role.tf
#################################################### user role

resource "openstack_identity_role_v3" "role_1" {
        name = "role_1"
}

resource "openstack_identity_role_assignment_v3" "role_assignment_1" {
        user_id    = openstack_identity_user_v3.test_admin.id
        project_id = openstack_identity_project_v3.test_project.id
        role_id    = openstack_identity_role_v3.role_1.id
}

:wq
tf plan
tf apply




vim flavor.tf
################################################### create flavor

resource "openstack_compute_flavor_v2" "flavor_c1_tiny" {
  name  = "c1.tyni"
  ram   = "256"
  vcpus = "1"
  disk  = "1"
  is_public = true
}

:wq
tf plan
tf apply



vim image.tf
################################################### create image

resource "openstack_images_image_v2" "cirros" {
  name             = "cirros"
  image_source_url = "cirros-0.5.1-x86_64-disk.img"
  container_format = "bare"
  disk_format      = "qcow2"
  visibility       = "public"
  protected        = "false"

  properties = {
    key = "value"
  }
}

:wq
tf plan
tf apply
