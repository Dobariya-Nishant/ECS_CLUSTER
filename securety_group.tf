resource "aws_security_group" "task_sg" {
  count = length(var.tasks)

  name        = var.tasks[count.index].name
  description = "Security Group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.tasks[count.index].enable_public_http == true ? [1] : []
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP"
    }
  }

  dynamic "ingress" {
    for_each = var.tasks[count.index].enable_public_https == true ? [1] : []
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS"
    }
  }

  dynamic "ingress" {
    for_each = var.tasks[count.index].load_balancer_config != null ? var.tasks[count.index].load_balancer_config : []
    content {
      from_port       = ingress.value["container_port"]
      to_port         = ingress.value["container_port"]
      protocol        = "tcp"
      security_groups = [ingress.value["sg_id"]]
      description     = "load balancer security group"
    }
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = var.tasks[count.index].name
    }
  )
}
