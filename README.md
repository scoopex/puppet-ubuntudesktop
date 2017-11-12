Overview
=========

I use this repo/code to setup my personal workstation/laptop system.
Puppet is executed in serverless mode using "puppet apply".

This project is GNU GPLv3 (see LICENCE file). Contributions or forks are welcome.

 Usage
=========

 * install ubuntu
    * activate disk encryption with LVM (not homedir-enrcyryption)    
    * select all additional software components
 * clone repo
   ```
   sudo apt install git
   mkdir -p ~/src/github
   cd ~/src/github
   git clone https://github.com/scoopex/puppet-mscubuntudesktop.git
   git clone git@github.com:scoopex/puppet-mscubuntudesktop.git # alternative way
   cd ~/src/github/puppet-mscubuntudesktop
   ```

 * Install Puppet infrastructure 
   ```
   ./setup.sh
   ```

 * Execute setup
   ```
   ./run-puppet.sh
   ```

Develop
=========

```
bundle install
rake
./run-puppet.sh --noop
```

# Run testsetup in kitchen

 * Execute testsetup in kitchen
   See: https://github.com/scoopex/puppet-kitchen_template
 * Start Virtualbox and access display
 * Login with default password
   * Login: marc
   * Password: install

Open TODOs
==========

 * Migrate to Puppet 5
 * Do not use my own virtualbox release
   * https://github.com/scoopex/puppet-virtualbox
   * https://github.com/voxpupuli/puppet-virtualbox/issues/57
 * Enable docker automated install 
 * Add a custom/local configuration
 * Rollout ms-env 
 * Add the correct Virtualbox apt keys
 * Use gconftool to provision specific settings
   ```
   gconftool-2  --recursive-list /
   ```
 * Autostart & Configure: clipit
 * Set Terminal Settings
   * Scrolling
   * Hotkeys
 * Configure Nextcloud
 * Configure Backup
 * Testing
   * Puppet-Lint
   * RSPec Tests
   * Serverspec Tests
