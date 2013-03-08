From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 8 Mar 2013 14:14:09 -0600
Message-ID: <CAH2r5mtSkS6LkjU9Lbzfa-U3VdmSmwphLafSwhhMVDeYib-vVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A small set of cifs fixes which includes one for a recent regression
in the write path (pointed out by Anton), some fixes for rename
problems and as promised for 3.9 removing the obsolete sockopt mount
option (and the accompanying deprecation warning).

The following changes since commit 9f225788cc047fb7c2ef2326eb4f86dee890e2ef:

  Merge branch 'merge' of
git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2013-03-05
18:56:22 -0800)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

Jeff Layton (2):
      cifs: remove the sockopt= mount option
      cifs: don't try to unlock pagecache page after releasing it

Pavel Shilovsky (1):
      CIFS: Fix missing of oplock_read value in smb30_values structure

Sachin Prabhu (2):
      cifs: Fix bug when checking error condition in
cifs_rename_pending_delete()
      cifs: Check server capability before attempting silly rename

 fs/cifs/cifssmb.c |    2 +-
 fs/cifs/connect.c |   16 +---------------
 fs/cifs/inode.c   |   11 ++++++++++-
 fs/cifs/smb2ops.c |    1 +
 4 files changed, 13 insertions(+), 17 deletions(-)

-- 
Thanks,

Steve
