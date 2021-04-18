output "efs_mounts" {
  value = {
    for mount_target, details in aws_efs_mount_target.app_mount_target :
    mount_target => ({
      "id"                     = details.id
      "dns_name"               = details.dns_name
      "mount_target_dns_name"  = details.mount_target_dns_name
      "file_system_arn"        = details.file_system_arn,
      "network_interface_id"   = details.network_interface_id
      "availability_zone_name" = details.availability_zone_name
    })
  }
}

output "instances" {
  value = {
    for instance, details in module.instances :
    instance => ({
      "private_ip"  = details.private_ip
      "ssh_command" = "ssh ec2-user@${details.private_ip}"
    })
  }
}
