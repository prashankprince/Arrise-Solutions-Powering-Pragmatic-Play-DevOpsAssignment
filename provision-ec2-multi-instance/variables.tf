variable "instances" {
  description = "Provison 5 EC2 instances"

  type = map(object({
    instance_type        = string
    root_volume_type     = string
    root_volume_size     = number
    key_name             = string
    subnet_id            = string
    security_group_ids   = list(string)
    environment          = string
    owner                = string
    protected            = bool
  }))

  validation {
    condition     = length(var.instances) == 5
    error_message = "5 EC2 instances must be defined."
  }

  validation {
    condition = length([
      for instance in var.instances : instance
      if instance.protected
    ]) == 1

    error_message = "Atleast one instance must have protected = true."
  }

  validation {
    condition = alltrue([
      for instance in var.instances :
      contains(["gp2", "gp3", "io1", "io2", "standard"], instance.root_volume_type)
    ])

    error_message = "root_volume_type must be gp2, gp3, io1, io2, or standard."
  }
}