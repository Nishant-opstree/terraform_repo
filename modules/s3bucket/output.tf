output "webapp_s3_bucket" {
  value = aws_s3_bucket.webapp_s3_bucket
}
output "webapp_dynamodb_table" {
  value = aws_dynamodb_table.webapp_dynamodb_table
}