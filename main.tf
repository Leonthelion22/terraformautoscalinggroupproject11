terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

#Creating Subnets with  your Default VPC
resource "aws_launch_template" "terraec2" {
  name          = "terraec2"
  image_id      = "ami-04681163a08179f28"
  instance_type = "t2.micro"
  user_data     = base64encode(file("terrauserdata.sh"))

}
# Auto Scaling Group creation
resource "aws_autoscaling_group" "terra_asg" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 2
  max_size           = 5
  min_size           = 2
#launch template
  launch_template {
    id      = aws_launch_template.terraec2.id
    version = "$Latest"
  }
}

#Creating Subnets
data "aws_subnets" "terrasubnet" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = [var.subnet_one, var.subnet_two]
  }
}
#Create Security Group For Server
resource "aws_security_group" "terrasecg" {
  name        = "terrasecg"
  description = "Allow traffic on necessary ports"
  vpc_id      = var.vpc_id

  tags = {
    Name = "terrasecg"
  }

  #Allow port 8080
  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow port 443
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  #Allow port 22
  ingress {
    protocol    = "tcp"
    self        = true
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["66.108.66.189/32"] #Grab your own IP address
  }  #allow port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating S3 Bucket backend
terraform {
  backend "s3" {
    bucket = "terrabucket2211"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}