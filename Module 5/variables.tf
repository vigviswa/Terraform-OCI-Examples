variable "region" {
    type = string
    sensitive = false
    description = "Region where you want the configuration to be deployed"
    default = "us-ashburn-1"
}

variable "tenancy" {
    type = string
    sensitive = true
    description = "The OCID of your OCI Tenancy"
}

variable "user" {
    type = string
    sensitive = true
    description = "The User OCID of your OCI Tenancy"
}

variable "fingerprint" {
    type = string
    sensitive = true
    description = "The Fingerprint of your API Key"
}

variable "key_path" {
    type = string
    sensitive = true
    description = "The Path to your private key file"
}

variable "learning_source" {

    type = string
    description = "Source Name"
    default = "Pluralsight"

}

variable "learning_module" {

    type = string
    description = "Module Name"
    default = "1"
    
}

variable "sshkey" {

    type = string
    sensitive = true
    description = "SSHKEY"

}

variable "subnet_cidr_block" {

    type = list(string)
    description = "CIDR Block for subnets"
    default = [ "172.16.0.0/24", "172.16.1.0/24" ]
  
}