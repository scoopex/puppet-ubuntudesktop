#!/bin/bash
set -e

module_dir="/opt/puppetlabs/puppet/modules"
cachedir="/var/cache/puppet-ubuntudesktop/"
age="$(( $(date +%s) - $(stat -c %Y $cachedir) ))"
sdir="$(dirname $(readlink -f $0))"

if ! [ -f $cachedir ] || [ $age -gt $(( 3600 * 24 * 8 )) ];then
   echo "sudo rm -rf ${cachedir?}/*"
   sudo rm -rvf "${cachedir?}/*"
else
   echo "INFO: Cache not old enough, delete cachedir for reinstall:"
   echo "sudo rm -rf ${cachedir?CACHEDIR}/*"
fi

echo 
set -x
sudo mkdir -p $module_dir
sudo bash -c "r10k puppetfile install --puppetfile=Puppetfile -v --moduledir=/opt/puppetlabs/puppet/modules"
sudo ln -snf ${sdir} $module_dir/ubuntudesktop
sudo puppet apply \
   --modulepath $module_dir \
   ${sdir}/manifests/local.pp  --test $@
echo
