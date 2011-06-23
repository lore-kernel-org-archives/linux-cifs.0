From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Thu, 23 Jun 2011 15:21:21 -0500
Message-ID: <BANLkTim=2Gr1_ynOY0A06eqV4n45Znh9dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 2992c4bd5742b31a0ee00a76eee9c1c284507418:

  Merge branch 'bugfixes' of
git://git.linux-nfs.org/projects/trondmy/nfs-2.6 (2011-06-21 18:20:55
-0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (1):
      cifs: fix wsize negotiation to respect max buffer size and
active signing (try #4)

Pavel Shilovsky (1):
      CIFS: Fix problem with 3.0-rc1 null user mount failure

 fs/cifs/connect.c |   39 +++++++++++++++++++++++++--------------
 1 files changed, 25 insertions(+), 14 deletions(-)


-- 
Thanks,

Steve
