#!/bin/bash

SDIR="$(dirname $(readlink -f $0))"
REL="$(lsb_release -c -s)"

if [ "$(lsb_release -c -s)" = "zesty" ];then
  REL="yakkety"
fi

set -x
set -e
sudo apt update
sudo apt install wget -y
sudo rm -rf /tmp/setup-ubuntu/
sudo mkdir -p /tmp/setup-ubuntu
sudo wget https://apt.puppetlabs.com/puppetlabs-release-pc1-${REL}.deb
sudo dpkg -i puppetlabs-*.deb
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt install puppet-agent librarian-puppet git -y
sudo apt autoremove -y
sudo ln -snf /opt/puppetlabs/bin/puppet /usr/local/sbin/puppet
sudo ln -snf $SDIR/Puppetfile /etc/puppetlabs/puppet/Puppetfile
sudo ln -snf $SDIR /etc/puppetlabs/puppet/modules/ubuntudesktop

cd /etc/puppetlabs/puppet/
sudo librarian-puppet install --verbose
