parent_organizational_unit = [
    {
        parent_ou_name = "parent1"
    },
    {
        parent_ou_name = "parent2"
    },
    {
        parent_ou_name = "parent3"
    }
]

child_organizational_unit = [
    {
        ou_name        = "child1"
        parent_ou_name = "parent1"
    },
    {
        ou_name        = "child2"
    },
    {
        ou_name        = "child3"
        parent_ou_name = "parent3"
    }
]

accounts = [
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
    },
        {
        account_name   = "child5acc"
        account_email  = "ddd445149@gmail.com"
        ou_name        = "child1"
    },
    {
        account_name   = "child6acc"
        account_email  = "ddd055621@gmail.com"
        ou_name        = "child2"
    },
        {
        account_name   = "child7acc"
        account_email  = "dsdsds323222@gmail.com"
        ou_name        = "parent3"
    }
]