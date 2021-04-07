# Reference for moving objects between remote states:
# https://www.maxivanov.io/how-to-move-resources-and-modules-in-terragrunt/

resource "aws_organizations_organization" "root" {
  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
}

resource "aws_organizations_organizational_unit" "prod" {
  name      = "PROD"
  parent_id = aws_organizations_organization.root.roots[0].id
}

resource "aws_organizations_organizational_unit" "dev" {
  name      = "DEV"
  parent_id = aws_organizations_organization.root.roots[0].id
}

# This will fail until you validate your organizations management account's email address
# In this case, the management account will be the `general` iamadmin
resource "aws_organizations_account" "dev" {
  name      = var.dev_account_name
  email     = var.dev_account_email
  parent_id = aws_organizations_organizational_unit.dev.id
}

resource "aws_organizations_account" "prod" {
  name      = var.prod_account_name
  email     = var.prod_account_email
  parent_id = aws_organizations_organizational_unit.prod.id
}
