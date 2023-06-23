

## vpc configurations
variable "cidr_block"{
  type = string
  default ="10.0.0.0/16"
}

variable "tags" {
  type = map
  default = {

    "Name" = "jeevan-view"
    "Env"  = "test"
    "terrform" = "true"
    "owner" = "jeevan"
  }
}

variable "vpc_tags" {
  type = map
  default = {}
}

variable "az" {
  type = list
  default = ["ap-southeast-1a","ap-southeast-1b","ap-southeast-1c"]
  
}

variable "public_subnet_cidr" {
  type = list(string)
  default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  }

variable "public_subnet_cidr_names" {
 type = list 
 default = ["public-1a", "public-1b", "public-1c"]
}


variable "app_subnet_cidr" {
  type = list
  default = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
  }

variable "app_subnet_cidr_names" {
 type = list 
 default = ["app-1a", "app-1b","app-1c"]
}


variable "db_subnet_cidr" {
  type = list
    default = ["10.0.7.0/24","10.0.8.0/24","10.0.9.0/24"]
  }

variable "db_subnet_cidr_names" {
 type = list 
 default = ["db-1a", "db-1b","db-1c"]
}

variable "igw" {
  type = map
  default = {"Name" = "jeevan-view"}
}

variable "public-Rt" {
  type = map
  default = {"Name" = "jeevan-view-public-subnets"}
}


variable "private-Rt" {
  type = map
  default = {"Name" = "jeevan-view-private-subnets"}
}


## nat configuration
variable "nat-eip" {
  type = map
  default = { "Name" = "jeevan-view-nat-eip"}
  
}

variable "nat_tag" {
  type = map
  default = { "Name" = "jeevan-view-nat"}
}


# name of web-servers
variable "web-servers" {
  type = list
  default = ["web1","web2","web-3"]
  

}
# name of db-servers
# variable "db-servers" {
#   type = list
#   default = ["db1","db2","db-3"]
  

# }



# name of key-pairs
variable "key_pair" {
  type = string
  default = "tf-master"
}


# KMS Configuration
variable "admin_iam_role" {
  type        = string
  description = "Admin IAM role"
  default     = "jeevan-view"
}

variable "kms-key" {
  type = map
  default = { "Name" = "jeevan-view",
   "Rotation" = "true", "owner" = "jeevan"} 
 

}

variable "web-ami_id" {
  type = string
  default = "ami-054c486632a4875d3"
}



##efs configuration
variable "efs_name" {
  type = string
  default = "jeevan-view"
}








