nodejs(){
LOG=${log}
echo -e "\e[31m create ${component} service \e[0m"

cp ${component}.service /etc/systemd/system ${component}.service &>>${log}

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
curl -o /tmp ${component}.zip https://roboshop-artifacts.s3.amazonaws.com ${component}.zip &>>${log}

echo -e "\e[34m unziping the files \e[0m"
cd /app
unzip  /tmp ${component}.zip &>>${log}
cd /app

echo ">>>>>> installing dependencies <<<<<<<<<<<"
npm install &>>${log}

echo -e "\e[34m installing mongodb \e[0m"
yum install mongodb-org-shell -y &>>${log}

echo ">>>>>> loading ${component} schema <<<<<<<<<<<"
mongo --host mongodb.sgdevrobo.online </app/schema ${component}.js &>>${log}
echo ">>>>>> start ${component} service <<<<<<<<<<<"
systemctl daemon-reload
systemctl enable ${component}
systemctl restart ${component}
}