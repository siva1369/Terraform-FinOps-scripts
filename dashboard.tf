# resource "aws_cloudformation_stack" "dashboard" {

#   name = var.dashboard_stack

#   template_url = "https://raw.githubusercontent.com/aws-samples/aws-cloud-intelligence-dashboards/main/cfn/cloud-intelligence-dashboard.json"

#   capabilities = [

#     "CAPABILITY_IAM",
#     "CAPABILITY_NAMED_IAM",
#     "CAPABILITY_AUTO_EXPAND"
#   ]

#   parameters = {

#     CURDatabaseName = aws_glue_catalog_database.database.name

#     CURTableName = "cost_and_usage_report"

#     AthenaWorkgroup = aws_athena_workgroup.athena.name
#   }

#   depends_on = [
#     aws_glue_crawler.crawler
#   ]
# }


resource "aws_cloudformation_stack" "dashboard" {

  name = var.dashboard_stack

  template_url = "https://${aws_s3_bucket.cur_bucket.bucket}.s3.${var.region}.amazonaws.com/templates/cloud-intelligence-dashboard.json"

  capabilities = [

    "CAPABILITY_IAM",
    "CAPABILITY_NAMED_IAM",
    "CAPABILITY_AUTO_EXPAND"
  ]

  parameters = {

    CURDatabaseName = aws_glue_catalog_database.database.name

    CURTableName = "cost_and_usage_report"

    AthenaWorkgroup = aws_athena_workgroup.athena.name
  }

  depends_on = [

    aws_s3_object.dashboard_template,
    aws_glue_crawler.crawler
  ]

  
}