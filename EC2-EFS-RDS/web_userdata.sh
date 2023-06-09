#! /bin/bash
sleep 60
sudo yum -y update 
sudo yum -y upgrade
DBPassword=$(aws ssm get-parameters --region ap-southeast-1 --names "/ALBDemo/Wordpress/DBPassword" --with-decryption --query "Parameters[0].Value")
DBPassword=$(echo "$DBPassword" | sed -e 's/^"//' -e 's/"$//')
DBRootPassword=$(aws ssm get-parameters --region ap-southeast-1 --names "/ALBDemo/Wordpress/DBRootPassword" --with-decryption --query "Parameters[0].Value")
DBRootPassword=$(echo "$DBRootPassword" | sed -e 's/^"//' -e 's/"$//')
DBUser=$(aws ssm get-parameters --region ap-southeast-1 --names "/ALBDemo/Wordpress/DBUser" --query "Parameters[0].Value")
DBUser=$(echo "$DBUser" | sed -e 's/^"//' -e 's/"$//')
DBName=$(aws ssm get-parameters --region ap-southeast-1 --names "/ALBDemo/Wordpress/DBName" --query "Parameters[0].Value")
DBName=$(echo "$DBName" | sed -e 's/^"//' -e 's/"$//')
DBEndpoint=$(aws ssm get-parameters --region ap-southeast-1 --names "/ALBDemo/Wordpress/DBEndpoint" --query "Parameters[0].Value")
DBEndpoint=$(echo "$DBEndpoint" | sed -e 's/^"//' -e 's/"$//')
EFSFSID=$(aws ssm get-parameters --region ap-southeast-1 --names "/ALBDemo/Wordpress/EFSFSID" --query Parameters[0].Value)
EFSFSID=$(echo $EFSFSID | sed -e 's/^"//' -e 's/"$//')
sudo yum install -y  httpd wget 
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2 
sudo amazon-linux-extras install epel -y 
sudo yum -y install amazon-efs-utils
sudo systemctl enable httpd 
sudo systemctl start httpd 
mkdir -p /var/www/html/wp-content 
chown -R ec2-user:apache /var/www/ 
echo -e "$EFSFSID:/ /var/www/html/wp-content efs _netdev,tls,iam 0 0" >> /etc/fstab 
mount -a -t efs defaults
sudo wget http://wordpress.org/latest.tar.gz -P /var/www/html/
cd /var/www/html 
sudo tar -zxvf latest.tar.gz 
sudo cp -rvf wordpress/* . 
sudo rm -R wordpress 
sudo rm latest.tar.gz
sudo cp ./wp-config-sample.php ./wp-config.php 
sudo sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php 
sudo sed -i "s/'username_here'/'$DBUser'/g" wp-config.php 
sudo sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php
sudo sed -i "s/'localhost'/'$DBEndpoint'/g" wp-config.php
sudo usermod -a -G apache ec2-user 
sudo chown -R ec2-user:apache /var/www 
sudo chmod 2775 /var/www 
sudo find /var/www -type d -exec chmod 2775 {} \; 
sudo find /var/www -type f -exec chmod 0664 {} \;


