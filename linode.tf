# Linode provider credentials.
provider "linode" {
  config_path    = local.credentialsFilename
  config_profile = "linode"
}