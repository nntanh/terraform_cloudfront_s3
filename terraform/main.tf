provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket = "aaa-nntanh76-tfstate-bucket/test/" # s3 context path
    key    = "test.tfstate"                      # name for tfstatet
    region = "ap-southeast-1"                    # s3 region
  }
}

# module "s3-bucket" {
#   source                   = "terraform-aws-modules/s3-bucket/aws"
#   count                    = length(var.bucket)
#   bucket                   = var.bucket[count.index]
#   control_object_ownership = true
#   object_ownership         = var.object_ownership
# }

resource "aws_s3_bucket" "s3_buckets" {
  count = length(var.bucket)
  bucket = var.bucket[count.index]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_ownership_controls" {
  count = length(var.bucket)

  bucket = aws_s3_bucket.s3_buckets[count.index].id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  count = length(var.bucket)

  bucket = aws_s3_bucket.s3_buckets[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "null_resource" "copy_to_s3" {
  count = length(var.bucket)

  provisioner "local-exec" {
    command = <<-EOT
      aws s3 cp ../source/${var.html[count.index]}/ s3://${var.bucket[count.index]}/${var.html[count.index]}/ --recursive
    EOT
  }

  depends_on = [aws_s3_bucket.s3_buckets]
}

# module "cloudfront" {
#   source  = "terraform-aws-modules/cloudfront/aws"
#   version = "3.2.1"
#   count   = length(var.bucket)

# }