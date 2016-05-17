From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: [git pull] vfs.git#sendmsg.cifs
Date: Wed, 18 May 2016 00:34:13 +0100
Message-ID: <20160517233413.GN14480@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs iovec cleanups.  The first one is an infrastructure patch that had been
pulled into davem's tree (as of commit 6c61403daea578dcfe84f187c204db1a3fa3d6ae
Merge: 743b03a 2da6290
Author: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Date:   Thu Apr 14 00:39:15 2016 -0400

    Merge branch 'for-davem' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
), the rest are cifs-specific.  One trivial conflict with PAGE_CACHE_SIZE ->
PAGE_SIZE conversion (in fs/cifs/file.c; resolved by taking my version and
replacing all PAGE_CACHE_SIZE with PAGE_SIZE in the result; note that one
instance is just prior to the lines git considers a conflict).

The following changes since commit f55532a0c0b8bb6148f4e07853b876ef73bc69ca:

  Linux 4.6-rc1 (2016-03-26 16:03:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git sendmsg.cifs

for you to fetch changes up to 71335664c38f03de10d7cf1d82705fe55a130b33:

  cifs: don't bother with kmap on read_pages side (2016-03-28 14:05:52 -0400)

----------------------------------------------------------------
Al Viro (6):
      [net] drop 'size' argument of sock_recvmsg()
      cifs: merge the hash calculation helpers
      cifs: quit playing games with draining iovecs
      cifs: no need to wank with copying and advancing iovec on recvmsg side either
      cifs_readv_receive: use cifs_read_from_socket()
      cifs: don't bother with kmap on read_pages side

 drivers/target/iscsi/iscsi_target_util.c |   5 +-
 fs/cifs/cifsencrypt.c                    |  97 +++++++++++----------
 fs/cifs/cifsglob.h                       |   2 -
 fs/cifs/cifsproto.h                      |  12 +--
 fs/cifs/cifssmb.c                        |  11 +--
 fs/cifs/connect.c                        | 127 ++++++++--------------------
 fs/cifs/file.c                           |  53 ++++--------
 fs/cifs/smb2transport.c                  | 107 +++--------------------
 fs/cifs/transport.c                      | 141 +++++++++----------------------
 include/linux/net.h                      |   3 +-
 net/socket.c                             |  23 +++--
 11 files changed, 180 insertions(+), 401 deletions(-)
