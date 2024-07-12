variable "account_id" {
  description = "12 digit aws account id"
}


variable "input_bucket" {
  description = "Name of the input S3 bucket"
  default     = "07052024-input"
}

variable "stage1_bucket" {
  description = "Name of the stage1 bucket"
  default = "07052024-stage-1"
}

variable "output_bucket" {
  description = "Name of the output bucket"
  default = "07052024-output"
}

variable "layer_bucket" {
  description = "Name of the layer bucket"
  default = "07052024-layer-bucket"
}

variable "presigned_url_lambda_name" {
  description = "Name of the presigned url lambda function"
  default = "getPresignedUrl"
}

variable "frame_splitting_lambda_name" {
  description = "Name of the video splitting function"
  default = "video-splitting"
}