resource "aws_athena_workgroup" "athena" {

  name = var.athena_workgroup

  configuration {

    result_configuration {

      output_location = "s3://${aws_s3_bucket.cur_bucket.bucket}/athena-results/"
    }
  }

  force_destroy = true
}