data "aws_organizations_organization" "org" {}

data "aws_organizations_organizational_units" "top_ous" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

locals {
  matching_ou_ids = [
    for ou in data.aws_organizations_organizational_units.top_ous.children : ou.id
    if ou.name == var.parent_ou_name
  ]
}

resource "aws_organizations_organizational_unit" "organizational_unit" {
  name      = var.ou_name
  parent_id = var.parent_ou_name != "" && length(local.matching_ou_ids) > 0 ?
    one(local.matching_ou_ids) :
    data.aws_organizations_organization.org.roots[0].id
}

