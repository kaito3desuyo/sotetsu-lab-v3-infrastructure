variable "region" {}
variable "name" {}

variable "module" {
  type        = string
  default     = "database"
  description = "Module Name"
}

variable "vpc_id" {}
variable "subnet_ids" {}
variable "ingress_sg_ids" {}
variable "ingress_cidr_blocks" {}
variable "main_db_username" {}
variable "main_db_password" {}

locals {
  module_tags = {
    "Module" = var.module
  }
  prefix = "${var.name}-${var.module}"
}
