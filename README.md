# Overview

I use this repo/code to setup my personal system.

# Setup my workstation

 * Clone repo
   ```
   sudo bash
   apt install git
   cd /root
   git clone  git@github.com:scoopex/puppet-ubuntudesktop.git
   cd /root/puppet-ubuntudesktop
   ```

 * Install Puppet infrastructure
   ```
   ./setup.sh
   ```

 * Execute setup
   ```
   puppet apply --modulepath /etc/puppetlabs/puppet/modules/ /etc/puppetlabs/puppet/modules/ubuntudesktop/manifests/localrun.pp  --test
   ```
