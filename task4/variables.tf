variable "account_a_id" {
  description = "AWS Account A ID"
  type        = string
  default     = "000000000000"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ecr_repository_name" {
  description = "ECR repository that CI is allowed to push images to"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster containing the deployment service"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service that CI is allowed to update"
  type        = string
}

variable "s3_artifacts_bucket_name" {
  description = "S3 bucket containing build artifacts"
  type        = string
}
