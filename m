From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fix
Date: Fri, 7 Jun 2013 15:14:33 -0500
Message-ID: <CAH2r5muw-8mpY68trpPuMjm8+CRwJ5vmt80fTTUsZOTxwXsiKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fix one byte buffer overrun with prefixpaths on cifs mounts which can
cause a problem with mount depending on the string length.

The following changes since commit a93cb29acaa8f75618c3f202d1cf43c231984644:

  Merge branch 'drm-fixes' of
git://people.freedesktop.org/~airlied/linux (2013-05-31 16:04:05
+1000)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-3.10

Jeff Layton (1):
      cifs: fix off-by-one bug in build_unc_path_to_root

 fs/cifs/connect.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

-- 
Thanks,

Steve
