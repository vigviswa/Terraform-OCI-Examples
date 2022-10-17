output "vcndns" {

    value = oci_core_vcn.vigviswavcn.vcn_domain_name
}

output "privateip" {
    value = oci_core_instance.first_instance.private_ip
}