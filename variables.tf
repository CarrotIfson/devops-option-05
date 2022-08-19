variable "aws_region" {
  default = "eu-west-1"
}

variable "env" {
  description = "Environment/Stage of the current deployment"
  default     = "dev"
}

variable "prefix" {
  description = "It will be prepended to all terraform resources"
  default     = "test-devops"
}

variable "tf_profile" {
  default = "default"
}

variable "ec2_size" {
  default = "t2.nano"
}

variable "customer" {
  default = "wh"
}

variable "ssh_key_name" {
  description = "SSH key for EC2 access. If empty, the key pair wont be created"
  default     = "option5_SSH_Key"
}

variable "insert_test_items" {
  description = "Enable or disable inserting some sample items into the dynamodb table"
  default     = true
}

