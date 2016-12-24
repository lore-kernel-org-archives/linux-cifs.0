From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Sat, 24 Dec 2016 10:53:20 -0600
Message-ID: <CAH2r5mvhe=P7okz2O6i962HjbVMdR+0XRjKCw6OsNqeVzrgDHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following changes since commit
43c4f67c966deb1478dc9acbf66ab547287d530f:

  Merge branch 'akpm' (patches from Andrew) (2016-11-30 16:33:41 -0800)

Includes various cifs/smb3  bug fixes, mostly for stable as well.  In
the next week I expect that Germano will have some reconnection fixes,
and also I expect to have the remaining pieces of the snapshot
enablement and SMB3 ACLs, but wanted to get this set of bug fixes in.


They are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 374402a2a1dfbbee8ab1a5a32ec4887bf8c15d52:

  cifs_get_root shouldn't use path with tree name (2016-12-15 01:42:54 -0600)

----------------------------------------------------------------
Andy Lutomirski (1):
      cifs: Fix smbencrypt() to stop pointing a scatterlist at the stack

Germano Percossi (1):
      Fix default behaviour for empty domains and add domainauto option

Pavel Shilovsky (5):
      CIFS: Decrease verbosity of ioctl call
      CIFS: Fix missing nls unload in smb2_reconnect()
      CIFS: Fix a possible memory corruption in push locks
      CIFS: Fix a possible memory corruption during reconnect
      CIFS: Fix a possible double locking of mutex during reconnect

Rasmus Villemoes (1):
      cifs: use %16phN for formatting md5 sum

Sachin Prabhu (1):
      cifs_get_root shouldn't use path with tree name

Steve French (1):
      SMB3: parsing for new snapshot timestamp mount parm

 fs/cifs/cifsencrypt.c | 14 ++++++---
 fs/cifs/cifsfs.c      |  2 +-
 fs/cifs/cifsglob.h    |  8 +++++
 fs/cifs/cifsproto.h   |  6 +++-
 fs/cifs/connect.c     | 82 +++++++++++++++++++++++++++++++++++++++++-------
 fs/cifs/dir.c         |  4 +--
 fs/cifs/file.c        |  8 ++++-

-- 
Thanks,

Steve
