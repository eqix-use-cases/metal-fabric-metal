// metal dedicated port
data "equinix_fabric_port" "this" {
  uuid = var.dedicated_port_uuid
}

// metal interconnection
resource "equinix_metal_connection" "this" {
  description        = "Metal interconnection"
  name               = random_pet.this.id
  project_id         = var.project_id
  type               = "shared"
  redundancy         = "primary"
  metro              = var.metro_z
  speed              = "10Gbps"
  vlans              = [var.vxlan]
  service_token_type = "z_side"
}

// fabric connection
resource "equinix_fabric_connection" "this" {
  name = random_pet.this.id
  type = "EVPL_VC"
  notifications {
    type   = "ALL"
    emails = ["andrei.popa@eu.equinix.com"]
  }
  bandwidth = 50
  order {
    purchase_order_number = ""
  }
  a_side {
    access_point {
      type = "COLO"
      port {
        uuid = data.equinix_fabric_port.this.uuid
      }
      link_protocol {
        type     = "DOT1Q"
        vlan_tag = var.vxlan
        //vlan_c_tag = var.vxlan
      }
      location {
        metro_code = var.metro_a
      }
    }
  }
  z_side {
    service_token {
      uuid = lookup({
        for obj in equinix_metal_connection.this.service_tokens : "id" => "${obj.id}"
      }, "id")
    }
  }
}

data "equinix_metal_connection" "this" {
  // share connection which provides token for the fabric connection 
  connection_id = var.dedicated_fabric_connection_uuid
}

// metal virtual circuit
resource "equinix_metal_virtual_circuit" "this" {
  name          = random_pet.this.id
  connection_id = data.equinix_metal_connection.this.id // existing of the dedicated port
  project_id    = var.project_id
  port_id       = var.dedicated_port_id // existing of the primary dedicated port
  vlan_id       = var.vxlan
  nni_vlan      = var.vxlan
}
