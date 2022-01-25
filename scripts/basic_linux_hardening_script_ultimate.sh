#!/usr/bin/env bash

#update the system
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get autoremove
sudo apt-get autoclean

#Enable automatic updates
sudo apt-get install unattended-upgrades -y

#To disable the root account if needed
sudo passwd -l root

#Installing AppArmor
sudo apt install apparmor -y
sudo systemctl start apparmor

#Installing AV
sudo apt install clamav clamav-daemon -y
sudo systemctl stop clamav-freshclam
sudo freshclam
systemctl start clamav-freshclam
systemctl enable clamav-freshclam

#installing rootkit scanner
#sudo apt-get install rkhunter -y
#scan system for rootkits
#sudo rkhunter -C

#prevent root login from ssh
awk '$1=="PermitRootLogin"{foundLine=1; print "PermitRootLogin no"} $1!="PermitRootLogin"{print $0} END{if(foundLine!=1) print "PermitRootLogin no"}' /etc/ssh/sshd_config > /etc/ssh/sshd_config.tmp && mv /etc/ssh/sshd_config.tmp /etc/ssh/sshd_config
awk '$1=="LogLevel"{foundLine=1; print "LogLevel VERBOSE"} $1!="LogLevel"{print $0} END{if(foundLine!=1) print "LogLevel VERBOSE"}' /etc/ssh/sshd_config > /etc/ssh/sshd_config.tmp && mv /etc/ssh/sshd_config.tmp /etc/ssh/sshd_config
sudo service ssh restart


# Set the /tmp in the fstab.
#echo "/tmpdisk	/tmp	ext4	loop,nosuid,noexec,rw	0 0" >> sudo /etc/fstab
#echo "/vartmpdisk  /var/tmp    ext4    loop,nosuid,noexec,rw   0 0" >> sudo /etc/fstab
#sudo mount -o remount /tmp
#sudo mount -o remount /var/tmp

#sudo cp -prf /var/tmpold/* /var/tmp/
#sudo rm -rf /var/tmpold/


#install firewall
sudo apt-get install ufw

name=$(hostname)

sudo ufw allow ssh
sudo ufw allow 3389

if [[ "$name" = *"portal"* ]]; then 
    sudo ufw allow 135
    sudo ufw allow 139
    sudo ufw allow 445
    sudo ufw allow 1433
    sudo ufw allow 5985
fi

#gallery, drony, keycloak, nextcloud, lims, gitlab, blog, www
if [[ "$name" = *"gallery"* ]] || [[ "$name" = *"drony"* ]] || [[ "$name" = *"keycloak"* ]] || [[ "$name" = *"nextcloud"* ]] || [[ "$name" = *"lims"* ]] || [[ "$name" = *"gitlab"* ]] || [[ "$name" = *"blog"* ]] || [[ "$name" = *"www"* ]] || [[ "$name" = *"portal"* ]] || [[ "$name" = *"med"* ]]; then
    sudo ufw allow http
    sudo ufw allow 443

elif [[ "$name" = *"dns"* ]]; then
    sudo ufw allow 25
    sudo ufw allow 53
    sudo ufw allow 465
    sudo ufw allow 587
fi


#sudo ufw allow from x.x.x.x to x.x.x.x
sudo ufw default deny
echo "y" | sudo ufw enable

sudo useradd -m -p $(perl -e 'print crypt("Pa55w0rdAoG!", "salt"),"\n"') linux_user
sudo usermod -aG sudo linux_user
awk '$1=="%sudo"{foundLine=1; print "%sudo ALL=(ALL:ALL) ALL"} $1!="%sudo"{print $0} END{if(foundLine!=1) print "%sudo ALL=(ALL:ALL) ALL"}' /etc/sudoers > /etc/sudoers.tmp && mv /etc/sudoers.tmp /etc/sudoers

sudo rm -- $0
sudo reboot