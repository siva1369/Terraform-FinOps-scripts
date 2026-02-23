resource "aws_cloudformation_stack" "dashboard" {

  name = var.dashboard_stack

  template_url = "https://aws-cloud-intelligence-dashboards.s3.amazonaws.com/cfn/cudos/cudos.yaml"

  capabilities = [
    "CAPABILITY_NAMED_IAM"
  ]

  parameters = {

    # REQUIRED
    AthenaWorkgroup = aws_athena_workgroup.athena.name
    CURDatabaseName = aws_glue_catalog_database.database.name
    CURTableName    = "cost_and_usage_report"

    # REQUIRED for QuickSight
    QuickSightUser = "default/sivaiah123@gmail.com"

    # REQUIRED region
    QuickSightRegion = var.region

  }

  depends_on = [
    aws_glue_crawler.crawler
  ]
}
