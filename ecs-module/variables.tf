/**************************************
*
* Terraform variables definition
*
***************************************/

variable "aws_region" {
  type = string
  description = "AWS region"  
  default = "us-west-2"
}

variable "app_name" {
  type = string
  description = "Application name"  
  default = "my-ecs-app"
}

/////////////////////////////////////////
// Variables CIDR Security Group
/////////////////////////////////////////

variable "vpc_cidr" {
  type = string
  description = "VPC IPv4 CIDR blocks"
  default = "10.0.0.0/16"
}

variable "admin_sources_cidr" {
  type = list(string)
  description = "List of IPv4 CIDR blocks from which to allow admin access"
  default = ["0.0.0.0/0"]
}

variable "app_sources_cidr" {
  type = list(string)
  description = "List of IPv4 CIDR blocks from which to allow application access"
  default = ["0.0.0.0/0"]
}

/////////////////////////////////////////
// Variables ECS
/////////////////////////////////////////

variable "cluster_runner_type" {
  type = string
  description = "EC2 instance type of ECS Cluster Runner"
  default = "t3.medium"
}

//cluster with 2 instances by default

variable "cluster_runner_count" {
  type = string
  description = "Number of EC2 instances for ECS Cluster Runner" 
  default = "2"
}

variable "aws_key_pair_name" {
  type = string
  description = "AWS key pair name"
  default = "kruger"
}
/////////////////////////////////////////
// Variables Docker 
/////////////////////////////////////////

variable "docker_image_name" {
  type = string
  description = "Docker image name" 
  default = "my-nginx-ecs"
}

// by default is a docker image (with nginx + phyton + webpage) in ECR
variable "ecr_app_image" {
  type = string
  description = "Docker image name in ECR"
  default = "704246131615.dkr.ecr.us-west-2.amazonaws.com/my-nginx-ecs:latest"  
}

/////////////////////////////////////////
// Variables Nginx App Container
///////////////////////////////////////// 

variable "nginx_app_name" {
  type = string
  description = "Name of Application Container"
  default = "mynginx"
}

variable "nginx_app_port" {
  description = "Port exposed by the Docker image to redirect traffic to"
  default = 80
}

variable "nginx_app_count" {
  description = "Number of Docker containers to run"
  default = 2
}


/*
* Supported value for the task CPU and memory in your task definition 
*
* CPU value 	Memory value (MiB)
* 256 (.25 vCPU) 	512 (0.5GB), 1024 (1GB), 2048 (2GB)
* 512 (.5 vCPU) 	1024 (1GB), 2048 (2GB), 3072 (3GB), 4096 (4GB)
* 1024 (1 vCPU) 	2048 (2GB), 3072 (3GB), 4096 (4GB), 5120 (5GB), 6144 (6GB), 7168 (7GB), 8192 (8GB)
* 2048 (2 vCPU) 	Between 4096 (4GB) and 16384 (16GB) in increments of 1024 (1GB)
* 4096 (4 vCPU) 	Between 8192 (8GB) and 30720 (30GB) in increments of 1024 (1GB) 
*/

variable "nginx_fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default = "512"
}

variable "nginx_fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default = "1024"
}

/////////////////////////////////////////
// Utilities
/////////////////////////////////////////

variable "separator" {
  type = string
  description = "Separator character" 
  default = "\",\""
}

variable "app_environment" {
  type = string
  description = "Application environment"
  default = "Dev"
}

