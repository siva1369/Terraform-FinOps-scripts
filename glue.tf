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

resource "aws_iam_role_policy_attachment" "glue_service" {

  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy_attachment" "s3_access" {

  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_glue_catalog_database" "database" {

  name = var.database_name
}

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
    aws_cur_report_definition.cur
  ]
}