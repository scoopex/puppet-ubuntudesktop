#== Class: ubuntudesktop::profile::software
#
# Setup my personal ubuntu desktop
#
# === Authors
#
# Marc Schoechlin <marc.schoechlin@256bit.org>
#
#

class ubuntudesktop::aspect::software (
  Array[String] $packages_additional = [],
  Array[String] $packages_exclude    = [],
  Array[String] $ide_snaps           = [
    'intellij-idea-community',
    'pycharm-community',
    'gradle',
    'code',
    'dbeaver-ce'
  ],
  Boolean $nextcloud                 = true,
  Boolean $virtualbox                = true,
  Boolean $docker                    = true,
  Boolean $openvpn                   = true,
  Boolean $wireguard                 = false,
  Boolean $spotify                   = true,
  Boolean $zoom                      = false,
  Boolean $signal                    = true,
  Boolean $kubernetes_client         = true,
) {
  # Install Helper Files
  file { '/opt/ubuntudesktop/':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  file { '/opt/ubuntudesktop/helpers':
    ensure  => 'directory',
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/ubuntudesktop/helpers',
    backup  => false,
    recurse => remote,
    require => File['/opt/ubuntudesktop/']
  }
  #########################################################################

  $pg_packages = [
    'postgresql-client-common', 'postgresql-client', 'pgtop', 'pg-activity', 'pgcli',
    'mysql-client',
  ]
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
    'zsh',
    'ruby-bundler',
    'cifs-utils',
    'xclip',
    'tree',
    'dialog',
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
    'git', 'git-man', 'tig', 'diffutils', 'diffstat', 'myrepos', 'git-review',
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
    'shellcheck',
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
    'libreoffice-help-de', 'hunspell-de-de-frami', 'libreoffice-l10n-de', 'mythes-de', 'hyphen-de',
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
    'pdfarranger', 'diffpdf',
    'percona-toolkit',
    'ipmiutil', 'xtightvncviewer',
    'hotspot',
    'apt-listchanges', 'apt-file'
  ]

  $install_packages = $default_packages + $packages_additional
  $install_packages_with_excludes = $install_packages - $packages_exclude

  ensure_resource('package', $install_packages, { 'ensure' => 'present' })


  $install_python_packages = ['python3', 'python3-dev', 'python3-doc', 'python3-venv', 'libpython3-stdlib']

  ensure_resource('package', $install_python_packages, { 'ensure' => 'present' })

  if ($zoom) {
    ensure_resource('package', ['libxcb-xtest0', 'libegl1-mesa', 'libgl1-mesa-glx'], { 'ensure' => 'present' })
    ubuntudesktop::helpers::deb_package_install_from_url { 'zoom':
      uri     => 'https://zoom.us/client/latest/zoom_amd64.deb',
      require => [Package['libxcb-xtest0'], Package['libegl1-mesa'], Package['libgl1-mesa-glx']]
    }
  }else {
    ensure_resource('package', ['libxcb-xtest0', 'libegl1-mesa', 'libgl1-mesa-glx', 'zoom'], { 'ensure' => 'absent' })
  }


  #########################################################################
  ### Nextcloud

  $dist_codename = $os['distro']['codename']

  if ($nextcloud) {
    exec { 'add-apt-repository ppa:nextcloud-devs/client && apt-get update':
      user    => 'root',
      unless  => "test -f /etc/apt/sources.list.d/nextcloud-devs-ubuntu-client-${dist_codename}.list",
      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
      creates => "/etc/apt/sources.list.d/nextcloud-devs-ubuntu-client-${dist_codename}.sources",
    }
    -> package { 'nextcloud-client':
      ensure => installed,
    }
    -> package { 'dolphin-nextcloud':
      ensure => installed,
    }
  }

  #   #########################################################################
  #   ### Virtualbox
  #

  if ($virtualbox) {
    ensure_resource('package', [
      'dkms',
      'build-essential',
      'virtualbox',
      'virtualbox-dkms',
      'virtualbox-guest-additions-iso'],
      { 'ensure' => 'present' }
    )
    exec { "usermod -a -G vboxusers ${::ubuntudesktop::user}":
      user    => 'root',
      unless  => "id ${::ubuntudesktop::user}|grep vboxusers",
      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
      require => Package['virtualbox']
    }
  }else {
    ensure_resource('package', [
      'virtualbox',
      'virtualbox-dkms',
      'virtualbox-guest-additions-iso'],
      { 'ensure' => 'absent' }
    )
  }

  #########################################################################
  ### Docker

  if ($docker) {
    class { '::docker':
      dns                         => '8.8.8.8',
      version                     => 'latest',
      ip_forward                  => true,
      iptables                    => true,
      ip_masq                     => true,
      docker_users                => [ $::ubuntudesktop::user ],
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
      require => Service['docker']
    }
  }

  #########################################################################
  ### VPN

  if ($openvpn) {
    ensure_resource('package', [ 'network-manager-openvpn', 'openvpn'], { 'ensure' => 'present'
    })
  }

  file { '/etc/sudoers.d/vpn':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => @("EOF")
    ${ubuntudesktop::user} ALL = NOPASSWD:/usr/sbin/openvpn
    ${ubuntudesktop::user} ALL = NOPASSWD:/usr/sbin/vpnc
    ${ubuntudesktop::user} ALL = NOPASSWD:/usr/bin/wg-quick
    ${ubuntudesktop::user} ALL = NOPASSWD:/usr/bin/wg
    | EOF
  }
  if ($wireguard) {
    ensure_resource('package', [ 'wireguard-tools', 'wireguard'], { 'ensure' => 'present' })
  }
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
    ubuntudesktop::helpers::snap_install { 'spotify':
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
    extra_args => '--classic'
  }

  githubreleases_download { '/tmp/gitui-linux-x86_64.tar.gz':
    author            => 'extrawurst',
    repository        => 'gitui',
    asset             => true,
    asset_filepattern => 'gitui-linux-x86_64.tar.gz',
    notify            => Exec['gitui_install']
  }
  exec { 'gitui_install':
    user        => 'root',
    refreshonly => true,
    command     => 'tar -C /usr/local/bin/ -zxvf /tmp/gitui-linux-x86_64.tar.gz ./gitui',
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
  }
  file { '/usr/local/bin/gitui':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Exec['gitui_install']
  }


  githubreleases_download { '/tmp/lazygit_Linux_x86_64.tar.gz':
    author            => 'jesseduffield',
    repository        => 'lazygit',
    asset             => true,
    asset_filepattern => 'lazygit_.*_Linux_x86_64.tar.gz',
    notify            => Exec['lazygit_install']
  }

  exec { 'lazygit_install':
    user        => 'root',
    refreshonly => true,
    command     => 'tar -C /usr/local/bin/ -zxvf /tmp/lazygit_Linux_x86_64.tar.gz lazygit',
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
  }
  file { '/usr/local/bin/lazygit':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Exec['lazygit_install']
  }

  githubreleases_download { '/tmp/logcli-linux-amd64.zip':
    author            => 'grafana',
    repository        => 'loki',
    asset             => true,
    asset_filepattern => 'logcli-linux-amd64.zip',
    notify            => Exec['logcli_install']
  }
  exec { 'logcli_install':
    user        => 'root',
    refreshonly => true,
    command     => 'unzip -o -d /tmp/ /tmp/logcli-linux-amd64.zip logcli-linux-amd64 && mv /tmp/logcli-linux-amd64 /usr/local/bin/logcli',
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
  }
  file { '/usr/local/bin/logcli':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Exec['k9s_install']
  }

  if ($kubernetes_client) {
    ubuntudesktop::helpers::snap_install { ['helm', 'kubectl', 'kubelogin']:
      extra_args => '--classic'
    }


    $k9s_file='k9s_Linux_amd64.tar.gz'
    githubreleases_download { "/tmp/${k9s_file}":
      author            => 'derailed',
      repository        => 'k9s',
      asset             => true,
      asset_filepattern => $k9s_file,
      notify            => Exec['k9s_install']
    }
    exec { 'k9s_install':
      user        => 'root',
      refreshonly => true,
      command     => "tar -C /usr/local/bin/ -zxvf /tmp/${k9s_file} k9s",
      path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
    }
    file { '/usr/local/bin/k9s':
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Exec['k9s_install']
    }
    githubreleases_download {
      '/tmp/kubefwd_amd64.deb':
      author     => 'txn2',
      repository => 'kubefwd',
      asset_filepattern => 'kubefwd_amd64.deb',
      asset             => true,
      notify            => Exec['kubefwd_install']
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
    #ubuntudesktop::helpers::install_helper {'ubuntu-desktop_install_argocd': }

    $kind_file='kind-linux-amd64'
    githubreleases_download { "/tmp/${kind_file}":
      author            => 'kubernetes-sigs',
      repository        => 'kind',
      asset             => true,
      asset_filepattern => $kind_file,
    }
    -> file { '/usr/local/bin/kind':
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => "file:///tmp/${kind_file}",
    }
    -> exec { 'kind_install':
      user        => 'root',
      provider    => 'shell',
      command     => '/usr/local/bin/kind completion bash > /etc/bash_completion.d/kind',
      refreshonly => true,
      path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
    }
    -> file { '/etc/bash_completion.d/kind':
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  $rustdesk_file='/var/tmp/rustdesk.deb'
  githubreleases_download { 'rustdesk':
    target            => $rustdesk_file,
    author            => 'rustdesk',
    repository        => 'rustdesk',
    asset             => true,
    asset_filepattern => 'rustdesk-.*-x86_64\.deb',
  }

  ubuntudesktop::helpers::snap_install { ['chromium']: }
  ubuntudesktop::helpers::snap_install { 'firefox': }

  file { '/usr/share/keyrings/element-io-archive-keyring.gpg':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'https://packages.element.io/debian/element-io-archive-keyring.gpg',
  }
  -> file { '/etc/apt/sources.list.d/element-io.list':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => @(EOT)
      # created by puppet
      deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main
      |EOT
  }
  exec { 'apt-get update':
    alias     => 'apt-get-update-element',
    unless    => 'which element-desktop',
    user      => 'root',
    path      => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
    subscribe => [ File['/usr/share/keyrings/element-io-archive-keyring.gpg'], File[
      '/etc/apt/sources.list.d/element-io.list']]
  } ->
  package { 'element-desktop':
    require   => [ File['/usr/share/keyrings/element-io-archive-keyring.gpg'], File[
      '/etc/apt/sources.list.d/element-io.list']],
    subscribe => Exec['apt-get-update-element']
  }
}
