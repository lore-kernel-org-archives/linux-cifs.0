From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] Fix data corruption at oplock break handler
Date: Fri,  7 Mar 2014 13:29:18 +0000
Message-ID: <1394198960-7585-1-git-send-email-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fix data corruption at oplock break handler.

To avoid data corruption, we have to avoid changing the oplock
value for a particular file until existing writer threads have quit. For that
reason, we move the set_oplock_value to the oplock_break handler. Since the
values used for the oplock break vary according to the protocol versions, we
need to have protocol specific oplock_break handlers.

I have successfully tested this against a reproducer we have for both SMB1 and
SMB2.

Sachin Prabhu (2):
  Add oplock_break to smb_version_operations
  cifs: Wait for writebacks to complete before attempting write.

 fs/cifs/cifsfs.c    | 14 +++++++++-
 fs/cifs/cifsglob.h  |  9 +++++--
 fs/cifs/cifsproto.h |  5 ++++
 fs/cifs/file.c      | 69 ++++++++++++-------------------------------------
 fs/cifs/misc.c      | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/cifs/smb1ops.c   | 65 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2misc.c  | 18 ++++++++++---
 fs/cifs/smb2ops.c   | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 264 insertions(+), 61 deletions(-)

-- 
1.8.4.2
