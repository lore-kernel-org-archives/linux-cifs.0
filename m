From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 27 Apr 2012 17:38:07 -0500
Message-ID: <CAH2r5mtB70PEfxB7-hRigJ0mdqvTtGahmpOX56-R+0CsOjZk8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit c6f5c93098f5577210f8f3ea22209b3f266c66af:
  Linus Torvalds (1):
        Merge branch 'for-3.4' of git://linux-nfs.org/~bfields/linux

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git master

Jeff Layton (1):
      cifs: fix offset handling in cifs_iovec_write

Sachin Prabhu (2):
      CIFS: Show backupuid/gid in /proc/mounts
      Use correct conversion specifiers in cifs_show_options

 fs/cifs/cifsfs.c  |   12 ++++++++----
 fs/cifs/connect.c |   12 ++++++------
 fs/cifs/file.c    |    3 ++-
 3 files changed, 16 insertions(+), 11 deletions(-)


-- 
Thanks,

Steve
