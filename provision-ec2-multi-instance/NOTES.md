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

# Task 2 - Remote State and Locking

## Local State Behavior

Before configuring a remote backend, Terraform uses the local backend
by default. The Terraform state is stored in a local `terraform.tfstate`
file on the machine running Terraform.

If two developers run `terraform apply` at the same time using separate
local state files, they do not share a common state or locking mechanism.
Each Terraform process may operate using its own potentially stale copy
of state. Concurrent changes can therefore result in conflicting
infrastructure operations or inconsistent state.

## Remote State

The configuration was changed to use an Amazon S3 backend.

The S3 backend stores the Terraform state remotely at:

    ec2-multi-instance/terraform.tfstate

This allows team members to work against the same shared state rather
than separate local state files.

## State Locking

A DynamoDB table named `terraform-state-lock` is configured for Terraform
state locking.

When Terraform performs an operation that can modify state, it acquires
a lock. If another Terraform process attempts to perform a conflicting
operation while the state is locked, Terraform cannot acquire the lock
and does not proceed with the state-changing operation.

After the first Terraform operation completes, the lock is released.

This prevents multiple users from modifying the same Terraform state
concurrently.

## Backend Resources

The backend consists of:

- Amazon S3 bucket for remote Terraform state
- S3 bucket versioning for state recovery
- S3 server-side encryption
- DynamoDB table for state locking

The S3 bucket and DynamoDB table are created separately using the
`bootstrap` Terraform configuration because the backend infrastructure
must exist before Terraform can initialize and use the S3 backend.

Note - Hashicorp documents DynamoDB locking is deprecated and S3 native locking
should be used.
example - 
``
backend "s3" {
  bucket       = "my-terraform-state-2026-prashank"
  key          = "ec2-multi-instance/terraform.tfstate"
  region       = "us-east-1"
  use_lockfile = true
}
``