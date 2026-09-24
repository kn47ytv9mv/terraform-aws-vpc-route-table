variable "vpc_id" {
  default     = null
  description = "The ID of the VPC in which to create the route table."
}

variable "routes" {
  default     = []
  description = "Routes to add to the route table. Each entry needs a destination (destination_cidr_block or destination_ipv6_cidr_block) and exactly one target (gateway_id, nat_gateway_id, network_interface_id, transit_gateway_id, vpc_peering_connection_id, vpc_endpoint_id, carrier_gateway_id, local_gateway_id, or core_network_arn)."
  type = list(object({
    destination_cidr_block      = optional(string)
    destination_ipv6_cidr_block = optional(string)
    gateway_id                  = optional(string)
    nat_gateway_id              = optional(string)
    network_interface_id        = optional(string)
    transit_gateway_id          = optional(string)
    vpc_peering_connection_id   = optional(string)
    vpc_endpoint_id             = optional(string)
    carrier_gateway_id          = optional(string)
    local_gateway_id            = optional(string)
    core_network_arn            = optional(string)
  }))

  validation {
    condition = alltrue([
      for r in var.routes : (
        (r.destination_cidr_block != null) != (r.destination_ipv6_cidr_block != null)
        ) && (
        length([for t in [
          r.gateway_id, r.nat_gateway_id, r.network_interface_id, r.transit_gateway_id,
          r.vpc_peering_connection_id, r.vpc_endpoint_id, r.carrier_gateway_id,
          r.local_gateway_id, r.core_network_arn
        ] : t if t != null]) == 1
      )
    ])
    error_message = "Each routes entry needs exactly one destination (destination_cidr_block or destination_ipv6_cidr_block) and exactly one target."
  }
}

variable "tags" {
  default     = null
  description = "A map of tags to assign to the route table."
}
