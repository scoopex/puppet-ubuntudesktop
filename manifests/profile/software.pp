# == Class: ubuntudesktop::profile::software
#
# Setup my personal ubuntu desktop
#
# === Authors
#
# Marc Schoechlin <marc.schoechlin@256bit.org>
#
#

class ubuntudesktop::profile::software (
  Array[String] $packages_additional = [],
  Array[String] $packages_exclude    = [],
  Array[String] $ide_snaps           = ["intellij-idea-community", "pycharm-community", "gradle"],
  Boolean $nextcloud                 = true,
  Boolean $virtualbox                = true,
  String $virtualbox_version         = "6.1",
  String $virtualbox_extpack_url     =
  "https://download.virtualbox.org/virtualbox/6.1.4/Oracle_VM_VirtualBox_Extension_Pack-6.1.4.vbox-extpack",
  Boolean $docker                    = true,
  Boolean $openvpn                   = false,
  Boolean $vim                       = true,
  Boolean $spotify                   = true,
  Boolean $teams                     = false,
  Boolean $kubernetes_client         = true,
) {
  # Install Helper Files
  file { '/opt/ubuntudesktop/':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  file { "/opt/ubuntudesktop/helpers":
    ensure  => 'directory',
    mode => '0755',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/ubuntudesktop/helpers',
    backup  => false,
    recurse => remote,
    require => File["/opt/ubuntudesktop/"]
  }
  #########################################################################
  ### STANDARD PACKAGE SOURCES

  apt::source { "archive.ubuntu.com-mscdesktop":
    location => 'http://archive.canonical.com/ubuntu',
    repos    => "partner",
  }

  #########################################################################
  ### STANDARD PACKAGES

  $default_packages = [ 'ubuntu-restricted-extras',
    'gnome-tweaks',
    'pandoc', 'grip',
    'youtube-dl',
    'copyq',
    'wine-stable', 'playonlinux', 'winetricks',
    'xine-ui',
    'rpm',
    'mosh',
    'libterm-readline-gnu-perl', 'perl-doc',
    'whois',
    'apache2-utils',
    'siege',
    'inotify-tools',
    'highlight',
    'wcalc',
    'ruby-bundler',
    'geeqie',
    'firefox', 'firefox-locale-de',
    'cifs-utils',
    'tree',
    'keepass2',
    'wavemon',
    'wakeonlan',
    'w3m',
    'xalan',
    'xsel',
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
    'remmina', 'remmina-plugin-rdp',
    'rsync',
    'enigmail',
    'default-jdk', 'maven', 'visualvm', 'icedtea-netx',
    #'icedtea-plugin',
    'git', 'git-man', 'tig', 'diffutils', 'diffstat', 'myrepos',
    #'shutter',
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
    'bolt',
    'ncftp',
    'ndiff',
    'pwgen',
    'puppet-lint',
    'texlive-base', 'texlive-binaries', 'texlive-extra-utils', 'texlive-fonts-extra', 'texlive-fonts-recommended',
    'texlive-fonts-recommended-doc', 'texlive-font-utils',
    #'texlive-generic-recommended', 
    'texlive-lang-german',
    'texlive-latex-base', 'texlive-latex-base-doc', 'texlive-latex-extra', 'texlive-latex-recommended',
    'texlive-latex-recommended-doc', 'texlive-pictures', 'texlive-pictures-doc', 'texlive-pstricks',
    'texlive-pstricks-doc',
    'rtorrent',
    'scribus', 'inkscape',
    'siege',
    'socat',
    'splint',
    'strace',
    'subversion',
    'devscripts', 'debhelper', 'dh-make',
    'ldap-utils',
    'python3-pip', 'virtualenv', 'virtualenvwrapper', 'python3-virtualenv', 'build-essential', 'libssl-dev',
    'libffi-dev', 'python3-dev', 'pylint', 'pyflakes',
    'ipython3', 'python3-autopep8',
    'python3-pylint-flask', 'python3-pyflakes', 'python3-flake8', 'python3-packaging',
    'python3-nose', 'python3-nose-cov', 'python3-nose-json', 'python3-nose-parameterized', 'python3-nose-timer',
    'python3-nose-yanc',
    'pdfshuffler',
    #'pdfchain',
    'percona-toolkit',
    'ipmiutil', 'xtightvncviewer',
    'bless',
  ]

  $install_packages = $default_packages + $packages_additional
  $install_packages_with_excludes = $install_packages - $packages_exclude

  ensure_resource('package', $install_packages, { 'ensure' => 'present' })

  #########################################################################
  ### Nextcloud

  if ($nextcloud) {
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

  if ($virtualbox) {
    ensure_resource('package', [ 'dkms', 'build-essential', ], { 'ensure' => 'present' })
    class { 'virtualbox':
      require => Package['dkms'],
      version => '6.1',
    }
    virtualbox::extpack { 'Oracle_VM_VirtualBox_Extension_Pack':
      ensure           => present,
      source           => $virtualbox_extpack_url,
      verify_checksum  => false,
      follow_redirects => true,
    }
    exec { "usermod -a -G vboxusers ${::ubuntudesktop::user}":
      user   => 'root',
      unless => "id ${::ubuntudesktop::user}|grep vboxusers",
      path   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
    }
  }

  #########################################################################
  ### Docker

  if ($docker) {
    class { '::docker':
      dns          => '8.8.8.8',
      version      => 'latest',
      ip_forward   => true,
      iptables     => true,
      ip_masq      => true,
      docker_users => [ $::ubuntudesktop::user ],
    }

    file { '/etc/cron.d/docker-gc':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "
@daily root /usr/bin/docker image prune -a --filter 'until=48h' -f 2>&1|logger -t docker-image-prune
      "
    }

  }

  #########################################################################
  ### VPN

  if ($openvpn) {
    ensure_resource('package', [ 'network-manager-openvpn', 'network-manager-openvpn-gnome', ], { 'ensure' => 'present'
    })
  }

  file { '/etc/sudoers.d/vpn':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "
${ubuntudesktop::user} ALL = NOPASSWD:/usr/sbin/openvpn
${ubuntudesktop::user} ALL = NOPASSWD:/usr/sbin/vpnc
"
  }

  #########################################################################
  ### VIM

  if ($vim) {
    ensure_resource('package', [ 'vim', 'vim-gtk3', 'vim-syntastic', 'vim-python-jedi', 'exuberant-ctags',
      'vim-pathogen' ], { 'ensure' => 'present' }
    )
    alternatives { 'editor':
      path    => '/usr/bin/vim.basic',
      require => Package['vim']
    }

    file { '/etc/apparmor.d/local/usr.bin.firefox':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "
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

  #########################################################################
  ### SPOTIFY

  if ($spotify) {
    ubuntudesktop::snap_install { "spotify":
    }
  }

  #########################################################################
  ### M$ Teams
  # https://docs.microsoft.com/en-us/windows-server/administration/linux-package-repository-for-microsoft-software

  if ($teams) {
    apt::source { 'teams':
      location => 'https://packages.microsoft.com/repos/ms-teams',
      release  => 'stable',
      repos    => 'main',
      key      => {
        'id'     => 'BC528686B50D79E339D3721CEB3E94ADBE1229CF',
        'server' => 'https://packages.microsoft.com/keys/microsoft.asc',
      },
    }
    -> package { 'teams':
      ensure => installed,
    }
  }else {
    package { 'teams':
      ensure => absent,
    }
  }
  if ($ide_snaps) {
    ubuntudesktop::snap_install { intellij_ide_snaps:
      extra_args => "--classic"
    }
  }

  if ($kubernetes_client) {
    ubuntudesktop::snap_install { ["helm", "kubectl", "kontena-lens"]:
      extra_args => "--classic"
    }
    ubuntudesktop::deb_package_install_from_url { "kubefwd":
      uri => "https://github.com/txn2/kubefwd/releases/download/1.14.7/kubefwd_1.14.7_linux_amd64.deb"
    }
    ubuntudesktop::install_helper {"ubuntu-desktop_install_argocd":
    }
  }

  exec { 'snap install chromium':
    user   => 'root',
    unless => 'snap list chromium',
    path   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
  }

  ubuntudesktop::deb_package_install_from_url { "discord":
    uri => "https://discord.com/api/download?platform=linux&format=deb",
  }

}
