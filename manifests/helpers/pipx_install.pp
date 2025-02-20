define ubuntudesktop::helpers::pipx_install(
  String $extra_args = "",
) {
  exec { "pipx install ${title} ${extra_args}":
    user   => $ubuntudesktop::user,
    path   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
  }
}
