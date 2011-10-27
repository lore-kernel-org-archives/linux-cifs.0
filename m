From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Thu, 27 Oct 2011 13:16:21 -0500
Message-ID: <CAH2r5msFde8+dBW1uku_=qv5maXcypoM3cXWCAOK3pbEKv=86w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 65112dccf8a113737684366349d7f9ec373ddc47:

  Merge git://git.samba.org/sfrench/cifs-2.6 (2011-10-10 14:53:11 +1200)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git master

Dan Carpenter (1):
      CIFS: cleanup min_t() cast in cifs_read()

Gerlando Falauto (1):
      CIFS: fix automount for DFS shares

Jeff Layton (27):
      cifs: switch CIFSSMBQAllEAs to use memcmp
      cifs: use memcpy for magic string in cifs signature generation BSRSPYL
      cifs: get rid of unused xid in cifs_get_root
      cifs: untangle server->maxBuf and CIFSMaxBufSize
      cifs: clean up checkSMB
      cifs: consolidate signature generating code
      cifs: trivial: remove obsolete comment
      cifs: make smb_msg local to read_from_socket
      cifs: check for unresponsive server every time we call kernel_recvmsg
      cifs: simplify read_from_socket
      cifs: clean up check_rfc1002_header
      cifs: turn read_from_socket into a wrapper around a vectorized version
      cifs: keep a reusable kvec array for receives
      cifs: add a third receive phase to cifs_demultiplex_thread
      cifs: move mid finding into separate routine
      cifs: eliminate is_multi_rsp parm to find_cifs_mid
      cifs: move buffer pointers into TCP_Server_Info
      cifs: find mid earlier in receive codepath
      cifs: break out 3rd receive phase into separate function
      cifs: add a callback function to receive the rest of the frame
      cifs: fix protocol definition for READ_RSP
      cifs: add cifs_async_readv
      cifs: convert cifs_readpages to use async reads
      cifs: allow for larger rsize= options and change defaults
      cifs: tune bdi.ra_pages in accordance with the rsize
      cifs: allow cifs_max_pending to be readable under
/sys/module/cifs/parameters
      cifs, freezer: add wait_event_freezekillable and have cifs use it

Paul Bolle (1):
      cifs: Fix typo 'CIFS_NFSD_EXPORT'

Pavel Shilovsky (47):
      CIFS: Fix incorrect max RFC1002 write size value
      CIFS: Simplify byte range locking code
      CIFS: Move byte range lock list from fd to inode
      CIFS: Fix error handling in cifs_readv_complete
      CIFS: Fix DFS handling in cifs_get_file_info
      CIFS: Implement caching mechanism for mandatory brlocks
      CIFS: Implement caching mechanism for posix brlocks
      CIFS: Send as many mandatory unlock ranges at once as possible
      CIFS: Make cifs_push_locks send as many locks at once as possible
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
      CIFS: Fix compile warnings

Sachin Prabhu (1):
      cifs: Display strictcache mount option in /proc/mounts

Shirish Pargaonkar (5):
      cifs: Add mount options for backup intent (try #6)
      cifs: clean up unused encryption code
      cifs: Add data structures and functions for uid/gid to SID
mapping (try #4)
      cifs: Call id to SID mapping functions to change owner/group
(try #4 repost)
      CIFS: Enable signing in SMB2

Steve French (25):
      add new module parameter 'enable_oplocks'
      Typo in cifs readme in name of module parm directory
      [CIFS] Show nostrictsync and noperm mount options in /proc/mounts
      Merge branch 'cifs-3.2' of git://git.samba.org/jlayton/linux
into temp-3.2-jeff
      [CIFS] Fixup trivial checkpatch warning
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
      CIFS: Add error mapping function for smb2 status codes to posix errors
      [CIFS] Add SMB2 support for cifs_get_file_info
      CIFS: Introduce SMB2 Kconfig option
      CIFS: Introduce smb2 mounts as vers=2
      [CIFS] Update cifs version to 1.76
      [CIFS] Add definition for share encryption
      [CIFS] Fix endian warnings
      [CIFS] Fix various sparse and compile warnings
      [CIFS] Fix build break when freezer not configured

Suresh Jayaraman (2):
      cifs: update README about the kernel module parameters
      cifs: warn about deprecation of /proc/fs/cifs/OplockEnabled interface

 fs/cifs/Kconfig         |   21 +
 fs/cifs/Makefile        |    4 +
 fs/cifs/README          |   14 +
 fs/cifs/TODO            |    2 +
 fs/cifs/cifs_debug.c    |  355 ++++---
 fs/cifs/cifs_debug.h    |   12 +-
 fs/cifs/cifs_fs_sb.h    |    8 +-
 fs/cifs/cifs_unicode.c  |   61 +
 fs/cifs/cifs_unicode.h  |    7 +
 fs/cifs/cifsacl.c       |  347 +++++-
 fs/cifs/cifsacl.h       |    2 +-
 fs/cifs/cifsencrypt.c   |  135 +--
 fs/cifs/cifsfs.c        |  197 ++--
 fs/cifs/cifsfs.h        |   12 +-
 fs/cifs/cifsglob.h      |  246 ++++-
 fs/cifs/cifspdu.h       |   48 +-
 fs/cifs/cifsproto.h     |  132 ++-
 fs/cifs/cifssmb.c       |  569 ++++++++--
 fs/cifs/connect.c       | 1015 ++++++++++++-----
 fs/cifs/dir.c           |   28 +-
 fs/cifs/export.c        |    4 +-
 fs/cifs/file.c          | 1803 +++++++++++++++++++++---------
 fs/cifs/inode.c         |  207 +++--
 fs/cifs/link.c          |   17 +-
 fs/cifs/maperror.c      | 1830 ++++++++++++++++++++++++++++++
 fs/cifs/misc.c          |   87 +-
 fs/cifs/nterr.h         |    1 +
 fs/cifs/ntlmssp.h       |   10 +
 fs/cifs/readdir.c       |    4 +-
 fs/cifs/sess.c          |   12 +-
 fs/cifs/smb2dir.c       |   79 ++
 fs/cifs/smb2file.c      |  559 +++++++++
 fs/cifs/smb2glob.h      |  215 ++++
 fs/cifs/smb2inode.c     |  829 ++++++++++++++
 fs/cifs/smb2link.c      |  108 ++
 fs/cifs/smb2misc.c      |  523 +++++++++
 fs/cifs/smb2pdu.c       | 2887 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h       | 1064 +++++++++++++++++
 fs/cifs/smb2proto.h     |  280 +++++
 fs/cifs/smb2readdir.c   |  594 ++++++++++
 fs/cifs/smb2sess.c      |  109 ++
 fs/cifs/smb2status.h    | 1782 +++++++++++++++++++++++++++++
 fs/cifs/smb2transport.c |  678 +++++++++++
 fs/cifs/smbencrypt.c    |  121 --
 fs/cifs/transport.c     |  210 +++--
 fs/cifs/xattr.c         |    2 +-
 include/linux/freezer.h |   22 +-
 47 files changed, 15512 insertions(+), 1740 deletions(-)
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

-- 
Thanks,

Steve
