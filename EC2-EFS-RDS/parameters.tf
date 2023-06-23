resource "aws_ssm_parameter" "dbuser" {
  name        = "/ALBDemo/Wordpress/DBUser"
  description = "Wordpress Database User"
  type        = "String"
  data_type   = "text"
  value       = "dbuser"
}

resource "aws_ssm_parameter" "dbname" {
  name        = "/ALBDemo/Wordpress/DBName"
  description = "Wordpress Database Name"
  type        = "String"
  data_type   = "text"
  value       = "demodb"
}

resource "aws_ssm_parameter" "dbendpoint" {
  name        = "/ALBDemo/Wordpress/DBEndpoint"
  description = "Wordpress Endpoint Name"
  type        = "String"
  data_type   = "text"
  value       = aws_db_instance.main.endpoint
}

resource "aws_ssm_parameter" "dbpassword" {
  name        = "/ALBDemo/Wordpress/DBPassword"
  description = "DB Password"
  type        = "SecureString"
  value       = "jeevan123" 
  key_id      = aws_kms_key.kms-key.id
}

resource "aws_ssm_parameter" "dbrootpassword" {
  name        = "/ALBDemo/Wordpress/DBRootPassword"
  description = "DBRoot Password"
  type        = "SecureString"
  value       = "jeevan123" 
  key_id      = aws_kms_key.kms-key.id
}

resource "aws_ssm_parameter" "efsfsid" {
  name        = "/ALBDemo/Wordpress/EFSFSID"
  description = "ID for Wordpress Content"
  type        = "String"
  value       = aws_efs_file_system.efs.id
}
