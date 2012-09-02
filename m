From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [GIT] CIFS Fixes
Date: Sun, 2 Sep 2012 08:05:25 -0500
Message-ID: <CAH2r5mu2b+VMYLMaqjYxwDy5UD0Y=R-Naa+aqn1Ocu1hAmBr-g@mail.gmail.com>
References: <CAH2r5mu3nbn8rmvPnL+y_orKcYzixQX0BFMHDB1Ku4NoDvbuzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mu3nbn8rmvPnL+y_orKcYzixQX0BFMHDB1Ku4NoDvbuzA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---------- Forwarded message ----------
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Sun, Sep 2, 2012 at 8:05 AM
Subject: [GIT] CIFS Fixes
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>


The following changes since commit 6dab7ede9390d4d937cb89feca932e4fd575d2da:

  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm
(2012-08-18 16:20:05 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to ea7b4887e7266b93fa0c203cc452a926a0fef4f0:

  CIFS: Fix cifs_do_create error hadnling (2012-08-19 22:30:18 -0500)

----------------------------------------------------------------
Pavel Shilovsky (2):
      CIFS: Fix log messages in packet checking for SMB2
      CIFS: Fix cifs_do_create error hadnling

Steve French (2):
      CIFS: Protect i_nlink from being negative
      cifs: print error code if smb signature verification fails

 fs/cifs/cifssmb.c   | 11 ++++++++---
 fs/cifs/dir.c       |  9 +--------
 fs/cifs/inode.c     | 24 ++++++++++++++++--------
 fs/cifs/link.c      |  2 ++
 fs/cifs/smb2misc.c  | 16 +++++++++-------
 fs/cifs/smb2pdu.h   | 10 ++++++----
 fs/cifs/transport.c |  9 ++++++---
 7 files changed, 48 insertions(+), 33 deletions(-)

--
Thanks,

Steve


-- 
Thanks,

Steve
