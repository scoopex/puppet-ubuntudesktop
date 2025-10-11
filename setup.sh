#!/bin/bash

SDIR="$(dirname $(readlink -f $0))"

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

# https://github.com/OpenVoxProject/openvox/pkgs/rubygems/openvox

sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt install git r10k ruby-rubygems -y
sudo apt install augeas-tools libaugeas0 ruby-augeas -y
sudo apt autoremove -y
sudo gem install openvox --version "8.23.1" 
#sudo grep -q include_legacy_facts /etc/puppetlabs/puppet/puppet.conf || sudo bash -c 'echo "include_legacy_facts=true" >> /etc/puppetlabs/puppet/puppet.conf'
