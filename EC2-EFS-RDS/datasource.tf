# data "aws_ami" "amazon_linux_2" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-*-hvm-2.0.????????-x86_64-gp2"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }

#   filter {
#     name   = "ena-support"
#     values = ["true"]
#   }

#   owners = ["amazon"]
# }

# output "ami_id" {
#   value = data.aws_ami.amazon_linux_2.id
# }



data "aws_caller_identity" "current" {}