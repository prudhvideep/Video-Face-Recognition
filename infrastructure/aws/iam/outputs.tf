output "presigned_url_lambda_role_arn" {
  value = aws_iam_role.presigned_url_lambda_role.arn
  description = "presigned url lambda function arn"
}

output "output_data_lambda_role_arn" {
  value = aws_iam_role.output_data_lambda_role.arn
  description = "output data lambda role arn" 
}

output "delete_objects_lambda_role_arn" {
  value = aws_iam_role.delete_objects_lambda_role.arn
  description = "delete objects lambda role arn"
}

output "video_splitting_lambda_role_arn" {
  value = aws_iam_role.video_splitting_lambda_role.arn
  description = "video splitting lamda role arn"
}

output "face_recognition_lambda_role_arn" {
  value = aws_iam_role.face_recognition_lambda_role.arn
  description = "face recognition lambda role arn"
}