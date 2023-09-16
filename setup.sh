#!/bin/bash

SDIR="$(dirname $(readlink -f $0))"
REL="jammy"

set -x
set -e

sudo apt update
sudo apt install wget -y

sudo rm -rf /tmp/setup-ubuntu/
mkdir /tmp/setup-ubuntu
cd /tmp/setup-ubuntu


sudo apt-get purge puppet* hiera* -y 
sudo rm -rf /etc/puppet*
sudo apt-get autoremove -y
sudo -rf /var/tmp/puppet*
sudo wget -P /var/tmp/ http://apt.puppetlabs.com/puppet6-release-$REL.deb
sudo dpkg -i /var/tmp/puppet6-release-$REL.deb
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt install puppet-agent librarian-puppet git -y
sudo apt autoremove -y
sudo ln -snf /opt/puppetlabs/bin/puppet /usr/local/sbin/puppet
sudo ln -snf $SDIR/Puppetfile /etc/puppet/Puppetfile
sudo mkdir -p /etc/puppet/modules
sudo ln -snf $SDIR /etc/puppet/modules/ubuntudesktop

sudo systemctl disable puppet.service
sudo systemctl stop puppet.service
