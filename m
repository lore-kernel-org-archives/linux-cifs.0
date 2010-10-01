From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 1 Oct 2010 16:11:44 -0500
Message-ID: <AANLkTint=vBmDyrH_bGSexFnbUE0QJguEQJMhveriFQu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 899611ee7d373e5eeda08e9a8632684e1ebbbf00:

  Linux 2.6.36-rc6 (2010-09-28 18:01:22 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (2):
      cifs: set backing_dev_info on new S_ISREG inodes
      cifs: prevent infinite recursion in cifs_reconnect_tcon

 fs/cifs/cifssmb.c |   49 +++++++++++++++++++++++++++++++++----------------
 fs/cifs/inode.c   |    2 ++
 2 files changed, 35 insertions(+), 16 deletions(-)


-- 
Thanks,

Steve
