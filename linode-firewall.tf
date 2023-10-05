# Definition of the firewall rules of the swarm.
resource "linode_firewall" "srt" {
  label           = "srt-rules"
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  # Enable SSH connections.
  inbound {
    label    = "ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = [ "0.0.0.0/0" ]
  }

  # Enable join of nodes in the swarm.
  inbound {
    label    = "swarm-join"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "2377"
    ipv4     = [ "0.0.0.0/0" ]
  }

  # Enable communication between nodes of the swarm.
  inbound {
    label    = "swarm-nodes"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "1-65535"
    ipv4     = [
      "${linode_instance.spo.ip_address}/32",
      "${linode_instance.iad.ip_address}/32"
    ]
  }

  # Enable live video streaming in the swarm.
  inbound {
    label    = "srt-live-transmit"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "31234"
    ipv4     = [ "179.97.191.88/32" ]
  }

  # Enable live video playing in the swarm.
  inbound {
    label    = "srt-live-receive"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "32000"
    ipv4     = [ "179.97.191.88/32" ]
  }

  # Attach the firewall rules in the swarm nodes.
  linodes = [
    linode_instance.spo.id,
    linode_instance.iad.id
  ]

  depends_on = [
    linode_instance.spo,
    linode_instance.iad,
    null_resource.applyStack
  ]
}