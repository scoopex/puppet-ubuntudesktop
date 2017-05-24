# Overview

I use this repo/code to setup my personal system.

This project is GNU GPLv3 (see LICENCE file).

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

# Open TODOs

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
