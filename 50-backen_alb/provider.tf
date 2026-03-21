terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.33.0" #terraform aws version
    }
}


backend "s3" {
    bucket         = "gaddam-remote-state-dev" # Replace with your bucket name
    key            = "remote-state-dev-sg-backend_alb" # Path within the bucket
    region         = "us-east-1" # Replace with your AWS region
    encrypt        = true
    use_lockfile   = true # <--- Enables native S3 locking
  }


}

provider "aws" {
  region = "us-east-1"
}


