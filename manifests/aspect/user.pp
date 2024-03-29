# == Class: ubuntudesktop::profile::kernel
#
# Setup my personal ubuntu desktop
#
# === Authors
#
# Marc Schoechlin <marc.schoechlin@256bit.org>
#
#

class ubuntudesktop::aspect::user {

  file { '/etc/updatedb.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => @("EOF")
    # generated by puppet
    PRUNE_BIND_MOUNTS="yes"
    PRUNENAMES=".git .bzr .hg .svn .cache"
    PRUNEPATHS="/tmp /var/spool /media /var/lib/os-prober /var/lib/ceph /home/.ecryptfs /var/lib/schroot /home/${ubuntudesktop::user}/snap /home/${ubuntudesktop::user}/.cache /home/${ubuntudesktop::user}/.local /home/${ubuntudesktop::user}/.thunderbird"
    PRUNEFS="NFS afs autofs binfmt_misc ceph cgroup cgroup2 cifs coda configfs curlftpfs debugfs devfs devpts devtmpfs ecryptfs ftpfs fuse.ceph fuse.cryfs fuse.encfs fuse.glusterfs fuse.gocryptfs fuse.gvfsd-fuse fuse.mfs fuse.rclone fuse.rozofs fuse.sshfs fusectl fusesmb hugetlbfs iso9660 lustre lustre_lite mfs mqueue ncpfs nfs nfs4 ocfs ocfs2 proc pstore rpc_pipefs securityfs shfs smbfs sysfs tmpfs tracefs udev udf usbfs"
    | EOF
  }

}
