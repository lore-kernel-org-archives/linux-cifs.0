From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 5 Nov 2010 13:59:17 -0500
Message-ID: <AANLkTinmeqdheKAFSytELyQcCAyyxLPS3DCayL2Y7ORa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit e99d11d19977c74b18411cdb59cdebb788237a6e:

  fs: logfs: Fix up MTD=y build. (2010-11-01 16:34:56 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

J. Bruce Fields (1):
      cifs: trivial doc fix: note setlease implemented

Jeff Layton (3):
      cifs: store pointer to master tlink in superblock (try #2)
      cifs: convert tlink_tree to a rbtree
      cifs: dereferencing first then checking

Jiri Slaby (1):
      FS: cifs, remove unneeded NULL tests

Pavel Shilovsky (2):
      CIFS: Add cifs_set_oplock_level
      cifs: make cifs_set_oplock_level() take a cifsInodeInfo pointer

Steve French (2):
      Merge branch 'master' of /.../torvalds/linux-2.6
      [CIFS] Cleanup unused variable build warning

Suresh Jayaraman (1):
      cifs: trivial comment fix: tlink_tree is now a rbtree

 fs/cifs/TODO         |    2 +-
 fs/cifs/cifs_fs_sb.h |    6 +-
 fs/cifs/cifsfs.c     |    5 +-
 fs/cifs/cifsglob.h   |    3 +-
 fs/cifs/cifsproto.h  |    1 +
 fs/cifs/connect.c    |  195 +++++++++++++++++++++++++------------------------
 fs/cifs/file.c       |   72 ++++++-------------
 fs/cifs/ioctl.c      |    4 -
 fs/cifs/misc.c       |   25 ++++++-
 9 files changed, 152 insertions(+), 161 deletions(-)


--
Thanks,

Steve
