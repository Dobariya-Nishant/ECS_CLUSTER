resource "aws_security_group" "task_sg" {
  count       = length(var.tasks)
  name        = var.tasks[count.index].name
  description = "Security Group"

  dynamic "ingress" {
    for_each = var.tasks[count.index].enable_public_access == true && var.tasks[count.index].enable_http == true ? [1] : []
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP"
    }
  }

  dynamic "ingress" {
    for_each = var.tasks[count.index].enable_public_access == true && var.tasks[count.index].enable_https == true ? [1] : []
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS"
    }
  }

  dynamic "ingress" {
    for_each = try(var.tasks[count.index].lb_sg_id != null && var.tasks[count.index].enable_http == true, false) ? [1] : []
    content {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      security_groups = [var.tasks[count.index].lb_sg_id]
      description     = "Allow HTTP from LB SG"
    }
  }

  dynamic "ingress" {
    for_each = try(var.tasks[count.index].lb_sg_id != null && var.tasks[count.index].enable_https == true, false) ? [1] : []
    content {
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      security_groups = [var.tasks[count.index].lb_sg_id]
      description     = "Allow HTTPS from LB SG"
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
