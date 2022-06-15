########## create launch template ##########
resource "aws_launch_template" "test_launch_template" {
        name = "test_launch_template"
        image_id = "ami-0cbec04a61be382d9"
        instance_type = "t2.micro"
        key_name = "TF_Test_Key"
        vpc_security_group_ids = ["${aws_security_group.Test_Private_WEB_SG.id}"]
        iam_instance_profile {
                name = "test-s3-readonly"
        }
        user_data = filebase64("Test_Web.sh")

        depends_on = [ aws_nat_gateway.test_nat, aws_rds_cluster_instance.test_cluster_instances, aws_rds_cluster.test_cluster  ]
}
