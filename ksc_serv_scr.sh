#!/bin/bash
#не забыть снять решетку с /etc/hosts
set -e
echo "Шаг 1"
sudo apt install mariadb-server <<EOF
y
EOF
sleep 20
echo "Шаг 2" 
sudo /usr/bin/mysql_secure_installation <<EOF
xxXX1234
n
y
y
y
y
EOF
sudo bash -c 'cat > /etc/mysql/my.cnf <<EOF
[mysqld]
sort_buffer_size=10M
join_buffer_size=100M
join_buffer_space_limit=300M
join_cache_level=8
tmp_table_size=512M
max_heap_table_size=512M
key_buffer_size=200M
innodb_buffer_pool_size=100M
innodb_thread_concurrency=20
innodb_flush_log_at_trx_commit=0
innodb_lock_wait_timeout=300
max_allowed_packet=32M
max_connections=151
max_prepared_stmt_count=12800
table_open_cache=60000
table_open_cache_instances=4
table_definition_cache=60000
EOF'
sudo mysql -u root <<EOF
CREATE USER 'kscadmin' IDENTIFIED BY 'xxXX1234';
GRANT ALL PRIVILEGES ON *.* TO 'kscadmin';
CREATE DATABASE kscdb;
exit
EOF
sudo systemctl restart mariadb.service
sleep 10
sudo adduser ksc <<EOF
xxXX1234
xxXX1234




y
EOF
sudo groupadd kladmins
sudo gpasswd -a ksc kladmins
sudo usermod -g kladmins ksc
sudo apt install ./ksc64_15.1.0-11795_amd64.deb
sleep 5

sudo /opt/kaspersky/ksc64/lib/bin/setup/postinstall.pl
#
#q
#y
#y
#1
#192.168.0.17
#kladmins
#ksc
#ksc
#1
#127.0.0.1
#3306
#kscdb
#kscadmin
#xxXX1234
#ksc
#xxXX1234
#xxXX1234

sleep 5 
sudo bash -c 'cat > /etc/ksc-web-console-setup.json <<EOF
{
"address": "127.0.0.1",
"port": 8080,
"trusted": "127.0.0.1|13299|/var/opt/kaspersky/klnagent_srv/1093/cert/klserver.cer|KSC Server",
"acceptEula": true
}
EOF'
sudo apt install ./ksc-web-console-15.1.523.x86_64.deb
sleep 5
sudo systemctl restart KSC*
sleep 5
sudo apt reinstall ./ksc-web-console-15.1.523.x86_64.deb
sleep 5
sudo systemctl restart KSC*
sleep 5
sudo dpkg -i ./klnagent64_15.1.0-20748_amd64.deb
sleep 10

sudo /opt/kaspersky/klnagent64/lib/bin/setup/postinstall.pl
#y
#192.168.0.17
#
#
#y
#1
sleep 5

sudo dpkg -i ./kesl_12.1.0-1508_amd64.deb
sleep 5

sudo /opt/kaspersky/kesl/bin/kesl-setup.pl
#n
#
#
#
#q
#y
#y
#n
sudo apt install lshw

#
#
#
#Дальше вход на 127.0.0.1:8080, настройка КСЦ, создание групп, перемещения уже определенного устройства в управляемые и настройка политик(для этого нужен плагин).