echo -e "\e[31m create catalogue service \e[0m"

cp catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log

echo ">>>>>> create mongodb repos <<<<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo ">>>>>> installing nodesource <<<<<<<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log
yum install nodejs -y &>>/tmp/roboshop.log
echo ">>>>>> useradd roboshop <<<<<<<<<<<"
useradd roboshop &>>/tmp/roboshop.log
echo -e "\e[33m removing the content and reinstalling \e[0m"
rm -rf /app &>>/tmp/roboshop.log

echo ">>>>>> creating app directory <<<<<<<<<<<"
mkdir /app &>>/tmp/roboshop.log
echo ">>>>>> downloading roboshop artifacts <<<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log

echo -e "\e[34m unziping the files \e[0m"
cd /app
unzip  /tmp/catalogue.zip &>>/tmp/roboshop.log
cd /app

echo ">>>>>> installing dependencies <<<<<<<<<<<"
npm install &>>/tmp/roboshop.log

echo -e "\e[34m installing mongodb \e[0m"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

echo ">>>>>> loading catalogue schema <<<<<<<<<<<"
mongo --host mongodb.sgdevrobo.online </app/schema/catalogue.js &>>/tmp/roboshop.log
echo ">>>>>> start catalogue service <<<<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
