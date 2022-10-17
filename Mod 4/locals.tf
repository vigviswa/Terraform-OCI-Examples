locals {

    common_tags = {

        learning_source = var.learning_source
        module = "$(var.learning_source) _ $(var.learning_module)"
        dns_label = "$(output.vcndns)"

    }
  
}