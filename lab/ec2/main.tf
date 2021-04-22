locals {
  vpc_id = var.vpc_id != null ? var.vpc_id : data.aws_vpc.default.id
}

resource "aws_key_pair" "this" {
  key_name   = "${var.name}-${var.env}-ssh-key"
  public_key = var.ssh_public_key
}

resource "aws_network_interface" "this" {
  subnet_id       = var.subnet_id != null ? var.subnet_id : tolist(data.aws_subnet_ids.all.ids)[0]
  security_groups = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "${var.name}-${var.env}-nic"
  }
}

data "aws_vpc" "selected" {
  id = local.vpc_id
}

resource "aws_security_group" "allow_ssh" {
  name        = "${var.name}-${var.env}_allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ingress_ip]
  }

  ingress {
    description = "Ingress from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS009  Allow all egress for demo instance
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "this" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = var.instance_type
  iam_instance_profile = var.iam_instance_profile

  network_interface {
    network_interface_id = aws_network_interface.this.id
    device_index         = 0
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  key_name  = aws_key_pair.this.key_name
  user_data = var.user_data

  tags = {
    Name = "${var.name}-${var.env}"
  }

  root_block_device {
    encrypted = true
  }
}
