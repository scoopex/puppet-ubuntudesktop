define ubuntudesktop::install_helper(
  String $extra_args = "",
) {
  exec { "/opt/ubuntudesktop/helpers/${title} ${extra_args}":
    user   => 'root',
    unless => "/opt/ubuntudesktop/helpers/${title} check",
    logoutput => true,
    path   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
  }
}