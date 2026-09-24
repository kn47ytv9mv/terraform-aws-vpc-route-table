mock_provider "aws" {}

run "routes_needs_one_destination_and_one_target" {
  command = plan

  variables {
    vpc_id = "vpc-0123456789abcdef0"
    routes = [{
      destination_cidr_block      = "0.0.0.0/0"
      destination_ipv6_cidr_block = "::/0"
      gateway_id                  = "igw-0123456789abcdef0"
    }]
  }

  expect_failures = [var.routes]
}

run "routes_needs_a_target" {
  command = plan

  variables {
    vpc_id = "vpc-0123456789abcdef0"
    routes = [{
      destination_cidr_block = "0.0.0.0/0"
    }]
  }

  expect_failures = [var.routes]
}

run "no_routes_by_default" {
  command = plan

  variables {
    vpc_id = "vpc-0123456789abcdef0"
  }

  assert {
    condition     = length(aws_route.resource) == 0
    error_message = "No routes were given, so no aws_route resources should be created."
  }
}

run "routes_keyed_by_stable_destination" {
  command = plan

  variables {
    vpc_id = "vpc-0123456789abcdef0"
    routes = [
      {
        destination_cidr_block = "0.0.0.0/0"
        gateway_id             = "igw-0123456789abcdef0"
      },
      {
        destination_ipv6_cidr_block = "::/0"
        gateway_id                  = "igw-0123456789abcdef0"
      },
    ]
  }

  assert {
    condition     = length(aws_route.resource) == 2
    error_message = "Two distinct destinations should produce two routes."
  }

  assert {
    condition     = contains(keys(aws_route.resource), "0.0.0.0/0") && contains(keys(aws_route.resource), "::/0")
    error_message = "Routes should be keyed by their destination CIDR, not by list index."
  }
}

run "all_nine_route_targets_accepted" {
  command = plan

  variables {
    vpc_id = "vpc-0123456789abcdef0"
    routes = [
      { destination_cidr_block = "10.201.0.0/16", gateway_id = "igw-0123456789abcdef0" },
      { destination_cidr_block = "10.202.0.0/16", nat_gateway_id = "nat-0123456789abcdef0" },
      { destination_cidr_block = "10.203.0.0/16", network_interface_id = "eni-0123456789abcdef0" },
      { destination_cidr_block = "10.204.0.0/16", transit_gateway_id = "tgw-0123456789abcdef0" },
      { destination_cidr_block = "10.205.0.0/16", vpc_peering_connection_id = "pcx-0123456789abcdef0" },
      { destination_cidr_block = "10.206.0.0/16", vpc_endpoint_id = "vpce-0123456789abcdef0" },
      { destination_cidr_block = "10.207.0.0/16", carrier_gateway_id = "cagw-0123456789abcdef0" },
      { destination_cidr_block = "10.208.0.0/16", local_gateway_id = "lgw-0123456789abcdef0" },
      { destination_cidr_block = "10.209.0.0/16", core_network_arn = "arn:aws:networkmanager::123456789012:core-network/core-network-0123456789abcdef0" },
    ]
  }

  assert {
    condition     = length(aws_route.resource) == 9
    error_message = "All nine distinct target types should each produce their own route."
  }
}

run "readme_gateway_target" {
  command = plan

  variables {
    vpc_id = "vpc-0123456789abcdef0"
    routes = [{
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = "igw-0123456789abcdef0"
    }]
  }
}

run "readme_nat_gateway_target" {
  command = plan

  variables {
    vpc_id = "vpc-0123456789abcdef0"
    routes = [{
      destination_cidr_block = "0.0.0.0/0"
      nat_gateway_id         = "nat-0123456789abcdef0"
    }]
  }
}
