func_appreq(){
  log=/tmp/roboshop.log
  echo -e "\e[31m useradd roboshop \e[0m"
  useradd roboshop &>>${log}
  echo -e "\e[33m removing the content and reinstalling \e[0m"
  rm -rf /app &>>${log}

  echo -e "\e[31m creating app directory \e[0m"
  mkdir /app &>>${log}
  echo -e "\e[31m downloading roboshop artifacts \e[0m"
  curl -o /tmp ${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}

  echo -e "\e[34m unziping the files \e[0m"
  cd /app
  unzip  /tmp/${component}.zip &>>${log}
  cd /app
}

func_nodejs(){
  log=/tmp/roboshop.log
echo -e "\e[31m create ${component} service \e[0m"

cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

echo -e "\e[31m create mongodb repos \e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[31m installing nodesource \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
yum install nodejs -y &>>${log}

func_appreq

echo -e "\e[31m installing dependencies \e[0m"
npm install &>>${log}

echo -e "\e[34m installing mongodb \e[0m"
yum install mongodb-org-shell -y &>>${log}

echo -e "\e[31m loading catalogue schema \e[0m" | tee -a /tmp/roboshop.log
mongo --host mongodb.sgdevrobo.online </app/schema/${component}.js &>>${log}

echo -e "\e[31m start ${component} service \e[0m"
systemctl daemon-reload
systemctl enable ${component}
systemctl restart ${component}
}

func_java(){
  log=/tmp/roboshop.log
  echo -e "\e[31m start ${component} service \e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  echo -e "\e[31m installing maven \e[0m"
  yum install maven -y &>>${log}
  fun_appreq
  echo -e "\e[34m cleaning maven package \e[0m"
  mvn clean package &>>${log}
  echo -e "\e[34m moving the ${component} files \e[0m"
  mv target/${component}-1.0.jar ${component}.jar &>>${log}
  echo -e "\e[34m uinstalling mysql files \e[0m"
  yum install mysql -y &>>${log}
  echo -e "\e[34m loading the schema files \e[0m"
  mysql -h mysql.sgdevrobo.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}

}