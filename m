From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] CIFS Fixes
Date: Thu, 2 Apr 2015 22:32:12 -0500
Message-ID: <CAH2r5msrTxz=co472T2K+46-ounHDy1QTSTt_qZHrz+CjBXXYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A set of small cifs fixes fixing a memory leak, kernel oops, and
infinite loop (and some spotted by Coverity)

The following changes since commit 90a5a895cc8b284ac522757a01de15e36710c2b9:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
(2015-03-23 10:16:13 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 4c5930e8056127e9a89bb7836bfa34318a89ab14:

  Fix warning (2015-04-01 00:01:47 -0500)

----------------------------------------------------------------
David Disseldorp (1):
      cifs: fix use-after-free bug in find_writable_file

Sachin Prabhu (1):
      cifs: smb2_clone_range() - exit on unhandled error

Steve French (8):
      Fix warning on uninitialized buftype
      Don't ignore errors on encrypting password in SMBTcon
      Fix dereference before null check warning
      Fix coverity warning
      Fix warning on impossible comparison
      CIFS: session servername can't be null
      Fix another dereference before null check warning
      Fix warning

Taesoo Kim (1):
      cifs: potential memory leaks when parsing mnt opts

 fs/cifs/cifsencrypt.c |  6 +++++-
 fs/cifs/connect.c     | 13 +++++++++++--
 fs/cifs/file.c        |  1 +
 fs/cifs/inode.c       |  2 ++
 fs/cifs/smb2misc.c    |  2 +-
 fs/cifs/smb2ops.c     |  3 ++-
 fs/cifs/smb2pdu.c     | 17 ++++++++++-------
 7 files changed, 32 insertions(+), 12 deletions(-)

-- 
Thanks,

Steve
