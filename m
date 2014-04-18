From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 18 Apr 2014 17:42:51 -0500
Message-ID: <CAH2r5muY4DkuCCJgn+s_xgvmoMJr_xrvpY9u1eCbJqXYjbWXZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A set of 5 small cifs fixes

The following changes since commit 0f689a33ad17845363acdc6d52783befd6ad116c:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux (2014-04-16
11:28:25 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 1f80c0cc39e587edd06a36b43ba3a3b09d4ac428:

  cif: fix dead code (2014-04-16 23:08:57 -0500)

----------------------------------------------------------------
Cyril Roelandt (1):
      fs: cifs: remove unused variable.

Jeff Layton (1):
      cifs: fix error handling cifs_user_readv

Michael Opdenacker (1):
      cif: fix dead code

Sachin Prabhu (1):
      cifs: Wait for writebacks to complete before attempting write.

Steve French (1):
      Return correct error on query of xattr on file with empty xattrs

 fs/cifs/cifsfs.c    | 14 +++++++++-
 fs/cifs/cifsglob.h  |  8 ++++++
 fs/cifs/cifsproto.h |  3 +++
 fs/cifs/cifssmb.c   |  3 +++
 fs/cifs/file.c      | 35 +++++++++++++++++++++----
 fs/cifs/misc.c      | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/cifs/smb1ops.c   | 11 ++++++++
 fs/cifs/smb2misc.c  | 18 ++++++++++---
 fs/cifs/smb2ops.c   | 14 ++++++++++
 fs/cifs/smb2pdu.c   |  2 --
 10 files changed, 169 insertions(+), 13 deletions(-)

-- 
Thanks,

Steve
