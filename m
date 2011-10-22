From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [v2 PATCH 0/4] Implement byte-range lock caching
Date: Sat, 22 Oct 2011 15:33:28 +0400
Message-ID: <1319283212-19024-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is the rest of byte-range lock cache patchset that includes several fixes in patches #1 and #3.

The patchset is going to simplify brlocking code and add caching support for exclusive oplock cases. I splitted it into several independent parts - so, each can be applied separately once it's reviewed.

Any comments and testing are welcome!

Pavel Shilovsky (4):
  CIFS: Implement caching mechanism for mandatory brlocks
  CIFS: Implement caching mechanism for posix brlocks
  CIFS: Send as many mandatory unlock ranges at once as possible
  CIFS: Make cifs_push_locks send as many locks at once as possible

 fs/cifs/cifsglob.h  |    2 +
 fs/cifs/cifsproto.h |    7 +-
 fs/cifs/cifssmb.c   |   48 +++++-
 fs/cifs/file.c      |  533 ++++++++++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 538 insertions(+), 52 deletions(-)
