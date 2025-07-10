data "aws_organizations_organization" "org" {}

data "aws_organizations_organizational_unit" "top_ou" {
  count     = var.parent_ou_name != null ? 1 : 0
  name      = var.parent_ou_name
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "organizational_unit" {
  count     = var.parent_ou_name != "" ? 1 : 0
  name      = var.ou_name
  parent_id = var.parent_ou_name != null ? data.aws_organizations_organizational_unit.top_ou[0].id : data.aws_organizations_organization.org.roots[0].id
}



