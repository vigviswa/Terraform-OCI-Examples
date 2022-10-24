resource "oci_core_instance" "first_instance" {

  compartment_id = oci_identity_compartment.viswaterraform.id
  availability_domain = data.oci_identity_availability_domains.test_ads.availability_domains[1].name
  shape = "VM.Standard.E3.Flex"
  display_name = "First Instances"

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

resource "oci_core_instance" "second_instance" {

  compartment_id = oci_identity_compartment.viswaterraform.id
  availability_domain = data.oci_identity_availability_domains.test_ads.availability_domains[0].name
  shape = "VM.Standard.E3.Flex"
  display_name = "Second Instance"

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
        subnet_id = oci_core_subnet.Public.id
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