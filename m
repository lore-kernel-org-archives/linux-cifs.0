From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 1 Aug 2011 09:54:51 -0500
Message-ID: <CAH2r5mt6abR=zssjd7jS0u+ojA=Yk8Vj4==iejQzKCiw8wgXjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 24c3047095fa3954f114bfff2e37b8fcbb216396:

  Merge branch 'nfs-for-3.1' of
git://git.linux-nfs.org/projects/trondmy/linux-nfs (2011-07-31
06:26:50 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (7):
      cifs: advertise the right receive buffer size to the server
      cifs: trivial: goto out here is unnecessary
      cifs: don't start signing too early
      cifs: fix name parsing in CIFSSMBQAllEAs
      cifs: fix compiler warning in CIFSSMBQAllEAs
      cifs: simplify refcounting for oplock breaks
      cifs: remove unneeded variable initialization in cifs_reconnect_tcon

Pavel Shilovsky (5):
      CIFS: Move buffer allocation to a separate function
      CIFS: Simplify socket reading in demultiplex thread
      CIFS: Move RFC1002 check to a separate function
      CIFS: Move mid search to a separate function
      CIFS: Cleanup demupltiplex thread exiting code

 fs/cifs/cifsencrypt.c |   16 +-
 fs/cifs/cifsfs.c      |   18 --
 fs/cifs/cifsfs.h      |    4 -
 fs/cifs/cifsglob.h    |    2 -
 fs/cifs/cifssmb.c     |    6 +-
 fs/cifs/connect.c     |  659 ++++++++++++++++++++++++++-----------------------
 fs/cifs/file.c        |   27 +--
 fs/cifs/misc.c        |   11 +-
 fs/cifs/sess.c        |    3 +-
 9 files changed, 370 insertions(+), 376 deletions(-)


-- 
Thanks,

Steve
