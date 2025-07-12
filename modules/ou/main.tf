data "aws_organizations_organization" "main" {}

data "aws_organizations_organizational_units" "top_ous" {
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

locals {
  all_parent_ou_map = {
    for ou in data.aws_organizations_organizational_units.top_ous.children :
    ou.name => ou.id
  }
  parent_ou_id  = var.parent_ou_name != null ? lookup(local.all_parent_ou_map, var.parent_ou_name, null) : null
}

resource "aws_organizations_organizational_unit" "parent_organizational_unit" {
  count     = local.parent_ou_id == null ? 1 : 0
  name      = var.parent_ou_name
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

data "aws_organizations_organizational_unit" "top_ou" {
  count     = var.parent_ou_name != null ? 1 : 0
  name      = var.parent_ou_name
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

resource "aws_organizations_organizational_unit" "organizational_unit" {
  name      = var.ou_name
  parent_id = var.parent_ou_name != null ? data.aws_organizations_organizational_unit.top_ou[0].id : data.aws_organizations_organization.main.roots[0].id
}



