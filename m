From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 0/6] Implement byte-range lock caching
Date: Fri,  7 Oct 2011 17:10:18 +0400
Message-ID: <1317993024-15003-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset is going to simplify brlocking code and add caching support for exclusive oplock cases. I splitted it into several independent parts - so, each can be applied separately once it's reviewed.

Any comments and testing are welcome!

Pavel Shilovsky (6):
  CIFS: Simplify byte range locking code
  CIFS: Move byte range lock list from fd to inode
  CIFS: Implement caching mechanism for mandatory brlocks
  CIFS: Implement caching mechanism for posix brlocks
  CIFS: Send as many mandatory unlock ranges at once as possible
  CIFS: Make cifs_push_locks send as many locks at once as possible

 fs/cifs/cifsfs.c    |    3 +-
 fs/cifs/cifsglob.h  |   10 +-
 fs/cifs/cifsproto.h |    9 +-
 fs/cifs/cifssmb.c   |   52 +++-
 fs/cifs/file.c      |  766 ++++++++++++++++++++++++++++++++++++++++-----------
 5 files changed, 660 insertions(+), 180 deletions(-)
