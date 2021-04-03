resource "aws_network_interface" "this" {
  subnet_id = tolist(data.aws_subnet_ids.all.ids)[0]
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  network_interface {
    network_interface_id = aws_network_interface.this.id
    device_index         = 0
  }
}
