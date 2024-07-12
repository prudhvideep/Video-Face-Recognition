output "input_bucket_arn" {
  value = aws_s3_bucket.input_bucket.arn
  description = "input bucket arn"
}

output "input_bucket_id" {
  value = aws_s3_bucket.input_bucket.id
  description = "input bucket id"
}