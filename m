From: ROBIN CERNIN <cerninr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: CIFS - VFS error question
Date: Wed, 26 Sep 2012 09:33:03 +0200
Message-ID: <CAFdSyFFkcSbBrqH7mgBJxFL+kfZNuMBK+8ZGoarPxQeAS0rXng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

First of all I wanna say you are doing great job developing cif-utils.
Secondly I have question on using following version of cifs:

filename:       /lib/modules/2.6.18-308.8.1.
el5/kernel/fs/cifs/cifs.ko
version:        1.60RH
description:    VFS to access servers complying with the SNIA CIFS
Specification e.g. Samba and Windows
license:        GPL
author:         Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
srcversion:     63D9396D38F380652744D7E
depends:
vermagic:       2.6.18-308.8.1.el5 SMP mod_unload gcc-4.1
parm:           CIFSMaxBufSize:Network buffer size (not including
header). Default: 16384 Range: 8192 to 130048 (int)
parm:           cifs_min_rcv:Network buffers in pool. Default: 4
Range: 1 to 64 (int)
parm:           cifs_min_small:Small network buffers in pool. Default:
30 Range: 2 to 256 (int)
parm:           cifs_max_pending:Simultaneous requests to server.
Default: 50 Range: 2 to 256 (int)
module_sig:    883f3504fa440f6a462ac2afa8e12f112b2f409f6ea4176acbbe7f2f2c13e944e9a17d507b429c09c8e9ef6118eb3d5c40fcbfa81c96bf86e626c06e

on RHEL get following errors in the /var/log/messages:

Sep 24 20:08:48 xxxxxxx kernel:  CIFS VFS: No response for cmd 50 mid 39222
Sep 24 20:08:48 xxxxxxx kernel:  CIFS VFS: No response for cmd 50 mid 39231
Sep 24 20:08:48 xxxxxxx kernel:  CIFS VFS: No response for cmd 50 mid 39236
Sep 25 10:45:16 xxxxxxx kernel:  CIFS VFS: Send error in SessSetup = -5
Sep 25 10:45:16 xxxxxxx kernel:  CIFS VFS: Unexpected lookup error -5
Sep 25 13:08:25 xxxxxxx kernel:  CIFS VFS: No response for cmd 6 mid 47208
Sep 25 16:50:27 xxxxxxx kernel:  CIFS VFS: No response for cmd 162 mid 48857
Sep 25 20:07:37 xxxxxxx kernel:  CIFS VFS: No response for cmd 50 mid 50442


Can you please clarify a bit to me what are these errors related to? I
dont hear anyone complaing that this isnt working but I can still see
these errors.

Thank you in advanced,
Best Regards,
Robin Cernin
