variable "project_id" {
  description = "Metal project ID"
  default     = ""
}

variable "metal_cluster" {
  type = map(object({
    plan             = string
    metro            = string
    operating_system = string
    billing_cycle    = string
    vxlan            = number
    network_type     = string
    port_name        = string
    ip               = string
    netmask          = string
  }))
}


variable "dedicated_port_uuid" {
  description = "Dedicated port UUID"
  type        = string
  default     = ""
}

variable "connection_type" {
  description = "type of Metal connection"
  type        = string
  default     = ""
}

variable "metro_a" {
  description = "Metro for A-side"
  type        = string
  default     = ""
}

variable "metro_z" {
  description = "Metro for Z-side"
  type        = string
  default     = ""
}

variable "vxlan" {
  description = "VLAN"
  type        = number
  default     = 0
}

variable "dedicated_fabric_connection_uuid" {
  description = "Dedicated fabric connection"
  type        = string
  default     = ""
}

variable "dedicated_port_id" {
  description = "Existing dedicated port uuid"
  type        = string
  default     = ""
}
