From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Wed, 27 May 2015 15:18:26 -0500
Message-ID: <CAH2r5ms2eiCTVpuO7h3Qb9Ww9j0vs0pdRY7Rf-GAdK72SMpMQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Back from SambaXP - now have 8 small CIFS bug fixes to merge.
Please pull the following changes since commit
030bbdbf4c833bc69f502eae58498bc5572db736:

  Linux 4.1-rc3 (2015-05-10 15:12:29 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 4afe260bab50290a05e5732570329a530ed023f3:

  CIFS: Fix race condition on RFC1002_NEGATIVE_SESSION_RESPONSE
(2015-05-20 13:25:55 -0500)

----------------------------------------------------------------
Chengyu Song (1):
      cifs: potential missing check for posix_lock_file_wait

Dan Carpenter (1):
      CIFS: remove an unneeded NULL check

Federico Sauter (1):
      CIFS: Fix race condition on RFC1002_NEGATIVE_SESSION_RESPONSE

Nakajima Akira (3):
      Fix that several functions handle incorrect value of mapchars
      Fix to check Unique id and FileType when client refer file directly.
      Fix to convert SURROGATE PAIR

Sachin Prabhu (1):
      cifs: Don't replace dentries for dfs mounts

Steve French (1):
      [cifs] fix null pointer check

 fs/cifs/cifs_dfs_ref.c |   3 +-
 fs/cifs/cifs_unicode.c | 182 ++++++++++++++++++++++++++++++++++++-------------
 fs/cifs/cifsfs.c       |   2 +
 fs/cifs/cifsproto.h    |   4 +-
 fs/cifs/cifssmb.c      |  23 ++++---
 fs/cifs/connect.c      |   3 +-
 fs/cifs/dir.c          |   3 +-
 fs/cifs/file.c         |   7 +-
 fs/cifs/inode.c        |  31 +++++++--
 fs/cifs/link.c         |   3 +-
 fs/cifs/readdir.c      |   2 +
 fs/cifs/smb1ops.c      |   3 +-
 fs/cifs/smb2pdu.c      |   2 +-
 13 files changed, 194 insertions(+), 74 deletions(-)

-- 
Thanks,

Steve
