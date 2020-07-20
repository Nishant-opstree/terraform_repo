variable "bucket_name" {
 default = "nishant-terraform-bucket" 
}
variable "versioning" {
 default = true
}
variable "s3_algorithm" {
 default = "AES256"
}
variable "dynamo_name" {
 default = "nishant-terraform"
}
variable "dynamo_billing_mode" {
 default = "PAY_PER_REQUEST"
}
variable "dynamo_hash_key" {
 default = "LockID"
}
variable "dynamo_attribute_name" {
 default = "LockID"
}
variable "dynamo_attribute_type" {
 default = "S"
}