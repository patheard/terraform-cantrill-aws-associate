# Create a volume, attach it and create a snapshot

data "aws_ebs_default_kms_key" "current" {}
data "aws_kms_key" "current" {
  key_id = data.aws_ebs_default_kms_key.current.key_arn
}

locals {
  kms_key_id = var.volume_kms_key_id == "aws/ebs" ? data.aws_kms_key.current.arn : var.volume_kms_key_id
}

resource "aws_volume_attachment" "volume_attachment" {
  device_name = var.volume_device_name
  volume_id   = aws_ebs_volume.volume.id
  instance_id = var.aws_instance_id
}

resource "aws_ebs_volume" "volume" {
  availability_zone = var.volume_az
  size              = var.volume_size
  type              = var.volume_type

  encrypted  = true
  kms_key_id = local.kms_key_id

  tags = {
    Name = "${var.volume_name}-${var.env}-volume"
  }
}

resource "aws_ebs_snapshot" "volume_snapshot" {
  volume_id = aws_ebs_volume.volume.id

  tags = {
    Name = "${var.volume_name}-${var.env}-snapshot"
  }
}
