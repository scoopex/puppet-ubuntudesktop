class ubuntudesktop::aspect::kubernetes (
) {
  ubuntudesktop::helpers::snap_install { ['helm', 'kubectl', 'kubelogin']:
    extra_args => '--classic'
  }
  -> archive { "${ubuntudesktop::cachedir}/user/krew-linux_amd64.tar.gz":
    source       => "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew-linux_amd64.tar.gz",
    cleanup      => false,
    extract      => true,
    extract_path => "${ubuntudesktop::cachedir}/user/",
    user         => $ubuntudesktop::user,
    creates      => "${ubuntudesktop::cachedir}/krew-linux_amd64",
  }
  -> exec { 'krew_install':
    user    => $ubuntudesktop::user,
    environment => ["HOME=${ubuntudesktop::homedir}"],
    command => "${ubuntudesktop::cachedir}/user/krew-linux_amd64 install krew",
    logoutput => true,
    unless => 'kubectl krew',
    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:${ubuntudesktop::homedir}/.krew/bin",
  }
  -> ubuntudesktop::helpers::krew_install {
    ['neat', 'who-can', 'sniff' ,'trace', 'df-pv', 'access-matrix' , 'node-admin' ,'spy', 'view-secret']:
  }

  $k9s_file = 'k9s_Linux_amd64.tar.gz'
  githubreleases_download { "${ubuntudesktop::cachedir}/${k9s_file}":
    author            => 'derailed',
    repository        => 'k9s',
    asset             => true,
    asset_filepattern => $k9s_file,
    notify            => Exec['k9s_install']
  }
  exec { 'k9s_install':
    user        => 'root',
    refreshonly => true,
    command     => "tar -C /usr/local/bin/ -zxvf ${ubuntudesktop::cachedir}/${k9s_file} k9s",
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
  }
  file { '/usr/local/bin/k9s':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Exec['k9s_install']
  }
  githubreleases_download {
    "${ubuntudesktop::cachedir}/kubefwd_amd64.deb":
      author            => 'txn2',
      repository        => 'kubefwd',
      asset_filepattern => 'kubefwd_amd64.deb',
      asset             => true,
      notify            => Exec['kubefwd_install']
  }
  exec { 'kubefwd_install':
    user        => 'root',
    refreshonly => true,
    command     => "dpkg -i ${ubuntudesktop::cachedir}/kubefwd_amd64.deb",
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
  ubuntudesktop::helpers::install_helper { 'ubuntu-desktop_install_argocd': }

  $kind_file = 'kind-linux-amd64'
  githubreleases_download { "${ubuntudesktop::cachedir}/${kind_file}":
    author            => 'kubernetes-sigs',
    repository        => 'kind',
    asset             => true,
    asset_filepattern => $kind_file,
  }
  -> file { '/usr/local/bin/kind':
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => "file://${ubuntudesktop::cachedir}/${kind_file}",
  }
  -> exec { 'kind_install':
    user        => 'root',
    provider    => 'shell',
    command     => '/usr/local/bin/kind completion bash > /etc/bash_completion.d/kind',
    refreshonly => true,
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
  }
  -> file { '/etc/bash_completion.d/kind':
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }
  #    -> file { '/etc/systemd/system/user@.service.d/delegate.conf':
  #    owner   => 'root',
  #    group   => 'root',
  #    mode    => '0644',
  #    content => "
  #[Service]
  #Delegate=yes
  #",
  #    notify => Exec['systemctl-daemon-reload']
  #    }
  #    -> file { '/etc/modules-load.d/iptables.conf':
  #    owner   => 'root',
  #    group   => 'root',
  #    mode    => '0644',
  #    content => "
  #ip6_tables
  #ip6table_nat
  #ip_tables
  #iptable_nat
  #"
  #    }
  #     exec { 'systemctl daemon-reload':
  #       alias       => 'systemctl-daemon-reload',
  #       user        => 'root',
  #       path        => '/usr/bin:/usr/sbin:/bin',
  #       refreshonly => true,
  #     }

  githubreleases_download { "${ubuntudesktop::cachedir}/stern_linux_arm64.tar.gz":
    author            => 'stern',
    repository        => 'stern',
    asset             => true,
    asset_filepattern => 'stern_.*_linux_amd64\.tar\.gz',
    notify            => Exec['stern_install'],
  }
  exec { 'stern_install':
    user        => 'root',
    refreshonly => true,
    command     => "tar -C /usr/local/bin/ -zxvf ${ubuntudesktop::cachedir}/stern_linux_arm64.tar.gz stern",
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
  }
  -> file { '/usr/local/bin/stern':
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }

  #$install_pipx_packages = ['yaookctl']
  #ensure_resource('ubuntudesktop::helpers::pipx_install', $install_pipx_packages)
}
