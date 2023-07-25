echo -e "\e[31m create catalogue service \e[0m"

cp catalogue.service /etc/systemd/system/catalogue.service

echo ">>>>>> create mongodb repos <<<<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo ">>>>>> installing nodesource <<<<<<<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
echo ">>>>>> useradd roboshop <<<<<<<<<<<"
useradd roboshop
echo ">>>>>> creating app directory <<<<<<<<<<<"
mkdir /app
echo ">>>>>> downloading roboshop artifacts <<<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "\e[34m unziping the files \e[0m"
cd /app
unzip /tmp/catalogue.zip
cd /app

echo ">>>>>> installing dependencies <<<<<<<<<<<"
npm install

echo -e "\e[34m installing mongodb \e[0m"
yum install mongodb-org-shell -y

echo ">>>>>> loading catalogue schema <<<<<<<<<<<"
mongo --host mongodb.sgdevrobo.online </app/schema/catalogue.js
echo ">>>>>> start catalogue service <<<<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
