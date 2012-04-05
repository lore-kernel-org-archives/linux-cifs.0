From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Wed, 4 Apr 2012 20:13:15 -0500
Message-ID: <CAH2r5mtGRU-ueg=rS36HCX5Wd7ZVoLRQdQ9mpiRhAnZsdBFatg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit fa2a4519cb6ad94224eb56a1341fff570fd44ea1:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/sparc

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git master

Dan Carpenter (1):
      cifs: writing past end of struct in cifs_convert_address()

Jeff Layton (1):
      cifs: silence compiler warnings showing up with gcc-4.7.0

Pavel Shilovsky (2):
      CIFS: Fix VFS lock usage for oplocked files
      CIFS: Fix VFS lock usage for oplocked files

Sachin Prabhu (2):
      Remove unnecessary check for NULL in password parser
      Fix UNC parsing on mount

Steve French (1):
      Revert "CIFS: Fix VFS lock usage for oplocked files"

 fs/cifs/cifssmb.c  |   24 ++++++++++++------------
 fs/cifs/connect.c  |   17 ++++++++---------
 fs/cifs/file.c     |   10 +++++++++-
 fs/cifs/netmisc.c  |    3 +--
 fs/locks.c         |    3 ++-
 include/linux/fs.h |    5 +++++
 6 files changed, 37 insertions(+), 25 deletions(-)

-- 
Thanks,

Steve
