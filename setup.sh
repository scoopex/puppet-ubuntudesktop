#!/bin/bash

SDIR="$(dirname $(readlink -f $0))"
REL="$(lsb_release -c -s)"


set -x
apt update
apt install wget -y
mkdir /tmp/setup-ubuntu
cd /tmp/setup-ubuntu
wget -c https://apt.puppetlabs.com/puppetlabs-release-pc1-${REL}.deb
dpkg -i puppetlabs-release-pc1-${REL}.deb
apt update
apt upgrade -y
apt dist-upgrade -y
apt install puppet-agent librarian-puppet git -y
apt autoremove -y
ln -snf /opt/puppetlabs/bin/puppet /usr/local/sbin/puppet
ln -snf $SDIR/Puppetfile /etc/puppetlabs/puppet/Puppetfile
ln -snf $SDIR /etc/puppetlabs/puppet/modules/ubuntudesktop

cd /etc/puppetlabs/puppet/
librarian-puppet install --verbose

