## EC2 Multi-Instance Provisioning Notes
# Overview

This module provisions exactly five EC2 instances from a single instances input variable.

Each instance definition controls:

- Instance type

- Root volume type

- Root volume size

- Key pair

- Subnet

- Security groups

- Environment tag

- Owner tag

- Whether the instance is protected from accidental destruction

The module uses for_each rather than five separate hardcoded EC2 resource blocks.

# Protected Instance

db-01 is the protected instance.

It has:
``
protected = true
``

The aws_instance.protected resource uses:
``
lifecycle {
  prevent_destroy = true
}
``

db-01 was selected because it represents a database instance and is therefore treated as an instance that should not be accidentally destroyed through a normal Terraform plan/apply as it would mean loss of customer database.

The variable validation requires exactly one instance to have protected = true.

# Why Two Resource Blocks?

Terraform lifecycle meta-arguments such as prevent_destroy cannot be dynamically assigned from each.value.

For example, this pattern is not supported:

``
lifecycle {
  prevent_destroy = each.value.protected
}
``


Therefore, the module separates the five instances into:

1. Single protected instance.

2. Four unprotected instances.

Both groups are still driven entirely from the same instances input variable, and neither group contains five hardcoded EC2 definitions.

# Storage

The example configuration includes both io1 and io2 volumes:

- app-01 uses io1.

- db-01 uses io2.

The remaining instances use other EBS volume types.

# Tags

Every instance receives:

- Name

- Environment

- Owner

The Name tag is derived from the key of the instances map.

# Outputs

The module exposes:

instance_ids — instance name to EC2 instance ID.

private_ips — instance name to private IP address.

Example:

instance_ids = {
  "app-01" = "i-0123456789abcdef0"
  "app-02" = "i-0123456789abcdef1"
  "db-01"  = "i-0123456789abcdef2"
  "web-01" = "i-0123456789abcdef3"
  "web-02" = "i-0123456789abcdef4"
}


The actual IDs and IP addresses are assigned by AWS during deployment.