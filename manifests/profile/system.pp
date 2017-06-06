# == Class: mscubuntudesktop::profile::system
#
# Setup my personal ubuntu desktop
#
# === Authors
#
# Marc Schoechlin <marc.schoechlin@256bit.org>
#
#

class mscubuntudesktop::profile::system {

  # Mount Options
  mount { '/':
    ensure  => 'mounted',
    device  => '/dev/mapper/ubuntu--vg-root',
    fstype  => 'ext4',
    options => 'defaults,noatime,nodiratime',
  }

  # Disable capslock
  augeas{ 'disable_capslock':
    context =>  '/files/etc/default/keyboard',
    changes =>  "set XKBOPTIONS 'ctrl:nocaps'",
    onlyif  =>  "match XKBOPTIONS not_include 'ctrl:nocaps'",
  }

  # Disable crash reporter
  augeas{ 'disable_apport':
    context =>  '/files/etc/default/apport',
    changes =>  'set enabled \'0\'',
  }

  # configure sudo
  file { '/etc/sudoers.d/':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
  }

  # Install a tiny script to update the system
  file { '/usr/local/sbin/ubuntu-update':
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => "puppet:///modules/${module_name}/ubuntu-update",
  }
  file { '/etc/sudoers.d/ubuntu-update':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "
     ${mscubuntudesktop::user} ALL = NOPASSWD:/usr/local/sbin/ubuntu-update
    "
  }
  file { '/etc/sudoers.d/puppet':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "
${mscubuntudesktop::user} ALL = NOPASSWD:/opt/puppetlabs/bin/puppet
    "
  }
  # Install a tiny script to update the system
  file { '/usr/sbin/passwd-sync':
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => "puppet:///modules/${module_name}/passwd-sync",
  }
  -> exec { "/usr/sbin/passwd-sync ${mscubuntudesktop::user} root set":
    user   => 'root',
    unless => "/usr/sbin/passwd-sync ${mscubuntudesktop::user} root check",
    path   => '/usr/bin:/usr/sbin:/bin',
  }

  # Apparmor
  package { 'apparmor-utils':
    ensure => installed,
  }

  # Disable the guest access
  file { '/etc/lightdm/lightdm.conf.d/50-no-guest.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => '
  [SeatDefaults]
  allow-guest=false
      '
    }
}
