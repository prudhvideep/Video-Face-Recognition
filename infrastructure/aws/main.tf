terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

module "ecr" {
  source = "./ecr"
}

module "iam" {
  source        = "./iam"
  account_id    = var.account_id
  input_bucket  = var.input_bucket
  output_bucket = var.output_bucket
}

module "s3" {
  source = "./s3"
  input_bucket = var.input_bucket
  output_bucket = var.output_bucket
  stage1_bucket = var.stage1_bucket
  layer_bucket = var.layer_bucket
  video_splitting_lambda_fun_arn = module.lambda.video_splitting_lambda_fun_arn
  lambda_permission_id = module.lambda.lambda_permission_id
}

module "lambda" {
  source = "./lambda"
  presigned_url_lambda_role_arn = module.iam.presigned_url_lambda_role_arn
  output_data_lambda_role_arn = module.iam.output_data_lambda_role_arn
  delete_objects_lambda_role_arn = module.iam.delete_objects_lambda_role_arn
  video_splitting_lambda_role_arn = module.iam.video_splitting_lambda_role_arn
  face_recognition_lambda_role_arn = module.iam.face_recognition_lambda_role_arn
  repository_url = module.ecr.repository_url
  account_id = var.account_id
  input_bucket_arn = module.s3.input_bucket_arn
  input_bucket_id = module.s3.input_bucket_id
} 

