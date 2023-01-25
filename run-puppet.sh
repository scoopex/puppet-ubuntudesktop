#!/bin/bash
set -x
set -e

cd /etc/puppetlabs/puppet/
sudo librarian-puppet install --verbose
sudo puppet apply --modulepath /etc/puppetlabs/puppet/modules/ /etc/puppetlabs/puppet/modules/ubuntudesktop/manifests/local.pp  --test $@

