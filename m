From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fix
Date: Thu, 16 Sep 2010 12:33:49 -0500
Message-ID: <AANLkTino4o4ErGF8-cjrUODUykiqxhbtJ6maKv-aLCfY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit bfa88ea7ee9e6b4fd673e45a8cc0a8e0b7ef4761:

  Merge branch 'sched/urgent' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
(2010-09-13 14:34:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (1):
      cifs: fix potential double put of TCP session reference

 fs/cifs/connect.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


-- 
Thanks,

Steve
