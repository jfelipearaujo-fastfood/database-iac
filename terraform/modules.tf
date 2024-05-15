module "products_db" {
  source = "./modules/database_nosql"

  region = var.region

  db_name           = "products"
  db_engine         = "mongodb"
  db_instance_class = "db.t3.medium"
  db_port           = 27017
  db_username       = "fastfood"

  vpc_name = var.vpc_name
}

module "orders_db" {
  source = "./modules/database_sql"

  region = var.region

  db_name           = "orders"
  db_engine         = "postgres"
  db_engine_version = "16"
  db_instance_class = "db.t3.micro"
  db_port           = 5432
  db_username       = "fastfood"

  vpc_name = var.vpc_name
}

module "payments_db" {
  source = "./modules/database_sql"

  region = var.region

  db_name           = "payments"
  db_engine         = "postgres"
  db_engine_version = "16"
  db_instance_class = "db.t3.micro"
  db_port           = 5432
  db_username       = "fastfood"

  vpc_name = var.vpc_name
}

module "productions_db" {
  source = "./modules/database_sql"

  region = var.region

  db_name           = "productions"
  db_engine         = "postgres"
  db_engine_version = "16"
  db_instance_class = "db.t3.micro"
  db_port           = 5432
  db_username       = "fastfood"

  vpc_name = var.vpc_name
}
