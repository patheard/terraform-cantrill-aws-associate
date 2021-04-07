output "dev_account_name" {
  value = aws_organizations_account.dev.name
}

output "dev_account_email" {
  value = aws_organizations_account.dev.email
}

output "dev_organizational_unit_id" {
  value = aws_organizations_organizational_unit.dev.id
}

output "prod_account_name" {
  value = aws_organizations_account.prod.name
}

output "prod_account_email" {
  value = aws_organizations_account.prod.email
}

output "prod_organizational_unit_id" {
  value = aws_organizations_organizational_unit.prod.id
}
