resource "aws_s3_bucket" "my_bucket" {
  bucket = "alina-bucket-for-opsproject"
  tags = {
    Name = "alina-bucket"
  }
}

resource "aws_s3_bucket_acl" "my_bucket_acl" {
  bucket = aws_s3_bucket.my_bucket.id
  acl    = "private"
}