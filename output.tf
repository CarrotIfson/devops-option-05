output "private_key" {
  value     = var.ssh_key_name == "" ? null : tls_private_key.ssh[0].private_key_pem
  sensitive = true
}
output "ec2_dns" {
  value = aws_instance.ec2.public_dns
}
output "dynamodb_table" {
  value = aws_dynamodb_table.tbl.name
}
output "aws_region" {
  value = var.aws_region
}
