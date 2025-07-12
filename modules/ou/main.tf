data "aws_organizations_organization" "main" {}

data "aws_organizations_organizational_units" "top_ous" {
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

# Try to find an existing OU
locals {
  existing_ou_id = ( var.parent_ou_name != null && contains([for ou in data.aws_organizations_organizational_units.top_ous.children : ou.name], var.parent_ou_name) ) ? one([ for ou in data.aws_organizations_organizational_units.top_ous.children : ou.id if ou.name == var.parent_ou_name ]) : null
}

# Create only if not exists
resource "aws_organizations_organizational_unit" "parent_ou" {
  count     = var.create_parent_ou && local.existing_ou_id == null ? 1 : 0
  name      = var.parent_ou_name
  parent_id = data.aws_organizations_organization.main.roots[0].id

  lifecycle {
    prevent_destroy = true
  }
}

# Final OU ID logic
locals {
  final_parent_ou_id = var.parent_ou_name == null ? data.aws_organizations_organization.main.roots[0].id : coalesce(local.existing_ou_id, try(aws_organizations_organizational_unit.parent_ou[0].id, null))
}

resource "aws_organizations_organizational_unit" "child_ou" {
  name      = var.ou_name
  parent_id = local.final_parent_ou_id
}
