resource "aws_ssm_parameter" "dbstring" {
  name  = "/my-app/dbstring"
  type  = "String"
  value = var.dbstring
}

resource "aws_ssm_parameter" "dbpassword" {
  name  = "/my-app/dbpassword"
  type  = "SecureString"
  value = var.dbpassword
}
