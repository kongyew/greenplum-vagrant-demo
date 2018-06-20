#!/usr/bin/env bash

echo "========================================"


sudo add-apt-repository ppa:greenplum/db
apt-get update
apt-get --yes --force-yes upgrade
apt-get --yes --force-yes install unzip sudo software-properties-common vim less
apt-get --yes --force-yes install greenplum-db-oss

# Reference : https://launchpad.net/~greenplum/+archive/ubuntu/db
echo "loading /opt/gpdb/greenplum_path.sh"
source /opt/gpdb/greenplum_path.sh

#cp $GPHOME/docs/cli_help/gpconfigs/gpinitsystem_singlenode .

echo "====Add gpadmin user and group===="
/usr/sbin/groupadd gpadmin
/usr/sbin/useradd  -g gpadmin -m  gpadmin
echo "gpadmin:pivotal"|chpasswd 
echo "gpadmin        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers 

chown -R gpadmin: /home/gpadmin
mkdir -p /gpdata/master /gpdata/segments 

ssh-keygen -f /root/.ssh/id_rsa -N ''
cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys
mkdir -p /home/gpadmin/.ssh 
cat /root/.ssh/id_rsa.pub >> /home/gpadmin/.ssh/authorized_keys
cp /root/.ssh/id_rsa /root/.ssh/id_rsa.pub /home/gpadmin/.ssh/ 
chown gpadmin:gpadmin -R /home/gpadmin/.ssh
echo "gpdbsne" > /tmp/gpdb-hosts
gpssh-exkeys -f /tmp/gpdb-hosts
cp /opt/configs/gpinitsystem_singlenode /tmp 


chmod 777 /tmp/gpinitsystem_singlenode 
chown -R gpadmin: /gpdata
echo "127.0.0.1 gpdbsne gpdbsne.localdomain" >> /etc/hosts 
su -l gpadmin -c "echo 'source /opt/gpdb/greenplum_path.sh' >> /home/gpadmin/.bashrc" 
su -l gpadmin -c "echo 'export MASTER_DATA_DIRECTORY=/gpdata/master/gpseg-1' >> /home/gpadmin/.bashrc" 


su -l gpadmin -c "source /opt/gpdb/greenplum_path.sh;gpssh-exkeys -f /tmp/gpdb-hosts"
echo "==== gpinitsystem ===="
su -l gpadmin -c "source /opt/gpdb/greenplum_path.sh;gpinitsystem -a -c /tmp/gpinitsystem_singlenode" 
cp  /opt/configs/limits.conf.add /etc/security/limits.conf 
cp  /opt/configs/sysctl.conf.add /etc/security/sysctl.conf 



locale-gen en_US.UTF-8 

apt-get clean all 
rm -f /etc/service/sshd/down 
#/etc/my_init.d/00_regen_ssh_host_keys.sh 






echo "========================================"
# set vim as default editor and create alias
echo "" >> /root/.bashrc
echo "export GPDB_=vim" >> /root/.bashrc
echo "" >> /root/.bashrc
echo "alias vi=vim" >> /root/.bashrc
echo "" >> /root/.bashrc


sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock

