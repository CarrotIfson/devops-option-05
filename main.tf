locals {
  stack = "${var.env}-${var.aws_region}"
}

resource "aws_kms_key" "kms" {
  description = "${var.prefix}-kms-key-${local.stack}"
}

resource "aws_kms_alias" "a" {
  name          = "alias/${var.prefix}-kms-key-${local.stack}"
  target_key_id = aws_kms_key.kms.key_id
}