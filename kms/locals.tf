locals {
  # Flatten all replica key aliases into a single map so aws_kms_alias.replica
  # can use for_each. The map key ("<replica_key>/<alias_key>") is unique across
  # all replica keys even when two regions share the same alias name.
  #
  # Example input (var.replica_keys):
  #   replica_keys = {
  #     us_east = {
  #       region = "us-east-1"
  #       aliases = {
  #         primary = { name = "alias/my-key" }
  #         backup  = { name_prefix = "alias/my-key-backup-" }
  #       }
  #     }
  #     eu_west = {
  #       region = "eu-west-1"
  #       aliases = {
  #         primary = { name = "alias/my-key" }
  #       }
  #     }
  #   }
  #
  # Example output (local.replica_key_aliases):
  #   {
  #     "us_east/primary" = { region = "us-east-1", name = "alias/my-key",            name_prefix = null,                    replica_key = "us_east" }
  #     "us_east/backup"  = { region = "us-east-1", name = null,                      name_prefix = "alias/my-key-backup-",  replica_key = "us_east" }
  #     "eu_west/primary" = { region = "eu-west-1", name = "alias/my-key",            name_prefix = null,                    replica_key = "eu_west" }
  #   }
  replica_key_aliases = {
    for entry in flatten([
      for k, v in var.replica_keys : [
        for ak, av in v.aliases : {
          key         = "${k}/${ak}"
          region      = v.region
          name        = av.name
          name_prefix = av.name_prefix
          replica_key = k
        }
      ]
    ]) : entry.key => entry
  }
}
