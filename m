From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fix
Date: Wed, 9 May 2012 08:12:22 -0500
Message-ID: <CAH2r5muJzvc0xtOuUsLuKLFBSLDK_wQTusG0F3NJzVC0U2qUeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 5c503f8c0f7550ffe76e388172f898d8d11a336e:
  Steve French (1):
        Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git master

Dan Carpenter (1):
      cifs: fix revalidation test in cifs_llseek()

 fs/cifs/cifsfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


-- 
Thanks,

Steve
