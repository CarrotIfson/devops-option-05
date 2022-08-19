resource "aws_iam_policy" "secret" {
  name = "${var.prefix}-kms-policy-${local.stack}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["kms:Decrypt"]
        Effect   = "Allow"
        Resource = aws_kms_key.kms.arn
      },
    ]
  })
}
resource "aws_iam_policy" "dynamo" {
  name = "${var.prefix}-dynamo-policy-${local.stack}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:GetRecords",
          "dynamodb:GetItem",
        "dynamodb:PutItem"]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.tbl.arn
      },
    ]
  })
}

resource "aws_iam_role" "ec2_role" {
  name = "${var.prefix}-role-${local.stack}"
  managed_policy_arns = [aws_iam_policy.secret.arn,
  aws_iam_policy.dynamo.arn]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

/*
data "aws_iam_policy_document" "secret_manager" {
  statement {
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      aws_kms_key.kms.arn
    ]
  }
}

data "aws_iam_policy_document" "dynamo" {
  statement {
    actions = [
        "dynamodb:GetRecords",
        "dynamodb:GetItem",
        "dynamodb:PutItem"
    ]
    resources = [
      aws_dynamodb_table.tbl.arn
    ]
  }
}*/