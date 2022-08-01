provider "aws" {
  region = local.region
}

locals {
  region = "eu-west-2"
}



################################################################################
# Supporting Resources
################################################################################

# Firstly create a random generated password to use in secrets.
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "^[a-zA-Z0-9]*$"
}


module "secret-manager-with-rotation" {
  source              = "../component/secret-manager-with-rotation/terraform-aws-secret-manager-with-rotation/"
  name                = "PassRotation"
  rotation_days       = 7
  postgresql_username = var.database_users
  postgresql_dbname   = var.auth_database_name
  postgresql_password = random_password.password.result
}



################################################################################
# RDS Aurora Module
################################################################################

module "aurora" {
  source = "../component/services/aurora/"

  name           = var.auth_database_name
  engine         = "aurora-postgresql"
  engine_version = "14.3"
  instances = {
    1 = {
      identifier          = "static-member-1"
      instance_class      = "db.r5.large"
      publicly_accessible = false
    }
    2 = {
      identifier     = "excluded-member-1"
      instance_class = "db.r5.large"
      promotion_tier = 15
    }
  }

  endpoints = {
    static = {
      identifier     = "static-custom-endpt"
      type           = "ANY"
      static_members = ["static-member-1"]
      tags           = { Endpoint = "static-members" }
    }
    excluded = {
      identifier       = "excluded-custom-endpt"
      type             = "READER"
      excluded_members = ["excluded-member-1"]
      tags             = { Endpoint = "excluded-members" }
    }
  }

  vpc_id                 = var.vpc_id
  db_subnet_group_name   = var.db_subnet_group_name
  create_db_subnet_group = false
  create_security_group  = true
  allowed_cidr_blocks    = var.private_subnets_cidr_blocks
  security_group_egress_rules = {
    to_cidrs = {
      cidr_blocks = ["10.33.0.0/28"]
      description = "Egress to corporate printer closet"
    }
  }

  iam_database_authentication_enabled = true
  master_password                     = local.db_creds.password
  create_random_password              = false
  apply_immediately   = true
  skip_final_snapshot = true

  db_parameter_group_name         = aws_db_parameter_group.auroradb.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.auroradb.id
  enabled_cloudwatch_logs_exports = ["postgresql"]
  tags = local.tags
}

resource "aws_db_parameter_group" "auroradb" {
  name        = "${var.auth_database_name}-aurora-db-postgres14-parameter-group"
  family      = "aurora-postgresql14"
  description = "${var.auth_database_name}-aurora-db-postgres14-parameter-group"
  tags        = var.tags
}

resource "aws_rds_cluster_parameter_group" "auroradb" {
  name        = "${var.auth_database_name}-aurora-postgres14-cluster-parameter-group"
  family      = "aurora-postgresql14"
  description = "${var.auth_database_name}-aurora-postgres14-cluster-parameter-group"
  tags        = var.tags
}


module "db_iam_user" {
  source = "../component/security/aws/iam-db-user/"
  name  = "db_iam_users"
  users = var.database_users
  tags = merge(var.tags)
}




