module "ecr_repo" {
    source   = "../../../../modules/ecr"

    environment = var.environment
    ecr_name    = "ervcp_repo"
    role_access = ["drone-Role"]
}
