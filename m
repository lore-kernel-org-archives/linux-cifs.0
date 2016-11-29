From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Tue, 29 Nov 2016 13:22:28 -0600
Message-ID: <CAH2r5mucpAw+-YM=M1fzUqxtGpv6niEiy_1G6MhAj5in0RaHYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A few misc important cifs fixes, including a fix for a 4.9 regression
in posix_acl xattr handling

Please pull the following changes since commit
88abd8249ee8bcebb98c90e890ea5e342db832af:

  Merge branch 'for-4.9-fixes' of
git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata (2016-11-28
14:17:10 -0800)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to ae9ebe7c4ee0c16c3d55d1ae3096c82e0a7c136f:

  CIFS: iterate over posix acl xattr entry correctly in
ACL_to_cifs_posix() (2016-11-28 23:08:53 -0600)

----------------------------------------------------------------
Eryu Guan (1):
      CIFS: iterate over posix acl xattr entry correctly in ACL_to_cifs_posix()

Sachin Prabhu (2):
      CIFS: Fix BUG() in calc_seckey()
      Call echo service immediately after socket reconnect

 fs/cifs/cifsencrypt.c | 11 ++++++++---
 fs/cifs/cifssmb.c     |  4 ++--
 fs/cifs/connect.c     | 25 ++++++++++++++++++-------
 3 files changed, 28 insertions(+), 12 deletions(-)

-- 
Thanks,

Steve
