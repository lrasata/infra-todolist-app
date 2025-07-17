variable "instance_name" {
  description = "Value of the EC2 instance's Name tag."
  type        = string
  default     = "TodoListEC2Instance"
}

variable "instance_type" {
  description = "The EC2 instance's type."
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  default = 1
  type    = number

  validation {
    condition     = var.instance_count == 1
    error_message = "Only 1 instance is allowed."
  }
}
