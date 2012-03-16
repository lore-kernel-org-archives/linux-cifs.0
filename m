From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 0/6] Prepare byte-range locking code for future SMB2 usage
Date: Fri, 16 Mar 2012 18:17:46 +0300
Message-ID: <1331911072-1078-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is one of the preparation step that makes the byte-range locking code more
protocol independent.

Pavel Shilovsky (6):
  CIFS: Move locks to file structure
  CIFS: Fix VFS locks usage
  CIFS: Convert lock type to 32 bit variable
  CIFS: Separate protocol specific lock type handling
  CIFS: Separate protocol specific part from getlk
  CIFS: Separate protocol specific part from setlk

 fs/cifs/cifsfs.c   |    1 -
 fs/cifs/cifsglob.h |    5 +-
 fs/cifs/file.c     |  250 +++++++++++++++++++++++++++++++++++++---------------
 3 files changed, 182 insertions(+), 74 deletions(-)
