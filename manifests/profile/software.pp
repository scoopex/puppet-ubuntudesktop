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
   'iptraf',
   'pidgin',
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
 ]

 package { $packages:
    ensure => installed,
 }


#########################################################################
### Nextcloud

 exec { 'add-apt-repository ppa:nextcloud-devs/client && apt-get update':
     user    => 'root',
     unless  => "test -f /etc/apt/sources.list.d/nextcloud-devs-ubuntu-client-${::lsbdistcodename}.list",
     path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
 }->
 package { 'nextcloud-client':
    ensure => installed,
 }

#########################################################################
### Virtualbox

class { 'virtualbox':
}

#virtualbox::extpack { 'Oracle_VM_VirtualBox_Extension_Pack':
#    ensure           => present,
#    source           => 'http://download.virtualbox.org/virtualbox/4.3.20/Oracle_VM_VirtualBox_Extension_Pack-4.3.20.vbox-extpack',
#    checksum_string  => '4b7546ddf94308901b629865c54d5840',
#    follow_redirects => true,
#}


#########################################################################
### Virtualbox

class { '::docker':
     dns => '8.8.8.8',
     version => 'latest',
     ip_forward      => true,
     iptables        => true,
     ip_masq         => true,
     docker_users    => [ $::ubuntudesktop::user ],
     manage_kernel   => false,
}
#########################################################################
### OpenVPN

  package { [ 'openvpn', 'network-manager-openvpn', 'network-manager-openvpn-gnome', ]:
    ensure => installed,
  }

  file { '/etc/sudoers.d/openvpn':
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    content => "
     ${ubuntudesktop::user} ALL = NOPASSWD:/usr/sbin/openvpn
    "
  }

#########################################################################
### VIM

	package { [ 'vim', 'vim-gtk3', 'vim-puppet', 'vim-python-jedi', ]:
		 ensure => installed,
	}->
	alternatives { 'editor':
	  path => '/usr/bin/vim.basic',
	}
# TODO
#   exec { 'vim-addons -w install puppet':
#     user    => 'root',
#     unless  => 'vim-addons | grep -q installed',
#     path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin',
#   }

}
