From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Wed, 25 Jul 2012 14:58:00 -0500
Message-ID: <CAH2r5mvgQTG2j68c78hiZBMbgNvL3t6iY+d6CWnvtqQXNu2kaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 0ec4f431eb56d633da3a55da67d5c4b88886ccc7:

  locks: fix checking of fcntl_setlease argument (2012-07-23 12:46:01 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 764a1b1acecedfe204cb2e80d8e2cc7c6df1b0b8:

  cifs: ensure that we always do cifsFileInfo_get under the spinlock
(2012-07-25 14:51:30 -0500)

----------------------------------------------------------------
Jeff Layton (7):
      cifs: after upcalling for krb5 creds, invalidate key rather than
revoking it
      cifs: remove extraneous newlines from cERROR and cFYI calls
      cifs: move file_lock off stack in cifs_push_posix_locks
      cifs: remove bogus reset of smb_buf_length in smb_send routines
      cifs: rename cifs_sign_smb2 to cifs_sign_smbv
      cifs: reinstate sec=ntlmv2 mount option
      cifs: ensure that we always do cifsFileInfo_get under the spinlock

Pavel Shilovsky (32):
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
      CIFS: Make CAP_* checks protocol independent

Steve French (1):
      CIFS: Map SMB2 status codes to POSIX errors

 fs/cifs/Makefile        |    3 +-
 fs/cifs/cache.c         |    2 +-
 fs/cifs/cifs_debug.c    |   62 +-
 fs/cifs/cifs_dfs_ref.c  |    7 +-
 fs/cifs/cifs_unicode.c  |   60 ++
 fs/cifs/cifs_unicode.h  |    6 +-
 fs/cifs/cifsacl.c       |   27 +-
 fs/cifs/cifsencrypt.c   |   52 +-
 fs/cifs/cifsfs.c        |   24 +-
 fs/cifs/cifsglob.h      |  192 +++-
 fs/cifs/cifsproto.h     |  253 ++---
 fs/cifs/cifssmb.c       |  365 +++----
 fs/cifs/connect.c       |  446 +++------
 fs/cifs/dir.c           |   51 +-
 fs/cifs/file.c          |  193 ++--
 fs/cifs/inode.c         |  236 ++---
 fs/cifs/ioctl.c         |    6 +-
 fs/cifs/link.c          |   44 +-
 fs/cifs/misc.c          |   31 +-
 fs/cifs/nterr.c         |    6 +-
 fs/cifs/nterr.h         |   22 +-
 fs/cifs/ntlmssp.h       |   10 +
 fs/cifs/readdir.c       |   31 +-
 fs/cifs/sess.c          |   12 +-
 fs/cifs/smb1ops.c       |  399 +++++++-
 fs/cifs/smb2glob.h      |   44 +
 fs/cifs/smb2inode.c     |  124 +++
 fs/cifs/smb2maperror.c  | 2477 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2misc.c      |  347 +++++++
 fs/cifs/smb2ops.c       |  304 ++++++
 fs/cifs/smb2pdu.c       | 1125 +++++++++++++++++++++
 fs/cifs/smb2pdu.h       |  577 +++++++++++
 fs/cifs/smb2proto.h     |   78 ++
 fs/cifs/smb2status.h    | 1782 ++++++++++++++++++++++++++++++++++
 fs/cifs/smb2transport.c |  172 ++++
 fs/cifs/smbencrypt.c    |   14 +-
 fs/cifs/transport.c     |   95 +-
 fs/cifs/xattr.c         |   24 +-
 38 files changed, 8555 insertions(+), 1148 deletions(-)
 create mode 100644 fs/cifs/smb2glob.h
 create mode 100644 fs/cifs/smb2inode.c
 create mode 100644 fs/cifs/smb2maperror.c
 create mode 100644 fs/cifs/smb2misc.c
 create mode 100644 fs/cifs/smb2pdu.c
 create mode 100644 fs/cifs/smb2pdu.h
 create mode 100644 fs/cifs/smb2proto.h
 create mode 100644 fs/cifs/smb2status.h
 create mode 100644 fs/cifs/smb2transport.c

-- 
Thanks,

Steve
