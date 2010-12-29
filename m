From: =?iso-8859-1?Q?S=F3nia_Lil=E9o?= <sonia.lileo-aVRZU1sUoHQ@public.gmane.org>
Subject: Limit of simultaneous mount cifs processes?
Date: Wed, 29 Dec 2010 07:45:36 +0100
Message-ID: <8E45B10EB0F9F148970C9EB4C51FE2A00A78DD5E@hosrv-exh-027.ho.dr.dgcsystems.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "'linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: sv-SE
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi!

I am using the following command to mount a folder of my Windows 7 comp=
uter to a cluster of several Linux machines

mount -t cifs //windows7-computer/folder-to-mount /home/sonia/mnt-folde=
r -o user=3Dwindows_user,pass=3Dwindows_password,uid=3Dlinux_user,gid=3D=
linux_group

I need to mount the "folder-to-mount" about 40-50 times simultaneously =
to different "mnt-folders".

But I have found that I cannot do this.=20
It seems that there is a kind of limit that only allows me to mount the=
 "folder-to-mount" about 12-14 times simultaneously.

Why is this happening?
Any hints on how to solve this problem?

The error message that I get is the following,

mount error(5): Input/output error
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

cifs.ko is the following

filename:=A0=A0=A0=A0=A0=A0 cifs.ko
version:=A0=A0=A0=A0=A0=A0=A0 1.61
description:=A0=A0=A0 VFS to access servers complying with the SNIA CIF=
S Specification e.g. Samba and Windows
license:=A0=A0=A0=A0=A0=A0=A0 GPL
author:=A0=A0=A0=A0=A0=A0=A0=A0 Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
srcversion:=A0=A0=A0=A0 6EEAB9465787AE0C514101E
depends:=A0=A0=A0=A0=A0=A0=A0=20
vermagic:=A0=A0=A0=A0=A0=A0 2.6.32-24-server SMP mod_unload modversions=
=20
parm:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 CIFSMaxBufSize:Network buffer size =
(not including header). Default: 16384 Range: 8192 to 130048 (int)
parm:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cifs_min_rcv:Network buffers in poo=
l. Default: 4 Range: 1 to 64 (int)
parm:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cifs_min_small:Small network buffer=
s in pool. Default: 30 Range: 2 to 256 (int)
parm:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cifs_max_pending:Simultaneous reque=
sts to server. Default: 50 Range: 2 to 256 (int)

cat /proc/fs/cifs/DebugData gives

Servers:
1) Name: xx.xxx.xx.xxx=A0 Domain: UN Uses: 1 OS: Windows 7 Professional=
 7600
NOS: Windows 7 Professional 6.1Capability: 0x1e3fc
SMB session status: 1TCP status: 1
Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
Shares:
1) \\windows7-computer\Users Mounts: 3 Type: NTFS DevInfo: 0x20 Attribu=
tes: 0xc700ff
PathComponentMax: 255 Status: 0x1 type: DISK DISCONNECTED=20

MIDs:

2) Name: xx.xxx.xx.xxx=A0 Domain: UN Uses: 1 OS: Windows 7 Professional=
 7600
NOS: Windows 7 Professional 6.1Capability: 0x1e3fc
SMB session status: 1TCP status: 1
Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
Shares:
1) \\windows7-computer\Users Mounts: 10 Type: NTFS DevInfo: 0x20 Attrib=
utes: 0xc700ff
PathComponentMax: 255 Status: 0x1 type: DISK DISCONNECTED=20

/var/log/messages shows

Dec 28 17:00:40 sonia-v1 kernel: [ 6941.421070] Status code returned 0x=
c00000d0
NT_STATUS_REQUEST_NOT_ACCEPTED error in SessSetup =3D -5
Dec 28 17:00:40 sonia-v1 kernel: [ 6941.422241] Status code returned 0x=
c00000d0
NT_STATUS_REQUEST_NOT_ACCEPTED

Regards,
S=F3nia
