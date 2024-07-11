resource "aws_s3_bucket_notification" "input_bucket_notification" {
  bucket = var.input_bucket

  lambda_function {
    lambda_function_arn = var.video_splitting_lambda_fun_arn
    events = [ "s3:ObjectCreated:*" ]
    filter_prefix       = "AWSLogs/"
    filter_suffix       = ".log"
  }

  depends_on = [ var.lambda_permission_id ]
}