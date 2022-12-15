resource "aws_s3_bucket" "{var.my_bucket}" {
    bucket = "var.my_bucket"
    force_destroy = true
    versioning {
       enabled = true
    }
}