// hostname
resource "random_pet" "this" {
  length = 2
}

// ssh keys
module "key" {
  source     = "git::github.com/andrewpopa/terraform-metal-project-ssh-key"
  project_id = var.project_id
}

// metal devices
resource "equinix_metal_device" "this" {
  for_each            = var.metal_cluster
  hostname            = "${random_pet.this.id}-${each.value.metro}"
  plan                = each.value.plan
  metro               = each.value.metro
  operating_system    = each.value.operating_system
  billing_cycle       = each.value.billing_cycle
  tags                = ["${random_pet.this.id}-${each.value.metro}"]
  project_id          = var.project_id
  project_ssh_key_ids = [module.key.id]
  user_data = templatefile("${path.module}/bootstrap/vlans.sh", {
    VLAN    = each.value.vxlan
    IP      = each.value.ip
    NETMASK = each.value.netmask
  })
}

// vlan for metal
resource "equinix_metal_vlan" "this" {
  for_each   = var.metal_cluster
  metro      = each.value.metro
  vxlan      = each.value.vxlan
  project_id = var.project_id
}

// network type on each device
resource "equinix_metal_device_network_type" "this" {
  for_each  = var.metal_cluster
  device_id = equinix_metal_device.this["${each.key}"].id
  type      = each.value.network_type // layer3 interface
}

// attach device
resource "equinix_metal_port_vlan_attachment" "this" {
  for_each  = var.metal_cluster
  device_id = equinix_metal_device_network_type.this["${each.key}"].id
  port_name = each.value.port_name
  vlan_vnid = each.value.vxlan
}
