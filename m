From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 4 Oct 2013 21:50:24 -0500
Message-ID: <CAH2r5mv1Uw1P8Lz6_v3VxJgH56iXrp03tPAmd6YsP083rkBwxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Small set of cifs fixes.   Most important is Jeff's fix that works
around disconnection problems which can be caused by simultaneous use
of user space tools (starting a long running smbclient backup then
doing a cifs kernel mount) or multiple cifs mounts through a NAT, and
Jim's fix to deal with reexport of cifs share.

I expect to send two more cifs fixes next week (being tested now) -
fixes to address an SMB2 unmount hang when server dies and a fix for
cifs symlink handling of Windows "NFS" symlinks.

The following changes since commit 62d228b8c676232eca579f91cc0782b060a59097:

  Merge branch 'fixes' of git://git.kernel.org/pub/scm/virt/kvm/kvm
(2013-09-17 22:20:30 -0400)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to ffe67b58595eda992f369de7ac4d0a9b165074fd:

  [CIFS] update cifs.ko version (2013-09-25 19:01:27 -0500)

----------------------------------------------------------------
David Howells (1):
      CIFS: FS-Cache: Uncache unread pages in cifs_readpages() before
freeing them

Jeff Layton (1):
      cifs: stop trying to use virtual circuits

Jim McDonough (1):
      [CIFS] Provide sane values for nlink

Steve French (2):
      [CIFS] Remove ext2 flags that have been moved to fs.h
      [CIFS] update cifs.ko version

 fs/cifs/cifsfs.h   |  2 +-
 fs/cifs/cifsglob.h |  5 +---
 fs/cifs/cifspdu.h  | 21 +-------------
 fs/cifs/cifssmb.c  |  1 -
 fs/cifs/file.c     |  8 ++++++
 fs/cifs/fscache.c  |  7 +++++
 fs/cifs/fscache.h  | 13 +++++++++
 fs/cifs/inode.c    | 45 +++++++++++++++++++++++++----
 fs/cifs/readdir.c  |  3 ++
 fs/cifs/sess.c     | 84 +-----------------------------------------------------
 10 files changed, 74 insertions(+), 115 deletions(-)

-- 
Thanks,

Steve
