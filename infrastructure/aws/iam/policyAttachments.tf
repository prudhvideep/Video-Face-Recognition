resource "aws_iam_role_policy_attachment" "presigned_url_lambda_upload_policy_attachment" {
  role       = aws_iam_role.presigned_url_lambda_role.name
  policy_arn = aws_iam_policy.aws_lambda_upload_policy.arn
}

resource "aws_iam_role_policy_attachment" "presigned_url_lambda_execution_policy_attachment" {
  role       = aws_iam_role.presigned_url_lambda_role.name
  policy_arn = aws_iam_policy.aws_lambda_execution_policy.arn
}

resource "aws_iam_role_policy_attachment" "output_data_execution_policy" {
  role       = aws_iam_role.output_data_lambda_role.name
  policy_arn = aws_iam_policy.aws_lambda_execution_policy.arn
}

resource "aws_iam_role_policy_attachment" "output_data_get_object_policy" {
  role       = aws_iam_role.output_data_lambda_role.name
  policy_arn = aws_iam_policy.aws_lambda_get_object_policy.arn
}

resource "aws_iam_role_policy_attachment" "delete_objects_execution_policy" {
  role       = aws_iam_role.delete_objects_lambda_role.name
  policy_arn = aws_iam_policy.aws_lambda_execution_policy.arn
}

resource "aws_iam_role_policy_attachment" "delete_objects_delete_policy" {
  role       = aws_iam_role.delete_objects_lambda_role.name
  policy_arn = aws_iam_policy.aws_lambda_delete_object_policy.arn
}

resource "aws_iam_role_policy_attachment" "video_splitting_s3_full_access_policy" {
  role       = aws_iam_role.video_splitting_lambda_role.name
  policy_arn = aws_iam_policy.aws_s3_full_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "video_splitting_lambda_full_access_policy" {
  role       = aws_iam_role.video_splitting_lambda_role.name
  policy_arn = aws_iam_policy.aws_lambda_full_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "video_splitting_lambda_execution_policy" {
  role       = aws_iam_role.video_splitting_lambda_role.name
  policy_arn = aws_iam_policy.aws_lambda_execution_policy.arn
}

resource "aws_iam_role_policy_attachment" "face_recognition_lambda_execution_policy" {
  role       = aws_iam_role.face_recognition_lambda_role.name
  policy_arn = aws_iam_policy.aws_lambda_execution_policy.arn
}

resource "aws_iam_role_policy_attachment" "face_recognition_lambda_full_access_policy" {
  role       = aws_iam_role.face_recognition_lambda_role.name
  policy_arn = aws_iam_policy.aws_lambda_full_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "face_recognition_s3_full_access_policy" {
  role       = aws_iam_role.face_recognition_lambda_role.name
  policy_arn = aws_iam_policy.aws_s3_full_access_policy.arn
}
