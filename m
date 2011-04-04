From: Luk Claes <luk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: slash appended to filesystem when mtab symlinked to proc
Date: Mon, 04 Apr 2011 16:33:05 +0200
Message-ID: <4D99D6A1.7080101@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi

A Debian user reported a bug that a slash gets appended to the
filesystem when he mounts a share. This only happens when mtab is
symlinked to proc which I can reproduce:

$ grep cifs /etc/fstab
//<host>/<path>	/mnt	cifs	user,user=<username>	0	0

$ mount /mnt

$ grep cifs /etc/mtab
//<host>/<path>/ /mnt cifs
rw,nosuid,nodev,relatime,unc=\\<host>\<path>,username=<username>,uid=1000,forceuid,gid=1000,forcegid,addr=<ip>,file_mode=0755,dir_mode=0755,serverino,rsize=16384,wsize=57344
0 0

$ umount /mnt
umount: /mnt mount disagrees with the fstab

There does not seem to be any other filesystems that append a slash to
the filesystem in proc. Does cifsfs do that intentionally (in which case
the client should cope with it: by means of umount.cifs?) or should it
get fixed in the kernel (maybe the client should still cope with it)?

Can you give me a hand in identifying the code that would need to be
updated to fix this so I can prepare a patch?

Cheers

Luk
