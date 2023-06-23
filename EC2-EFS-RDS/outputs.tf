# output "db_private_ip" {
#   value = aws_instance.db[0].private_ip
# }

# output "web_private_ip" {
#   value = aws_instance.web[0].private_ip
# }

output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "efs_id" {
  value = aws_efs_file_system.efs.id
}