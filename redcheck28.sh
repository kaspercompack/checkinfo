#!/bin/bash
set -e
sudo bash -c 'cat >> /etc/apt/sources.list <<EOF
deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-extended/ 1.7_x86-64 astra-ce main contrib non-free
EOF'
sudo apt -y update
sleep 5
sudo apt -y install postgresql
sleep 5
sudo systemctl enable postgresql
sudo -u postgres psql <<EOF
CREATE ROLE redcheck WITH PASSWORD '12345' LOGIN CREATEDB SUPERUSER;
\q
EOF
sleep 5
sudo chmod 777 /etc/postgresql/14/main/postgresql.conf
sudo echo "listen_addresses = '192.168.0.18'" >> /etc/postgresql/14/main/postgresql.conf
sudo chmod 777 /etc/postgresql/14/main/pg_hba.conf
sudo echo host all redcheck 192.168.0.0/24 scram-sha-256 >> /etc/postgresql/14/main/pg_hba.conf
sudo systemctl restart postgresql
sudo ufw allow 5432/tcp
sleep 5
sudo tar -xvf /home/astra/Загрузки/redcheck-debian-repo-2.8.1.10341.tar.gz -C /usr/local/src
sudo apt-key add /usr/local/src/redcheck-debian-repo/PUBLIC-GPG-KEY-redcheck
echo "deb file:/usr/local/src/redcheck-debian-repo/ 1.7_x86-64 non-free dotnet" | sudo tee /etc/apt/sources.list.d/redcheck.list
sudo apt -y update
sudo apt -y install aspnetcore-runtime-6.0 redcheck-api redcheck-client redcheck-scan-service redcheck-sync-service redcheck-cleanup-service
sudo apt-get install python3-pip
sudo redcheck-bootstrap configure -c=all

#sudo altxmap -O --osscan-guess -T4 -oX nmap_os.xml 192.168.0.0/24
#import sys,xml.etree.ElementTree as ET, csv
#tree = ET.parse('nmap_os.xml')
#root = tree.getroot()
#with open('nmap_os.csv','w',newline='',encoding='utf-8') as f:
#    w = csv.writer(f)
#    w.writerow(['Host','CPE'])
#    for host in root.findall('host'):
#        Host = ''
#        for addr in host.findall('address'):
#            if addr.get('addrtype') == 'ipv4':
#                ip = addr.get('addr'); break
#        if not Host:
#            a = host.find('address')
#            Host = a.get('addr') if a is not None else ''
#        os_name = ''
#        os_elem = host.find('os')
#        if os_elem is not None:
#            om = os_elem.find('osmatch')
#            if om is not None:
#                os_name = om.get('name','')
#        w.writerow([Host, os_name])
#print('Saved nmap_os.csv')
