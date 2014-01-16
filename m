From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 0/4] Cleanup open codepath
Date: Thu, 16 Jan 2014 15:53:32 +0400
Message-ID: <1389873217-17519-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset includes various cleanups that touch open codepath. This will help to introduce share modes into cifs module easier.

Patches are rebased on top of Sachin's patchset "Clean up MF-Symlink code and add readlink support for DFS shares".

Pavel Shilovsky (4):
  CIFS: Cleanup CIFSSMBOpen
  CIFS: Cleanup cifs_mknod
  CIFS: Remove extra indentation in cifs_sfu_type
  CIFS: Cleanup cifs open codepath

 fs/cifs/cifsacl.c   |   40 +++++++++----
 fs/cifs/cifsproto.h |    7 +--
 fs/cifs/cifssmb.c   |  158 +++++++++++++++++++++++++++---------------------
 fs/cifs/dir.c       |   59 +++++++++---------
 fs/cifs/file.c      |    2 +-
 fs/cifs/inode.c     |  166 +++++++++++++++++++++++++++++----------------------
 fs/cifs/link.c      |   44 +++++++++-----
 fs/cifs/smb1ops.c   |   71 +++++++++++++---------
 8 files changed, 317 insertions(+), 230 deletions(-)

-- 
1.7.10.4
