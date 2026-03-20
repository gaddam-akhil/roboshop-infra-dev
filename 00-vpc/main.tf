module "vpc" {
    #source = "../../terraform-aws-vpc"
    source = "git::https://github.com/gaddam-akhil/terraform-aws-vpc.git?ref=main"
    project = var.project_name
    environment = var.env
    Is_peering_required = true
}
