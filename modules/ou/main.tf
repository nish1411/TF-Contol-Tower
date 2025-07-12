# Look up existing OU (by name)
data "aws_organizations_organizational_units" "top_ous" {
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

# Match OU ID if it exists
data "aws_organizations_organizational_unit" "matched" {
  count = contains([for ou in data.aws_organizations_organizational_units.top_ous.children : ou.name], var.parent_ou_name) ? 1 : 0
  id    = one([
    for ou in data.aws_organizations_organizational_units.top_ous.children :
    ou.id if ou.name == var.parent_ou_name
  ])
}

# Create only if not exists
resource "aws_organizations_organizational_unit" "parent_ou" {
  count     = length(data.aws_organizations_organizational_unit.matched) == 0 ? 1 : 0
  name      = var.parent_ou_name
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

# Final OU ID
locals {
  final_parent_ou_id = var.parent_ou_name == null ? data.aws_organizations_organization.main.roots[0].id : ( length(data.aws_organizations_organizational_unit.matched) > 0 ? data.aws_organizations_organizational_unit.matched[0].id : aws_organizations_organizational_unit.parent_ou[0].id )
}

resource "aws_organizations_organizational_unit" "child_ou" {
  name      = var.ou_name
  parent_id = local.final_parent_ou_id
}
