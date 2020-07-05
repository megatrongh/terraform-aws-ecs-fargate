variable "env_short" {
    type    = string
    default = "dev"
}

variable "cidr_block" {
    type    = string
    default = "10.0.0.0/16"
}

variable "region" {
    type    = string
    default = "us-east-1"
}

variable "version" {
    type    = string
    default = "~> 2.0"
}

variable "account_ecr" {
  type = string
  default = "878925712923"
}

variable "container_port" {
  description = "The port where the Docker is exposed"
  default     = 8000
}

variable "host_port" {
  default     = 8000
}

variable "public_subnets" {
  type = list

  default = [
    "10.0.0.0/24"
  ]
}

variable "private_subnets" {
  type = list

  default = [
    "10.0.1.0/24"
  ]
}

variable "availability_zones" {
  type = list
  default     = ["us-east-1a"]
}


