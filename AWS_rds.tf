vim rds.tf

########## create RDS Mysql DB instance ##########\

##### subnet group #####

resource "aws_db_subnet_group" "test_db_subnet_group" {
        name = "test_db_subnet_group"
        subnet_ids = [ aws_subnet.Test_Private_Subnet_1.id, aws_subnet.Test_Private_Subnet_2.id ]
        depends_on = [ aws_subnet.Test_Private_Subnet_1, aws_subnet.Test_Private_Subnet_2 ]
}

##### parameter group #####

resource "aws_db_parameter_group" "test_db_parameter_group" {
        name = "test-db-parameter-group"
        family = "aurora-mysql5.7"
}

resource "aws_rds_cluster_parameter_group" "test_rds_cluster_parameter_group" {
        name = "test-rds-cluster-parameter-group"
        family = "aurora-mysql5.7"
}

##### rds cluster setting #####

resource "aws_rds_cluster" "test_cluster" {
        cluster_identifier = "test-aurora-cluster"
        engine = "aurora-mysql"
        engine_version = "5.7.mysql_aurora.2.10.2"
        availability_zones = [ "ap-northeast-2a", ]
        database_name = "kgitbank"
        master_username = "admin"
        master_password = "terraform"
        backup_retention_period = 1
        db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.test_rds_cluster_parameter_group.name
        db_subnet_group_name = aws_db_subnet_group.test_db_subnet_group.name
        vpc_security_group_ids = [ aws_security_group.Test_Private_DB_SG_1.id, ]
        deletion_protection = false
        skip_final_snapshot = true

        depends_on = [ aws_db_subnet_group.test_db_subnet_group,
                       aws_rds_cluster_parameter_group.test_rds_cluster_parameter_group,
                       aws_db_parameter_group.test_db_parameter_group  ]
}

resource "aws_rds_cluster_instance" "test_cluster_instances" {
        count = 1
        identifier = "test-aurora-cluster-${count.index}"
        cluster_identifier = aws_rds_cluster.test_cluster.id
        instance_class = "db.t3.small"
        engine = aws_rds_cluster.test_cluster.engine
        engine_version = aws_rds_cluster.test_cluster.engine_version
        publicly_accessible = false
        db_parameter_group_name = aws_db_parameter_group.test_db_parameter_group.name
}

:wq

tf plan
tf apply
