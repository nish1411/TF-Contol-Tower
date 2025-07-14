data "template_file" "controltower_manifest" {
  template = file("${path.module}/manifest.json")
  vars = {
    log_archive_account_id = aws_organizations_account.log_archive.id
    audit_account_id       = aws_organizations_account.audit.id
    security_ou_name       = "Security-OU"
  }
}

resource "aws_controltower_landing_zone" "example" {
  manifest_json = data.template_file.controltower_manifest.rendered
  version       = "3.3"
}

data "aws_organizations_organization" "main" {}

resource "aws_organizations_account" "log_archive" {
  name      = "logs"
  email     = "nishsjsk07@gmail.com"
  role_name = "OrganizationAccountAccessRole"
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

resource "aws_organizations_account" "audit" {
  name      = "auds"
  email     = "sjsknish@gmail.com"
  role_name = "OrganizationAccountAccessRole"
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

output "log_archive_account_id" {
  value = aws_organizations_account.log_archive.id
}

output "audit_account_id" {
  value = aws_organizations_account.audit.id
}

output "security_ou" {
  value = aws_organizations_organizational_unit.security_ou.id
}

resource "aws_iam_role" "ctl_admin" {
  name = "AWSControlTowerAdmin"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "controltower.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ctl_admin_policy_attach" {
  role       = aws_iam_role.ctl_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
