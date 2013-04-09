From: Peter Maloney <peter.maloney-bU717sqhW2kTELwDM1PSjyEWGD4kr0XT@public.gmane.org>
Subject: mount.cifs fails if your password starts with a comma
Date: Tue, 09 Apr 2013 14:22:42 +0200
Message-ID: <51640812.2050900@brockmann-consult.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I'm not subscribed to this list, so be sure to CC

mount.cifs fails if your password starts with a comma, but works with a
comma in the middle. (eg. ",asdfasdf" does not work but "a,asdfasdf" works)

also your password excluding the comma appears in dmesg for all to see

perhaps also a malicious password could be created to add unwanted
options to a user mountable fstab line.


# mount -vvv /fs1
mount: fstab path: "/etc/fstab"
mount: mtab path:  "/etc/mtab"
mount: lock path:  "/etc/mtab~"
mount: temp path:  "/etc/mtab.tmp"
mount: UID:        0
mount: eUID:       0
mount: spec:  "//bcserver2/fs1"
mount: node:  "/fs1"
mount: types: "cifs"
mount: opts:  "user=test,uid=test,gid=users,noauto"
mount: external mount: argv[0] = "/sbin/mount.cifs"
mount: external mount: argv[1] = "//bcserver2/fs1"
mount: external mount: argv[2] = "/fs1"
mount: external mount: argv[3] = "-v"
mount: external mount: argv[4] = "-o"
mount: external mount: argv[5] = "rw,noauto,user=test,uid=1000,gid=100"
Password:       (here I typed ",asdfasdf")
mount.cifs kernel mount options:
ip=10.3.0.5,unc=\\bcserver2\fs1,noauto,uid=1000,gid=100,ver=1,user=test,pass=********
mount error(22): Invalid argument
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

# dmesg | tail -n1
[1221917.271440] CIFS: Unknown mount option "asdfasdf"

# grep cifs /etc/fstab
//bcserver2/fs1 /fs1 cifs user=test,uid=test,gid=users,noauto

# mount -V
mount from util-linux 2.20.1 (with libblkid and selinux support)

# cat /proc/version
Linux version 3.8.4-1-default (geeko@buildhost) (gcc version 4.7.2
20130108 [gcc-4_7-branch revision 195012] (SUSE Linux) ) #1 SMP Fri Mar
22 23:08:34 UTC 2013 (20fc41c)
