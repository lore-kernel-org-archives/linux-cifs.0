From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 31 Jan 2014 23:19:45 -0600
Message-ID: <CAH2r5mtf4EZX+L4BV+=1Mu=EzE_5zAFpoDZ7WTE0oFx2NP=+7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A set of cifs fixes (mostly for symlinks, and SMB2 xattrs) and cleanups.

The following changes since commit d8ec26d7f8287f5788a494f56e8814210f0e64be:

  Linux 3.13 (2014-01-19 18:40:07 -0800)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to a9a315d41407cd1079eb815f4adae897cc08b0d2:

  cifs: Fix check for regular file in couldbe_mf_symlink() (2014-01-31
09:06:43 -0600)

----------------------------------------------------------------
Christian Engelmayer (1):
      cifs: Fix memory leak in cifs_hardlink()

Pavel Shilovsky (4):
      CIFS: Cleanup CIFSSMBOpen
      CIFS: Cleanup cifs_mknod
      CIFS: Remove extra indentation in cifs_sfu_type
      CIFS: Cleanup cifs open codepath

Sachin Prabhu (8):
      cifs: Rename and cleanup open_query_close_cifs_symlink()
      cifs: Rename MF symlink function names
      cifs: use protocol specific call for query_mf_symlink()
      cifs: Add create MFSymlinks to protocol ops struct
      cifs: Re-order M-F Symlink code
      cifs: move unix extension call to cifs_query_symlink()
      cifs: Add support for follow_link on dfs shares under posix extensions
      cifs: Fix check for regular file in couldbe_mf_symlink()

Steve French (1):
      [CIFS] Fix SMB2 mounts so they don't try to set or get xattrs via cifs

 fs/cifs/cifsacl.c   |  40 +++++--
 fs/cifs/cifsglob.h  |  14 ++-
 fs/cifs/cifsproto.h |  22 ++--
 fs/cifs/cifssmb.c   | 158 ++++++++++++++-----------
 fs/cifs/dir.c       |  59 +++++-----
 fs/cifs/file.c      |   2 +-
 fs/cifs/inode.c     | 178 ++++++++++++++++-------------
 fs/cifs/link.c      | 323 +++++++++++++++++++++++++---------------------------
 fs/cifs/readdir.c   |   2 +-
 fs/cifs/smb1ops.c   | 126 ++++++++++++++------
 fs/cifs/xattr.c     |  49 ++++----
 11 files changed, 553 insertions(+), 420 deletions(-)

-- 
Thanks,

Steve
