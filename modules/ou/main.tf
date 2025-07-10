data "aws_organizations_organization" "org" {}

data "aws_organizations_organizational_units" "top_ous" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

locals {
  parent_ou_id = var.parent_ou_name != "" ? (
    one([
      for ou in data.aws_organizations_organizational_units.top_ous.children :
      ou.id if ou.name == var.parent_ou_name
    ])
  ) : data.aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "organizational_unit" {
  name      = var.ou_name
  parent_id = local.parent_ou_id
}

output "ord_id" {
  value = data.aws_organizations_organization.org.roots[0].id
}
