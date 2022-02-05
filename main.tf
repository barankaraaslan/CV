terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.74.0"
    }
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_ecrpublic_repository" "cv-as-service" {
  provider = aws.us_east_1
  repository_name = "cv-as-service"
}

resource "aws_ecrpublic_repository" "cv-builder" {
  provider = aws.us_east_1
  repository_name = "cv-builder"
}

resource "aws_ecs_cluster" "foo" {
  name = "white-hart"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}