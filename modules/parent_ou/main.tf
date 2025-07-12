data "aws_organizations_organization" "main" {}

data "aws_organizations_organizational_units" "top_ous" {
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

resource "aws_organizations_organizational_unit" "parent_organizational_unit" {
  name      = var.parent_ou_name
  parent_id = data.aws_organizations_organization.main.roots[0].id
}




