module "bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = "${var.name}-mattermost"
  acl           = "private"
  force_destroy = var.bucket_force_destroy

  versioning = {
    enabled = false
  }

  tags = merge({}, var.tags)
}

resource "aws_iam_user" "this" {
  name = "${var.name}-mattermost-objectstore"
  path = "/"

  tags = merge({}, var.tags)
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

resource "aws_iam_user_policy" "all_access" {
  name = "${var.name}-mattermost-objecstore-all"
  user = aws_iam_user.this.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${module.bucket.this_s3_bucket_arn}",
        "${module.bucket.this_s3_bucket_arn}/*"
      ]
    }
  ]
}
EOF
}
