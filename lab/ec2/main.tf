resource "aws_key_pair" "this" {
  key_name   = "ssh-key"
  public_key = var.ssh_public_key
}

resource "aws_network_interface" "this" {
  subnet_id       = tolist(data.aws_subnet_ids.all.ids)[0]
  security_groups = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "${var.name}-${var.env}-nic"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ingress_ip]
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
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  network_interface {
    network_interface_id = aws_network_interface.this.id
    device_index         = 0
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
