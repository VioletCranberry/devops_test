module "ec2_generic" {

    source            = "../../../../modules/ec2_generic"  
    service_name      = "ervcp"
    instance_count    = 1

    instance_type     = "t2.micro"
    availability_zone = var.availability_zone
    instance_key      = var.master_key
    environment       = var.environment

    security_groups = [
        "${var.environment}-common",
        "${var.environment}-frontend"
    ]

    instance_tags = {
        "Name"        = "${var.environment}-ervcp"
    }
}
