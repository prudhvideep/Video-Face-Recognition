resource "aws_lambda_function_url" "presigned_url_function_url" {
  function_name      = aws_lambda_function.presigned_url_lambda_func.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = false
    allow_origins     = ["*"]
    allow_methods     = ["POST"]
    allow_headers     = ["date", "keep-alive", "content-type"]
    expose_headers    = ["keep-alive", "date", "content-type"]
  }

  depends_on = [aws_lambda_function.presigned_url_lambda_func]
}

resource "aws_lambda_function_url" "output_data_function_url" {
  function_name      = aws_lambda_function.output_data_lambda_func.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = false
    allow_origins     = ["*"]
    allow_methods     = ["POST"]
    allow_headers     = ["date", "keep-alive", "content-type"]
    expose_headers    = ["keep-alive", "date", "content-type"]
  }

  depends_on = [aws_lambda_function.output_data_lambda_func]
}

resource "aws_lambda_function_url" "delete_objects_function_url" {
  function_name      = aws_lambda_function.delete_objects_lambda_func.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = false
    allow_origins     = ["*"]
    allow_methods     = ["POST"]
    allow_headers     = ["date", "keep-alive", "content-type"]
    expose_headers    = ["keep-alive", "date", "content-type"]
  }

  depends_on = [aws_lambda_function.delete_objects_lambda_func]

}