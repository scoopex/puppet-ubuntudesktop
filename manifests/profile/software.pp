#== Class: ubuntudesktop::profile::software
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
  Array[String] $ide_snaps           = ["intellij-idea-community", "pycharm-community", "gradle", "code", "dbeaver-ce" ],
  Boolean $nextcloud                 = true,
#   Boolean $virtualbox                = false,
#   String $virtualbox_version         = "6.1",
#   String $virtualbox_extpack_url     =
#   "https://download.virtualbox.org/virtualbox/6.1.4/Oracle_VM_VirtualBox_Extension_Pack-6.1.4.vbox-extpack",
  Boolean $docker                    = true,
  Boolean $openvpn                   = false,
  Boolean $spotify                   = true,
  Boolean $signal                    = true,
  Boolean $zoom                      = true,
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

  $pg_packages = [ 'postgresql-client-common', 'postgresql-client', 'pgtop', 'pg-activity', 'pgcli' ]
    ensure_resource('package', $pg_packages,
        { 'ensure' => 'present' }
  )

  #########################################################################
  ### STANDARD PACKAGES

  $default_packages = [ 'ubuntu-restricted-extras',
    'pandoc',
    'solaar',
    'wine-stable', 'playonlinux', 'winetricks',
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
    'cifs-utils',
    'tree',
    'keepass2',
    'wavemon',
    'wakeonlan',
    'w3m',
    'xalan',
    'xsel',
    'qmmp',
    'easytag',
    'id3tool',
    'lame',
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
    'a2ps',
    'screen',
    'ncdu',
    'gimp',
    'gnuplot', 'gnuplot-qt',
    'graphviz',
    'hplip',
    'rsync',
    'default-jdk', 'maven', 'visualvm', 'icedtea-netx',
    'git', 'git-man', 'tig', 'diffutils', 'diffstat', 'myrepos',
    'flameshot',
    'curl', 'wget',
    'htop',
    'iftop', 'iptraf-ng',
    'pv',
    'lsscsi',
    'sysstat',
    'traceroute', 'mtr',
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
    'libffi-dev', 'python3-dev', 'pylint', 
    'ipython3', 'python3-autopep8',
    'python3-pylint-flask', 'python3-flake8', 'python3-packaging',
    'pdfarranger',
    'percona-toolkit',
    'ipmiutil', 'xtightvncviewer',
    'bless',
    'apt-listchanges', 'apt-file'
  ]

  $install_packages = $default_packages + $packages_additional
  $install_packages_with_excludes = $install_packages - $packages_exclude

  ensure_resource('package', $install_packages, { 'ensure' => 'present' })


  $install_python_packages = ['python3', 'python3-dev', 'python3-doc', 'python3-venv', 'libpython3-stdlib']

  ensure_resource('package', $install_python_packages, { 'ensure' => 'present' })

  if ($zoom){

    ensure_resource('package', ['libxcb-xtest0', 'libegl1-mesa', 'libgl1-mesa-glx'], { 'ensure' => 'present' })
    ubuntudesktop::helpers::deb_package_install_from_url { 'zoom':
      uri => 'https://zoom.us/client/latest/zoom_amd64.deb',
      require => [Package['libxcb-xtest0'], Package['libegl1-mesa'], Package['libgl1-mesa-glx']]
    }
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

#   #########################################################################
#   ### Virtualbox
# 
#   if ($virtualbox) {
#     ensure_resource('package', [ 'dkms', 'build-essential', ], { 'ensure' => 'present' })
#     class { 'virtualbox':
#       require => Package['dkms'],
#       version => '6.1',
#     }
#     virtualbox::extpack { 'Oracle_VM_VirtualBox_Extension_Pack':
#       ensure           => present,
#       source           => $virtualbox_extpack_url,
#       verify_checksum  => false,
#       follow_redirects => true,
#     }
#     exec { "usermod -a -G vboxusers ${::ubuntudesktop::user}":
#       user   => 'root',
#       unless => "id ${::ubuntudesktop::user}|grep vboxusers",
#       path   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
#     }
#   }

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
      use_upstream_package_source => true,
    }

    file { '/etc/cron.d/docker-gc':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "
@daily root /usr/bin/docker system prune -a --filter 'until=48h' -f 2>&1|logger -t docker-system-prune
      "
    }
    file { '/etc/docker/daemon.json':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => '{ "experimental": true }',
      require => Service["docker"]
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
  ensure_resource('package', [ 'wireguard-tools', 'wireguard'], { 'ensure' => 'present'})

  #########################################################################
  ### VIM

  ensure_resource('package', [ 'vim', 'vim-gtk3', 'vim-syntastic', 'vim-python-jedi', 'exuberant-ctags',
    'vim-pathogen' ], { 'ensure' => 'present' }
  )
  alternatives { 'editor':
    path    => '/usr/bin/vim.basic',
    require => Package['vim']
  }



  #########################################################################
  ### SPOTIFY

  if ($spotify) {
    ubuntudesktop::helpers::snap_install { "spotify":
    }
  }


  if ($signal) {
    exec { 'snap install signal-desktop':
      user   => 'root',
      unless => 'snap list signal-desktop',
      path   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
    }
  }

 
  #########################################################################


  ubuntudesktop::helpers::snap_install { $ide_snaps:
      extra_args => "--classic"
  }

#   githubreleases_download { '/tmp/lazygit_Linux_x86_64.tar.gz':
#     author            => 'jesseduffield',
#     repository        => 'lazygit',
#     asset             => true,
#     asset_filepattern => 'lazygit_.*_Linux_x86_64.tar.gz',
#     notify            => Exec["lazygit_install"]
#   }
# 
#   exec { 'lazygit_install':
#     user        => 'root',
#     refreshonly => true,
#     command     => 'tar -C /usr/local/bin/ -zxvf /tmp/lazygit_Linux_x86_64.tar.gz lazygit',
#     path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
#   }
#   file { '/usr/local/bin/lazygit':
#     owner   => 'root',
#     group   => 'root',
#     mode    => '0755',
#     require => Exec["lazygit_install"]
#   }
# 

#   githubreleases_download { '/tmp/logcli-linux-amd64.zip':
#     author            => 'grafana',
#     repository        => 'loki',
#     asset             => true,
#     asset_filepattern => 'logcli-linux-amd64.zip',
#     notify            => Exec["logcli_install"]
#   }
#   exec { 'logcli_install':
#     user        => 'root',
#     refreshonly => true,
#     command     => 'unzip -o -d /tmp/ /tmp/logcli-linux-amd64.zip logcli-linux-amd64 && mv /tmp/logcli-linux-amd64 /usr/local/bin/logcli',
#     path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
#   }
#   file { '/usr/local/bin/logcli':
#     owner   => 'root',
#     group   => 'root',
#     mode    => '0755',
#     require => Exec["k9s_install"]
#   }
# 

  if ($kubernetes_client) {
    ubuntudesktop::helpers::snap_install { ["helm", "kubectl", "k9s"]:
      extra_args => "--classic"
    }


#     $k9s_file="k9s_Linux_amd64.tar.gz"
# 
#     githubreleases_download { "/tmp/${k9s_file}":
#       author            => 'derailed',
#       repository        => 'k9s',
#       asset             => true,
#       asset_filepattern => "${k9s_file}",
#       notify            => Exec["k9s_install"]
#     }
#     exec { 'k9s_install':
#       user        => 'root',
#       refreshonly => true,
#       command     => "tar -C /usr/local/bin/ -zxvf /tmp/${k9s_file} k9s",
#       path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
#     }
#     file { '/usr/local/bin/k9s':
#       owner   => 'root',
#       group   => 'root',
#       mode    => '0755',
#       require => Exec["k9s_install"]
#     }
# 
#     githubreleases_download {
#       '/tmp/kubefwd_amd64.deb':
#       author     => 'txn2',
#       repository => 'kubefwd',
#       asset_filepattern => 'kubefwd_amd64.deb',
#       asset             => true,
#       notify            => Exec["kubefwd_install"]
#     }
#     exec { 'kubefwd_install':
#       user        => 'root',
#       refreshonly => true,
#       command     => 'dpkg -i /tmp/kubefwd_amd64.deb',
#       path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
#     }
#     file { '/etc/sudoers.d/kubefwd':
#     owner   => 'root',
#     group   => 'root',
#     mode    => '0644',
#     content => "
# ${ubuntudesktop::user} ALL=(ALL) SETENV: NOPASSWD: /usr/local/bin/kubefwd *
# "
#     }
#    ubuntudesktop::helpers::install_helper {"ubuntu-desktop_install_argocd": }
  }

  ubuntudesktop::helpers::snap_install { ["chromium"]: }
  ubuntudesktop::helpers::snap_install { "firefox": }
}
