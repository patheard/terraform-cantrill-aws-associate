# Allow EC2 instances to assume a role
resource "aws_iam_role" "ec2_assume_role" {
  name = "ec2_assume_role"

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

# Allow the ECS instance to mount and write to the EFS
resource "aws_iam_role_policy" "ecs_efs_role_policy" {
  name = "ecs_efs_role_policy"

  role = aws_iam_role.ec2_assume_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite"
        ],
        Effect   = "Allow",
        Resource = aws_efs_file_system.file_system.arn
      }
    ]
  })
}

resource "aws_iam_instance_profile" "efs_profile" {
  role = aws_iam_role.ec2_assume_role.name
}

module "instances" {
  count  = 3
  source = "../ec2"

  env                  = var.env
  name                 = "${var.instance_name}-${count.index}"
  ingress_ip           = "10.16.0.0/16"
  instance_type        = "t2.micro"
  ssh_public_key       = var.instance_ssh_public_key
  iam_instance_profile = aws_iam_instance_profile.efs_profile.name

  # Mount the EFS using encypted traffic and the IAM role in our EFS profile
  user_data = <<-USER_DATA
  #!/bin/bash
  sudo yum -y install amazon-efs-utils  
  fs_dns="${aws_efs_mount_target.app_mount_target[var.efs_subnets[count.index]].mount_target_dns_name}"
  echo "$fs_dns:/ /mnt/shared efs _netdev,tls,iam 0 0"  | sudo tee -a /etc/fstab
  sudo mkdir -p /mnt/shared
  sudo mount /mnt/shared
  USER_DATA

  vpc_id    = var.vpc_id
  subnet_id = var.subnets[var.efs_subnets[count.index]].id
}


