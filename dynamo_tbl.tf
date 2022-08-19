
resource "aws_dynamodb_table" "tbl" {
  name = "${var.prefix}-dynamodb-${local.stack}"
  attribute {
    name = "testDevopsHash"
    type = "S"
  }
  attribute {
    name = "someColumn"
    type = "N"
  }

  hash_key = "testDevopsHash"
  global_secondary_index {
    name            = "someColumnIdx"
    hash_key        = "someColumn"
    projection_type = "KEYS_ONLY"
  }
  billing_mode = "PAY_PER_REQUEST"

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.kms.arn
  }
}


resource "aws_dynamodb_table_item" "item1" {
  count = var.insert_test_items == true ? 1 : 0

  table_name = aws_dynamodb_table.tbl.name
  hash_key   = aws_dynamodb_table.tbl.hash_key

  item       = <<ITEM
{
    "testDevopsHash": {"S":"JustSomeTest"},
    "someColumn": {"N":"1234"} 
}
ITEM
  depends_on = [aws_dynamodb_table.tbl]
}

resource "aws_dynamodb_table_item" "item2" {
  count = var.insert_test_items == true ? 1 : 0

  table_name = aws_dynamodb_table.tbl.name
  hash_key   = aws_dynamodb_table.tbl.hash_key

  item       = <<ITEM
{
    "testDevopsHash": {"S":"AnotherTest"},
    "someColumn": {"N":"5678"} 
}
ITEM
  depends_on = [aws_dynamodb_table.tbl]
} 