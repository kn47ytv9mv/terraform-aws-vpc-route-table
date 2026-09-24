# terraform-aws-vpc-route-table

Terraform module for a VPC route table with an arbitrary set of routes.

## Cost

Route tables and the routes within them carry no charge. This module
has no cost impact of its own.

## Usage

```hcl
module "route_table" {
  source = "kn47ytv9mv/vpc-route-table/aws"

  vpc_id = aws_vpc.example.id

  routes = [
    {
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = aws_internet_gateway.example.id
    }
  ]
}
```

Or directly from this repository:

```hcl
module "route_table" {
  source = "github.com/kn47ytv9mv/terraform-aws-vpc-route-table"

  vpc_id = aws_vpc.example.id

  routes = [
    {
      destination_cidr_block = "0.0.0.0/0"
      nat_gateway_id         = aws_nat_gateway.example.id
    }
  ]
}
```

Associate the table with a subnet using
[`terraform-aws-vpc-subnet`](https://github.com/kn47ytv9mv/terraform-aws-vpc-subnet)'s
`route_table_id` input:

```hcl
module "subnet" {
  source = "kn47ytv9mv/vpc-subnet/aws"

  vpc_id         = aws_vpc.example.id
  cidr_block     = "10.0.1.0/24"
  route_table_id = module.route_table.id
}
```

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.3 |
| aws | ~> 6.61 |

## Providers

| Name | Version |
|---|---|
| aws | ~> 6.61 |

## Inputs

| Name | Description | Default | Required |
|---|---|---|---|
| vpc_id | The ID of the VPC in which to create the route table. | `null` | no |
| routes | Routes to add to the route table. Each entry needs a destination (`destination_cidr_block` or `destination_ipv6_cidr_block`) and exactly one target (`gateway_id`, `nat_gateway_id`, `network_interface_id`, `transit_gateway_id`, `vpc_peering_connection_id`, `vpc_endpoint_id`, `carrier_gateway_id`, `local_gateway_id`, or `core_network_arn`). | `[]` | no |
| tags | A map of tags to assign to the route table. | `null` | no |

## Outputs

| Name | Description |
|---|---|
| id | The ID of the route table. |
| arn | The ARN of the route table. |

## License

MIT — see [LICENSE.md](LICENSE.md).
