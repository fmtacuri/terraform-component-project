/**************************************
*
* Terraform Project Main configuration
*
***************************************/

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

# Create a bucket AWS S3
resource "aws_s3_bucket" "s3_example" {
  bucket = "bucket-flugel"
  acl    = "private" # or can be "public-read"
  tags   = {
    Name        = "Flugel"
    Environment = "Dev"
    Owner       = "InfraTeam"
  }
  versioning {
    enabled = true
  }
}

#  Create a AWS EC2 Instance
resource "aws_instance" "ec2_example" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"
  tags = {
    Name        = "Flugel"
    Environment = "Dev"
    Owner       = "InfraTeam"
  }
}

# variables for automation testing
output "bucket_id" {
  value = trimspace(aws_s3_bucket.s3_example.id)
}

output "instance_id" {
  value = trimspace(aws_instance.ec2_example.tags.Name)
}


/////////////////////////////////////
// Amazon ECS configuration
/////////////////////////////////////

module "ecs_main" {
  source             = "../ecs-module/"

  app_name           = "my-ecs-app"
  app_environment    = "Dev"
  aws_region         = "us-west-2"
  app_sources_cidr   = ["0.0.0.0/0"]
  admin_sources_cidr = ["0.0.0.0/0"]
  aws_key_pair_name  = "kruger"
  ecr_app_image      = "704246131615.dkr.ecr.us-west-2.amazonaws.com/my-nginx-ecs:latest"
}

output "nginx_dns_lb" {
  description = "DNS load balancer"
  value       = module.ecs_main.nginx_dns_lb 
}
