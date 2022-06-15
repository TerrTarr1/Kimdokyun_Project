vim alb.tf

########## create load balancer target group ##########

resource "aws_lb_target_group" "test_tg" {
        name = "test-tg"
        port = 80
        protocol = "HTTP"
        protocol_version = "HTTP1"
        target_type = "instance"
        vpc_id = "${aws_vpc.Test_VPC.id}"
}

########## create load balancer ##########

resource "aws_lb" "test_lb" {
        name = "test-lb"
        internal = false
        load_balancer_type = "application"
        subnets =  ["${aws_subnet.Test_Public_Subnet_1.id}", "${aws_subnet.Test_Public_Subnet_2.id}"]
        security_groups = ["${aws_security_group.Test_Public_ALB_SG.id}"]

        enable_deletion_protection = false
}

########## target group listener ##########

resource "aws_lb_listener" "test_lb_listener" {
        load_balancer_arn = "${aws_lb.test_lb.arn}"
        port = "80"
        protocol = "HTTP"

        default_action {
                type = "forward"
                target_group_arn = "${aws_lb_target_group.test_tg.arn}"
        }
}

########## load balancer & TG attachment ##########

resource "aws_autoscaling_attachment" "asg_attachment_tg" {
        autoscaling_group_name = "${aws_autoscaling_group.test_ag1.id}"
        alb_target_group_arn = "${aws_lb_target_group.test_tg.arn}"
}

:wq

tf plan
tf apply
