variable "input_bucket" {
  type = string
}

variable "output_bucket" {
  type = string
}

variable "stage1_bucket" {
  type = string
}

variable "layer_bucket" {
  type = string
}

variable "video_splitting_lambda_fun_arn" {
  type = string
  description = "video splitting lambda func arn"
}

variable "lambda_permission_id" {
  type = string
  description = "lambda permission id"
}