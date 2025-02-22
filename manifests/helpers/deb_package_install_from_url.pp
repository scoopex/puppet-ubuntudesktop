define ubuntudesktop::helpers::deb_package_install_from_url (
  String $pkg_name = $title,
  String $uri,
) {
  archive { "/tmp/${title}.deb":
    source => $uri,
    cleanup => false,
    creates => "/tmp/${title}.deb",
  }
  package { $pkg_name:
    provider => dpkg,
    ensure   => present,
    source   => "/tmp/${title}.deb",
    require  => Archive["/tmp/${title}.deb"]
  }
}