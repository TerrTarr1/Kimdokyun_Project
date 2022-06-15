vim sec.tf

########## create security group ##########

##### Public Security Group #####

resource "aws_security_group" "Test_Public_SG" {
        vpc_id = aws_vpc.Test_VPC.id
        name = "Test_Public_SG"
        description = "Test_Public_SG"
        tags = {
                Name = "tf_Public_SG"
        }
}

resource "aws_security_group" "Test_Public_ALB_SG" {
        vpc_id = aws_vpc.Test_VPC.id
        name = "Test_Public_ALB_SG"
        description = "Test_Public_ALB_SG"
        tags = {
                Name = "tf_Public_ALB_SG"
        }
}

##### Private Security Group #####

resource "aws_security_group" "Test_Private_WEB_SG" {
        vpc_id = aws_vpc.Test_VPC.id
        name = "Test_Private_WEB_SG"
        description = "Test_Private_WEB_SG"
        tags = {
                Name = "tf_Private_WEB_SG"
        }
}

resource "aws_security_group" "Test_Private_DB_SG_1" {
        vpc_id = aws_vpc.Test_VPC.id
        name = "Test_Private_DB_SG_1"
        description = "Test_Private_DB_SG_1"
        tags = {
                Name = "tf_Private_DB__SG_1"
        }
}

##### Public SG rule #####

### public sg rule ###

resource "aws_security_group_rule" "Test_Public_SG_Rule_Ingress" {
        type = "ingress"
        from_port = 0
        to_port = 65535
        protocol = -1
        cidr_blocks = ["${aws_vpc.Test_VPC.cidr_block}"]
        security_group_id = "${aws_security_group.Test_Public_SG.id}"
        lifecycle {
                create_before_destroy = true
        }
}

resource "aws_security_group_rule" "Test_Public_SG_Rule_Egress" {
        type = "egress"
        from_port = 0
        to_port = 65535
        protocol = -1
        cidr_blocks = [ "0.0.0.0/0" ]
        security_group_id = aws_security_group.Test_Public_SG.id
        lifecycle {
                create_before_destroy = true
        }
}

### public alb sg http rule ###

resource "aws_security_group_rule" "Test_Public_ALB_HTTP_SG_Rule_Ingress" {
        type = "ingress"
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
        security_group_id = "${aws_security_group.Test_Public_ALB_SG.id}"
        lifecycle {
                create_before_destroy = true
        }
}

resource "aws_security_group_rule" "Test_Public_ALB_HTTPS_SG_Rule_Ingress" {
        type = "ingress"
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
        security_group_id = "${aws_security_group.Test_Public_ALB_SG.id}"
        lifecycle {
                create_before_destroy = true
        }
}

### public alb sg rule ###

resource "aws_security_group_rule" "Test_Public_ALB_SG_Rule_Egress" {
        type = "egress"
        from_port = 0
        to_port = 65535
        protocol = -1
        cidr_blocks = [ "0.0.0.0/0" ]
        security_group_id = aws_security_group.Test_Public_ALB_SG.id
        lifecycle {
                create_before_destroy = true
        }
}

##### Private SG rule #####

#DB Rule

resource "aws_security_group_rule" "Test_Private_SG_Rule_DB_Ingress" {
        type = "ingress"
        from_port = 3306
        to_port = 3306
        protocol = "TCP"
        security_group_id = aws_security_group.Test_Private_WEB_SG.id
        source_security_group_id = aws_security_group.Test_Public_SG.id
        lifecycle {
                create_before_destroy = true
        }
}

resource "aws_security_group_rule" "Test_Private_SG_Rule_DB_Egress" {
        type = "egress"
        from_port = 3306
        to_port = 3306
        protocol = "TCP"
        security_group_id = aws_security_group.Test_Private_WEB_SG.id
        source_security_group_id = aws_security_group.Test_Public_SG.id
        lifecycle {
                create_before_destroy = true
        }
}

### private web sg http rule ###

resource "aws_security_group_rule" "Test_Private_WEB_SG_Rule_HTTP_Ingress" {
        type = "ingress"
        from_port = 80
        to_port = 80
        protocol = "TCP"
        source_security_group_id = aws_security_group.Test_Public_ALB_SG.id
        security_group_id = aws_security_group.Test_Private_WEB_SG.id
        lifecycle {
                create_before_destroy = true
        }
}
resource "aws_security_group_rule" "Test_Private_WEB_SG_Rule_HTTP_Egress" {
        type = "egress"
        from_port = 0
        to_port = 65535
        protocol = -1
        cidr_blocks = [ "0.0.0.0/0" ]
        security_group_id = aws_security_group.Test_Private_WEB_SG.id
        lifecycle {
                create_before_destroy = true
        }
}

### private web sg https  rule ###

resource "aws_security_group_rule" "Test_Private_WEB_SG_Rule_HTTPS_Ingress" {
        type = "ingress"
        from_port = 443
        to_port = 443
        protocol = "TCP"
        source_security_group_id = aws_security_group.Test_Public_ALB_SG.id
        security_group_id = aws_security_group.Test_Private_WEB_SG.id
        lifecycle {
                create_before_destroy = true
        }
}

resource "aws_security_group_rule" "Test_Private_WEB_SG_Rule_HTTPS_Egress" {
        type = "egress"
        from_port = 443
        to_port = 443
        protocol = "TCP"
        source_security_group_id = aws_security_group.Test_Public_ALB_SG.id
        security_group_id = aws_security_group.Test_Private_WEB_SG.id
        lifecycle {
                create_before_destroy = true
        }
}

### private db sg rule ###

resource "aws_security_group_rule" "Test_Private_DB_SG_Rule_Ingress" {
        type = "ingress"
        from_port = 3306
        to_port = 3306
        protocol = "TCP"
        source_security_group_id = aws_security_group.Test_Private_WEB_SG.id
        security_group_id = aws_security_group.Test_Private_DB_SG_1.id
        lifecycle {
                create_before_destroy = true
        }
}

resource "aws_security_group_rule" "Test_Private_DB_SG_Rule_egress" {
        type = "egress"
        from_port = 3306
        to_port = 3306
        protocol = "TCP"
        source_security_group_id = aws_security_group.Test_Private_WEB_SG.id
        security_group_id = aws_security_group.Test_Private_DB_SG_1.id
        lifecycle {
                create_before_destroy = true
        }
}

:wq

tf plan
tf apply
