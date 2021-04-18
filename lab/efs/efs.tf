locals {
  efs_name = "${var.efs_name}-${var.env}"
}

resource "aws_efs_file_system" "file_system" {
  creation_token = local.efs_name
  encrypted      = true

  tags = {
    Name = local.efs_name
  }
}

# Create a mount target in each AZ of the app subnets
resource "aws_efs_mount_target" "app_mount_target" {
  for_each = toset(var.efs_subnets)

  file_system_id  = aws_efs_file_system.file_system.id
  subnet_id       = var.subnets[each.key].id
  security_groups = [aws_security_group.efs_sg.id]
}

# Allow clients full access to the EFS by connecting to the mount targets
# Deny non encrypted access
resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.file_system.id

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "AllowClientsToMount",
    Statement = [
      {
        Sid    = "AllowClientsToMount",
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Resource = aws_efs_file_system.file_system.arn,
        Action = [
          "elasticfilesystem:ClientRootAccess",
          "elasticfilesystem:ClientWrite",
          "elasticfilesystem:ClientMount"
        ]
        Condition = {
          Bool = {
            "elasticfilesystem:AccessedViaMountTarget" : "true"
          }
        }
      },
      {
        Sid    = "EnforceEncrytionInTransit",
        Effect = "Deny",
        Principal = {
          AWS = "*"
        },
        Action = "*",
        Condition = {
          Bool = {
            "aws:SecureTransport" : "false"
          }
        }
      },
    ]
  })
}
