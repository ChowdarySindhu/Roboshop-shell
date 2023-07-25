LOG=${log}
echo -e "\e[31m create catalogue service \e[0m"

cp catalogue.service /etc/systemd/system/catalogue.service &>>${log}

echo ">>>>>> create mongodb repos <<<<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo ">>>>>> installing nodesource <<<<<<<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
yum install nodejs -y &>>${log}
echo ">>>>>> useradd roboshop <<<<<<<<<<<"
useradd roboshop &>>${log}
echo -e "\e[33m removing the content and reinstalling \e[0m"
rm -rf /app &>>${log}

echo ">>>>>> creating app directory <<<<<<<<<<<"
mkdir /app &>>${log}
echo ">>>>>> downloading roboshop artifacts <<<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}

echo -e "\e[34m unziping the files \e[0m"
cd /app
unzip  /tmp/catalogue.zip &>>${log}
cd /app

echo ">>>>>> installing dependencies <<<<<<<<<<<"
npm install &>>${log}

echo -e "\e[34m installing mongodb \e[0m"
yum install mongodb-org-shell -y &>>${log}

echo ">>>>>> loading catalogue schema <<<<<<<<<<<"
mongo --host mongodb.sgdevrobo.online </app/schema/catalogue.js &>>${log}
echo ">>>>>> start catalogue service <<<<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
