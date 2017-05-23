class profile::packages {

#########################################################################
### STANDARD PACKAGES
 $packages = [ 'ubuntu-restricted-extras',
	'gcgxine',
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
   'gnuplot',
   'hplip',
   'iptraf',
   'pidgin',
   'remmina',
   'remmina-plugin-rdp',
   'rsync',
   'enigmail',
   'openvpn',
 ]

 package { $packages:
    ensure => installed,
 ]

#########################################################################
### VIM

	package { [ 'vim', 'vim-gtk' ]:
		 ensure => installed,
	}->
	alternatives { 'editor':
	  path => '/usr/bin/vim.basic',
	}

}
