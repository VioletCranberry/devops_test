module "ec2_generic" {

  source         = "../../../../modules/ec2_generic"
  service_name   = "drone"
  instance_count = 1

  instance_type = "t2.micro"

  availability_zone = var.availability_zone
  instance_key      = var.master_key
  environment       = var.environment

  security_groups = [
    "${var.environment}-drone",
    "${var.environment}-common",
    "${var.environment}-k3s"
  ]

  instance_tags = {
    "Environment" = var.environment
  }

}
