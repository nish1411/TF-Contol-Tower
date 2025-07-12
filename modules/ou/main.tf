data "aws_organizations_organization" "main" {}

data "aws_organizations_organizational_units" "top_ous" {
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

# Try to get parent OU ID from existing OUs
locals {
  existing_ou_id = (
    var.parent_ou_name != null &&
    contains([for ou in data.aws_organizations_organizational_units.top_ous.children : ou.name], var.parent_ou_name)
  ) ? one([
    for ou in data.aws_organizations_organizational_units.top_ous.children :
    ou.id if ou.name == var.parent_ou_name
  ]) : null
}

# Create new OU only if it doesn't already exist
resource "aws_organizations_organizational_unit" "parent_ou" {
  count     = local.existing_ou_id == null && var.parent_ou_name != null ? 1 : 0
  name      = var.parent_ou_name
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

locals {
  final_parent_ou_id = (
    var.parent_ou_name == null ? data.aws_organizations_organization.main.roots[0].id : coalesce( local.existing_ou_id, try(aws_organizations_organizational_unit.parent_ou[0].id, null)
    )
  )
}


resource "aws_organizations_organizational_unit" "child_ou" {
  name      = var.ou_name
  parent_id = local.final_parent_ou_id
}
