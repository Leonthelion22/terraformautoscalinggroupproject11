variable "subnet_one" {
  description = "Subnetnumber1"
  type        = string
  default     = "subnet-0f9705a8a66fbd289"
}
variable "subnet_two" {
  description = "Subnetnumber2"
  type        = string
  default     = "subnet-03abc29d866014e87"
}

variable "vpc_id" {
  description = "myvpc"
  type        = string
  default     = "vpc-090ba000000005"     # grab your default VPC ID

}
