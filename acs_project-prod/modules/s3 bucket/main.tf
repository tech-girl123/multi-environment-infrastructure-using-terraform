
# #Create S3 Bucket for prod
# resource "aws_s3_bucket" "group13-env-s3-1" {
#   bucket = "${var.prod-env}-acs730-project-group13"
#   tags = {
#     Name        = "group13 bucket"
#     Environment = "var.prod-env"
#   }
# }

# # Create ACL for S3
# resource "aws_s3_bucket_acl" "group13-env-s3-acl-1" {
#   bucket = "${var.prod-env}-acs730-project-group13"
#   acl    = "private"
# }

# # Limit access to S3
# resource "aws_s3_bucket_public_access_block" "group13-env-s3-acl-1" {
# bucket = "${var.prod-env}-acs730-project-group13"

#   block_public_acls       = true
#   block_public_policy     = true
#   restrict_public_buckets = true
#   ignore_public_acls      = true
# }


# # Create S3 Bucket for dev
# resource "aws_s3_bucket" "group13-env-s3-2" {
# bucket = "${var.dev-env}-acs730-project-group13"
#   tags = {
#     Name        = "My bucket"
#     Environment = "var.dev-env"
#   }
# }

# # Create ACL for S3
# resource "aws_s3_bucket_acl" "group13-env-s3-acl-2" {
#   bucket = "${var.dev-env}-acs730-project-group13"
#   acl    = "private"
# }

# # Limit access to S3
# resource "aws_s3_bucket_public_access_block" "group13-env-s3-acl-2" {
#   bucket = "${var.dev-env}-acs730-project-group13"

#   block_public_acls       = true
#   block_public_policy     = true
#   restrict_public_buckets = true
#   ignore_public_acls      = true
# }




# # Create S3 Bucket for staging

# resource "aws_s3_bucket" "group13-env-s3-3" {
#   bucket = "${var.staging-env}-acs730-project-group13"
#   tags = {
#     Name        = "My bucket"
#     Environment = "var.staging-env"
#   }
# }

# # Create ACL for S3
# resource "aws_s3_bucket_acl" "group13-env-s3-acl-3" {
# bucket = "${var.staging-env}-acs730-project-group13"
#   acl    = "private"
# }

# # Limit access to S3
# resource "aws_s3_bucket_public_access_block" "group13-env-s3-acl-3" {
#   bucket = "${var.staging-env}-acs730-project-group13"

#   block_public_acls       = true
#   block_public_policy     = true
#   restrict_public_buckets = true
#   ignore_public_acls      = true
# }