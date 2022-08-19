/* INSTANCE */

data "aws_ami" "awslinux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_iam_instance_profile" "ec2_prof" {
  name = "${var.prefix}-profile-${local.stack}"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "ec2" {
  instance_type = var.ec2_size
  ami           = data.aws_ami.awslinux.id

  iam_instance_profile = aws_iam_instance_profile.ec2_prof.name
  security_groups      = [aws_security_group.ssh.name]
  tags = {
    Name = "${var.prefix}-ec2-${local.stack}"
  }

  key_name = var.ssh_key_name == "" ? null : aws_key_pair.generated_key[0].key_name

  depends_on = [
    aws_security_group.ssh
  ]
}

resource "aws_security_group" "ssh" {
  name = "${var.prefix}-sg-${local.stack}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # all outbound 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "ssh" {
  count     = var.ssh_key_name == "" ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  count      = var.ssh_key_name == "" ? 0 : 1
  key_name   = "${var.ssh_key_name}-${local.stack}"
  public_key = tls_private_key.ssh[0].public_key_openssh
}
