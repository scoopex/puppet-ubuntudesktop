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
  String[2] $user = 'schoecmc',
) {
  include ubuntudesktop::profile::kernel
  include ubuntudesktop::profile::software
  include ubuntudesktop::profile::system
}
