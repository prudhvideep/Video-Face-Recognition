#input bucket
resource "aws_s3_bucket" "input_bucket" {
  bucket = var.input_bucket
}

resource "aws_s3_bucket_public_access_block" "input_bucket_public_access" {
  bucket = var.input_bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  depends_on = [aws_s3_bucket.input_bucket]
}

resource "aws_s3_bucket_policy" "input_bucket_allow_get_put_actions" {
  bucket = var.input_bucket
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = "arn:aws:s3:::${var.input_bucket}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.input_bucket_public_access]
}

resource "aws_s3_bucket_cors_configuration" "input_bucket_cors_configuration" {
  bucket = var.input_bucket
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT"]
    allowed_origins = ["*"]
  }
  depends_on = [aws_s3_bucket_policy.input_bucket_allow_get_put_actions]
}

#stage-1 bucket
resource "aws_s3_bucket" "stage1_bucket" {
  bucket = var.stage1_bucket
}

#output bucket
resource "aws_s3_bucket" "output_bucket" {
  bucket = var.output_bucket
}

resource "aws_s3_bucket_public_access_block" "output_bucket_public_access" {
  bucket = var.output_bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  depends_on = [aws_s3_bucket.output_bucket]
}

resource "aws_s3_bucket_policy" "output_bucket_allow_get_delete_policy" {
  bucket = var.output_bucket
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${var.output_bucket}/*"
      },
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:DeleteObject",
        "Resource" : "arn:aws:s3:::${var.output_bucket}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.output_bucket_public_access]
}

resource "aws_s3_bucket_cors_configuration" "output_bucket_cors_policy" {
  bucket = var.output_bucket
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }

  depends_on = [aws_s3_bucket_policy.output_bucket_allow_get_delete_policy]
}

#Layer bucket
resource "aws_s3_bucket" "layer_bucket" {
  bucket = var.layer_bucket
}

resource "aws_s3_object" "layer_bucket_data_pt" {
  bucket = var.layer_bucket
  key    = "data.pt"
  source = "./s3/s3_files/data.pt"

  depends_on = [aws_s3_bucket.layer_bucket]
}

resource "aws_s3_object" "layer_bucket_ffmpeg" {
  bucket = var.layer_bucket
  key    = "ffmpeg.zip"
  source = "./s3/s3_files/ffmpeg.zip"

  depends_on = [aws_s3_bucket.layer_bucket]
}