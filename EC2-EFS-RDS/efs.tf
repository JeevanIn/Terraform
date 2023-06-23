resource "aws_efs_file_system" "efs" {
  creation_token = var.efs_name
  encrypted      = true
  #kms_key_id     = aws_kms_key.kms-key.id  # Optional: If you want to use a specific KMS key for encryption
  
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"  # Optional: Modify based on your requirements
  }
}

resource "aws_efs_mount_target" "mount_target" {
  count             = length(var.app_subnet_cidr)
  file_system_id    = aws_efs_file_system.efs.id
  subnet_id         = element(aws_subnet.app[*].id, count.index)
  security_groups   = [aws_security_group.efs.id]
}