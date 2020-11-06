
# ---------------------------------------------------------------------------------------------------------------------
# ALB
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_alb" "alb" {
  name            = "${var.stack}-alb"
  # subnets         = "${aws_subnet.public.*.id}"
  subnets         = aws_subnet.public.*.id
  # security_groups = ["${aws_security_group.alb-sg.id}"]
  security_groups = [aws_security_group.alb-sg.id]
}

# ---------------------------------------------------------------------------------------------------------------------
# ALB TARGET GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_alb_target_group" "trgp" {
  name        = "${var.stack}-tgrp"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
}

# ---------------------------------------------------------------------------------------------------------------------
# ALB LISTENER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.trgp.id
    type             = "forward"
  }
}

output "alb_address" {
  value = aws_alb.alb.dns_name
}