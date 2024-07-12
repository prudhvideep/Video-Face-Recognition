output "presigned_function_url" {
  value = aws_lambda_function_url.presigned_url_function_url.function_url
  depends_on = [ aws_lambda_function_url.presigned_url_function_url ]
}

output "output_data_function_url" {
  value = aws_lambda_function_url.output_data_function_url.function_url
  depends_on = [ aws_lambda_function_url.output_data_function_url ]
}

output "delete_results_function_url" {
  value = aws_lambda_function_url.delete_objects_function_url.function_url
  depends_on = [ aws_lambda_function.delete_objects_lambda_func ]
}

output "video_splitting_lambda_fun_arn" {
  value = aws_lambda_function.video_splitting_lambda_func.arn
  description = "video splitting lambda function arn"
}

output "lambda_permission_id" {
  value = aws_lambda_permission.allow_bucket.id
  description = "lambda permission id"
}