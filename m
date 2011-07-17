From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Sun, 17 Jul 2011 12:07:28 -0500
Message-ID: <CAH2r5muaSQZKGiNe+3w9-gf9gR=DPpdCWnRANZSZkM8JU8JHVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 620917de59eeb934b9f8cf35cc2d95c1ac8ed0fc:

  Linux 3.0-rc7 (2011-07-11 16:51:52 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Shirish Pargaonkar (1):
      cifs: Fix signing failure when server mandates signing for NTLMSSP

Steve French (2):
      [CIFS] update limit for snprintf in cifs_construct_tcon
      [CIFS] update cifs to version 1.74

 fs/cifs/cifsfs.h  |    2 +-
 fs/cifs/connect.c |    2 +-
 fs/cifs/sess.c    |   10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)


-- 
Thanks,

Steve
