resource "aws_s3_bucket" "my_bucket" {
  bucket = "alina-bucket"
  acl    = "private"

  tags = {
    Name = "alina-bucket"
  }
}