resource "aws_s3_object" "dashboard_template" {

  bucket = aws_s3_bucket.cur_bucket.bucket

  key = "templates/cloud-intelligence-dashboard.json"

  source = "${path.module}/cloud-intelligence-dashboard.json"

  etag = filemd5("${path.module}/cloud-intelligence-dashboard.json")

  content_type = "application/json"
}