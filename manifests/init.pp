# == Class: ubuntudesktop
#
# Setup my personal ubuntu desktop
#
# === Authors
#
# Marc Schoechlin <marc.schoechlin@256bit.org>
#
#
class ubuntudesktop (
  String[2] $user = 'marc',
  String[2] $homedir = '/home/marc',
  String[2] $cachedir = '/var/cache/puppet-ubuntudesktop',
) {
  include ubuntudesktop::aspect::base
  include ubuntudesktop::aspect::kernel
  include ubuntudesktop::aspect::software
  include ubuntudesktop::aspect::kubernetes
  include ubuntudesktop::aspect::system
  include ubuntudesktop::aspect::user
  include ubuntudesktop::aspect::hardware
}
