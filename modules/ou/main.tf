data "aws_organizations_organization" "main" {}

################## Organizational Unit ##################


resource "aws_organizations_organizational_unit" "parent_ou" {
  for_each  = var.organizational_units
  name      = each.key
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

locals {
  child_ous = merge([
    for parent, config in var.organizational_units : {
      for child in config.child_ous : 
      "${parent}-${child}" => {
        name       = child
        parent_key = parent
      }
    }
  ]...)
}

resource "aws_organizations_organizational_unit" "child_ou" {
  for_each  = local.child_ous

  name      = each.value.name
  parent_id = aws_organizations_organizational_unit.parent_ou[each.value.parent_key].id
}



################## Accounts ##################

data "aws_organizations_organizational_units" "top_ous" {
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

data "aws_organizations_organizational_units" "all_child_ous" {
  for_each  = { for ou in data.aws_organizations_organizational_units.top_ous.children : ou.name => ou.id }
  parent_id = each.value
}

locals {
  accounts_map = {
    for acc in var.accounts :
    acc.account_name => acc
  }

  all_parent_ou_map = {
    for ou in data.aws_organizations_organizational_units.top_ous.children :
    ou.name => ou.id
  }

  all_child_ou_map = merge(
    [
      for ou_group in data.aws_organizations_organizational_units.all_child_ous :
      {
        for ou in ou_group.children :
        ou.name => ou.id
      }
    ]...
  )


#  selected_child_ou_id = var.ou_name != null ? lookup(local.all_child_ou_map, var.ou_name, null) : null
#  selected_root_ou_id  = var.ou_name != null ? lookup(local.all_parent_ou_map, var.ou_name, null) : null
#  selected_parent_ou_id = (
#    local.selected_child_ou_id != null ? local.selected_child_ou_id :
#    local.selected_root_ou_id  != null ? local.selected_root_ou_id :
#    data.aws_organizations_organization.main.roots[0].id
#  )
}

resource "aws_organizations_account" "new_account" {
  name      = var.account_name
  email     = var.account_email
  role_name = "OrganizationAccountAccessRole"
  parent_id = lookup( local.all_child_ou_map, each.value.ou_name, lookup( local.all_parent_ou_map, each.value.ou_name, data.aws_organizations_organization.main.roots[0].id ))
  #parent_id = local.selected_parent_ou_id
  depends_on = ["aws_organizations_organizational_unit.child_ou"]
}
