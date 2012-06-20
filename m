From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 00/24] Get SMB2 mount work
Date: Wed, 20 Jun 2012 18:37:25 +0400
Message-ID: <CAKywueTKQEMz0pz_DbvFGC8xV4pHK3D=V-X_LXtdfVmTooFUug@mail.gmail.com>
References: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340202664-28696-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/6/20 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> This is the first chunk of SMB2 patches. It allows:
> 1) mount a network share,
> 2) stat inode information,
> 3) send echo message,
> 4) display statistics.
>
> The patchset implements the approach of having ops structure of
> protocol-specific callbacks that is used by the generic code.
>
> Changes since version #1:
> - add patch that fixes Get/FreeXid
> - add patch that prefixes existing CIFS STATUS_ codes with NT_
>
> Pavel Shilovsky (23):
> =A0CIFS: Rename Get/FreeXid and make them work with unsigned int
> =A0CIFS: Rename 7 error codes to NT_ style
> =A0CIFS: Add SMB2 status codes
> =A0CIFS: Make transport routines work with SMB2
> =A0CIFS: Add SMB2 credits support
> =A0CIFS: Make demultiplex_thread work with SMB2 code
> =A0CIFS: Respect SMB2 header/max header size
> =A0CIFS: Add capability to send SMB2 negotiate message
> =A0CIFS: Add session setup/logoff capability for SMB2
> =A0CIFS: Add tree connect/disconnect capability for SMB2
> =A0CIFS: Process reconnects for SMB2 shares
> =A0CIFS: Move getting dfs referalls to ops struct
> =A0CIFS: Move informational tcon calls to ops struct
> =A0CIFS: Move is_path_accessible to ops struct
> =A0CIFS: Add SMB2 support for is_path_accessible
> =A0CIFS: Move query inode info code to ops struct
> =A0CIFS: Query SMB2 inode info
> =A0CIFS: Move building path to root to ops struct
> =A0CIFS: Add SMB2 support for build_path_to_root
> =A0CIFS: Move echo code to osp struct
> =A0CIFS: Add echo request support for SMB2
> =A0CIFS: Move clear/print_stats code to ops struct
> =A0CIFS: Allow SMB2 statistics to be tracked
>
> Steve French (1):
> =A0CIFS: Map SMB2 status codes to POSIX errors
>
> =A0fs/cifs/Makefile =A0 =A0 =A0 =A0| =A0 =A03 +-
> =A0fs/cifs/cifs_debug.c =A0 =A0| =A0 62 +--
> =A0fs/cifs/cifs_dfs_ref.c =A0| =A0 =A07 +-
> =A0fs/cifs/cifs_unicode.c =A0| =A0 60 ++
> =A0fs/cifs/cifs_unicode.h =A0| =A0 =A06 +-
> =A0fs/cifs/cifsacl.c =A0 =A0 =A0 | =A0 21 +-
> =A0fs/cifs/cifsfs.c =A0 =A0 =A0 =A0| =A0 24 +-
> =A0fs/cifs/cifsglob.h =A0 =A0 =A0| =A0126 +++-
> =A0fs/cifs/cifsproto.h =A0 =A0 | =A0210 +++---
> =A0fs/cifs/cifssmb.c =A0 =A0 =A0 | =A0303 ++++----
> =A0fs/cifs/connect.c =A0 =A0 =A0 | =A0151 ++---
> =A0fs/cifs/dir.c =A0 =A0 =A0 =A0 =A0 | =A0 24 +-
> =A0fs/cifs/file.c =A0 =A0 =A0 =A0 =A0| =A0133 ++--
> =A0fs/cifs/inode.c =A0 =A0 =A0 =A0 | =A0209 ++----
> =A0fs/cifs/ioctl.c =A0 =A0 =A0 =A0 | =A0 =A06 +-
> =A0fs/cifs/link.c =A0 =A0 =A0 =A0 =A0| =A0 24 +-
> =A0fs/cifs/misc.c =A0 =A0 =A0 =A0 =A0| =A0 31 +-
> =A0fs/cifs/nterr.c =A0 =A0 =A0 =A0 | =A0 =A06 +-
> =A0fs/cifs/nterr.h =A0 =A0 =A0 =A0 | =A0 26 +-
> =A0fs/cifs/ntlmssp.h =A0 =A0 =A0 | =A0 10 +
> =A0fs/cifs/readdir.c =A0 =A0 =A0 | =A0 15 +-
> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0 =A0| =A0 =A06 +-
> =A0fs/cifs/smb1ops.c =A0 =A0 =A0 | =A0186 +++++
> =A0fs/cifs/smb2glob.h =A0 =A0 =A0| =A0 44 ++
> =A0fs/cifs/smb2inode.c =A0 =A0 | =A0124 ++++
> =A0fs/cifs/smb2maperror.c =A0| 1829 +++++++++++++++++++++++++++++++++=
++++++++++++++
> =A0fs/cifs/smb2misc.c =A0 =A0 =A0| =A0344 +++++++++
> =A0fs/cifs/smb2ops.c =A0 =A0 =A0 | =A0298 ++++++++
> =A0fs/cifs/smb2pdu.c =A0 =A0 =A0 | 1125 +++++++++++++++++++++++++++++
> =A0fs/cifs/smb2pdu.h =A0 =A0 =A0 | =A0568 +++++++++++++++
> =A0fs/cifs/smb2proto.h =A0 =A0 | =A0 75 ++
> =A0fs/cifs/smb2status.h =A0 =A0| 1782 +++++++++++++++++++++++++++++++=
++++++++++++++
> =A0fs/cifs/smb2transport.c | =A0151 ++++
> =A0fs/cifs/transport.c =A0 =A0 | =A0 13 +-
> =A0fs/cifs/xattr.c =A0 =A0 =A0 =A0 | =A0 24 +-
> =A035 files changed, 7317 insertions(+), 709 deletions(-)
> =A0create mode 100644 fs/cifs/smb2glob.h
> =A0create mode 100644 fs/cifs/smb2inode.c
> =A0create mode 100644 fs/cifs/smb2maperror.c
> =A0create mode 100644 fs/cifs/smb2misc.c
> =A0create mode 100644 fs/cifs/smb2pdu.c
> =A0create mode 100644 fs/cifs/smb2pdu.h
> =A0create mode 100644 fs/cifs/smb2proto.h
> =A0create mode 100644 fs/cifs/smb2status.h
> =A0create mode 100644 fs/cifs/smb2transport.c
>

Also, I pushed these patches to smb2-mount branch:
http://git.altlinux.org/people/piastry/public/?p=3Dcifs-2.6.git;a=3Dsho=
rtlog;h=3Drefs/heads/smb2-mount

--=20
Best regards,
Pavel Shilovsky.
