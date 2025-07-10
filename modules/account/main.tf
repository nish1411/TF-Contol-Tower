data "aws_organizations_organization" "org" {}

data "aws_organizations_organizational_units" "top_ous" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

data "aws_organizations_organizational_units" "all_child_ous" {
  for_each  = { for ou in data.aws_organizations_organizational_units.top_ous.children : ou.name => ou.id }
  parent_id = each.value
}

locals {
  all_child_ou_map = merge([
    for ou_group in data.aws_organizations_organizational_units.all_child_ous :
    {
      for ou in ou_group.children :
      ou.name => ou.id
    }
  ])

  selected_ou_id = lookup(local.all_child_ou_map, var.ou_name, null)
}

resource "aws_organizations_account" "new_account" {
  name      = var.account_name
  email     = var.account_email
  role_name = "OrganizationAccountAccessRole"
  parent_id = local.selected_ou_id
}