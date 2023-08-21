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

module "s3-bucket" {
  source                   = "terraform-aws-modules/s3-bucket/aws"
  version                  = "3.14.1"
  count                    = length(var.bucket)
  bucket                   = var.bucket[count.index]
  control_object_ownership = true
  object_ownership         = var.object_ownership
}

resource "null_resource" "copy_to_s3" {
  count = length(var.bucket)

  provisioner "local-exec" {
    command = <<-EOT
      aws s3 cp ./source/${var.html[count.index]}/ s3://${var.bucket[count.index]}/ --recursive
    EOT
  }

  depends_on = [module.s3-bucket]
}


# resource "aws_s3_bucket_object" "objects" {
#   for_each = var.html

#   bucket = each.value.bucket_name
#   key    = "${each.value.folder_name}/" # Thư mục trong S3 sẽ có cùng tên với folder_name.

#   source       = "./source/${each.value.folder_name}/*"
#   content_type = "text/plain"

#   depends_on = [module.s3-bucket]
# }

# module "cloudfront" {
#   source  = "terraform-aws-modules/cloudfront/aws"
#   version = "3.2.1"
#   count   = length(var.bucket)
# }