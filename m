From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 00/24] Get SMB2 mount work
Date: Wed, 20 Jun 2012 18:30:40 +0400
Message-ID: <1340202664-28696-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the first chunk of SMB2 patches. It allows:
1) mount a network share,
2) stat inode information,
3) send echo message,
4) display statistics.

The patchset implements the approach of having ops structure of
protocol-specific callbacks that is used by the generic code.

Changes since version #1:
- add patch that fixes Get/FreeXid
- add patch that prefixes existing CIFS STATUS_ codes with NT_

Pavel Shilovsky (23):
  CIFS: Rename Get/FreeXid and make them work with unsigned int
  CIFS: Rename 7 error codes to NT_ style
  CIFS: Add SMB2 status codes
  CIFS: Make transport routines work with SMB2
  CIFS: Add SMB2 credits support
  CIFS: Make demultiplex_thread work with SMB2 code
  CIFS: Respect SMB2 header/max header size
  CIFS: Add capability to send SMB2 negotiate message
  CIFS: Add session setup/logoff capability for SMB2
  CIFS: Add tree connect/disconnect capability for SMB2
  CIFS: Process reconnects for SMB2 shares
  CIFS: Move getting dfs referalls to ops struct
  CIFS: Move informational tcon calls to ops struct
  CIFS: Move is_path_accessible to ops struct
  CIFS: Add SMB2 support for is_path_accessible
  CIFS: Move query inode info code to ops struct
  CIFS: Query SMB2 inode info
  CIFS: Move building path to root to ops struct
  CIFS: Add SMB2 support for build_path_to_root
  CIFS: Move echo code to osp struct
  CIFS: Add echo request support for SMB2
  CIFS: Move clear/print_stats code to ops struct
  CIFS: Allow SMB2 statistics to be tracked

Steve French (1):
  CIFS: Map SMB2 status codes to POSIX errors

 fs/cifs/Makefile        |    3 +-
 fs/cifs/cifs_debug.c    |   62 +--
 fs/cifs/cifs_dfs_ref.c  |    7 +-
 fs/cifs/cifs_unicode.c  |   60 ++
 fs/cifs/cifs_unicode.h  |    6 +-
 fs/cifs/cifsacl.c       |   21 +-
 fs/cifs/cifsfs.c        |   24 +-
 fs/cifs/cifsglob.h      |  126 +++-
 fs/cifs/cifsproto.h     |  210 +++---
 fs/cifs/cifssmb.c       |  303 ++++----
 fs/cifs/connect.c       |  151 ++---
 fs/cifs/dir.c           |   24 +-
 fs/cifs/file.c          |  133 ++--
 fs/cifs/inode.c         |  209 ++----
 fs/cifs/ioctl.c         |    6 +-
 fs/cifs/link.c          |   24 +-
 fs/cifs/misc.c          |   31 +-
 fs/cifs/nterr.c         |    6 +-
 fs/cifs/nterr.h         |   26 +-
 fs/cifs/ntlmssp.h       |   10 +
 fs/cifs/readdir.c       |   15 +-
 fs/cifs/sess.c          |    6 +-
 fs/cifs/smb1ops.c       |  186 +++++
 fs/cifs/smb2glob.h      |   44 ++
 fs/cifs/smb2inode.c     |  124 ++++
 fs/cifs/smb2maperror.c  | 1829 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2misc.c      |  344 +++++++++
 fs/cifs/smb2ops.c       |  298 ++++++++
 fs/cifs/smb2pdu.c       | 1125 +++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h       |  568 +++++++++++++++
 fs/cifs/smb2proto.h     |   75 ++
 fs/cifs/smb2status.h    | 1782 +++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2transport.c |  151 ++++
 fs/cifs/transport.c     |   13 +-
 fs/cifs/xattr.c         |   24 +-
 35 files changed, 7317 insertions(+), 709 deletions(-)
 create mode 100644 fs/cifs/smb2glob.h
 create mode 100644 fs/cifs/smb2inode.c
 create mode 100644 fs/cifs/smb2maperror.c
 create mode 100644 fs/cifs/smb2misc.c
 create mode 100644 fs/cifs/smb2pdu.c
 create mode 100644 fs/cifs/smb2pdu.h
 create mode 100644 fs/cifs/smb2proto.h
 create mode 100644 fs/cifs/smb2status.h
 create mode 100644 fs/cifs/smb2transport.c
