class ubuntudesktop::profile::keyboard {

  augeas{ 'bar':
    context =>  "/files/etc/default/keyboard",
    changes =>  "set XKBOPTIONS 'ctrl:nocaps'",
    onlyif  =>  "match XKBOPTIONS not_include 'ctrl:nocaps' ",
  }

}
