instances = {
  "web-01" = {
    instance_type      = "t3.micro"
    root_volume_type   = "gp3"
    root_volume_size   = 20
    key_name           = "web-key"
    subnet_id          = "subnet-0123456789abcdef0"
    security_group_ids = ["sg-0123456789abcdef0"]
    environment        = "production"
    owner              = "platform-team"
    protected          = false
  }

  "web-02" = {
    instance_type      = "t3.small"
    root_volume_type   = "gp2"
    root_volume_size   = 25
    key_name           = "web-key-02"
    subnet_id          = "subnet-0123456789abcdef0"
    security_group_ids = ["sg-0123456789abcdef0"]
    environment        = "production"
    owner              = "platform-team"
    protected          = false
  }

  "app-001" = {
    instance_type      = "t3.medium"
    root_volume_type   = "io1"
    root_volume_size   = 40
    key_name           = "app-key"
    subnet_id          = "subnet-0123456789abcdef0"
    security_group_ids = ["sg-0123456789abcdef0"]
    environment        = "production"
    owner              = "application-team"
    protected          = false
  }

  "app-02" = {
    instance_type      = "m5.large"
    root_volume_type   = "gp3"
    root_volume_size   = 50
    key_name           = "app-key-02"
    subnet_id          = "subnet-0123456789abcdef0"
    security_group_ids = ["sg-0123456789abcdef0"]
    environment        = "staging"
    owner              = "application-team"
    protected          = false
  }

  "db-01" = {
    instance_type      = "r5.large"
    root_volume_type   = "io2"
    root_volume_size   = 100
    key_name           = "db-key"
    subnet_id          = "subnet-0123456789abcdef0"
    security_group_ids = ["sg-0123456789abcdef0"]
    environment        = "production"
    owner              = "database-team"
    protected          = true
  }
}
