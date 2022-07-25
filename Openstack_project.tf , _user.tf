vim project.tf
#################################################### create project

resource "openstack_identity_project_v3" "test_project" {
        name = "test_project"
        description = "project for test"
}

:wq
tf plan
tf apply



vim user.tf
#################################################### create user

resource "openstack_identity_user_v3" "test_admin" {
        default_project_id = "${openstack_identity_project_v3.test_project.id}"
        name = "test_admin"
        description = "admin user for test_project"

        password = "1234"

        ignore_change_password_upon_first_use = true

        multi_factor_auth_enabled = false

        extra = {
                email = "testAdmin@labs.local"
        }
}

:wq
tf plan
tf apply
