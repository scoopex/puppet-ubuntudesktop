class profile::kernel {

   sysctl { "vm.swappiness":
        ensure  => present,
        value   => "0",
        comment => "Do not swap pages until it is not really needed",
   }

}
