From: Kong <likong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mount.cifs failed to mount smb2-only shares
Date: Fri, 10 Jun 2011 22:26:41 +0000 (UTC)
Message-ID: <loom.20110611T002543-158@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Two problems with smb2-only shares. 

client: ubuntu 11.04 32-bit
I moved the original mount.cifs (version 4.5)to mount.cifs.old, and installed
mount.cifs version 5.0.

$ uname -r
2.6.38-8-generic
$ /sbin/mount.cifs -V
mount.cifs version: 5.0
$ /sbin/mount.cifs.old -V
mount.cifs version: 4.5

Server1: windows 2008 64-bit (standalone)
disable smb1 protocol to make it smb2 only (e.g., add reg value smb1 and set it
to 0, restart Lanmanserver service.  see
http://blogs.technet.com/b/askperf/archive/2008/05/30/two-minute-drill-overview-of-smb-2-0.aspx)

$ sudo /sbin/mount.cifs -v -o user=user1,pass=XXXX //AA.BB.CC.DD/C$ mnt
mount.cifs kernel mount options:
ip=AA.BB.CC.DD,unc=\\AA.BB.CC.DD\C$,,ver=1,user=user1,pass=********
mount error(112): Host is down
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

syslog:
Jun 10 14:18:26 ubuntu-1104 kernel: [10703.059510] CIFS VFS: cifs_mount failed
w/return code = -112

* before I disabled smb1 on server1, the same command can mount the share of the
same machine successfully.
* same result if I used /sbin/mount.cifs.old.

Server2: Mac OS X 10.7 (LION, Preview 4)
Apple replaces samba with their own smbx which speaks SMB2.

$ sudo /sbin/mount.cifs -v -o user=user2,pass=YYYY //EE.FF.GG.HH/Misc mnt
mount.cifs kernel mount options:
ip=EE.FF.GG.HH,unc=\\EE.FF.GG.HH\Misc,,ver=1,user=user2,pass=********
mount error(22): Invalid argument
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

syslog:
Jun 10 14:27:06 ubuntu-1104 kernel: [11222.340976] CIFS VFS: cifs_mount failed
w/return code = -22

* same result if I used /sbin/mount.cifs.old.
* the same command works with prior version of Mac OS X (which uses Samba).

Any suggestions?

Thanks.

Kong
