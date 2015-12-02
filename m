From: =?UTF-8?Q?Beno=c3=aet_Jager?= <jager-l5XJctvgKDKHXe+LvDLADg@public.gmane.org>
Subject: Encryption feature
Date: Wed, 2 Dec 2015 12:05:06 +0100
Message-ID: <565ED062.2010200@itrust.lu>
Reply-To: <jager-l5XJctvgKDKHXe+LvDLADg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

When setting up a samba 4 server acting as Active Directory, it is
possible to enable encryption with "smb encrypt =3D mandatory" entry in
configuration file for global section.
With this configuration, Windows machines (8 and 10) are able to
communicate (with encryption) with AD server.

But for linux stations, only smbclient works (using smbclient -e -m SMB=
3
\\\\<DNS AD>\\<SHARE>).

With cifs-utils (v. ), I get a "mount error(3): Permission denied" on
command line, and a "STATUS_ACCESS_DENIED" on logs.
I use following command : mount -t cifs //<DNS AD>//<SHARE> /mnt -o
user=3D<USER>,workgroup=3D<WORKGROUP>,ip=3D<IP>,vers=3D3.0

As manpage (man 8 mount.cifs) contains this note for "vers" option:
"Note too that while this option governs the protocol version used, not
all features of each version are available."
and sec option seems to only protect password when authenticating

Do you have any information on when encryption feature could be
implemented ?

Thanks

Beno=C3=AEt Jager
