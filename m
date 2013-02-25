From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Sun, 24 Feb 2013 22:00:47 -0600
Message-ID: <CAH2r5mspiwgRfpR+9k0_Y=iPkbEhn1QiHrfkhu6yRsER3YyvXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

4 small, miscellaneous cifs fixes

The following changes since commit 8b31849a113a8868eb2de692be5c9ecadae93ac9:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending
(2013-02-02 13:37:56 +1100)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

Jeff Layton (1):
      cifs: ensure that cifs_get_root() only traverses directories

Martijn de Gouw (1):
      cifs: set MAY_SIGN when sec=krb5

Steve French (2):
      cifs: bugfix for unreclaimed writeback pages in cifs_writev_requeue()
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
