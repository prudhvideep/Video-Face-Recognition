resource "aws_ecr_repository" "lambda_repo" {
  name         = "lambda-repo"
  force_delete = true
}
