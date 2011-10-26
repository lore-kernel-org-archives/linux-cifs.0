From: Tim Lank <timlank-3iNpEh//jjRBDgjK7y7TUQ@public.gmane.org>
Subject: mount.cifs - 4.8.1 -- server side restart - CIFS VFS: No response for cmd
Date: Wed, 26 Oct 2011 15:27:11 -0400
Message-ID: <CAHyifnRk95LXv-BMpbhiQk8MdQ-RHWcMa8egcOA6CKuR9xFcZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

linux-cifs list:

We are mounting a share provided by a Unisys MCP mainframe with the
following fstab entry....

/etc/fstab:
//UnisysMCPmainframe.example.com/staging_test /mnt/staging cifs
rw,file_mode=3D0775,dir_mode=3D
0775,uid=3D4051,gid=3D4053,credentials=3D/etc/nx-credentials.txt,_netde=
v 0 0

The mount is established just fine and works with the exception that
the mainframe does not support the POSIX utime() calls when files are
being created.

What we see though in operation, is that when the mainframe is
restarted (halt/load in their terminology), the mount.cifs module ends
up throwing the following into /var/log/messages and continually tries
to re-authenticate to the share (gleaned from tcpdump traces).=A0 The
mainframe logs show that these mounts try (and succeed) to "ATTACH"
(re-authenticate & re-establish the connection) once or twice a minute
thereafter.=A0 This essentially fills their logs and makes them unhappy
as you might imagine.=A0 These messages don't appear after an initial
mount and before a mainframe halt/load -- only after that point.

How do we prevent this behavior from our mount.cifs?

/var/log/messages:
Oct 26 04:33:15 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 50 mid 2068
Oct 26 04:35:24 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2071
Oct 26 04:36:07 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2074
Oct 26 04:36:19 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2077
Oct 26 04:38:04 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2090
Oct 26 04:38:16 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2093
Oct 26 04:39:04 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2096
Oct 26 04:39:13 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2099
Oct 26 04:40:07 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2102
Oct 26 04:40:19 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2105
Oct 26 04:41:07 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2108
Oct 26 04:41:16 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2111
Oct 26 04:42:13 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2119
Oct 26 04:42:25 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2122
Oct 26 04:43:10 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2125
Oct 26 04:44:14 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2132
Oct 26 04:45:10 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2139
Oct 26 04:46:13 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2146
Oct 26 04:48:04 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2160
Oct 26 04:48:16 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2163
Oct 26 04:49:04 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2166
Oct 26 04:49:13 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2169
Oct 26 04:50:06 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2172
Oct 26 04:50:18 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2175
Oct 26 04:51:09 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2178
Oct 26 04:51:21 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2181
Oct 26 04:53:04 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2191
Oct 26 04:53:16 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2194
Oct 26 04:54:04 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2197
Oct 26 04:54:13 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2200
Oct 26 04:55:11 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2203
Oct 26 04:55:23 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2206
Oct 26 04:56:07 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2209
Oct 26 04:56:16 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2212
Oct 26 04:56:33 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2215
Oct 26 04:56:39 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2218
Oct 26 04:57:13 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2228
Oct 26 04:58:10 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2235
Oct 26 04:59:13 linuxbox-263213161 kernel: CIFS VFS: No response for
cmd 117 mid 2242

# uname -r -v
2.6.32-131.6.1.el6.x86_64 #1 SMP Mon Jun 20 14:15:38 EDT 2011

# mount.cifs -V
mount.cifs version: 4.8.1

# rpm -qa | grep cifs
cifs-utils-4.8.1-2.el6.x86_64

# modinfo cifs
filename:=A0=A0=A0=A0=A0=A0 /lib/modules/2.6.32-131.6.1.el6.x86_64/kern=
el/fs/cifs/cifs.ko
version:=A0=A0=A0=A0=A0=A0=A0 1.68
description:=A0=A0=A0 VFS to access servers complying with the SNIA CIF=
S
Specification e.g. Samba and Windows
license:=A0=A0=A0=A0=A0=A0=A0 GPL
author:=A0=A0=A0=A0=A0=A0=A0=A0 Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
srcversion:=A0=A0=A0=A0 6BE0EB6FED154E567A97675
depends:
vermagic:=A0=A0=A0=A0=A0=A0 2.6.32-131.6.1.el6.x86_64 SMP mod_unload mo=
dversions
parm:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 CIFSMaxBufSize:Network buffer size =
(not including
header). Default: 16384 Range: 8192 to 130048 (int)
parm:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cifs_min_rcv:Network buffers in poo=
l. Default: 4
Range: 1 to 64 (int)
parm:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cifs_min_small:Small network buffer=
s in pool. Default:
30 Range: 2 to 256 (int)
parm:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cifs_max_pending:Simultaneous reque=
sts to server.
Default: 50 Range: 2 to 256 (int)

Documentation for the Unisys Mainframe can be found here....
http://public.support.unisys.com/search/DocumentationSearch.aspx?ID=3D6=
43&pla=3Dps&nav=3Dps

Unisys MCP release 13.1
MCP: *SYSTEM/MCP/541_74 [MCP 13 / SSR 54.1 (54.189.8444)]
Release ID: XXX 54.1A.74
