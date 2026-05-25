locals {
    subnet_config = flatten([
        for subnet_key, subnet_value in var.subnets : [
            for index, cidr in subnet_value.cidrs : {
                subnet_key = "${subnet_key}-${index + 1}"
                subnet_group = subnet_key
                subnet_name = subnet_value.name
                cidr_block = cidr
                availability_zone = var.availability_zones[index]
                public = subnet_value.public
                index = index + 1
            }
        ]
    ])

    subnet_map = {
        for subnet in local.subnet_config :
            subnet.subnet_key => subnet
    }

    public_subnets = {
        for key, value in local.subnet_map :
            key => value
            if value.public
    }

    private_subnets = {
        for key, value in local.subnet_map :
            key => value
            if !value.public
    }

    bastion_subnets = {
        for key, value in local.subnet_map :
            key => value
            if value.subnet_type == "bastionhost"
    }

    frontend_subnets = {
        for key, value in local.subnet_map :
            key => value
            if value.subnet_type == "frontend"
    }

    backend_subnets = {
        for key, value in local.subnet_map :
            key => value
            if value.subnet_type == "backend"
    }

    database_subnets = {
        for key, value in local.subnet_map :
            key => value
            if value.subnet_type == "database"
    }
}
