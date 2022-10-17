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
  region           = var.region
  tenancy_ocid     = var.tenancy
  user_ocid        = var.user
  fingerprint      = var.fingerprint
  private_key_path = var.key_path
}

resource "oci_identity_compartment" "viswaterraform" {

    compartment_id = "ocid1.compartment.oc1..aaaaaaaasdtuehkmrsgdlj52gt4edv4yjnw5jmup4z7wks6jvlvvgxjitnnq"
    description = "Compartment for Vignesh's Terraform Assets"
    name = "viswaterraform"
  
}

data "oci_core_services" "AshburnServices" {

}

data "oci_identity_availability_domains" "test_ads" {

  compartment_id = oci_identity_compartment.viswaterraform.id

}

resource "oci_core_vcn" "vigviswavcn" {

    compartment_id = oci_identity_compartment.viswaterraform.id
    cidr_block = "172.16.0.0/16"
    display_name = "Viswa VCN"
    freeform_tags = {"Source" = "Terraform"}
    dns_label = "viswavcn"
    # defined_tags = local.common_tags
  
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

resource "oci_core_route_table" "privatert" {
  compartment_id = oci_identity_compartment.viswaterraform.id
  vcn_id = oci_core_vcn.vigviswavcn.id
  display_name = "PrivateRT"
  route_rules {
    network_entity_id = oci_core_service_gateway.sgw.id

    destination = data.oci_core_services.AshburnServices.services[1].cidr_block
    destination_type = "SERVICE_CIDR_BLOCK"
  }
}

resource "oci_core_route_table_attachment" "public" {
  subnet_id = oci_core_subnet.Public.id
  route_table_id = oci_core_route_table.publicrt.id
}

resource "oci_core_route_table_attachment" "private" {
  subnet_id = oci_core_subnet.Private.id
  route_table_id = oci_core_route_table.privatert.id
}

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
  display_name = "igw"

}

resource "oci_core_instance" "first_instance" {

  compartment_id = oci_identity_compartment.viswaterraform.id
  availability_domain = data.oci_identity_availability_domains.test_ads.availability_domains[0].name
  shape = "VM.Standard.E3.Flex"
  display_name = "First Instance"

  agent_config {

        are_all_plugins_disabled = false
        is_management_disabled = false
        is_monitoring_disabled = false
  }

  source_details {
        #Required
        source_id = "ocid1.image.oc1.iad.aaaaaaaasdqmcux7p5sdhhsqygmfzf2n6smemihykfv4bv7qh4235zre75da"
        source_type = "image"
    }

    create_vnic_details {

        #Optional
        assign_public_ip = false
        assign_private_dns_record = true
        subnet_id = oci_core_subnet.Private.id
    }

    shape_config {

        #Optional
        memory_in_gbs = "8"
        ocpus = "2"
    }

    metadata = {

      ssh_authorized_keys = var.sshkey

    }    

  }




resource "oci_core_service_gateway" "sgw" {
  compartment_id = oci_identity_compartment.viswaterraform.id
  display_name = "sgw"
  services {
    service_id = data.oci_core_services.AshburnServices.services[1].id
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
    route_table_id = oci_core_route_table.privatert.id
}
