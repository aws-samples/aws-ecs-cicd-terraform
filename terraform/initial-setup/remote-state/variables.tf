variable "aws_region" {
  description = "The AWS region to create things in."
}

variable "aws_profile" {
  description = "AWS profile"
}

variable "stack" {
  description = "Name of the stack."
  default     = "CloudBootstrap-InitialSetup"
}

variable "project" {
  description = "Name of the project."
  default     = "cc-cloud-bootstrap"
}