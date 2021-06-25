module "registry_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = "${var.name}-gitlab-registry"
  acl           = "private"
  force_destroy = var.bucket_force_destroy

  versioning = {
    enabled = false
  }

  tags = merge({}, var.tags)
}

module "lfs_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = "${var.name}-gitlab-lfs"
  acl           = "private"
  force_destroy = var.bucket_force_destroy

  versioning = {
    enabled = false
  }

  tags = merge({}, var.tags)
}

module "artifacts_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = "${var.name}-gitlab-artifacts"
  acl           = "private"
  force_destroy = var.bucket_force_destroy

  versioning = {
    enabled = false
  }

  tags = merge({}, var.tags)
}

module "uploads_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = "${var.name}-gitlab-uploads"
  acl           = "private"
  force_destroy = var.bucket_force_destroy

  versioning = {
    enabled = false
  }

  tags = merge({}, var.tags)
}

module "tfstate_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = "${var.name}-gitlab-tfstate"
  acl           = "private"
  force_destroy = var.bucket_force_destroy

  versioning = {
    enabled = false
  }

  tags = merge({}, var.tags)
}

module "packages_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = "${var.name}-gitlab-packages"
  acl           = "private"
  force_destroy = var.bucket_force_destroy

  versioning = {
    enabled = false
  }

  tags = merge({}, var.tags)
}

module "pseudonymizer_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = "${var.name}-gitlab-pseudonymizer"
  acl           = "private"
  force_destroy = var.bucket_force_destroy

  versioning = {
    enabled = false
  }

  tags = merge({}, var.tags)
}

module "backups_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = "${var.name}-gitlab-backups"
  acl           = "private"
  force_destroy = var.bucket_force_destroy

  versioning = {
    enabled = false
  }

  tags = merge({}, var.tags)
}

module "backups-tmp_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = "${var.name}-gitlab-backups-tmp"
  acl           = "private"
  force_destroy = var.bucket_force_destroy

  versioning = {
    enabled = false
  }

  tags = merge({}, var.tags)
}

module "dependency_proxy_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = "${var.name}-gitlab-dependency-proxy"
  acl           = "private"
  force_destroy = var.bucket_force_destroy

  versioning = {
    enabled = false
  }

  tags = merge({}, var.tags)
}

module "mr_diffs_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = "${var.name}-gitlab-mr-diffs"
  acl           = "private"
  force_destroy = var.bucket_force_destroy

  versioning = {
    enabled = false
  }

  tags = merge({}, var.tags)
}

module "runner_cache_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  bucket        = "${var.name}-gitlab-runner-cache"
  acl           = "private"
  force_destroy = var.bucket_force_destroy

  versioning = {
    enabled = false
  }

  tags = merge({}, var.tags)
}

resource "aws_iam_user" "this" {
  name = "${var.name}-gitlab-objectstore"
  path = "/"

  tags = merge({}, var.tags)
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

resource "aws_iam_user_policy" "all_access" {
  name = "${var.name}-gitlab-objecstore-all"
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
        "${module.registry_bucket.this_s3_bucket_arn}",
        "${module.registry_bucket.this_s3_bucket_arn}/*",
        "${module.lfs_bucket.this_s3_bucket_arn}",
        "${module.lfs_bucket.this_s3_bucket_arn}/*",
        "${module.artifacts_bucket.this_s3_bucket_arn}",
        "${module.artifacts_bucket.this_s3_bucket_arn}/*",
        "${module.uploads_bucket.this_s3_bucket_arn}",
        "${module.uploads_bucket.this_s3_bucket_arn}/*",
        "${module.tfstate_bucket.this_s3_bucket_arn}",
        "${module.tfstate_bucket.this_s3_bucket_arn}/*",
        "${module.packages_bucket.this_s3_bucket_arn}",
        "${module.packages_bucket.this_s3_bucket_arn}/*",
        "${module.pseudonymizer_bucket.this_s3_bucket_arn}",
        "${module.pseudonymizer_bucket.this_s3_bucket_arn}/*",
        "${module.backups_bucket.this_s3_bucket_arn}",
        "${module.backups_bucket.this_s3_bucket_arn}/*",
        "${module.backups-tmp_bucket.this_s3_bucket_arn}",
        "${module.backups-tmp_bucket.this_s3_bucket_arn}/*",
        "${module.runner_cache_bucket.this_s3_bucket_arn}",
        "${module.runner_cache_bucket.this_s3_bucket_arn}/*",
        "${module.mr_diffs_bucket.this_s3_bucket_arn}",
        "${module.mr_diffs_bucket.this_s3_bucket_arn}/*",
        "${module.dependency_proxy_bucket.this_s3_bucket_arn}",
        "${module.dependency_proxy_bucket.this_s3_bucket_arn}/*"
      ]
    }
  ]
}
EOF
}
