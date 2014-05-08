From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: STATUS_USER_SESSION_DELETED: auth problems when downgrading from
 vers=3.0 to vers=2.0/2.1
Date: Thu, 08 May 2014 11:51:06 +0100
Message-ID: <1399546266.2850.16.camel@sachin-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I just finished installing a copy of Windows 2012 and was testing
version 3 when I came across this particular problem.

To reproduce
1) First mount a share using vers=3.0
# mount -t cifs -o username=user1,password=pass1,vers=3.0 //vm140-54/exports /mnt
This is successful.
2) Now unmount this share and attempt to mount with vers=2.0 to 2.1
# mount -t cifs -o username=user1,password=pass1,vers=2.1 //vm140-54/exports /mnt
mount error(5): Input/output error
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

/var/log/messages shows
kernel: [ 2730.843939] Status code returned 0xc0000203 STATUS_USER_SESSION_DELETED
kernel: [ 2730.846883] CIFS VFS: Send error in SessSetup = -5
kernel: [ 2730.849247] CIFS VFS: cifs_mount failed w/return code = -5

I can then mount using vers=3.0 and vers=1.0 but not 2.0 or 2.1.

I am attempting to debug this but was wondering if anyone had
encountered this before.

Sachin Prabhu
