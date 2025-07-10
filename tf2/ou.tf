
module "accounts" {
  for_each          = { for acc in var.accounts : "${acc.ou}-${acc.account_name}" => acc }
  source            = "../modules/account"
  account_name      = each.value.account_name
  account_email     = each.value.account_email
  ou_name           = each.value.ou_name
}
