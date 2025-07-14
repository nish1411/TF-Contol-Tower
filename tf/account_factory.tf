module "ou" {
 source                 = "../modules/ou"
 organizational_units   = var.organizational_units
}


module "accounts" {
  for_each          = { for acc in var.accounts : "${acc.account_name}" => acc }
  source            = "../modules/account"
  account_name      = each.value.account_name
  account_email     = each.value.account_email
  ou_name           = each.value.ou_name
}

module "control_tower"
  source               = "../modules/ct"
  log_account_name     = "logs"
  log_account_email    = "nishsjsk07@gmail.com"
  audit_account_name   = "auds
  audit_account_email  = "sjsknish@gmail.com"
  security_ou_name     = "sec"


