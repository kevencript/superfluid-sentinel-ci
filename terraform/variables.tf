variable "aws_access_key" {
  type        = string
  description = "The access key for the AWS IAM user."
}

variable "aws_secret_key" {
  type        = string
  description = "The secret key for the AWS IAM user."
}

variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket to use for storing the Terraform state."
}