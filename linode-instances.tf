# Define the default password for the instances.
resource "random_password" "default" {
  length = 15
}

# Create the manager instance of the swarm.
resource "linode_instance" "spo" {
  label           = "srt-spo"
  tags            = [ "srt" ]
  type            = "g7-premium-4"
  image           = "linode/debian11"
  region          = "br-gru"
  private_ip      = true
  root_pass       = random_password.default.result
  authorized_keys = [ chomp(tls_private_key.application.public_key_openssh) ]

  provisioner "remote-exec" {
    # Remote connection attributes.
    connection {
      host        = self.ip_address
      user        = "root"
      password    = random_password.default.result
      private_key = chomp(tls_private_key.application.private_key_openssh)
    }

    # Install the required software and initialize the swarm.
    inline = [
      "hostnamectl set-hostname srt-spo",
      "apt update",
      "apt -y upgrade",
      "apt -y install bash ca-certificates curl wget htop dnsutils net-tools vim",
      "curl https://get.docker.com | sh -",
      "systemctl enable docker",
      "systemctl start docker",
      "docker swarm init --advertise-addr=${self.ip_address}"
    ]
  }

  depends_on = [ random_password.default ]
}

# Get the swarm token.
data "external" getSwarmToken {
  program = [ "./getSwarmToken.sh", linode_instance.spo.ip_address, local.privateKeyFilename ]
  depends_on = [ linode_instance.spo ]
}

# Create a worker instance of the swarm.
resource "linode_instance" "iad" {
  label           = "srt-iad"
  tags            = [ "srt" ]
  type            = "g7-premium-4"
  image           = "linode/debian11"
  region          = "us-iad"
  private_ip      = true
  authorized_keys = [ chomp(tls_private_key.application.public_key_openssh) ]

  # Remote connection attributes.
  provisioner "remote-exec" {
    connection {
      host        = self.ip_address
      user        = "root"
      password    = random_password.default.result
      private_key = chomp(tls_private_key.application.private_key_openssh)
    }

    # Install the required software and join the instance in the swarm.
    inline = [
      "hostnamectl set-hostname srt-iad",
      "apt update",
      "apt -y upgrade",
      "apt -y install bash ca-certificates curl wget htop dnsutils net-tools vim",
      "curl https://get.docker.com | sh -",
      "systemctl enable docker",
      "systemctl start docker",
      "${data.external.getSwarmToken.result.command}"
    ]
  }

  depends_on = [ data.external.getSwarmToken ]
}

# Apply the stack in the swarm.
resource "null_resource" "applyStack" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    environment = {
      MANAGER_NODE=linode_instance.spo.ip_address
      PRIVATE_KEY_FILENAME=local.privateKeyFilename
    }

    quiet = true
    command = "./applyStack.sh"
  }

  depends_on = [ linode_instance.iad ]
}