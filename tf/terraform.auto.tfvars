organizational_unit = [
    {
        ou_name        = "parent1"
    },
    {
        ou_name        = "child1"
        parent_ou_name = "parent1"
    },
    {
        ou_name        = "parent2"
    }
]

accounts = [
    {
        account_name   = "child1acc"
        account_email  = "tu8834072@gmail.com"
        ou_name        = "child1"
    },
        {
        account_name   = "child2acc"
        account_email  = "tu8834072e@gmail.com"
        ou_name        = "parent2"
    }
]