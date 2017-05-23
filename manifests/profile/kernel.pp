class ubuntudesktop::profile::kernel {

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
        ensure  => present,
        value   => '65536',
   }


}
