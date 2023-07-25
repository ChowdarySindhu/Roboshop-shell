echo ">>>>>>>>>> create catalogue service <<<<<<<<<<<<<<<<<<"

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

echo ">>>>>> unzip the files <<<<<<<<<<<"
cd /app
unzip /tmp/catalogue.zip
cd /app

echo ">>>>>> installing dependencies <<<<<<<<<<<"
npm install

echo ">>>>>> installing mongodb client <<<<<<<<<<<"
yum install mongodb-org-shell -y

echo ">>>>>> loading catalogue schema <<<<<<<<<<<"
mongo --host mongodb.sgdevrobo.online </app/schema/catalogue.js
echo ">>>>>> start catalogue service <<<<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
