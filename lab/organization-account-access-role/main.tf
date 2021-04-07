# You must manually invite the `prod` iamadmin user to the organization for this
# to work.  This is a bit odd - in a normal situation, the prod account would be
# managed along with the organization via Terraform.

resource "aws_iam_role" "assume_role" {
  name = "OrganizationAccountAccessRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : {
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : "arn:aws:iam::${var.account_id}:root"
      },
      "Action" : "sts:AssumeRole"
    }
  })
}

# Grant the assumed role a managed policy (defaults to AdministratorAccess for the lab)
resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.assume_role.name
  policy_arn = var.policy_arn
}
