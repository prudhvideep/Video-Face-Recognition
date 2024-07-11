data "archive_file" "presigned_url_archive" {
  type        = "zip"
  source_dir  = "./lambda/lambda_files/getPresignedUrl"
  output_path = "./lambda/lambda_files/getPresignedUrl/getPresignedUrl.zip"
}

data "archive_file" "output_data_archive" {
  type        = "zip"
  source_dir  = "./lambda/lambda_files/getOutputData"
  output_path = "./lambda/lambda_files/getOutputData/getOutputData.zip"
}

data "archive_file" "delete_results_archive" {
  type        = "zip"
  source_dir  = "./lambda/lambda_files/deleteResultItems"
  output_path = "./lambda/lambda_files/deleteResultItems/deleteResultItems.zip"
}

data "archive_file" "video_splitting_archive" {
  type        = "zip"
  source_dir  = "./lambda/lambda_files/video-splitting"
  output_path = "./lambda/lambda_files/video-splitting/video-splitting.zip"
}
