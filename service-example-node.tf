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
   security_groups  = [aws_security_group.example_sg_ecs_tasks.id]
   subnets          = aws_subnet.private.*.id
 }
 
 load_balancer {
   target_group_arn = var.aws_alb_target_group_arn
   container_name   = "${var.name}-container-${var.environment}"
   container_port   = var.container_port
 }
 
 lifecycle {
   ignore_changes = [task_definition, desired_count]
 }
}