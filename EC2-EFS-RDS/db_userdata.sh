#! /bin/bash
sleep 60
sudo yum -y update 
sudo yum -y upgrade
sleep 60
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
sudo yum install -y mariadb-server wget 
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2 
sudo amazon-linux-extras install epel -y 
sudo systemctl enable mariadb 
sudo systemctl start mariadb

# sudo echo "CREATE DATABASE $DBName;" >> /tmp/db.setup 
# sudo echo "CREATE USER '$DBUser'@'%' IDENTIFIED BY '$DBPassword';" >> /tmp/db.setup 
# sudo echo "GRANT ALL ON $DBName.* TO '$DBUser'@'localhost';" >> /tmp/db.setup 
# sudo echo "FLUSH PRIVILEGES;" >> /tmp/db.setup 
# sudo mysqladmin -u root password $DBRootPassword
sudo sh -c 'echo "CREATE DATABASE $DBName;" >> /tmp/db.setup'
sudo sh -c 'echo "CREATE USER '\''$DBUser'\''@'\''%'\'' IDENTIFIED BY '\''$DBPassword'\'';" >> /tmp/db.setup'
sudo sh -c 'echo "GRANT ALL ON $DBName.* TO '\''$DBUser'\''@'\''%'\'';" >> /tmp/db.setup'
sudo sh -c 'echo "FLUSH PRIVILEGES;" >> /tmp/db.setup'
sudo mysqladmin -u root password "$DBRootPassword"
sudo mysql -u root --password=$DBRootPassword < /tmp/db.setup
sudo rm /tmp/db.setup