data "aws_organizations_organization" "org" {}

data "aws_organizations_organizational_unit" "top_ous" {
  count     = var.parent_ou_name != "" ? 1 : 0
  parent_id = data.aws_organizations_organization.org.roots[0].id
  name      = var.parent_ou_name
}

resource "aws_organizations_organizational_unit" "organizational_unit" {
  name      = var.ou_name
  parent_id = var.parent_ou_name != "" ? data.aws_organizations_organizational_unit.top_ous[count.index].id : data.aws_organizations_organization.org.roots[0].id
}


