variable "environment" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "security_groups" {
  type = list
}

variable "instance_type" {
  type = string
}

variable "service_name" {
  type = string
}

variable "instance_tags" {
  type = map
}

variable "instance_key" {
  type = string
}

variable "instance_count" {
  type = string
}
