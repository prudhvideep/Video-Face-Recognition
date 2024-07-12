resource "aws_lambda_layer_version" "ffmpeg_layer" {
  layer_name = "ffmpeg"
  filename = "./s3/s3_files/ffmpeg.zip"
}