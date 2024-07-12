resource "aws_lambda_permission" "allow_bucket" {
  statement_id = "AllowExecutionFromS3Bucket"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.video_splitting_lambda_func.arn
  principal = "s3.amazonaws.com"
  source_arn = var.input_bucket_arn
  source_account = var.account_id

  depends_on = [ var.input_bucket_id ]
}

