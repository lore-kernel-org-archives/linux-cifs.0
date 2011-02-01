From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 31 Jan 2011 20:43:05 -0600
Message-ID: <AANLkTik1a6rNm8OseakKoesCUNqLR+5jr1qwujSkAbaS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 70d1f365568e0cdbc9f4ab92428e1830fdb09ab0:

  Merge branch 'for-linus' of git://git.infradead.org/ubi-2.6
(2011-01-31 13:04:51 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (9):
      cifs: fix two compiler warning about uninitialized vars
      cifs: handle cancelled requests better
      cifs: send an NT_CANCEL request when a process is signalled
      cifs: simplify SMB header check routine
      cifs: don't pop a printk when sending on a socket is interrupted
      cifs: force a reconnect if there are too many MIDs in flight
      cifs: make CIFS depend on CRYPTO_MD4
      cifs: clean up some compiler warnings
      cifs: fix length checks in checkSMB

Shirish Pargaonkar (1):
      cifs: No need to check crypto blockcipher allocation

Steve French (2):
      Merge branch 'master' of /.../torvalds/linux-2.6
      [CIFS] Update cifs minor version

 fs/cifs/Kconfig        |    1 +
 fs/cifs/cifs_dfs_ref.c |    9 ++--
 fs/cifs/cifsencrypt.c  |    5 +-
 fs/cifs/cifsfs.h       |    2 +-
 fs/cifs/cifssmb.c      |    3 -
 fs/cifs/file.c         |    8 +---
 fs/cifs/link.c         |    3 +-
 fs/cifs/misc.c         |  116 +++++++++++++++++++++++++++---------------------
 fs/cifs/readdir.c      |    3 -
 fs/cifs/smbencrypt.c   |    3 +-
 fs/cifs/transport.c    |   62 +++++++++++++++++++++-----
 11 files changed, 130 insertions(+), 85 deletions(-)


-- 
Thanks,

Steve
