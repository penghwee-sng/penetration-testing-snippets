#!/usr/bin/env bash

sudo apt-get install cifs-utils samba -y
sudo mount -t cifs -o user=samba,password=P@55w0rd,vers=2.1 //fs/Public /mnt/local_share
sudo mkdir /mnt/local_share/$HOSTNAME
rm -- $0