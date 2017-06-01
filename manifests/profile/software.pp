# == Class: ubuntudesktop::profile::software
#
# Setup my personal ubuntu desktop
#
# === Authors
#
# Marc Schoechlin <marc.schoechlin@256bit.org>
#
#

class ubuntudesktop::profile::software {

#########################################################################
### STANDARD PACKAGES

  $packages = [ 'ubuntu-restricted-extras',
    'virtualenv',
    'wavemon',
    'wakeonlan',
    'w3m',
    'xalan',
    'xsel',
    'clipit',
    'icedax',
    'tagtool',
    'easytag',
    'id3tool',
    'lame',
    'nautilus-script-audio-convert',
    'libmad0',
    'mpg321',
    'libavcodec-extra',
    'libdvd-pkg',
    'p7zip-rar',
    'p7zip-full',
    'unace',
    'unrar',
    'zip',
    'unzip',
    'sharutils',
    'rar',
    'uudeview',
    'mpack',
    'arj',
    'cabextract',
    'file-roller',
    'flashplugin-installer',
    'a2ps',
    'ant',
    'screen',
    'dia',
    'dkms',
    'ncdu',
    'gimp',
    'gnuplot', 'gnuplot-qt',
    'graphviz',
    'hplip',
    'pidgin', 'pidgin-sipe',
    'remmina', 'remmina-plugin-rdp',
    'rsync',
    'enigmail',
    'default-jdk',
    'git', 'git-man', 'tig', 'diffutils', 'diffstat',
    'curl', 'wget',
    'htop',
    'iftop', 'iptraf-ng',
    'pv',
    'lsscsi',
    'sysstat',
    'traceroute',
    'net-tools',
    'tcpflow',
    'wireshark',
    'ding',
    'imagemagick',
    'ipcalc',
    'jq',
    'mysql-client',
    'ncftp',
    'ndiff',
    'pwgen',
    'puppet-lint',
    'texlive-base',
    'texlive-binaries',
    'texlive-extra-utils',
    'texlive-fonts-extra',
    'texlive-fonts-recommended',
    'texlive-fonts-recommended-doc',
    'texlive-font-utils',
    'texlive-generic-recommended',
    'texlive-lang-german',
    'texlive-latex-base',
    'texlive-latex-base-doc',
    'texlive-latex-extra',
    'texlive-latex-recommended',
    'texlive-latex-recommended-doc',
    'texlive-pictures',
    'texlive-pictures-doc',
    'texlive-pstricks',
    'texlive-pstricks-doc',
    'rtorrent',
    'scribus',
    'siege',
    'socat',
    'splint',
    'strace',
    'subversion',
    'devscripts', 'debhelper', 'build-essential', 'dh-make',
  ]

  package { $packages:
    ensure => installed,
  }


#########################################################################
### Nextcloud

  exec { 'add-apt-repository ppa:nextcloud-devs/client && apt-get update':
    user   => 'root',
    unless => "test -f /etc/apt/sources.list.d/nextcloud-devs-ubuntu-client-${::lsbdistcodename}.list",
    path   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
  }
  -> package { 'nextcloud-client':
    ensure => installed,
  }

#########################################################################
### Virtualbox

class { 'virtualbox':
}

#virtualbox::extpack { 'Oracle_VM_VirtualBox_Extension_Pack':
#    ensure           => present,
#    source           => 'http://download.virtualbox.org/virtualbox/5.1.22/Oracle_VM_VirtualBox_Extension_Pack-5.1.22-115126.vbox-extpack',
#    checksum_string  => '244e6f450cba64e0b025711050db3c43e6ce77e12cd80bcd08796315a90c8aaf',
#    follow_redirects => true,
#}


#########################################################################
### Docker

  class { '::docker':
    dns           => '8.8.8.8',
    version       => 'latest',
    ip_forward    => true,
    iptables      => true,
    ip_masq       => true,
    docker_users  => [ $::ubuntudesktop::user ],
    manage_kernel => false,
  }

  # TODO: check if there are ubuntu packages in future
  file { '/usr/local/sbin/docker-gc':
    owner          => 'root',
    group          => 'root',
    mode           => '0755',
    backup         => false,
    source         => 'https://raw.githubusercontent.com/spotify/docker-gc/master/docker-gc',
    checksum       => 'md5',
    checksum_value => '9d2a6feffab10e9bcea20c6c22bcebba',
  }

  file { '/etc/sudoers.d/docker-gc':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => "
     ${ubuntudesktop::user} ALL = NOPASSWD:/usr/local/sbin/docker-gc
    "
  }


#########################################################################
### OpenVPN

  package { [ 'openvpn', 'network-manager-openvpn', 'network-manager-openvpn-gnome', ]:
    ensure => installed,
  }

  file { '/etc/sudoers.d/openvpn':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => "
     ${ubuntudesktop::user} ALL = NOPASSWD:/usr/sbin/openvpn
    "
  }

#########################################################################
### VIM

  package { [ 'vim', 'vim-gtk3', 'vim-syntastic', 'vim-python-jedi', 'exuberant-ctags' ]:
    ensure => installed,
  }
  -> alternatives { 'editor':
    path => '/usr/bin/vim.basic',
  }

# TODO
#   exec { 'vim-addons -w install puppet':
#     user    => 'root',
#     unless  => 'vim-addons | grep -q installed',
#     path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
#   }

}
