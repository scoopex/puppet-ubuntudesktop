#!/bin/bash
set -x
sudo puppet apply --modulepath /etc/puppetlabs/puppet/modules/ /etc/puppetlabs/puppet/modules/ubuntudesktop/manifests/localrun.pp  --test $@

