From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 27 May 2011 10:36:50 -0500
Message-ID: <BANLkTikL34jsdYOVL_z6mvwgTk8fAjNVEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 71a8638480eb8fb6cfabe2ee9ca3fbc6e3453a14:

  Merge branch 'viafb-next' of git://github.com/schandinat/linux-2.6
(2011-05-22 12:39:58 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
..BRANCH.NOT.VERIFIED..

Christoph Hellwig (1):
      cifs: remove unused SMB2 config and mount options

Jeff Layton (7):
      cifs: consolidate SendReceive response checks
      cifs: make cifs_send_async take a kvec array
      cifs: add ignore_pend flag to cifs_call_async
      cifs: don't call mid_q_entry->callback under the Global_MidLock (try #5)
      cifs: convert cifs_writepages to use async writes
      cifs: clean up wsize negotiation and allow for larger wsize
      cifs: add cifs_async_writev

Pavel Shilovsky (7):
      CIFS: Simplify connection structure search calls
      CIFS: Simplify mount code for further shared sb capability
      CIFS: Fix undefined behavior when mount fails
      CIFS: Use pid saved from cifsFileInfo in writepages and set_file_size
      CIFS: Fix memory leak in cifs_do_mount
      CIFS: Migrate to shared superblock model
      CIFS: Add rwpidforward mount option

Steve French (5):
      [CIFS] When mandatory encryption on share, fail mount
      [CIFS] Migrate from prefixpath logic
      Fix extended security auth failure
      [CIFS] Rename three structures to avoid camel case
      [CIFS] Fix endian error comparing authusers when cifsacl enabled

 fs/cifs/Kconfig        |   20 --
 fs/cifs/README         |    3 +
 fs/cifs/cache.c        |    6 +-
 fs/cifs/cifs_debug.c   |   26 +-
 fs/cifs/cifs_dfs_ref.c |    2 +-
 fs/cifs/cifs_fs_sb.h   |    3 +-
 fs/cifs/cifs_spnego.c  |    2 +-
 fs/cifs/cifs_spnego.h  |    2 +-
 fs/cifs/cifsacl.c      |    9 +-
 fs/cifs/cifsencrypt.c  |   14 +-
 fs/cifs/cifsfs.c       |  233 ++++++++++++++----
 fs/cifs/cifsglob.h     |  129 +++++++++-
 fs/cifs/cifsproto.h    |  209 +++++++++-------
 fs/cifs/cifssmb.c      |  463 ++++++++++++++++++++++++++++--------
 fs/cifs/connect.c      |  625 +++++++++++++++++++++++++++---------------------
 fs/cifs/dir.c          |   33 ++--
 fs/cifs/file.c         |  376 +++++++++++++++--------------
 fs/cifs/fscache.c      |    6 +-
 fs/cifs/fscache.h      |    8 +-
 fs/cifs/inode.c        |   92 ++++----
 fs/cifs/ioctl.c        |    2 +-
 fs/cifs/link.c         |   46 +++--
 fs/cifs/misc.c         |   32 ++--
 fs/cifs/netmisc.c      |    2 +-
 fs/cifs/readdir.c      |    8 +-
 fs/cifs/sess.c         |   42 ++--
 fs/cifs/transport.c    |  214 +++++-----------
 fs/cifs/xattr.c        |    8 +-
 28 files changed, 1571 insertions(+), 1044 deletions(-)

-- 
Thanks,

Steve
