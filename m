From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 1 Mar 2013 11:16:29 -0600
Message-ID: <CAH2r5muxOAG8q1pcoJi9tPo7zpKkc8=WjS9Zbw=3+bonSyRbbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Four cifs fixes (including for kernel bug #53221 and samba bug #9519)

The following changes since commit 309667e53fcfd8e0b423280b6ea5a648fd92166c:

  Merge branch 'kconfig' of
git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild
(2013-02-27 12:28:30 -0800)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

Jeff Layton (1):
      cifs: ensure that cifs_get_root() only traverses directories

Martijn de Gouw (1):
      cifs: set MAY_SIGN when sec=krb5

Ouyang Maochun (1):
      cifs: bugfix for unreclaimed writeback pages in cifs_writev_requeue()

Steve French (1):
      POSIX extensions disabled on client due to illegal O_EXCL flag
sent to Samba

 fs/cifs/cifsfs.c  |    5 +++++
 fs/cifs/cifssmb.c |    5 ++++-
 fs/cifs/connect.c |    2 +-
 fs/cifs/file.c    |   12 +++++++++---
 4 files changed, 19 insertions(+), 5 deletions(-)

-- 
Thanks,

Steve
