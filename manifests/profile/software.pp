# == Class: mscubuntudesktop::profile::software
#
# Setup my personal ubuntu desktop
#
# === Authors
#
# Marc Schoechlin <marc.schoechlin@256bit.org>
#
#

class mscubuntudesktop::profile::software (
  Array[String] $packages_additional = [],
  Array[String] $packages_exclude = [],
  Boolean $nextcloud = true,
  Boolean $virtualbox = true,
  Boolean $docker = true,
  Boolean $openvpn = true,
  Boolean $vim = true,
  Boolean $spotify = true,
){

#########################################################################
### STANDARD PACKAGE SOURCES

apt::source { "archive.ubuntu.com-${::lsbdistcodename}":
  location => 'http://archive.canonical.com/ubuntu',
  repos    => "${::lsbdistcodename} partner",
}

#########################################################################
### STANDARD PACKAGES

  $default_packages = [ 'ubuntu-restricted-extras',
    'libterm-readline-gnu-perl',
    'whois',
    'linphone',
    'apache2-utils',
    'siege',
    'inotify-tools',
    'highlight',
    'grip',
    'wcalc',
    'battery-stats',
    'ruby-bundler',
    'geeqie',
    'firefox', 'firefox-locale-de',
    'cifs-utils',
    'tree',
    'chromium-browser',
    'keepass2',
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
    'git', 'git-man', 'tig', 'diffutils', 'diffstat', 'myrepos',
    'shutter',
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
    'texlive-base', 'texlive-binaries', 'texlive-extra-utils', 'texlive-fonts-extra', 'texlive-fonts-recommended',
    'texlive-fonts-recommended-doc', 'texlive-font-utils', 'texlive-generic-recommended', 'texlive-lang-german',
    'texlive-latex-base', 'texlive-latex-base-doc', 'texlive-latex-extra', 'texlive-latex-recommended',
    'texlive-latex-recommended-doc', 'texlive-pictures', 'texlive-pictures-doc', 'texlive-pstricks', 'texlive-pstricks-doc',
    'rtorrent',
    'scribus', 'inkscape',
    'siege',
    'socat',
    'splint',
    'strace',
    'subversion',
    'devscripts', 'debhelper', 'dh-make',
    'ldap-utils',
    'python-pip', 'virtualenv', 'build-essential', 'libssl-dev', 'libffi-dev', 'python-dev', 'pychecker', 'pyflakes', 'pylint', 'ipython3', 'python-autopep8',
    'python3-pylint-flask', 'python3-pyflakes', 'python3-flake8', 'pylint3',
    'python3-nose', 'python3-nose-cov', 'python3-nose-json', 'python3-nose-parameterized', 'python3-nose-timer', 'python3-nose-yanc',
    'unity-tweak-tool',
  ]

  $install_packages = $default_packages + $packages_additional
  $install_packages_with_excludes = $install_packages - $packages_exclude

  ensure_resource('package', $install_packages , {'ensure' => 'present'})

#########################################################################
### Nextcloud

  if ($nextcloud){
    exec { 'add-apt-repository ppa:nextcloud-devs/client && apt-get update':
      user    => 'root',
      unless  => "test -f /etc/apt/sources.list.d/nextcloud-devs-ubuntu-client-${::lsbdistcodename}.list",
      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
      creates => "/etc/apt/sources.list.d/nextcloud-devs-ubuntu-client-${::lsbdistcodename}.list",
    }
    -> package { 'nextcloud-client':
      ensure => installed,
    }
  }

#########################################################################
### Virtualbox

  if ($virtualbox){
    ensure_resource('package', [ 'dkms', 'build-essential',] , {'ensure' => 'present'})
    class { 'virtualbox':
      require => Package['dkms']
    }
    #virtualbox::extpack { 'Oracle_VM_VirtualBox_Extension_Pack':
    #    ensure           => present,
    #    source           => 'http://download.virtualbox.org/virtualbox/5.1.22/Oracle_VM_VirtualBox_Extension_Pack-5.1.22-115126.vbox-extpack',
    #    checksum_string  => '244e6f450cba64e0b025711050db3c43e6ce77e12cd80bcd08796315a90c8aaf',
    #    follow_redirects => true,
    #}
  }

#########################################################################
### Docker

  if ($docker){
    class { '::docker':
      dns           => '8.8.8.8',
      version       => 'latest',
      ip_forward    => true,
      iptables      => true,
      ip_masq       => true,
      docker_users  => [ $::mscubuntudesktop::user ],
      manage_kernel => false,
    }

    # TODO: check if there are ubuntu packages in future
    file { '/usr/local/sbin/docker-gc':
      ensure         => present,
      owner          => 'root',
      group          => 'root',
      mode           => '0755',
      backup         => false,
      source         => 'https://raw.githubusercontent.com/spotify/docker-gc/master/docker-gc',
      checksum       => 'md5',
      checksum_value => '9d2a6feffab10e9bcea20c6c22bcebba',
    }
    file { '/etc/sudoers.d/docker-gc':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "
${mscubuntudesktop::user} ALL = NOPASSWD:/usr/local/sbin/docker-gc
      "
    }
  }

#########################################################################
### OpenVPN

  if ($openvpn){
    ensure_resource('package', [ 'network-manager-openvpn', 'network-manager-openvpn-gnome', ] , {'ensure' => 'present'})

    file { '/etc/sudoers.d/openvpn':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "
${mscubuntudesktop::user} ALL = NOPASSWD:/usr/sbin/openvpn
      "
    }
  }

#########################################################################
### VIM

  if ($vim){
     ensure_resource('package', [ 'vim', 'vim-gtk3', 'vim-syntastic', 'vim-python-jedi', 'exuberant-ctags', 'vim-pathogen' ] , {'ensure' => 'present'})
     alternatives { 'editor':
       path => '/usr/bin/vim.basic',
       require => Package['vim']
     }

     file { '/etc/apparmor.d/local/usr.bin.firefox':
       owner   =>  'root',
       group   =>  'root',
       mode    =>  '0644',
       content =>  "
# Site-specific additions and overrides for usr.bin.firefox.
# For more details, please see /etc/apparmor.d/local/README.
allow /usr/bin/gvim ixr,
allow /usr/bin/vim.gtk3 ixr,
      ",
       require => [
         Package['apparmor-utils'],
         Package['firefox'],
       ]
     }
    -> exec { 'aa-enforce /etc/apparmor.d/usr.bin.firefox':
      user   => 'root',
      unless => 'sh -c "aa-status|grep -q firefox"',
      path   => '/usr/bin:/usr/sbin:/bin',
    }
  }
# TODO
#   exec { 'vim-addons -w install puppet':
#     user    => 'root',
#     unless  => 'vim-addons | grep -q installed',
#     path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
#   }
#########################################################################
### VIM

  if ($spotify){
    apt::source { 'spotify':
      location => 'http://repository.spotify.com',
      release  => 'stable',
      repos    => 'non-free',
      key      => {
        'id'     => 'BBEBDCB318AD50EC6865090613B00F1FD2C19886',
        'server' => 'hkp://keyserver.ubuntu.com:80',
      },
    }
    -> package { 'spotify-client':
            ensure => installed,
    }
  }
}
