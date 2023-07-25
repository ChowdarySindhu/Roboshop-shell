cp mysql.repo /etc/yum.repos.d/mysql.repo
yum module disable mysql -y
yum install mysql-community-server -y

mysql_secure_installation --set-root-pass sindhujagutha
systemctl enable mysqld
systemctl restart mysqld