vim flavor.tf

#################################################### create flavor

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
