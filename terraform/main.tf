provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

# Create the S3 bucket
module "s3_bucket" {
  source  = "./modules/s3-bucket"
  name    = "${var.s3_bucket_name}"
}

# Configure the Terraform backend
terraform {
  backend "s3" {
    bucket = local.bucket_name
    region = local.region
  }
}

locals {
  bucket_name = "${module.s3_bucket.bucket_name}"
  region         = "${module.s3_bucket.region}" 
}

