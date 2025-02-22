define ubuntudesktop::helpers::krew_install(
  String $extra_args = "",
) {
  exec { "kubectl krew install ${title} ${extra_args}":
    user   => $ubuntudesktop::user,
    environment => ["HOME=${ubuntudesktop::homedir}"],
    unless => "kubectl krew info '${title}'",
    path   => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:${ubuntudesktop::homedir}/.krew/bin",
  }
}
