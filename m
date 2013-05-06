From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 6 May 2013 09:02:02 -0500
Message-ID: <CAH2r5mukY9ERoHnE3qj9B-MGKFTFptJMotZ7N27a1G+P_g3C=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A set of cifs cleanup fixes.  The only big one of this set optimizes
the cifs error logging, renaming cFYI and cERROR macros to cifs_dbg,
and in the process makes it clearer and reduces module size.

The following changes since commit 173192958d06b8d1eb44f56d74373052ad6a9a60:

  Merge tag 'mmc-updates-for-3.10-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc (2013-05-04
13:45:17 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to b13ce4bbcae6181eb9cdda5a5bf88a28b0acd7aa:

  cifs: small variable name cleanup (2013-05-04 22:18:10 -0500)

----------------------------------------------------------------
Dan Carpenter (1):
      cifs: small variable name cleanup

Dia Vasile (1):
      cifs: replaced kmalloc + memset with kzalloc

Jeff Layton (4):
      cifs: ignore the unc= and prefixpath= mount options
      cifs: remove ENOSPC handling in smb_sendv
      cifs: on send failure, readjust server sequence number downward
      cifs: store the real expected sequence number in the mid

Joe Perches (1):
      [CIFS] cifs: Rename cERROR and cFYI to cifs_dbg

Silviu-Mihai Popescu (1):
      fs: cifs: use kmemdup instead of kmalloc + memcpy

Wei Yongjun (1):
      CIFS: fix error return code in cifs_atomic_open()

 fs/cifs/asn1.c          |  40 ++--
 fs/cifs/cache.c         |   6 +-
 fs/cifs/cifs_debug.c    |  67 ++++---
 fs/cifs/cifs_debug.h    |  70 +++----
 fs/cifs/cifs_dfs_ref.c  |  41 ++--
 fs/cifs/cifs_spnego.c   |   5 +-
 fs/cifs/cifs_unicode.c  |   4 +-
 fs/cifs/cifsacl.c       | 130 ++++++-------
 fs/cifs/cifsencrypt.c   | 106 +++++------
 fs/cifs/cifsfs.c        |  36 ++--
 fs/cifs/cifsproto.h     |  10 +-
 fs/cifs/cifssmb.c       | 488 ++++++++++++++++++++++++------------------------
 fs/cifs/connect.c       | 368 +++++++++++++++---------------------
 fs/cifs/dir.c           |  48 ++---
 fs/cifs/dns_resolve.c   |  17 +-
 fs/cifs/export.c        |   2 +-
 fs/cifs/file.c          | 166 ++++++++--------
 fs/cifs/fscache.c       |  58 +++---
 fs/cifs/inode.c         | 109 +++++------
 fs/cifs/ioctl.c         |   6 +-
 fs/cifs/link.c          |  24 +--
 fs/cifs/misc.c          |  78 ++++----
 fs/cifs/netmisc.c       |  16 +-
 fs/cifs/readdir.c       |  77 ++++----
 fs/cifs/sess.c          |  77 ++++----
 fs/cifs/smb1ops.c       |  50 ++---
 fs/cifs/smb2file.c      |   8 +-
 fs/cifs/smb2inode.c     |   2 +-
 fs/cifs/smb2maperror.c  |   2 +-
 fs/cifs/smb2misc.c      |  96 +++++-----
 fs/cifs/smb2ops.c       |  16 +-
 fs/cifs/smb2pdu.c       | 161 ++++++++--------
 fs/cifs/smb2transport.c |  26 +--
 fs/cifs/smbencrypt.c    |  17 +-
 fs/cifs/transport.c     |  84 +++++----
 fs/cifs/xattr.c         |  54 +++---
 36 files changed, 1261 insertions(+), 1304 deletions(-)

--
Thanks,

Steve
