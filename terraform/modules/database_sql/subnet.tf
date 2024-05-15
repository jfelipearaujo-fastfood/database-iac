data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-sng-${var.db_name}"
  subnet_ids = data.aws_subnets.private_subnets.ids
}
