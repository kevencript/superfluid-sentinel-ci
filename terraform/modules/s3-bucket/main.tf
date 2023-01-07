resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.name}"
  acl    = "private"
}