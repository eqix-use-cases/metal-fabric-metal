output "metal" {
  description = "Metal servers"
  //value       = equinix_metal_device.this["dallas"]
  //sensitive   = true
  value = {
    for_each = var.metal_cluster
    ip       = equinix_metal_device.this["${each.key}"].access_private_ipv4
  }
}

output "metal_service_token" {
  description = "Metal service token"
  value       = equinix_metal_connection.this.service_tokens
}

output "metal_connection_id" {
  value = equinix_metal_connection.this.id
}

output "service_token" {
  //value = tomap(equinix_metal_connection.this.service_tokens)
  value = lookup({
    for obj in equinix_metal_connection.this.service_tokens : "id" => "${obj.id}"
  }, "id")
}
