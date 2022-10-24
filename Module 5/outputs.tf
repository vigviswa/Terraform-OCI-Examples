output "vcndns" {

    value = oci_core_vcn.vigviswavcn.vcn_domain_name
}

output "privateipfirst" {
    value = oci_core_instance.first_instance.private_ip
}

output "privateipsecond" {

    value = oci_core_instance.second_instance.private_ip
}

output "shapes" {

    value = data.oci_load_balancer_shapes.lb_shapes.shapes
  
}