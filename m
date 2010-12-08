From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Wed, 8 Dec 2010 12:50:44 -0600
Message-ID: <AANLkTinBKtmopHGFsYQcbBz4VAanULv_K2JFUXSnB10Z@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 59e57c622c3502346e8f930421ebc482d639520c:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid (2010-12-02
17:40:04 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
..BRANCH.NOT.VERIFIED..

Jeff Layton (4):
      cifs: fix use of CONFIG_CIFS_ACL
      cifs: remove Local_System_Name
      cifs: fix check of error return from is_path_accessable
      cifs: allow calling cifs_build_path_to_root on incomplete cifs_sb

Steve French (1):
      Merge branch 'master' of /.../torvalds/linux-2.6

Suresh Jayaraman (2):
      cifs: add attribute cache timeout (actimeo) tunable
      cifs: remove bogus remapping of error in cifs_filldir()

 fs/cifs/Makefile     |    4 +-
 fs/cifs/README       |    9 +++
 fs/cifs/cifs_fs_sb.h |    1 +
 fs/cifs/cifsacl.c    |    3 -
 fs/cifs/cifsacl.h    |    4 -
 fs/cifs/cifsfs.c     |    3 +-
 fs/cifs/cifsglob.h   |   12 +++-
 fs/cifs/cifsproto.h  |    5 +-
 fs/cifs/cifssmb.c    |  183 +++++++++++++++++++++++++-------------------------
 fs/cifs/connect.c    |   42 ++++++++----
 fs/cifs/file.c       |    2 -
 fs/cifs/inode.c      |   21 +++---
 fs/cifs/readdir.c    |   12 ---
 13 files changed, 157 insertions(+), 144 deletions(-)


-- 
Thanks,

Steve
