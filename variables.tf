variable "region" {
  default = "ap-south-1"
}

variable "bucket_name" {
  description = "CUR S3 bucket name"
  default     = "finops-cur-bucket-demo-unique-12345"
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

variable "athena_workgroup" {
  default = "finops-workgroup"
}