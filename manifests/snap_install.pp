define ubuntudesktop::snap_install(
  String $extra_args = "",
) {
  exec { "snap install ${title} ${extra_args}":
    user   => 'root',
    unless => "snap list $title",
    path   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
  }
}
