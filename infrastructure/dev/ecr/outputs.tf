output "repository_url" {
  value = aws_ecr_repository.lambda_repo.repository_url
  description = "repository url"
}