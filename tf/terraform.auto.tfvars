organizational_unit = [
    {
        ou_name        = "child1"
        parent_ou_name = "parent1"
    },
    {
        ou_name        = "parent2"
    },
    {
        ou_name        = "child3"
        parent_ou_name = "parent3"
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
    },
    {
        account_name   = "child3acc"
        account_email  = "reee80747@gmail.com"
        ou_name        = "child3"
    },
    {
        account_name   = "child4acc"
        account_email  = "reee80747d@gmail.com"
        ou_name        = "parent3"
    }
]