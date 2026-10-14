class ubuntudesktop::aspect::base (){
  file { "${ubuntudesktop::cachedir}":
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
  file { "${ubuntudesktop::cachedir}/user":
    ensure  => 'directory',
    owner   => "${ubuntudesktop::user}",
    group   => 'users',
    mode    => '0755',
  }

  file { '/etc/cron.d/home-download-cleanup':  
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "
* */3 * * * ${ubuntudesktop::user} find /home/${ubuntudesktop::user}/Downloads -maxdepth 1 -type f -mtime +30  -exec rm -rvf {} + 2>&1|logger -t home-download-cleanup
      "
   }

}


