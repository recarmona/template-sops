module "bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = "${var.name}-velero"
  acl           = "private"
  force_destroy = var.bucket_force_destroy

  versioning = {
    enabled = false
  }

  tags = merge({}, var.tags)
}

resource "aws_iam_user" "this" {
  name = "${var.name}-velero-objectstore"
  path = "/"

  tags = merge({}, var.tags)
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

#Policy from https://github.com/vmware-tanzu/velero-plugin-for-aws/blob/modules/README.md
resource "aws_iam_user_policy" "all_access" {
  name = "${var.name}-velero-objecstore-all"
  user = aws_iam_user.this.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "${module.bucket.this_s3_bucket_arn}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "${module.bucket.this_s3_bucket_arn}"
            ]
        }
    ]
}
EOF
}
