#variables required for lambda

variable "presigned_url_lambda_role_arn" {
  type = string
  description = "presigned url lambda role arn"
}

variable "output_data_lambda_role_arn" {
  type = string
  description = "output data lambda role"
}

variable "delete_objects_lambda_role_arn" {
  type = string
  description = "delete objects data role"
}

variable "video_splitting_lambda_role_arn" {
  type = string
  description = "video splitting lambda role"
}

variable "face_recognition_lambda_role_arn" {
  type = string
  description = "face recognition lambda role"
}

variable "repository_url" {
  type = string
  description = "ecr repository url"
}

variable "account_id" {
  type = string
  description = "aws user id"
}

variable "input_bucket_arn" {
  type = string
  description = "arn for the input s3 bucket"
}

variable "input_bucket_id" {
  type = string
  description = "input bucket id"
}


