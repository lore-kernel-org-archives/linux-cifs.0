From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Thu, 21 Mar 2013 17:41:17 -0500
Message-ID: <CAH2r5msOBKtD1QSoToLNbR0Uvf=z2f41+BRcxqm3fd8f1EE5jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

3 small CIFS Fixes (the most important of the three fixes a recent
problem authenticating
to Windows 8 using cifs rather than SMB2)

The following changes since commit 6c23cbbd5056b155401b0a2b5567d530e6c750c4:
  Randy Dunlap (1):
        futex: fix kernel-doc notation and spello

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

Jeff Layton (1):
      cifs: ignore everything in SPNEGO blob after mechTypes

Mateusz Guzik (1):
      cifs: delay super block destruction until all cifsFileInfo
objects are gone

Sachin Prabhu (1):
      cifs: map NT_STATUS_SHARING_VIOLATION to EBUSY instead of ETXTBSY

 fs/cifs/asn1.c    |   53 +++++------------------------------------------------
 fs/cifs/cifsfs.c  |   24 ++++++++++++++++++++++++
 fs/cifs/cifsfs.h  |    4 ++++
 fs/cifs/file.c    |    6 +++++-
 fs/cifs/inode.c   |   10 ++++------
 fs/cifs/netmisc.c |    2 +-
 6 files changed, 43 insertions(+), 56 deletions(-)

-- 
Thanks,

Steve
