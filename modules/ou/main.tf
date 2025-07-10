data "aws_organizations_organization" "org" {}


# Only look up the parent OU if user specified one (non-root)
data "aws_organizations_organizational_unit" "top_ou" {
  count     = var.parent_ou_name != null ? 1 : 0
  name      = var.parent_ou_name
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "organizational_unit" {
  count     = var.parent_ou_name != "" ? 1 : 0
  name      = var.ou_name
  parent_id = data.aws_organizations_organizational_unit.top_ou[0].id
}

resource "aws_organizations_organizational_unit" "organizational_unit2" {
  count     = var.parent_ou_name == "" ? 1 : 0
  name      = var.ou_name
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

