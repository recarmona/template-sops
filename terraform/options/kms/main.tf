resource "aws_kms_key" "this" {
  description = "${var.name} key"
  enable_key_rotation = true
  key_usage = "ENCRYPT_DECRYPT"

  tags = merge({}, var.tags)
}

resource "aws_kms_grant" "grants" {
  count = length(var.principal_grants)

  grantee_principal = var.principal_grants[count.index]
  key_id = aws_kms_key.this.key_id
  operations = ["Decrypt"]
}

resource "aws_kms_alias" "this" {
  name = "alias/${var.name}"
  target_key_id = aws_kms_key.this.key_id
}
