terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.74.0"
    }
  }
}

provider "aws" {
  profile = "default"
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

resource "aws_ecs_cluster" "cv-as-service" {
  name = "cv-as-service-iaac"
}

data "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "cv-as-service" {
  family = "cv-as-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn = data.aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn = data.aws_iam_role.ecsTaskExecutionRole.arn
  container_definitions = jsonencode([
    {
      name      = "cv-as-service"
      image     = "public.ecr.aws/g6k1i6y8/cv-as-service:latest"
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "/ecs/manuel-task-cv-as-service",
            "awslogs-region": "us-east-1",
            "awslogs-stream-prefix": "ecs"
        }
      }
    }  
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_default_vpc" "default" {
}


data "aws_subnet_ids" "default" {
  vpc_id = aws_default_vpc.default.id
}

resource "aws_ecs_service" "cv-as-service" {
  name            = "cv-as-service"
  cluster         = aws_ecs_cluster.cv-as-service.id
  task_definition = aws_ecs_task_definition.cv-as-service.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets = data.aws_subnet_ids.default.ids
    assign_public_ip = "true"
  }
}
