From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 0/5] relock file capability and locking fixes
Date: Tue, 27 Nov 2012 10:50:23 +0400
Message-ID: <1353999029-3975-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset is targeted to implement cifs_relock_file as well as to fix some bugs in a lock/oplock codepath. This is suitable for v3.8.

Pavel Shilovsky (5):
  CIFS: Separate pushing posix locks and lock_sem handling
  CIFS: Separate pushing mandatory locks and lock_sem handling
  CIFS: Implement cifs_relock_file
  CIFS: Fix lock consistensy bug in cifs_setlk
  CIFS: Fix write after setting a read lock for read oplock files

 fs/cifs/file.c     |   87 ++++++++++++++++++++++++++++------------------------
 fs/cifs/smb2file.c |   12 --------
 2 files changed, 47 insertions(+), 52 deletions(-)

-- 
1.7.10.4
