include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//organization-cloudtrail"
}
inputs = {
  cloudtrail_name           = "cloudtrail_root_org"
  cloudwatch_log_group_name = "cloudtrail_root_org_log_group"
}
