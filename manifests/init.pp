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
) {
  include ubuntudesktop::profile::kernel
  include ubuntudesktop::profile::software
  include ubuntudesktop::profile::system
}
