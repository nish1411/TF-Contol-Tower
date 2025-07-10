variable "organizational_unit" {
  type = list(object({
    ou_name                    = optional(string)
    parent_ou_name             = optional(string)
  }))
  description = "organizational_unit_mapping"
  default     = []
}

variable "accounts" {
  type = list(object({
    account_name               = optional(string)
    account_email              = optional(string)
    ou_name                    = optional(string)
  }))
  description = "accounts_mapping"
  default     = []
}