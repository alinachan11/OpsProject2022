resource "aws_s3_bucket" "my_bucket" {
  bucket = "alina-bucket-for-opsproject"
  acl    = "private"

  tags = {
    Name = "alina-bucket"
  }
}