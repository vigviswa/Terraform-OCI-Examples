variable "compartment_id" {

  description = "Compartment where resources are deployed"
  type        = string

}

variable "region" {

  description = "Region where resources are deployed"
  type        = string
  default     = "us-pheonix-1"

}

variable "tenancy_ocid" {

  description = "Tenancy where the resources are deployed"
  type        = string

}

variable "user_ocid" {

  description = "OCID of the user deploying the resources"
  type        = string

}

variable "fingerprint" {

  description = "Generated fingerprint from the public key"
  type        = string

}

variable "private_key_path" {

  description = "Path to the private key"
  type        = string

}