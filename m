From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] SMB3 Fixes
Date: Mon, 1 May 2017 15:20:26 -0500
Message-ID: <CAH2r5mt5KBpG5AJ65v6oGWvP+pM9GAnwOi3PawpJ-Z3+ZdgyCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Three cifs/smb3 fixes - including two for stable

Please pull the following changes since commit
19ac4474203863a8141663d73d5976fe25464bfd:

  Merge tag 'ceph-for-4.11-rc9' of git://github.com/ceph/ceph-client
(2017-04-27 11:38:05 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to a6f74e80f271b19ea709cbda55e8eb67e9ffccf2:

  cifs: don't check for failure from mempool_alloc() (2017-04-28 07:56:33 -0500)

----------------------------------------------------------------
NeilBrown (1):
      cifs: don't check for failure from mempool_alloc()

Sachin Prabhu (2):
      Fix match_prepath()
      Do not return number of bytes written for ioctl CIFS_IOC_COPYCHUNK_FILE

 fs/cifs/connect.c       | 14 ++++++--------
 fs/cifs/ioctl.c         |  3 ++-
 fs/cifs/misc.c          | 14 +++++---------
 fs/cifs/smb2transport.c | 30 +++++++++++++-----------------
 fs/cifs/transport.c     | 32 ++++++++++++++------------------
 5 files changed, 40 insertions(+), 53 deletions(-)

-- 
Thanks,

Steve
