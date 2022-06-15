vim vpc.tf

########## create vpc ##########

resource "aws_vpc" "Test_VPC" {
        cidr_block = "192.168.0.0/16"
        tags = {
                Name = "terraform_VPC"
        }
}


########## create subnet ##########

##### public subnet1 #####
resource "aws_subnet" "Test_Public_Subnet_1" {
        vpc_id = aws_vpc.Test_VPC.id
        cidr_block = "192.168.1.0/24"
        availability_zone = "ap-northeast-2a"
        map_public_ip_on_launch = true
        tags = {
                Name = "tf_Public_Subnet_1"
        }
}
##### public subnet2 #####
resource "aws_subnet" "Test_Public_Subnet_2" {
        vpc_id = aws_vpc.Test_VPC.id
        cidr_block = "192.168.3.0/24"
        availability_zone = "ap-northeast-2c"
        map_public_ip_on_launch = true
        tags = {
                Name = "tf_Public_Subnet_2"
        }
}


##### private subnet1 #####
resource "aws_subnet" "Test_Private_Subnet_1" {
        vpc_id = aws_vpc.Test_VPC.id
        cidr_block = "192.168.2.0/24"
        availability_zone = "ap-northeast-2a"
        map_public_ip_on_launch = false
        tags = {
                Name = "tf_Private_Subnet_1"
        }
}
##### private subnet2 #####
resource "aws_subnet" "Test_Private_Subnet_2" {
        vpc_id = aws_vpc.Test_VPC.id
        cidr_block = "192.168.4.0/24"
        map_public_ip_on_launch = false
        availability_zone = "ap-northeast-2c"
        tags = {
                Name = "tf_Private_Subnet_2"
        }
}
########## create internet gateway ##########

resource "aws_internet_gateway" "Test_IGW" {
        vpc_id = aws_vpc.Test_VPC.id
        tags = {
                Name = "tf_IGW"
        }
}

########## create routing table ##########

##### Public routing table #####

resource "aws_route_table" "Test_Public_Route_1" {
        vpc_id = aws_vpc.Test_VPC.id
        route {
                cidr_block = "0.0.0.0/0"
                gateway_id = aws_internet_gateway.Test_IGW.id
        }
        tags = {
                Name = "tf_Public_Route_1"
        }
}

resource "aws_route_table" "Test_Public_Route_2" {
        vpc_id = aws_vpc.Test_VPC.id
        route {
                cidr_block = "0.0.0.0/0"
                gateway_id = aws_internet_gateway.Test_IGW.id
        }
        tags = {
                Name = "tf_Public_Route_2"
        }
}

##### Private routing table #####

resource "aws_route_table" "Test_Private_Route_1" {
        vpc_id = aws_vpc.Test_VPC.id

        route {
                nat_gateway_id = "${aws_nat_gateway.test_nat.id}"
                cidr_block = "0.0.0.0/0"
        }

        tags = {
                Name = "tf_Private_Route_1"
        }
}

resource "aws_route_table" "Test_Private_Route_2" {
        vpc_id = aws_vpc.Test_VPC.id

        route {
                nat_gateway_id = "${aws_nat_gateway.test_nat.id}"
                cidr_block = "0.0.0.0/0"
        }

        tags = {
                Name = "tf_Private_Route_2"
        }
}

##### set Public Routing Table Connection #####

resource "aws_route_table_association" "Test_Public_RT_Association_1" {
        subnet_id = aws_subnet.Test_Public_Subnet_1.id
        route_table_id = aws_route_table.Test_Public_Route_1.id
}

resource "aws_route_table_association" "Test_Public_RT_Association_2" {
        subnet_id = aws_subnet.Test_Public_Subnet_2.id
        route_table_id = aws_route_table.Test_Public_Route_2.id
}

###### set Private Routing Table Connection #####

resource "aws_route_table_association" "Test_Private_RT_Association_1" {
        subnet_id = aws_subnet.Test_Private_Subnet_1.id
        route_table_id = aws_route_table.Test_Private_Route_1.id
}

resource "aws_route_table_association" "Test_Private_RT_Association_2" {
        subnet_id = aws_subnet.Test_Private_Subnet_2.id
        route_table_id = aws_route_table.Test_Private_Route_2.id
}


########## create nat gateway ##########
resource "aws_nat_gateway" "test_nat" {
        allocation_id = "eipalloc-0db577d7eba0aa645"
        subnet_id = "${aws_subnet.Test_Public_Subnet_1.id}"
        connectivity_type = "public"
}

:wq

terraform plan
terraform apply

