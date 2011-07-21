From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fix
Date: Thu, 21 Jul 2011 16:21:27 -0500
Message-ID: <CAH2r5mv9VqnAwwHT+G55T6Ht_V0eQn_12SNOs=_2Yc9crrOuSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit cf6ace16a3cd8b728fb0afa68368fd40bbeae19f:

  Merge branch 'core-urgent-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
(2011-07-20 15:56:25 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
..BRANCH.NOT.VERIFIED..

Pavel Shilovsky (1):
      CIFS: Fix wrong length in cifs_iovec_read

 fs/cifs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Thanks,

Steve
