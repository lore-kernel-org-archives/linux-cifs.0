From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [v2 0/4] Introduce shared superblock model to cifs
Date: Thu,  5 May 2011 14:00:32 +0400
Message-ID: <1304589632-1209-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the second version of the set. It should be applied on top of current for-next branch + 6 DFS related patches from Sean Finney.

Pavel Shilovsky (4):
  CIFS: Simplify connection structure search calls
  CIFS: Simplify mount code for further shared sb capability
  CIFS: Migrate from prefixpath logic
  CIFS: Migrate to shared superblock model

 fs/cifs/cifs_fs_sb.h |    2 -
 fs/cifs/cifsfs.c     |  205 ++++++++++++++++++++++----
 fs/cifs/cifsglob.h   |   81 ++++++++++
 fs/cifs/cifsproto.h  |   13 ++-
 fs/cifs/connect.c    |  398 +++++++++++++++++++++++++-------------------------
 fs/cifs/dir.c        |    7 +-
 fs/cifs/inode.c      |   19 +--
 7 files changed, 472 insertions(+), 253 deletions(-)
