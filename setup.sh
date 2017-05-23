#!/bin/bash

SDIR="$(dirname $(readlink -f $0))"

set -x
apt update
apt install wget -y
mkdir /tmp/setup-ubuntu
cd /tmp/setup-ubuntu
wget -c https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
dpkg -i puppetlabs-release-pc1-xenial.deb
apt update
apt upgrade -y
apt dist-upgrade -y
apt install puppet-agent librarian-puppet git -y
apt autoremove -y
ln -snf /opt/puppetlabs/bin/puppet /usr/local/sbin/puppet
ln -snf $SDIR/Puppetfile /etc/puppetlabs/puppet/Puppetfile
cd /etc/puppetlabs/puppet/
librarian-puppet install --verbose
