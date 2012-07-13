From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 00/32] Get SMB2 mount work
Date: Fri, 13 Jul 2012 11:53:13 +0400
Message-ID: <1342166025-29377-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This version has the following changes:
1) patchset included "transport/session code move to ops struct" patchset
2) fixed credit patch
3) added echo patches
4) STATUS_* errors became __constant_cpu_to_le32
5) improved coding style
6) rebased on top of vfs atomic-open changes

Available on git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-mount

Pavel Shilovsky (31):
  CIFS: Move trans2 processing to ops struct
  CIFS: Extend credit mechanism to process request type
  CIFS: Move protocol specific negotiate code to ops struct
  CIFS: Move protocol specific session setup/logoff code to ops struct
  CIFS: Move protocol specific tcon/tdis code to ops struct
  CIFS: Rename Get/FreeXid and make them work with unsigned int
  CIFS: Rename 7 error codes to NT_ style
  CIFS: Add SMB2 status codes
  CIFS: Make transport routines work with SMB2
  CIFS: Add SMB2 credits support
  CIFS: Fix a wrong pointer in atomic_open
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
  CIFS: Setup async request in ops struct
  CIFS: Add SMB2 support for async requests
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
 fs/cifs/cifsglob.h      |  172 +++-
 fs/cifs/cifsproto.h     |  242 +++---
 fs/cifs/cifssmb.c       |  339 ++++----
 fs/cifs/connect.c       |  417 +++------
 fs/cifs/dir.c           |   48 +-
 fs/cifs/file.c          |  133 ++--
 fs/cifs/inode.c         |  210 ++---
 fs/cifs/ioctl.c         |    6 +-
 fs/cifs/link.c          |   24 +-
 fs/cifs/misc.c          |   31 +-
 fs/cifs/nterr.c         |    6 +-
 fs/cifs/nterr.h         |   26 +-
 fs/cifs/ntlmssp.h       |   10 +
 fs/cifs/readdir.c       |   15 +-
 fs/cifs/sess.c          |   10 +-
 fs/cifs/smb1ops.c       |  396 ++++++++-
 fs/cifs/smb2glob.h      |   44 +
 fs/cifs/smb2inode.c     |  124 +++
 fs/cifs/smb2maperror.c  | 2477 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2misc.c      |  347 +++++++
 fs/cifs/smb2ops.c       |  301 ++++++
 fs/cifs/smb2pdu.c       | 1123 +++++++++++++++++++++
 fs/cifs/smb2pdu.h       |  574 +++++++++++
 fs/cifs/smb2proto.h     |   78 ++
 fs/cifs/smb2status.h    | 1782 ++++++++++++++++++++++++++++++++++
 fs/cifs/smb2transport.c |  172 ++++
 fs/cifs/transport.c     |   87 +-
 fs/cifs/xattr.c         |   24 +-
 35 files changed, 8395 insertions(+), 1006 deletions(-)
 create mode 100644 fs/cifs/smb2glob.h
 create mode 100644 fs/cifs/smb2inode.c
 create mode 100644 fs/cifs/smb2maperror.c
 create mode 100644 fs/cifs/smb2misc.c
 create mode 100644 fs/cifs/smb2pdu.c
 create mode 100644 fs/cifs/smb2pdu.h
 create mode 100644 fs/cifs/smb2proto.h
 create mode 100644 fs/cifs/smb2status.h
 create mode 100644 fs/cifs/smb2transport.c
