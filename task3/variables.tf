variable "account_a_id" {
  description = "AWS Account A ID."
  type        = string
  default     = "000000000000"
}

variable "account_b_id" {
  description = "AWS Account B ID."
  type        = string
  default     = "111111111111"
}

variable "bucket_name" {
  description = "S3 bucket in Account B that roleC can access."
  type        = string
}