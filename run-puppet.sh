#!/bin/bash
set -e

cachedir="/var/cache/puppet-ubuntudesktop/"
age="$(( $(date +%s) - $(stat -c %Y $cachedir) ))"

if [ $age -gt $(( 3600 * 24 * 8 )) ];then
   rm -rvf "${cachedir?CACHEDIR}/*"
else
   echo "INFO: Cache not old enough, delete cachedir for reinstall: rm -rf ${cachedir?CACHEDIR}/*"
fi


set -x
cd /etc/puppetlabs/pxp-agent
sudo librarian-puppet install --verbose
sudo puppet apply \
   --modulepath /etc/puppetlabs/pxp-agent/modules/ \
   /etc/puppetlabs/pxp-agent/modules/ubuntudesktop/manifests/local.pp  --test $@
echo
