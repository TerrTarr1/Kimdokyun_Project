########### create auto scaling group ##########

resource "aws_autoscaling_group" "test_ag1" {
        name = "test_ag1"
        desired_capacity = 2
        max_size = 4
        min_size = 2
        vpc_zone_identifier = ["${aws_subnet.Test_Private_Subnet_1.id}", "${aws_subnet.Test_Private_Subnet_2.id}"]
        health_check_type = "EC2"
        health_check_grace_period = 300
        force_delete = false

        launch_template {
                id = "${aws_launch_template.test_launch_template.id}"
                version = "$Latest"
        }
}
