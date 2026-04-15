config {
    force = false
}

rule "terraform_required_providers" {
  enabled = false
  # defaults
  source = true
  version = false
}

rule "terraform_required_version" {
  enabled = true
}
