# == Class: ubuntudesktop::profile::kernel
#
# Setup my personal ubuntu desktop
#
# === Authors
#
# Marc Schoechlin <marc.schoechlin@256bit.org>
#
#

class ubuntudesktop::aspect::kernel {

  sysctl { 'vm.swappiness':
    ensure  => present,
    value   => '0',
    comment => 'swappiness this control is used to define how aggressively the kernel swaps out anonymous memory relative to pagecache and other caches. Increasing the value increases the amount of swapping. The default value is 60.',
  }

  sysctl { 'vm.vfs_cache_pressure':
    ensure  => present,
    value   => '50',
    comment => 'vfs_cache_pressure this variable controls the tendency of the kernel to reclaim the memory which is used for caching of VFS caches, versus pagecache and swap. Increasing this value increases the rate at which VFS caches are reclaimed.',
  }

  sysctl { 'fs.file-max':
    ensure => present,
    value  => '65536',
  }

  # Allow perf tracing
  sysctl { 'kernel.perf_event_paranoid': ensure => present, value  => '-1', }

  sysctl { 'fs.inotify.max_user_watches':
    ensure => present,
    value  => '524288',
  }

  sysctl { 'kernel.dmesg_restrict':
    ensure => present,
    value  => '0',
  }

}
