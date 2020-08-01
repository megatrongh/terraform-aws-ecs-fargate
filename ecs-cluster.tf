resource "aws_ecs_cluster" "example_ecs_cluster" {
  name = "example_ecs_cluster"
}

resource "aws_cloudwatch_log_group" "example_cloudwatch_logger" {
  name = "example_cloudwatch_logger"
}

resource "aws_ecs_task_definition" "example_task_def" {
  family                   = "example-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions    = <<EOF
  [
    {
      "name": "example_container",
      "image": "${var.account_ecr}.dkr.ecr.${var.region}.amazonaws.com/example_app:latest",
      "portMappings": [
        {
          "protocol"       : "tcp",
          "containerPort": ${var.container_port},
          "hostPort"     : ${var.host_port}
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "${var.region}",
          "awslogs-group": "example-logs",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
  EOF
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "ecs_task_role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs_task_execution_role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

data "aws_iam_policy_document" "example_policy_document" {
  statement {
    effect    = "Allow"
    actions   = ["sts:GetCallerIdentity"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "example_task_policy" {
  name   = "example_task_policy"
  policy = data.aws_iam_policy_document.example_policy_document.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.example_task_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
