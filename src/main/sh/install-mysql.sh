#!/bin/bash
source /tmp/expect-mysql-secure-install.sh

IS_INSTALL_MYSQL=0
function check_mysql_install(){
MYSQL_STATUS=$(dpkg -s mysql-server-8.0)
if [[ $MYSQL_STATUS == *"install ok installed"* ]]; then
  echo "mysql already installed, skip installation"
  IS_INSTALL_MYSQL=1
fi
}
function check_debconf_utils(){
  MYDEBCONF_STATUS=$(dpkg -s debconf-utils)
  if [[ $DEBCONF_STATUS == *"install ok installed"* ]];then
  echo "already installed so skip instalation"
  else
  sudo apt install -y debconf-utils
  fi
}
function install_mysql_server(){
  check_debconf_utils
  echo "mysql-server-8.0 mysql-server/root_password_again password root" | sudo debconf-set-selections
  echo "mysql-server-8.0 mysql-server/root_password password root" | sudo debconf-set-selections
  export DEBAIN_FRONTEND="noninteractive"
  sudo apt install -y mysql-server-8.0
  local MYSQL_INSTALL_STATUS=$?
  $MYSQL_INSTALL_STATUS
}
function checkExpectandInstall(){
  EXPECT_INSTALL_STATUS=$(dpkg -s expect)
  if [[ $EXPECT_INSTALL_STATUS == *"install ok installed"* ]]; then
    echo "expect already installed, so skipping installation"
  else
    sudo apt install -y expect
  fi
}

#main block
sudo apt update -y
check_mysql_install
if [ $IS_INSTALL_MYSQL -eq 0 ];then
  echo "info:mysql not found,installing sql"
  install_mysql_server  
  INSTALL_MYSQL_STATUS=$?
  if [ $INSTALL_MYSQL_STATUS=0 ]; then
     echo "installation success"
     checkExpectandInstall
     mysqlSecureInstall
  else
    echo "error! during installation of sql check logs"
  fi
else
   echo "already installed so skipping"
fi