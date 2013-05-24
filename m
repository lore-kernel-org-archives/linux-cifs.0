From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fix
Date: Fri, 24 May 2013 11:41:24 -0500
Message-ID: <CAH2r5msaDUJZhYs-Vjth54O45+TuKE2fytCHAsvEU611Vv56hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

One cifs fix to merge now - fixes possible DFS oops (I expect to
request a merge of 4 additional cifs fixes next week).

The following changes since commit ebb37277796269da36a8bc5d72ed1e8e1fb7d34b:

  Merge branch 'for-3.10/drivers' of git://git.kernel.dk/linux-block
(2013-05-08 11:51:05 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

Jeff Layton (1):
      cifs: only set ops for inodes in I_NEW state

 fs/cifs/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

-- 
Thanks,

Steve
