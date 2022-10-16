# block_type "label" "name_label"{
#     key = "value"
# }

terraform {
    required_providers {
      oci = {
        source = "oracle/oci"
      }
    }
}

provider "oci" {
  region           = ""
  tenancy_ocid     = ""
  user_ocid        = ""
  fingerprint      = ""
  private_key_path = ""
}

resource "oci_identity_compartment" "viswaterraform" {

    compartment_id = "ocid1.compartment.oc1..aaaaaaaasdtuehkmrsgdlj52gt4edv4yjnw5jmup4z7wks6jvlvvgxjitnnq"
    description = "Compartment for Vignesh's Terraform Assets"
    name = "viswaterraform"
  
}

# data "oci_core_services" "AshburnServices" {

# }

resource "oci_core_vcn" "vigviswavcn" {

    compartment_id = oci_identity_compartment.viswaterraform.id
    cidr_block = "172.16.0.0/16"
    display_name = "Viswa VCN"
    freeform_tags = {"Source" = "Terraform"}
  
}

resource "oci_core_route_table" "publicrt" {
  compartment_id = oci_identity_compartment.viswaterraform.id
  vcn_id = oci_core_vcn.vigviswavcn.id
  display_name = "PublicRT"
  route_rules {
    network_entity_id = oci_core_internet_gateway.igw.id

    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
}

# resource "oci_core_route_table" "privatert" {
#   compartment_id = oci_identity_compartment.viswaterraform.id
#   vcn_id = oci_core_vcn.vigviswavcn.id
#   display_name = "PrivateRT"
#   route_rules {
#     network_entity_id = oci_core_service_gateway.sgw.id

#     destination = "all-iad-services"
#     destination_type = "SERVICE_CIDR_BLOCK"
#   }
# }

resource "oci_core_route_table_attachment" "public" {
  subnet_id = oci_core_subnet.Public.id
  route_table_id = oci_core_route_table.publicrt.id
}

# resource "oci_core_route_table_attachment" "private" {
#   subnet_id = oci_core_subnet.Private.id
#   route_table_id = oci_core_route_table.privatert.id
# }

resource "oci_core_security_list" "secpub" {
  compartment_id = oci_identity_compartment.viswaterraform.id
  vcn_id = oci_core_vcn.vigviswavcn.id
  display_name = "PublicSL"
  egress_security_rules {
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol = "all"
  }
  ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
  }
  ingress_security_rules {
    protocol = "1"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    icmp_options {
      type = "8"
    }
  }
}

resource "oci_core_security_list" "secpri" {
  compartment_id = oci_identity_compartment.viswaterraform.id
  vcn_id = oci_core_vcn.vigviswavcn.id
  display_name = "PrivateSL"
}

resource "oci_core_internet_gateway" "igw" {

  compartment_id = oci_identity_compartment.viswaterraform.id
  vcn_id = oci_core_vcn.vigviswavcn.id

}

resource "oci_core_service_gateway" "sgw" {
  compartment_id = oci_identity_compartment.viswaterraform.id
  services {
    service_id = data.oci_core_services.AshburnServices.services[0].id
  }
  vcn_id = oci_core_vcn.vigviswavcn.id
}

resource "oci_core_subnet" "Public" {

    cidr_block = "172.16.0.0/24"
    compartment_id = oci_identity_compartment.viswaterraform.id
    vcn_id = oci_core_vcn.vigviswavcn.id

    display_name = "Public TSub"
    prohibit_internet_ingress = false
    route_table_id = oci_core_route_table.publicrt.id
    security_list_ids = [ oci_core_security_list.secpub.id ]
  
}

resource "oci_core_subnet" "Private" {
    cidr_block = "172.16.1.0/24"
    compartment_id = oci_identity_compartment.viswaterraform.id
    vcn_id = oci_core_vcn.vigviswavcn.id

    display_name = "Private TSub"
    prohibit_internet_ingress = true
    security_list_ids = [ oci_core_security_list.secpri.id ]
}
