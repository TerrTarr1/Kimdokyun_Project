vim role.tf

############################################################## user role

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
