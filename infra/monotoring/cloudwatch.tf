hcl
# Monitoreo básico con CloudWatch
resource "aws_cloudwatch_log_group" "backend_logs" {
  name              = "/ecs/hotel-backend"
  retention_in_days = 14
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "HighCPUBackend"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 120
  statistic           = "Average"
  threshold           = 80

  alarm_description = "Alarma cuando el uso de CPU supera el 80%"
  actions_enabled   = true

  dimensions = {
    ClusterName = aws_ecs_cluster.hotel_cluster.name
  }

  alarm_actions = []
}