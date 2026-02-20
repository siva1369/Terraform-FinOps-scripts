output "cur_bucket" {

  value = aws_s3_bucket.cur_bucket.bucket
}

output "glue_database" {

  value = aws_glue_catalog_database.database.name
}

output "crawler_name" {

  value = aws_glue_crawler.crawler.name
}

output "athena_workgroup" {

  value = aws_athena_workgroup.athena.name
}

output "dashboard_stack" {

  value = aws_cloudformation_stack.dashboard.name
}