vim image.tf

###################################################### create image

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
