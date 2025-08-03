class ubuntudesktop::aspect::hardware (){

  package { 'libinput-tools':
    ensure => installed,
  }

  file { [
          "${ubuntudesktop::homedir}/.config/input-remapper-2/",
          "${ubuntudesktop::homedir}/.config/input-remapper-2/presets/",
          "${ubuntudesktop::homedir}/.config/input-remapper-2/presets/Logitech MX Master 3S/"
  ]:
    ensure  => 'directory',
    owner   => "${ubuntudesktop::user}",
    group   => "${ubuntudesktop::user}",
    mode    => '0775',
    recurse => true,
    purge   => true,
  }

  file { "${ubuntudesktop::homedir}/.config/input-remapper-2/presets/Logitech MX Master 3S/Mouse.json":
    owner   => "${ubuntudesktop::user}",
    group   => "${ubuntudesktop::user}",
    mode    => '0640',
    content => @("EOF")
    [
        {
            "input_combination": [
                {
                    "type": 1,
                    "code": 275,
                    "origin_hash": "46064211e1205cc86236124068cf7950"
                }
            ],
            "target_uinput": "mouse",
            "output_symbol": "BTN_MIDDLE",
            "mapping_type": "key_macro"
        }
    ]
    | EOF
  }
  file { "${ubuntudesktop::homedir}/.config/input-remapper-2/config.json":
    owner   => "${ubuntudesktop::user}",
    group   => "${ubuntudesktop::user}",
    mode    => '0640',
    content => @("EOF")
    {
        "version": "2.1.1",
        "autoload": {
            "Logitech MX Master 3S": "Mouse"
        }
    }
    | EOF
  }
}
