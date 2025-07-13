#data "aws_organizations_organization" "main" {}
#
#resource "aws_organizations_account" "log_archive" {
#  name      = "logging"
#  email     = "tuse82013@gmail.com"
#  role_name = "OrganizationAccountAccessRole"
#  parent_id = data.aws_organizations_organization.main.roots[0].id
#}
#
#resource "aws_organizations_account" "audit" {
#  name      = "auditing"
#  email     = "utest1341@gmail.com"
#  role_name = "OrganizationAccountAccessRole"
#  parent_id = data.aws_organizations_organization.main.roots[0].id
#}
#
#
#output "log_archive_account_id" {
#  value = aws_organizations_account.log_archive.id
#}
#
#output "audit_account_id" {
#  value = aws_organizations_account.audit.id
#}
#

module "parent_ou" {
  source                 = "../modules/ou"
  organizational_units   = var.organizational_units
}


module "accounts" {
  for_each          = { for acc in var.accounts : "${acc.account_name}" => acc }
  source            = "../modules/account"
  account_name      = each.value.account_name
  account_email     = each.value.account_email
  ou_name           = each.value.ou_name
}

