#########################################
# PROVIDER
#########################################

terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#########################################
# VARIABLES
#########################################

variable "bucket_name" {
  default = "finops-cur-bucket-12345"
}

variable "database_name" {
  default = "finops_cur_db"
}

variable "crawler_name" {
  default = "finops_cur_crawler"
}

variable "dashboard_stack" {
  default = "finops-cloud-intelligence-dashboard"
}

#########################################
# S3 BUCKET FOR CUR
#########################################

resource "aws_s3_bucket" "cur_bucket" {

  bucket = var.bucket_name

  tags = {
    Name = "FinOps CUR Bucket"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {

  bucket = aws_s3_bucket.cur_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

#########################################
# CUR REPORT
#########################################

resource "aws_cur_report_definition" "cur" {

  report_name = "finops-cur"

  time_unit = "DAILY"

  format = "Parquet"

  compression = "Parquet"

  additional_schema_elements = [
    "RESOURCES"
  ]

  s3_bucket = aws_s3_bucket.cur_bucket.bucket

  s3_prefix = "cur"

  s3_region = "us-east-1"

  report_versioning = "OVERWRITE_REPORT"

  refresh_closed_reports = true

  depends_on = [
    aws_s3_bucket.cur_bucket
  ]
}

#########################################
# IAM ROLE FOR GLUE
#########################################

resource "aws_iam_role" "glue_role" {

  name = "FinOpsGlueRole"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Principal = {
          Service = "glue.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_policy" {

  role = aws_iam_role.glue_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy_attachment" "s3_policy" {

  role = aws_iam_role.glue_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

#########################################
# GLUE DATABASE
#########################################

resource "aws_glue_catalog_database" "database" {

  name = var.database_name
}

#########################################
# GLUE CRAWLER
#########################################

resource "aws_glue_crawler" "crawler" {

  name = var.crawler_name

  role = aws_iam_role.glue_role.arn

  database_name = aws_glue_catalog_database.database.name

  s3_target {

    path = "s3://${aws_s3_bucket.cur_bucket.bucket}/cur"
  }

  schema_change_policy {

    update_behavior = "UPDATE_IN_DATABASE"

    delete_behavior = "LOG"
  }

  depends_on = [

    aws_iam_role.glue_role,
    aws_s3_bucket.cur_bucket
  ]
}

#########################################
# ATHENA WORKGROUP
#########################################

resource "aws_athena_workgroup" "athena" {

  name = "finops-workgroup"

  configuration {

    result_configuration {

      output_location = "s3://${aws_s3_bucket.cur_bucket.bucket}/athena-results/"
    }
  }

  force_destroy = true
}

#########################################
# CLOUD INTELLIGENCE DASHBOARD
#########################################

resource "aws_cloudformation_stack" "dashboard" {

  name = var.dashboard_stack

  template_url = "https://raw.githubusercontent.com/aws-samples/aws-cloud-intelligence-dashboards/main/cfn/cloud-intelligence-dashboard.json"

  capabilities = [

    "CAPABILITY_IAM",
    "CAPABILITY_NAMED_IAM",
    "CAPABILITY_AUTO_EXPAND"
  ]

  depends_on = [

    aws_cur_report_definition.cur,
    aws_glue_catalog_database.database,
    aws_athena_workgroup.athena
  ]
}

#########################################
# OUTPUTS
#########################################

output "bucket" {

  value = aws_s3_bucket.cur_bucket.bucket
}

output "database" {

  value = aws_glue_catalog_database.database.name
}

output "crawler" {

  value = aws_glue_crawler.crawler.name
}

output "dashboard_stack" {

  value = aws_cloudformation_stack.dashboard.name
}
