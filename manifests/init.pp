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
) {
  include ubuntudesktop::aspect::kernel
  include ubuntudesktop::aspect::software
  include ubuntudesktop::aspect::kubernetes
  include ubuntudesktop::aspect::system
  include ubuntudesktop::aspect::user
}
