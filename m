From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS/SMB3 Fixes
Date: Thu, 28 Jul 2016 20:43:18 -0500
Message-ID: <CAH2r5mvN1Yrj7hHtdHYsV6gHZ5V1XgAjsjbohLUju+2Qs7wV7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Various CIFS/SMB3 fixes, most for stable

Please pull the following changes since commit
92d21ac74a9e3c09b0b01c764e530657e4c85c49:

  Linux 4.7-rc7 (2016-07-10 20:24:59 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 7893242e2465aea6f2cbc2639da8fa5ce96e8cc2:

  CIFS: Fix a possible invalid memory access in smb2_query_symlink()
(2016-07-27 22:55:56 -0500)

----------------------------------------------------------------
Aurelien Aptel (1):
      fs/cifs: make share unaccessible at root level mountable

Pavel Shilovsky (1):
      CIFS: Fix a possible invalid memory access in smb2_query_symlink()

Rabin Vincent (2):
      cifs: unbreak TCP session reuse
      cifs: fix crash due to race in hmac(md5) handling

Sachin Prabhu (2):
      Add MF-Symlinks support for SMB 2.0
      cifs: Check for existing directory when opening file with O_CREAT

 fs/cifs/cifs_fs_sb.h  |  4 ++++
 fs/cifs/cifsencrypt.c | 16 ++++++++++------
 fs/cifs/cifsfs.c      | 14 +++++++++++++-
 fs/cifs/connect.c     | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/dir.c         | 44 +++++++++++++++++++++++++++++++++++++-----
 fs/cifs/inode.c       | 22 +++++++++++++++++++--
 fs/cifs/smb2ops.c     | 32 ++++++++++++++++++++++++++++++-
 7 files changed, 169 insertions(+), 16 deletions(-)

-- 
Thanks,

Steve
