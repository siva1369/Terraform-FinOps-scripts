resource "aws_s3_bucket" "cur_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "FinOps CUR Bucket"
    Environment = "FinOps"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.cur_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "cur_policy" {

  bucket = aws_s3_bucket.cur_bucket.id

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Sid    = "AllowCURService"
        Effect = "Allow"

        Principal = {
          Service = "billingreports.amazonaws.com"
        }

        Action = [
          "s3:GetBucketAcl",
          "s3:GetBucketPolicy"
        ]

        Resource = aws_s3_bucket.cur_bucket.arn
      },

      {
        Sid    = "AllowCURPutObject"
        Effect = "Allow"

        Principal = {
          Service = "billingreports.amazonaws.com"
        }

        Action = "s3:PutObject"

        Resource = "${aws_s3_bucket.cur_bucket.arn}/*"
      }
    ]
  })
}