resource "aws_iam_role" "wordpress_role" {
  name               = "WordpressRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
    "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess"
  ]
   # Add the KMS decrypt permission
  inline_policy {
    name = "KMSDecryptAccess"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "kms:Decrypt",
      "Resource": "*"
    }
  ]
}
EOF
  }
}

resource "aws_iam_instance_profile" "wordpress_instance_profile" {
  name  = "WordpressInstanceProfile"
  role = aws_iam_role.wordpress_role.name
}
resource "aws_ssm_parameter" "cw_agent_config" {
  name        = "CWAgentConfig"
  description = "CloudWatch Agent Configuration"
  type        = "String"
  value = <<EOF
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/secure",
            "log_group_name": "/var/log/secure",
            "log_stream_name": "{instance_id}"
          },
          {
            "file_path": "/var/log/httpd/access_log",
            "log_group_name": "/var/log/httpd/access_log",
            "log_stream_name": "{instance_id}"
          },
          {
            "file_path": "/var/log/httpd/error_log",
            "log_group_name": "/var/log/httpd/error_log",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  },
  "metrics": {
    "append_dimensions": {
      "AutoScalingGroupName": "$${aws:AutoScalingGroupName}",
      "ImageId": "$${aws:ImageId}",
      "InstanceId": "$${aws:InstanceId}",
      "InstanceType": "$${aws:InstanceType}"
    },
    "metrics_collected": {
      "collectd": {
        "metrics_aggregation_interval": 60
      },
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_iowait",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "metrics_collection_interval": 60,
        "resources": ["*"],
        "totalcpu": false
      },
      "disk": {
        "measurement": [
          "used_percent",
          "inodes_free"
        ],
        "metrics_collection_interval": 60,
        "resources": ["*"]
      },
      "diskio": {
        "measurement": [
          "io_time",
          "write_bytes",
          "read_bytes",
          "writes",
          "reads"
        ],
        "metrics_collection_interval": 60,
        "resources": ["*"]
      },
      "mem": {
        "measurement": ["mem_used_percent"],
        "metrics_collection_interval": 60
      },
      "netstat": {
        "measurement": [
          "tcp_established",
          "tcp_time_wait"
        ],
        "metrics_collection_interval": 60
      },
      "statsd": {
        "metrics_aggregation_interval": 60,
        "metrics_collection_interval": 10,
        "service_address": ":8125"
              },
              "swap": {
                "measurement": [
                  "swap_used_percent"
                ],
                "metrics_collection_interval": 60
              }
            }
          }
        }
 }
 EOF
}
