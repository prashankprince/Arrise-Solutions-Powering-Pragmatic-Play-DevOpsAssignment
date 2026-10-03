locals {
  all_instances = merge(
    {
      for name, instance in aws_instance.protected :
      name => instance
    },
    {
      for name, instance in aws_instance.unprotected :
      name => instance
    }
  )
}

output "instance_ids" {
  description = "Map of instance name to EC2 instance ID."

  value = {
    for name, instance in local.all_instances :
    name => instance.id
  }
}

output "private_ips" {
  description = "Map of instance name to private IP address."

  value = {
    for name, instance in local.all_instances :
    name => instance.private_ip
  }
}
