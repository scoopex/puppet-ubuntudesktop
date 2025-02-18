define ubuntudesktop::helpers::snap_uninstall(
  String $extra_args = "",
) {
  exec { "snap remove ${title} ${extra_args}":
    user   => 'root',
    unless => "snap list $title",
    path   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
  }
}
