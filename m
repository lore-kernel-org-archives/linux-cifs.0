From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 20 May 2011 12:41:33 -0500
Message-ID: <BANLkTin1aphq5JHJkTOVjgSAaPWWYBuYYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sent the following request up, but plan to send another big set of
changes up with Jeff's aync set (would like help reviewing patches 3,
5 and 6 in particular of Jeff's set) and some of Pavel's SMB2 prep
patches in a few days.

The following changes since commit 61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf:

  Linux 2.6.39 (2011-05-18 21:06:34 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (5):
      VFS: trivial: fix comment on s_maxbytes value warning check
      cifs: fix comment in validate_t2
      cifs: fix some unused variable warnings in id_rb_search
      cifs: keep BCC in little-endian format
      cifs: turn BCC into a static inlined function

Justin P. Mattock (1):
      fs:cifs:connect.c remove one to many l's in the word.

Pavel Shilovsky (4):
      CIFS: Use invalidate_inode_pages2 instead of
invalidate_remote_inode (try #4)
      CIFS: Add launder_page operation (try #3)
      CIFS: directio read/write cleanups
      CIFS: Simplify invalidate part (try #5)

Sean Finney (6):
      cifs: Extract DFS referral expansion logic to separate function
      cifs: Add support for mounting Windows 2008 DFS shares
      cifs: cifs_parse_mount_options: do not tokenize mount options in-place
      cifs: Simplify handling of submount options in cifs_mount.
      cifs: Use kstrndup for cifs_sb->mountdata
      cifs: Unconditionally copy mount options to superblock info

Shirish Pargaonkar (5):
      cifs: Remove unused inode number while fetching root inode
      cifs: cleanup: Rename and remove config flags
      cifs: Add idmap key and related data structures and functions
(try #17 repost)
      cifs: Invoke id mapping functions (try #17 repost)
      cifs: Change key name to cifs.idmap, misc. clean-up

Steve French (11):
      Remove unused CIFSSMBNotify worker function
      Don't compile in unused reparse point symlink code
      Shrink stack space usage in cifs_construct_tcon
      Introduce SMB2 Kconfig option
      [CIFS] Use ecb des kernel crypto APIs instead of      local cifs
functions (repost)
      [CIFS] Allow to set extended attribute cifs_acl (try #2)
      Introduce smb2 mounts as vers=2
      consistently use smb_buf_length as be32 for cifs (try 3)
      [CIFS] Update cifs to version 1.72
      [CIFS] Remove sparse warning
      [CIFS] Fix to problem with getattr caused by invalidate
simplification patch

 fs/cifs/Kconfig        |   35 +++-
 fs/cifs/Makefile       |    2 +-
 fs/cifs/README         |   12 --
 fs/cifs/cifs_debug.c   |    2 +-
 fs/cifs/cifs_fs_sb.h   |    4 +-
 fs/cifs/cifs_unicode.h |    3 +
 fs/cifs/cifsacl.c      |  483 +++++++++++++++++++++++++++++++++++++++++-------
 fs/cifs/cifsacl.h      |   25 +++-
 fs/cifs/cifsencrypt.c  |   12 +-
 fs/cifs/cifsfs.c       |  119 +++++++-----
 fs/cifs/cifsfs.h       |   20 +-
 fs/cifs/cifsglob.h     |   10 +-
 fs/cifs/cifspdu.h      |   37 +---
 fs/cifs/cifsproto.h    |   30 ++--
 fs/cifs/cifssmb.c      |  377 +++++++++++++++++++++-----------------
 fs/cifs/connect.c      |  279 +++++++++++++++++++---------
 fs/cifs/export.c       |    4 +-
 fs/cifs/file.c         |  167 ++++++-----------
 fs/cifs/inode.c        |  129 +++++++++-----
 fs/cifs/misc.c         |   12 +-
 fs/cifs/netmisc.c      |    7 -
 fs/cifs/sess.c         |    9 +-
 fs/cifs/smbdes.c       |  418 -----------------------------------------
 fs/cifs/smbencrypt.c   |  124 ++++++++++---
 fs/cifs/transport.c    |   66 +++-----
 fs/cifs/xattr.c        |   20 ++
 fs/super.c             |    3 +-
 27 files changed, 1289 insertions(+), 1120 deletions(-)
 delete mode 100644 fs/cifs/smbdes.c

-- 
Thanks,

Steve
