# Allow incoming traffic to the EFS on the NFS port from the VPC
# In a production setting, there would also need to be an `egress` rule for the EC2's 
# SG that allowed outgoing traffic to the EFS, however in this case that's being covered 
# by the `lab/ec2` module's fully open egress.
resource "aws_security_group" "efs_sg" {
  name        = "${var.efs_name}-sg"
  description = "Allow ingress to the EFS"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 2049
    to_port     = 2049
    cidr_blocks = ["10.16.0.0/16"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
