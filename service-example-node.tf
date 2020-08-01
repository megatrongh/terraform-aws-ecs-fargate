
resource "aws_ecs_service" "example_ecs_service" {
  name                               = "example_ecs_service"
  cluster                            = aws_ecs_cluster.example_ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.example_task_def.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.example_sg_ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.example_alb_target_group.arn
    container_name   = "example_container"
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}


