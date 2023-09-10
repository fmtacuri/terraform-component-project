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
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create a bucket AWS S3
resource "aws_s3_bucket" "s3_example" {
  bucket = "my-ups-bucket-${local.s3-sufix}"
  tags = {
    Name = "my_ups_bucket-${local.s3-sufix}"
  }
}

#  Create a AWS EC2 Instance
resource "aws_instance" "ec2_example" {
  ami           = "ami-01c647eace872fc02"
  instance_type = "t2.micro"
  tags = {
    Name = "Flugel"
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
  aws_region         = "us-east-1"
  app_sources_cidr   = ["0.0.0.0/0"]
  admin_sources_cidr = ["0.0.0.0/0"]
  aws_key_pair_name  = "upskey"
  ecr_app_image      = "679343794938.dkr.ecr.us-east-1.amazonaws.com/tesis-ups:latest"
}

output "nginx_dns_lb" {
  description = "DNS load balancer"
  value       = module.ecs_main.nginx_dns_lb
}

resource "random_string" "sufijo-s3" {
  length  = 8
  special = false
  upper   = false
}

locals {
  s3-sufix = "ups-${random_string.sufijo-s3.id}"
}

variable "access_key" {}

variable "secret_key" {}