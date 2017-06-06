#!/bin/bash
set -x
sudo puppet apply --modulepath /etc/puppetlabs/puppet/modules/ /etc/puppetlabs/puppet/modules/mscubuntudesktop/manifests/localrun.pp  --test $@

