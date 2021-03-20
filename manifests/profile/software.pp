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
  Array[String] $ide_snaps           = ["intellij-idea-community", "pycharm-community", "gradle", "gitkraken", "code", "dbeaver-ce" ],
  Boolean $nextcloud                 = true,
  Boolean $virtualbox                = false,
  String $virtualbox_version         = "6.1",
  String $virtualbox_extpack_url     =
  "https://download.virtualbox.org/virtualbox/6.1.4/Oracle_VM_VirtualBox_Extension_Pack-6.1.4.vbox-extpack",
  Boolean $docker                    = true,
  Boolean $openvpn                   = false,
  Boolean $vim                       = true,
  Boolean $spotify                   = true,
  Boolean $teams                     = true,
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
    'gnome-tweaks', 'gnome-shell-extensions',
    'pandoc', 'grip',
    'wine-stable', 'playonlinux', 'winetricks',
    'xine-ui',
    'postgresql-client-common', 'postgresql-client-12', 'pgtop', 'pg-activity', 'pgcli',
    's3cmd',
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
    'apt-listchanges',
  ]

  $install_packages = $default_packages + $packages_additional
  $install_packages_with_excludes = $install_packages - $packages_exclude

  ensure_resource('package', $install_packages, { 'ensure' => 'present' })


  $install_python_packages = ['python3.9', 'python3.9-dev', 'python3.9-doc', 'python3.9-venv', 'libpython3.9-testsuite', 'libpython3.9-stdlib']

  ensure_resource('package', $install_python_packages, { 'ensure' => 'present', notify => Alternatives['python3'] })

  alternatives { 'python3':
      path    => '/usr/bin/python3.8',
  }


  exec { 'curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && chmod 755 /usr/local/bin/youtube-dl':
    user    => 'root',
    unless  => "test -f /usr/local/bin/youtube-dl",
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
    creates => "/usr/local/bin/youtube-dl",
    require => Package['curl'],
  }


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
    file { '/etc/docker/daemon.json':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => '{
"experimental": true
}',
    notify => Service["docker"]
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

    githubreleases_download { '/tmp/k9s_Linux_x86_64.tar.gz':
      author            => 'derailed',
      repository        => 'k9s',
      asset             => true,
      asset_filepattern => 'k9s_Linux_x86_64.tar.gz',
      notify            => Exec["k9s_install"]
    }
    exec { 'k9s_install':
      user        => 'root',
      refreshonly => true,
      command     => 'tar -C /usr/local/bin/ -zxvf /tmp/k9s_Linux_x86_64.tar.gz k9s',
      path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
    }
    file { '/usr/local/bin/k9s':
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Exec["k9s_install"]
    }

    githubreleases_download {
      '/tmp/kubefwd_amd64.deb':
      author     => 'txn2',
      repository => 'kubefwd',
      asset_filepattern => 'kubefwd_amd64.deb',
      asset             => true,
      notify            => Exec["kubefwd_install"]
    }
    exec { 'kubefwd_install':
      user        => 'root',
      refreshonly => true,
      command     => 'dpkg -i /tmp/kubefwd_amd64.deb',
      path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
    }
    file { '/etc/sudoers.d/kubefwd':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "
${ubuntudesktop::user} ALL=(ALL) SETENV: NOPASSWD: /usr/local/bin/kubefwd *
"
    }

    ubuntudesktop::install_helper {"ubuntu-desktop_install_argocd": }
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
