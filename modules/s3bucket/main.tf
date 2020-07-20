resource "aws_s3_bucket" "webapp_s3_bucket" {
  bucket = var.bucket_name
  versioning {
    enabled = var.versioning
  }  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.s3_algorithm
      }
    }
  }
}

resource "aws_dynamodb_table" "webapp_dynamodb_table" {
  name         = var.dynamo_name
  billing_mode = var.dynamo_billing_mode
  hash_key     = var.dynamo_hash_key
  attribute {
    name = var.dynamo_attribute_name
    type = var.dynamo_attribute_type
  }
}
