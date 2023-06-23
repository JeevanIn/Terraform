resource "aws_key_pair" "main" {
  key_name   = var.key_pair
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDyNqHmlpwIt7dQuSmGdTROTHyMRys3cX0vzwvEt0/NrG1XCcT3Y0XZXpSkSpFO5e18ixEJ5WqaW6fH53er3o+XeX/jMr0iYva526sIffcZWlUcjw04VNVwLRUmY8rmznt5/jPRyqkoBztj1UpVIDyJmIg8BN4FvpyLrpoZYSAQsToCYB0KOfzrXA22Z7XPXVr76gZfkf0Qrhl36khkG/wwjpYxFzQrteTacFLPX9L5gmfeEC7SxDythTZrszZwJCGw19HMHQik4BR3qA7YhwAKhtn0lJ7Gfa3oFAuVtB9DASw1G2Nex/KHf+OoX+UdDkTHe0DFNpGqnsTyhEtx3175VBvlGixfv6Wbya5GZFQ3fL3xYJopQ8ZQMuvPgrwX/js2+kcn7JS1iW78mPSbEdSrzgYB6DbDA5mdDSSofIC+wIP+b0K7ddUTa4OZbObsLb4OgNQqfeRxWW76LWHFms5ietAl7pVCgeY7cy7XFLG3ELVLYr+6ZpOvROi7YrvzH6c= dsiram@INBLR1MAC02ZK0P.local"
}


resource "aws_instance" "web" {
  ami  = var.web-ami_id
  instance_type = "t2.micro"
  count = 1
  subnet_id = aws_subnet.main[count.index].id
  tags = { "Name"=  var.web-servers[count.index]}
  vpc_security_group_ids = [aws_security_group.web.id]
  associate_public_ip_address = true
  user_data = file("web_userdata.sh")
  iam_instance_profile = aws_iam_instance_profile.wordpress_instance_profile.name
  

  source_dest_check           = false
  key_name                    = var.key_pair

  # root disk
   root_block_device {
    volume_size           = "8"
    volume_type           = "gp2"
    encrypted             = true
    kms_key_id            = aws_kms_key.kms-key.id
    delete_on_termination = true


}
}


# resource "aws_instance" "db" {
#   ami  = var.web-ami_id
#   instance_type = "t2.micro"
#   count = 1
#   subnet_id = aws_subnet.db[count.index].id
#   tags = { "Name"=  var.db-servers[count.index]}
#   vpc_security_group_ids = [aws_security_group.db.id]
#   associate_public_ip_address = true
#   user_data = file("db_userdata.sh")
#   iam_instance_profile = aws_iam_instance_profile.wordpress_instance_profile.name
  

#   source_dest_check           = false
#   key_name                    = var.key_pair

#   # root disk
#    root_block_device {
#     volume_size           = "8"
#     volume_type           = "gp2"
#     encrypted             = true
#     kms_key_id            = aws_kms_key.kms-key.id
#     delete_on_termination = true


# }
# }



