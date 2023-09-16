define ubuntudesktop::helpers::deb_package_install_from_url (
  String $uri,
) {
  archive { "/tmp/${title}.deb":
    source => $uri,
  }
  package { $title:
    provider => dpkg,
    ensure   => latest,
    source   => "/tmp/${title}.deb",
    require  => Archive["/tmp/${title}.deb"]
  }
}