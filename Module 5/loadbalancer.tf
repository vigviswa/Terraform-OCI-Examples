
data "oci_load_balancer_shapes" "lb_shapes" {

    compartment_id = oci_identity_compartment.viswaterraform.id

}

data "oci_load_balancer_policies" "policy" {

    compartment_id = oci_identity_compartment.viswaterraform.id
  
}

resource "oci_load_balancer_load_balancer" "test_load_balancer" {
    #Required
    compartment_id = oci_identity_compartment.viswaterraform.id
    display_name = "LoadBalancerTerraform"
    shape = data.oci_load_balancer_shapes.lb_shapes.shapes[5].name
    subnet_ids = [oci_core_subnet.Public.id]
    is_private = false

    shape_details {

        maximum_bandwidth_in_mbps = 100
        minimum_bandwidth_in_mbps = 10
    }

}

resource "oci_load_balancer_backend_set" "test_backend_set" {

    health_checker {

      protocol = "TCP"
      port = "22"
      retries = "3"
      interval_ms = "10000"
      timeout_in_millis = "3000"
      return_code = "200"

    }

    load_balancer_id = oci_load_balancer_load_balancer.test_load_balancer.id
    name = "TestBackend"
    policy = data.oci_load_balancer_policies.policy.policies[1].name

}

resource "oci_load_balancer_backend" "bckendfirst" {

    backendset_name = oci_load_balancer_backend_set.test_backend_set.name
    ip_address = oci_core_instance.first_instance.private_ip
    load_balancer_id = oci_load_balancer_load_balancer.test_load_balancer.id
    port = 22
  
}

resource "oci_load_balancer_backend" "bckendsec" {

    backendset_name = oci_load_balancer_backend_set.test_backend_set.name
    ip_address = oci_core_instance.second_instance.private_ip
    load_balancer_id = oci_load_balancer_load_balancer.test_load_balancer.id
    port = 22
  
}

resource "oci_load_balancer_listener" "listener" {

    default_backend_set_name = oci_load_balancer_backend_set.test_backend_set.name
    load_balancer_id = oci_load_balancer_load_balancer.test_load_balancer.id
    name = "ListenerTerraform"
    port = 22
    protocol = "TCP"
  
}