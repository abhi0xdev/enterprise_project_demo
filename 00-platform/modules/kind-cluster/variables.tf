variable "cluster_name" {
  description = "The name of the kind cluster"
  type        = string
}

variable "nodes" {
  description = "A list of nodes to create in the kind cluster"
  type = list(object({
    role = string
    extra_port_mappings = optional(list(object({
      container_port = number
      host_port      = number
      protocol       = optional(string, "TCP")
    })), [])
  }))

  validation {
    condition     = length([for n in var.nodes : n if n.role == "control-plane"]) >= 1
    error_message = "At least one node must have role = \"control-plane\"."
  }
}