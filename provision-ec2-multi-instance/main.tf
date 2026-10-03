locals {
  protected_instances = {
    for name, config in var.instances :
    name => config
    if config.protected
  }

  unprotected_instances = {
    for name, config in var.instances :
    name => config
    if !config.protected
  }
}

# The single protected instance.
resource "aws_instance" "protected" {
  for_each = local.protected_instances

  ami           = data.aws_ami.amazon_linux.id
  instance_type = each.value.instance_type
  key_name      = each.value.key_name

  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = each.value.security_group_ids

  root_block_device {
    volume_type = each.value.root_volume_type
    volume_size = each.value.root_volume_size
  }

  tags = {
    Name        = each.key
    Environment = each.value.environment
    Owner       = each.value.owner
  }

  lifecycle {
    prevent_destroy = true
  }
}

# The other four instances.
resource "aws_instance" "unprotected" {
  for_each = local.unprotected_instances

  ami           = data.aws_ami.amazon_linux.id
  instance_type = each.value.instance_type
  key_name      = each.value.key_name

  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = each.value.security_group_ids

  root_block_device {
    volume_type = each.value.root_volume_type
    volume_size = each.value.root_volume_size
  }

  tags = {
    Name        = each.key
    Environment = each.value.environment
    Owner       = each.value.owner
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}