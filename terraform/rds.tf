
# ---------------------------------------------------------------------------------------------------------------------
# RDS DB SUBNET GROUP
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_db_subnet_group" "db-subnet-grp" {
  name        = "petclinic-db-sgrp"
  description = "Database Subnet Group"
  subnet_ids  = aws_subnet.private.*.id
}

# ---------------------------------------------------------------------------------------------------------------------
# RDS (MYSQL)
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_db_instance" "db" {
  identifier        = "petclinic"
  allocated_storage = 5
  engine            = "mysql"
  engine_version    = "5.7"
  port              = "3306"
  instance_class    = var.db_instance_type
  name              = var.db_name
  username          = var.db_user
  password          = data.aws_ssm_parameter.dbpassword.value
  availability_zone      = "${var.aws_region}a"
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.db-subnet-grp.id
  parameter_group_name   = "default.mysql5.7"
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    Name = "${var.stack}-db"
  }
}

output "db_host" {
  value = aws_db_instance.db.address
}

output "db_port" {
  value = aws_db_instance.db.port
}

output "db_url" {
  value = "jdbc:mysql://${aws_db_instance.db.address}/${var.db_name}"
}
