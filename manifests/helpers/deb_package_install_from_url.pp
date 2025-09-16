define ubuntudesktop::helpers::deb_package_install_from_url (
  String $pkg_name = $title,
  String $uri,
) {
  archive { "${ubuntudesktop::cachedir}/${title}.deb":
    source => $uri,
    cleanup => false,
    creates => "${ubuntudesktop::cachedir}/${title}.deb",
    provider         => 'wget',
    download_options => '--timestamping'
  }
  -> package { $pkg_name:
    provider => dpkg,
    ensure   => present,
    source   => "${ubuntudesktop::cachedir}/${title}.deb",
    require  => Archive["${ubuntudesktop::cachedir}/${title}.deb"],
  }
}
