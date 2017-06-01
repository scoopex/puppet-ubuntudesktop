# Overview

I use this repo/code to setup my personal system.

This project is GNU GPLv3 (see LICENCE file).

# Setup my workstation

 * Clone repo
   ```
   sudo bash
   apt install git
   cd /root
   git clone https://github.com/scoopex/puppet-ubuntudesktop.git
   git clone git@github.com:scoopex/puppet-ubuntudesktop.git # alternative way
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

# Develop

```
bundle install
rake
```

# Open TODOs

 * Check exitcodes of all setup.sh commands
 * Rollout ms-env 
 * Sellect correct puppet install for ubuntu 17.04 
 * Add the correct Virtualbox apt keys
 * Add a custom/local configuration
 * Set root password to same password like "marc"
 * Use gconftool to provision specific settings
   ```
   gconftool-2  --recursive-list /
   ```
 * Autostart & Configure: clipit
 * Autostart & Configure: pidgin
 * Set Terminal Settings
   * Scrolling
   * Hotkeys
 * Configure Nextcloud
 * Configure Backup
 * Setup ms-env
 * Testing
   * Puppet-Lint
   * RSPec Tests
   * Serverspec Tests
