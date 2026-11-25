variable "namespaces" {
  description = "Namespaces to create, keyed by namespace name"
  type = map(object({
    environment  = string
    pod_security = optional(string, "restricted")
    quota = optional(object({
      cpu_limits    = string
      memory_limits = string
      pods          = string
    }))
  }))
}