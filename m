From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Sun, 11 Aug 2013 22:54:44 -0500
Message-ID: <CAH2r5mshu_A4vfqUU145=0d8C3YzY3oRg-FVdYr4yL7pnB6fgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A set of small cifs fixes, including 3 relating to symlink handling

The following changes since commit ecb2cf1a6b63825a258ff4fe0d7f3070fbe4676b:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
(2013-07-18 20:08:47 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 757c4f6260febff982276818bb946df89c1105aa:

  cifs: don't instantiate new dentries in readdir for inodes that need
to be revalidated immediately (2013-08-07 10:57:06 -0500)

----------------------------------------------------------------
Andi Shyti (1):
      cifs: file: initialize oparms.reconnect before using it

Chen Gang (1):
      cifs: extend the buffer length enought for sprintf() using

Jeff Layton (3):
      cifs: fix bad error handling in crypto code
      cifs: set sb->s_d_op before calling d_make_root()
      cifs: don't instantiate new dentries in readdir for inodes that
need to be revalidated immediately

Steve French (1):
      Do not attempt to do cifs operations reading symlinks with SMB2

 fs/cifs/cifsencrypt.c   | 14 ++++++---
 fs/cifs/cifsfs.c        | 11 +++----
 fs/cifs/cifsglob.h      |  4 +++
 fs/cifs/cifsproto.h     |  4 ++-
 fs/cifs/connect.c       |  7 +++--
 fs/cifs/file.c          |  1 +
 fs/cifs/link.c          | 84 +++++++++++++++++++++++++++++++------------------
 fs/cifs/readdir.c       |  8 +++++
 fs/cifs/sess.c          |  6 ++--
 fs/cifs/smb1ops.c       |  1 +
 fs/cifs/smb2transport.c |  9 ++++--
 11 files changed, 98 insertions(+), 51 deletions(-)

-- 
Thanks,

Steve
