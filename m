From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v3 0/5] Prepare byte-range locking code for future SMB2 usage
Date: Tue, 27 Mar 2012 15:38:34 +0400
Message-ID: <1332848319-6483-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the another preparation step before SMB2 protocol support. It separates
protocol specific things from byte-range locking code.

Pavel Shilovsky (5):
  CIFS: Move locks to cifsFileInfo structure
  CIFS: Convert lock type to 32 bit variable
  CIFS: Separate protocol specific lock type handling
  CIFS: Separate protocol specific part from getlk
  CIFS: Separate protocol specific part from setlk

 fs/cifs/cifsfs.c   |    1 -
 fs/cifs/cifsglob.h |    5 +-
 fs/cifs/file.c     |  194 ++++++++++++++++++++++++++++++++++------------------
 3 files changed, 130 insertions(+), 70 deletions(-)
