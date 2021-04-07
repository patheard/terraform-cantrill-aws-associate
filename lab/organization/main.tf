resource "aws_organizations_organization" "this" {

}

# This will fail until you validate your organizations management account's email address
# In this case, the management account will be the `general` iamadmin
resource "aws_organizations_account" "this" {
  name  = var.account_name
  email = var.account_email
}
