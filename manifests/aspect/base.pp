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
}