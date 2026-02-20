resource "aws_cur_report_definition" "cur" {

  report_name = "finops-cur-report"

  time_unit = "DAILY"

  format = "Parquet"

  compression = "Parquet"

  additional_schema_elements = [
    "RESOURCES"
  ]

  additional_artifacts = [
    "ATHENA"
  ]

  s3_bucket = aws_s3_bucket.cur_bucket.bucket

  s3_prefix = "cur"

  s3_region = var.region

  report_versioning = "OVERWRITE_REPORT"

  refresh_closed_reports = true

  depends_on = [
    aws_s3_bucket_policy.cur_policy
  ]
}