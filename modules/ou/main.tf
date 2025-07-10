data "aws_organizations_organization" "org" {}

data "aws_organizations_organizational_units" "top_ous" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

locals {
  ou_map = {
    for ou in data.aws_organizations_organizational_units.top_ous.children :
    ou.name => ou.id
  }

  parent_ou_name_normalized = coalesce(var.parent_ou_name, "")

  parent_ou_id = local.parent_ou_name_normalized != "" && contains(keys(local.ou_map), local.parent_ou_name_normalized)
    ? local.ou_map[local.parent_ou_name_normalized]
    : data.aws_organizations_organization.org.roots[0].id
}


resource "aws_organizations_organizational_unit" "organizational_unit" {
  name      = var.ou_name
  parent_id = local.parent_ou_id
}