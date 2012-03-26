From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 00/16] Get SMB2 mount work
Date: Mon, 26 Mar 2012 13:21:27 +0400
Message-ID: <1332753703-4315-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the first SMB2 code specific patchset that enables experimental
SMB2 support for cifs module. This patchset lets mount/stat work
on SMB2 shares.

Also, it doesn't follow the "transport ops" approach we discussed with
Jeff Layton recently in the list but this part can be easily modified
further without big code changes.

The reason why I am posting it in this way is due to the fact that
I have already given much testing for this variant of the patchset
and don't want to change things before the release.

I rebased this on top of Jeff's cifs-3.4 branch.

Pavel Shilovsky (13):
  CIFS: Check for SMB2 vs CIFS in find_tcp_session
  CIFS: Add SMB2 status codes
  CIFS: Make transport routines work with SMB2
  CIFS: Add SMB2 credits support
  CIFS: Make demultiplex_thread work with SMB2 code
  CIFS: Respect SMB2 max hdr size for cifs_request kmem_cache
  CIFS: Add capability to send SMB2 negotiate message
  CIFS: Add session setup/logoff capability for SMB2
  CIFS: Add tree connect/disconnect capability for SMB2
  CIFS: Process reconnects for SMB2 shares
  CIFS: Add SMB2 support for is_path_accessible
  CIFS: Query SMB2 inode info
  CIFS: Get SMB2 mount work

Steve French (3):
  CIFS: Introduce SMB2 Kconfig option
  CIFS: Introduce SMB2 mounts as vers=2
  CIFS: Map SMB2 status codes to POSIX errors

 fs/cifs/Kconfig         |   20 +
 fs/cifs/Makefile        |    3 +
 fs/cifs/cifs_debug.c    |   27 +-
 fs/cifs/cifs_debug.h    |    1 +
 fs/cifs/cifs_unicode.c  |   59 ++
 fs/cifs/cifs_unicode.h  |    5 +-
 fs/cifs/cifsfs.c        |    7 +-
 fs/cifs/cifsglob.h      |   74 ++-
 fs/cifs/cifsproto.h     |   28 +-
 fs/cifs/cifssmb.c       |   27 +-
 fs/cifs/connect.c       |  213 +++++-
 fs/cifs/dir.c           |    6 +-
 fs/cifs/file.c          |    5 +-
 fs/cifs/inode.c         |  105 ++-
 fs/cifs/misc.c          |   96 +++-
 fs/cifs/ntlmssp.h       |   10 +
 fs/cifs/sess.c          |    8 +-
 fs/cifs/smb2glob.h      |   44 ++
 fs/cifs/smb2inode.c     |  183 +++++
 fs/cifs/smb2maperror.c  | 1829 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2misc.c      |  357 +++++++++
 fs/cifs/smb2pdu.c       | 1113 ++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h       |  556 ++++++++++++++
 fs/cifs/smb2proto.h     |   79 ++
 fs/cifs/smb2status.h    | 1782 +++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2transport.c |  151 ++++
 fs/cifs/transport.c     |  106 ++-
 27 files changed, 6744 insertions(+), 150 deletions(-)
 create mode 100644 fs/cifs/smb2glob.h
 create mode 100644 fs/cifs/smb2inode.c
 create mode 100644 fs/cifs/smb2maperror.c
 create mode 100644 fs/cifs/smb2misc.c
 create mode 100644 fs/cifs/smb2pdu.c
 create mode 100644 fs/cifs/smb2pdu.h
 create mode 100644 fs/cifs/smb2proto.h
 create mode 100644 fs/cifs/smb2status.h
 create mode 100644 fs/cifs/smb2transport.c
