#!/bin/bash
set -x
set -e

cd /etc/puppet/
sudo librarian-puppet install --verbose
sudo puppet apply --modulepath /etc/puppet/modules/ /etc/puppet/modules/ubuntudesktop/manifests/local.pp  --test $@

