#!/bin/bash

SDIR="$(dirname $(readlink -f $0))"
REL="jammy"
PUPPET_REL="8"

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
sudo rm -rf /var/tmp/puppet*

sudo wget -P /var/tmp/ http://apt.puppetlabs.com/puppet${PUPPET_REL}-release-${REL}.deb
sudo dpkg -i /var/tmp/puppet${PUPPET_REL}-release-${REL}.deb
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt install puppet-agent librarian-puppet git r10k -y

sudo grep -q include_legacy_facts /etc/puppetlabs/puppet/puppet.conf || sudo bash -c 'echo "include_legacy_facts=true" >> /etc/puppetlabs/puppet/puppet.conf'
sudo apt autoremove -y
sudo ln -snf /opt/puppetlabs/bin/puppet /usr/local/sbin/puppet
sudo ln -snf ${SDIR}/Puppetfile /etc/puppetlabs/pxp-agent/Puppetfile
sudo mkdir -p /etc/puppetlabs/pxp-agent/modules
sudo ln -snf ${SDIR} /etc/puppetlabs/pxp-agent/modules/ubuntudesktop

sudo systemctl disable puppet.service
sudo systemctl stop puppet.service
