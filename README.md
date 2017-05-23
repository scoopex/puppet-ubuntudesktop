# Setup my workstation

 * Clone repo
   ```
   sudo bash
   cd /root
   git clone  git@github.com:scoopex/puppet-ubuntudesktop.git
   ```

 * Install Puppet infrastructure
   ```
   cd /root/puppet-ubuntudesktop
   ./setup.sh
   ln -snf /root/puppet-ubuntudesktop /etc/puppetlabs/puppet/modules/ubuntudesktop
   puppet apply /etc/puppetlabs/puppet/modules/ubuntudesktop/manifests/localrun.pp
   ```

 * Execute setup
   ```
   cd /root/puppet-ubuntudesktop
   ln -snf /root/puppet-ubuntudesktop /etc/puppetlabs/puppet/modules/ubuntudesktop
   puppet apply --modulepath /etc/puppetlabs/puppet/modules/ /etc/puppetlabs/puppet/modules/ubuntudesktop/manifests/localrun.pp  --test
   ```
