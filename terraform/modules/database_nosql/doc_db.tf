resource "aws_docdb_cluster_parameter_group" "parameter_group" {
  family = "docdb4.0"
  name   = "docdb-parameter-group-${var.db_name}"

  parameter {
    name  = "tls"
    value = "disabled"
  }
}

resource "aws_docdb_cluster" "db" {
  cluster_identifier     = "docdb-${var.db_name}-cluster"
  engine                 = "docdb"
  master_username        = var.db_username
  master_password        = random_password.password.result
  port                   = var.db_port
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
}

resource "aws_docdb_cluster_instance" "db_instance" {
  cluster_identifier = aws_docdb_cluster.db.cluster_identifier
  instance_class     = var.db_instance_class
}
