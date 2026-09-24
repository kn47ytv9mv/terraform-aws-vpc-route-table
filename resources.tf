resource "aws_route_table" "resource" {
  vpc_id = var.vpc_id

  tags = var.tags
}

resource "aws_route" "resource" {
  for_each = { for route in var.routes : coalesce(route.destination_cidr_block, route.destination_ipv6_cidr_block) => route }

  route_table_id = aws_route_table.resource.id

  destination_cidr_block      = each.value.destination_cidr_block
  destination_ipv6_cidr_block = each.value.destination_ipv6_cidr_block
  gateway_id                  = each.value.gateway_id
  nat_gateway_id              = each.value.nat_gateway_id
  network_interface_id        = each.value.network_interface_id
  transit_gateway_id          = each.value.transit_gateway_id
  vpc_peering_connection_id   = each.value.vpc_peering_connection_id
  vpc_endpoint_id             = each.value.vpc_endpoint_id
  carrier_gateway_id          = each.value.carrier_gateway_id
  local_gateway_id            = each.value.local_gateway_id
  core_network_arn            = each.value.core_network_arn
}

output "id" {
  description = "The ID of the route table."
  value       = aws_route_table.resource.id
}

output "arn" {
  description = "The ARN of the route table."
  value       = aws_route_table.resource.arn
}
