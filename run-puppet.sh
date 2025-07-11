#!/bin/bash
set -e

cachedir="/var/cache/puppet-ubuntudesktop/"
age="$(( $(date +%s) - $(stat -c %Y $cachedir) ))"
sdir="$(dirname $(readlink -f $0))"

if [ $age -gt $(( 3600 * 24 * 8 )) ];then
   echo "sudo rm -rf ${cachedir?}/*"
   sudo rm -rvf "${cachedir?}/*"
else
   echo "INFO: Cache not old enough, delete cachedir for reinstall:"
   echo "sudo rm -rf ${cachedir?CACHEDIR}/*"
fi

echo 
set -x
cd /etc/puppetlabs/pxp-agent
#sudo librarian-puppet install --verbose
sudo bash -c "PATH='$HOME/.local/share/gem/ruby/3.3.0/bin/:$PATH' r10k puppetfile install --puppetfile=Puppetfile -v"
sudo ln -snf ${sdir} /etc/puppetlabs/pxp-agent/modules/ubuntudesktop
sudo puppet apply \
   --modulepath /etc/puppetlabs/pxp-agent/modules/ \
   ${sdir}/manifests/local.pp  --test $@
echo
