#Presigned Url Lambda Function

resource "aws_lambda_function" "presigned_url_lambda_func" {
  filename         = data.archive_file.presigned_url_archive.output_path
  function_name    = "getPresignedUrl"
  role             = var.presigned_url_lambda_role_arn
  handler          = "handler.lambda_handler"
  source_code_hash = data.archive_file.presigned_url_archive.output_base64sha256
  runtime          = "python3.10"
  memory_size      = 512
  timeout          = 60

  ephemeral_storage {
    size = 512
  }
}

#Output Data Lambda Function

resource "aws_lambda_function" "output_data_lambda_func" {
  filename         = data.archive_file.output_data_archive.output_path
  function_name    = "getOutputData"
  role             = var.output_data_lambda_role_arn
  handler          = "handler.lambda_handler"
  source_code_hash = data.archive_file.output_data_archive.output_base64sha256
  runtime          = "python3.10"
  memory_size      = 1024
  timeout          = 60

  ephemeral_storage {
    size = 512
  }
}

#Delete Objects Lambda Function

resource "aws_lambda_function" "delete_objects_lambda_func" {
  filename         = data.archive_file.delete_results_archive.output_path
  function_name    = "deleteResultItems"
  role             = var.delete_objects_lambda_role_arn
  handler          = "handler.lambda_handler"
  source_code_hash = data.archive_file.output_data_archive.output_base64sha256
  runtime          = "python3.10"
  memory_size      = 1024
  timeout          = 75

  ephemeral_storage {
    size = 512
  }
}

#Video splitting lambda Function

resource "aws_lambda_function" "video_splitting_lambda_func" {
  filename         = data.archive_file.video_splitting_archive.output_path
  function_name    = "video-splitting"
  role             = var.video_splitting_lambda_role_arn
  handler          = "handler.lambda_handler"
  source_code_hash = data.archive_file.video_splitting_archive.output_base64sha256
  runtime          = "python3.8"
  memory_size      = 2048
  timeout          = 75
  
  layers = [ aws_lambda_layer_version.ffmpeg_layer.arn ]
  ephemeral_storage {
    size = 512
  }
}

#Face splitting lambda
resource "aws_lambda_function" "face_recognition_lambda_func" {
  function_name = "face-recognition"
  role = var.face_recognition_lambda_role_arn
  package_type  = "Image"
  image_uri = "${var.repository_url}:latest"

  depends_on = [ null_resource.docker_build ]
}