From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Tue, 6 Mar 2012 18:38:33 -0600
Message-ID: <CAH2r5ms=Ga99D2EuApfLoxtNDLfQ45TJMwnk23XcRrHDC0M9ig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 203738e548cefc3fc3c2f73a9063176c9f3583d5:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git master

Jeff Layton (1):
      cifs: fix dentry refcount leak when opening a FIFO on lookup

Pavel Shilovsky (1):
      CIFS: Fix mkdir/rmdir bug for the non-POSIX case

 fs/cifs/dir.c   |   20 ++++++++++++++++++--
 fs/cifs/inode.c |   28 +++++++++++++++++++---------
 2 files changed, 37 insertions(+), 11 deletions(-)


-- 
Thanks,

Steve
