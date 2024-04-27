#!/bin/bash
set -x
set -e

cd /etc/puppetlabs/pxp-agent
sudo librarian-puppet install --verbose
sudo puppet apply \
   --modulepath /etc/puppetlabs/pxp-agent/modules/ \
   /etc/puppetlabs/pxp-agent/modules/ubuntudesktop/manifests/local.pp  --test $@

