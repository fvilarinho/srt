# Definition of the firewall rules of the swarm.
resource "linode_firewall" "srtRules" {
  label           = "srt-rules"
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  # Enable SSH connections.
  inbound {
    label    = "ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
  }

  # Enable join of nodes in the swarm.
  inbound {
    label    = "swarm-join"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "2377"
    ipv4     = ["0.0.0.0/0"]
  }

  # Enable traffic from the manager node.
  inbound {
    label    = linode_instance.manager.label
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "1-65535"
    ipv4     = ["${linode_instance.manager.ip_address}/32"]
  }

  # Enable traffic from the worker nodes.
  dynamic "inbound" {
    for_each = { for worker in local.settings.workers : worker.label => worker }

    content {
      label    = inbound.key
      action   = "ACCEPT"
      protocol = "TCP"
      ports    = "1-65535"
      ipv4     = [ "${linode_instance.workers[inbound.key].ip_address}/32" ]
    }
  }

  # Enable live video streaming in the swarm.
  dynamic "inbound" {
    for_each = local.settings.allowedIps

    content {
      label    = "srt-live-transmit"
      action   = "ACCEPT"
      protocol = "UDP"
      ports    = "31234"
      ipv4     = [ "${inbound.value}/32" ]
    }
  }

  # Enable live video play in the swarm.
  inbound {
    label    = "srt-live-play"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "32000"
    ipv4     = [ "0.0.0.0/0" ]
  }
}

# Attach the firewall rules in the manager node.
resource "linode_firewall_device" "srtRulesManager" {
  entity_id   = linode_instance.manager.id
  firewall_id = linode_firewall.srtRules.id
}

# Attach the firewall rules in the worker nodes.
resource "linode_firewall_device" "srtRulesWorkers" {
  for_each    = { for worker in local.settings.workers : worker.label => worker }
  entity_id   = linode_instance.workers[each.key].id
  firewall_id = linode_firewall.srtRules.id
}