resource "aws_db_instance" "main" {
  allocated_storage    = 10
  db_name              = "demodb"
  identifier           = "jeevan-view"
  engine               = "mysql"
  engine_version       = "8.0.28"
  instance_class       = "db.t3.micro"
  username             = aws_ssm_parameter.dbuser.value
  password             = aws_ssm_parameter.dbpassword.value
  db_subnet_group_name = aws_db_subnet_group.database.name
  
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.db.id]
}

