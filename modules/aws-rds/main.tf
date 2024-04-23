# Creating DB subnet group for RDS Instances
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.sg-name
  subnet_ids = [data.aws_subnet.private-subnet1.id, data.aws_subnet.private-subnet2.id]
}

# Creating AWS RDS instance for MongoDB
resource "aws_db_instance" "rds" {
  identifier            = var.db-name 
  allocated_storage     = 10
  db_name               = var.db-name
  engine                = "mysql"
  engine_version        = "8.0"  
  instance_class        = "db.t3.micro"
  username              = var.username
  password              = var.password 
  skip_final_snapshot   = true
  port                  = 3306 
  db_subnet_group_name  = aws_db_subnet_group.db_subnet_group.name  
  vpc_security_group_ids  = [data.aws_security_group.db-sg.id]
  # make sure rds manual password chnages is ignored
  lifecycle {
     ignore_changes = [password]
   }
  tags = {
    Name = var.rds-name
  }
  depends_on = [aws_db_subnet_group.db_subnet_group] 
}
