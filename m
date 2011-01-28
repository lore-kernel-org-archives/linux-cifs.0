From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 28 Jan 2011 13:36:51 -0600
Message-ID: <AANLkTin2DmYgZsNW94XP8QCBuo_aHeq35DjGss1R8R4P@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit c723fdab8aa728dc2bf0da6a0de8bb9c3f588d84:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
(2011-01-25 14:23:54 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Pavel Shilovsky (2):
      CIFS: Implement cifs_strict_writev (try #4)
      CIFS: Add strictcache mount option

Shirish Pargaonkar (1):
      cifs: More crypto cleanup (try #2)

Steve French (1):
      [CIFS] Replace cifs md5 hashing functions with kernel crypto APIs

 fs/cifs/Makefile      |    2 +-
 fs/cifs/README        |    5 +
 fs/cifs/cifsencrypt.c |   33 +++--
 fs/cifs/cifsencrypt.h |   33 -----
 fs/cifs/cifsfs.c      |   15 ++-
 fs/cifs/cifsfs.h      |    4 +-
 fs/cifs/cifsproto.h   |   11 ++-
 fs/cifs/connect.c     |   11 +-
 fs/cifs/file.c        |  202 +++++++++++++++++++++++++++-
 fs/cifs/link.c        |   58 +++++++--
 fs/cifs/md4.c         |  205 ---------------------------
 fs/cifs/md5.c         |  366 -------------------------------------------------
 fs/cifs/md5.h         |   38 -----
 fs/cifs/smbdes.c      |    1 -
 fs/cifs/smbencrypt.c  |   91 +++++++++----
 15 files changed, 371 insertions(+), 704 deletions(-)
 delete mode 100644 fs/cifs/cifsencrypt.h
 delete mode 100644 fs/cifs/md4.c
 delete mode 100644 fs/cifs/md5.c
 delete mode 100644 fs/cifs/md5.h


-- 
Thanks,

Steve
