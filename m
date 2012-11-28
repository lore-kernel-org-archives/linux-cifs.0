From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 0/6] relock file capability and locking fixes
Date: Wed, 28 Nov 2012 18:23:39 +0400
Message-ID: <1354112625-30315-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is version #2.

Changes since #1:
1) add new "CIFS: Do not permit write to a range mandatory locked with a read lock" patch,
2) fix "CIFS: Fix write after setting a read lock for read oplock files" patch with Jeff suggestions,
3) add reviewed tags for patches that got them.

Original description:
This patchset is targeted to implement cifs_relock_file as well as to fix some bugs in a lock/oplock codepath. This is suitable for v3.8.

Pavel Shilovsky (6):
  CIFS: Separate pushing posix locks and lock_sem handling
  CIFS: Separate pushing mandatory locks and lock_sem handling
  CIFS: Implement cifs_relock_file
  CIFS: Fix lock consistensy bug in cifs_setlk
  CIFS: Do not permit write to a range mandatory locked with a read
    lock
  CIFS: Fix write after setting a read lock for read oplock files

 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/file.c      |  167 +++++++++++++++++++++++++++++----------------------
 fs/cifs/smb2file.c  |   12 ----
 3 files changed, 95 insertions(+), 86 deletions(-)

-- 
1.7.10.4
