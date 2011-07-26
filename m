From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Tue, 26 Jul 2011 10:11:03 -0500
Message-ID: <CAH2r5ms9FtVn9ctwdSVA-Vxm37=e_KN-p=fPm0xgVsKKjVzZ5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:

  Linux 3.0 (2011-07-21 19:17:23 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Christoph Hellwig (4):
      cifs: cleanup cifs_filldir
      cifs: introduce cifs_dirent
      cifs: use cifs_dirent to replace cifs_get_name_from_search_buf
      cifs: use cifs_dirent in cifs_save_resume_key

Pavel Shilovsky (1):
      CIFS: Fix oops while mounting with prefixpath

Shirish Pargaonkar (1):
      cifs: Cleanup: check return codes of crypto api calls

Steve French (1):
      [CIFS] Redundant null check after dereference

 fs/cifs/cifsencrypt.c |  110 ++++++++++---
 fs/cifs/cifsglob.h    |    2 +-
 fs/cifs/dir.c         |    7 +-
 fs/cifs/link.c        |    8 +-
 fs/cifs/readdir.c     |  427 +++++++++++++++++++++----------------------------
 fs/cifs/smbencrypt.c  |    8 +-
 6 files changed, 287 insertions(+), 275 deletions(-)


-- 
Thanks,

Steve
