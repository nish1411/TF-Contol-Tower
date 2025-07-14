data "template_file" "controltower_manifest" {
  template = file("${path.module}/manifest.json")
  vars = {
    log_archive_account_id = aws_organizations_account.log_archive.id
    audit_account_id       = aws_organizations_account.audit.id
    security_ou_id         = aws_organizations_organizational_unit.security_ou.id
  }
}

resource "aws_controltower_landing_zone" "example" {
  manifest_json = data.template_file.controltower_manifest.rendered
  version       = "3.3"
}

data "aws_organizations_organization" "ct" {}

resource "aws_organizations_account" "log_archive" {
  name      = var.log_account_name
  email     = var.log_account_email
  role_name = "OrganizationAccountAccessRole"
  parent_id = data.aws_organizations_organization.ct.roots[0].id
}

resource "aws_organizations_account" "audit" {
  name      = var.audit_account_name
  email     = var.audit_account_email
  role_name = "OrganizationAccountAccessRole"
  parent_id = data.aws_organizations_organization.ct.roots[0].id
}

resource "aws_organizations_organizational_unit" "security_ou" {
  name      = var.security_ou_name
  parent_id = data.aws_organizations_organization.ct.roots[0].id
}