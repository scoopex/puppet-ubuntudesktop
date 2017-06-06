# == Class: mscubuntudesktop
#
# Setup my personal ubuntu desktop
#
# === Authors
#
# Marc Schoechlin <marc.schoechlin@256bit.org>
#
#
class mscubuntudesktop (
  String[2] $user = 'marc',
) {
  include mscubuntudesktop::profile::kernel
  include mscubuntudesktop::profile::software
  include mscubuntudesktop::profile::system
}
