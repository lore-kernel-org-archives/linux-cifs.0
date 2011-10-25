From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 00/53] SMB2 protocol support for CIFS kernel module
Date: Tue, 25 Oct 2011 10:11:33 +0400
Message-ID: <1319523146-2859-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset enables SMB2 support with CONFIG_CIFS_SMB2 Kconfig option. While many operations work now, there are a lot of places to do here (brlocks, acls, prefixpaths, set_attr, etc).

You can test it by building with CONFIG_CIFS_SMB2 enabled and mounting with vers=2 option.


Pavel Shilovsky (37):
  CIFS: Add SMB2 transport routines
  CIFS: Expand cifs mid structure to keep SMB2 related fields
  CIFS: Make demultiplex_thread work with SMB2 code
  CIFS: Get mount/umount work with SMB2 protocol
  CIFS: Simplify SMB2 query info
  CIFS: Add SMB2 inode/dentry ops structures
  CIFS: Add SMB2 support for mkdir operation
  CIFS: Add SMB2 support for rmdir operation
  CIFS: Add SMB2 support for unlink operation
  CIFS: Add SMB2 support open/close file operations
  CIFS: Add SMB2 support for reopen file operation
  CIFS: Add SMB2 support for cifs_iovec_write
  CIFS: Add SMB2 support for cifs_iovec_read
  CIFS: Add address space ops structures for SMB2
  CIFS: Add read related address space operations for SMB2
  CIFS: Add write related address space operations for SMB2
  CIFS: Respect max buf size for SMB2 read and write
  CIFS: Temporarily disable set inode info for SMB2
  CIFS: Add writepages support for SMB2
  CIFS: Add readpages support for SMB2
  CIFS: Add echo request support for SMB2
  CIFS: Add SMB2 support for create operation
  CIFS: Add readdir support for SMB2
  CIFS: Add SMB2 support for rename operation
  CIFS: Add SMB2 support for hardlink operation
  CIFS: Add SMB2 support for flush operation
  CIFS: Add NTLMSSP sec type to defaults
  CIFS: Disable SMB2.1 protocol negotiating
  CIFS: Process oplocks for SMB2
  CIFS: Process STATUS_PENDING responses for SMB2
  CIFS: Request SMB2.1 leases
  CIFS: Process oplock/lease break for SMB2/2.1
  CIFS: Add strictcache i/o for SMB2
  CIFS: Process signing for SMB2_logoff
  CIFS: Change Makefile to support CONFIG_CIFS_SMB2
  CIFS: Add statfs support for SMB2
  CIFS: Disable lock call for SMB2 since we don't support it

Shirish Pargaonkar (1):
  CIFS: Enable signing in SMB2

Steve French (15):
  CIFS: Update cifs global structures to handle smb2 sessions
  CIFS: Allow SMB2 statistics to be tracked
  CIFS: Check for smb2 vs. cifs in find_tcp_session
  CIFS: Do not try to dump cifs mids from smb2 sessions
  CIFS: wait_for_free_request needs to wait on credits returned by
    server (for SMB2)
  CIFS: Add missing unicode handling routines needed by smb2
  CIFS: Add structure definitions for SMB2 PDUs
  CIFS: Add initial SMB2 worker functions
  CIFS: Allocating SMB2 mids (multiplex identifier structures)
  CIFS: Add routines to free SMB2 mids
  CIFS: Add sync_smb2_mid_result
  CIFS: Add error mapping function for smb2 status codes to posix
    errors
  [CIFS] Add SMB2 support for cifs_get_file_info
  CIFS: Introduce SMB2 Kconfig option
  CIFS: Introduce smb2 mounts as vers=2

 fs/cifs/Kconfig         |   21 +
 fs/cifs/Makefile        |    4 +
 fs/cifs/TODO            |    2 +
 fs/cifs/cifs_debug.c    |  345 ++++---
 fs/cifs/cifs_debug.h    |   12 +-
 fs/cifs/cifs_fs_sb.h    |    4 +-
 fs/cifs/cifs_unicode.c  |   61 +
 fs/cifs/cifs_unicode.h  |    7 +
 fs/cifs/cifsacl.h       |    2 +-
 fs/cifs/cifsencrypt.c   |   30 +-
 fs/cifs/cifsfs.c        |  173 ++--
 fs/cifs/cifsfs.h        |    6 +-
 fs/cifs/cifsglob.h      |  193 +++-
 fs/cifs/cifsproto.h     |  112 ++-
 fs/cifs/cifssmb.c       |  157 ++-
 fs/cifs/connect.c       |  382 ++++++--
 fs/cifs/dir.c           |    6 +-
 fs/cifs/file.c          |  655 ++++++++---
 fs/cifs/inode.c         |  153 ++-
 fs/cifs/maperror.c      | 1830 ++++++++++++++++++++++++++++++
 fs/cifs/misc.c          |   21 +-
 fs/cifs/nterr.h         |    1 +
 fs/cifs/ntlmssp.h       |   10 +
 fs/cifs/readdir.c       |    4 +-
 fs/cifs/sess.c          |    8 +-
 fs/cifs/smb2dir.c       |   79 ++
 fs/cifs/smb2file.c      |  559 +++++++++
 fs/cifs/smb2glob.h      |  215 ++++
 fs/cifs/smb2inode.c     |  828 ++++++++++++++
 fs/cifs/smb2link.c      |  108 ++
 fs/cifs/smb2misc.c      |  523 +++++++++
 fs/cifs/smb2pdu.c       | 2886 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h       | 1063 +++++++++++++++++
 fs/cifs/smb2proto.h     |  280 +++++
 fs/cifs/smb2readdir.c   |  594 ++++++++++
 fs/cifs/smb2sess.c      |  109 ++
 fs/cifs/smb2status.h    | 1782 +++++++++++++++++++++++++++++
 fs/cifs/smb2transport.c |  677 +++++++++++
 fs/cifs/transport.c     |  191 ++--
 39 files changed, 13315 insertions(+), 778 deletions(-)
 create mode 100644 fs/cifs/maperror.c
 create mode 100644 fs/cifs/smb2dir.c
 create mode 100644 fs/cifs/smb2file.c
 create mode 100644 fs/cifs/smb2glob.h
 create mode 100644 fs/cifs/smb2inode.c
 create mode 100644 fs/cifs/smb2link.c
 create mode 100644 fs/cifs/smb2misc.c
 create mode 100644 fs/cifs/smb2pdu.c
 create mode 100644 fs/cifs/smb2pdu.h
 create mode 100644 fs/cifs/smb2proto.h
 create mode 100644 fs/cifs/smb2readdir.c
 create mode 100644 fs/cifs/smb2sess.c
 create mode 100644 fs/cifs/smb2status.h
 create mode 100644 fs/cifs/smb2transport.c
