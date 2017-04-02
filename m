From: Jon Scott <jonzanscott-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Unable to mount windows share as administrator
Date: Sun, 2 Apr 2017 18:39:00 -0400
Message-ID: <CAJvXCJfBq=iLK=pPXuwQN1fZ4exVkrp2QP5cywWhygpMoKZPLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I'm able to mount a share from Windows 10 without problems if my
.smbcredentials file contains a username and password of a regular
user on the Windows system.  However, if I change the credentials to
an administrator on the Windows system, I get:

mount error(13): Permission denied
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

Here's the relevant /etc/fstab entry:
//RONE/Users/fran /rone_users cifs
credentials=/home/jon/.smbcredentials,ro,iocharset=utf8 0 0

4.4.0-71-generic
mount.cifs version: 6.4
