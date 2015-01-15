From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Complete oplock break jobs before closing file handle
Date: Thu, 15 Jan 2015 12:22:04 +0000
Message-ID: <1421324524-2524-1-git-send-email-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Commit
c11f1df5003d534fd067f0168bfad7befffb3b5c
requires writers to wait for any pending oplock break handler to
complete before proceeding to write. This is done by waiting on bit
CIFS_INODE_PENDING_OPLOCK_BREAK in cifsFileInfo->flags. This bit is
cleared by the oplock break handler job queued on the workqueue once it
has completed handling the oplock break allowing writers to proceed with
writing to the file.

While testing, it was noticed that the filehandle could be closed while
there is a pending oplock break which results in the oplock break
handler on the cifsiod workqueue being cancelled before it has had a
chance to execute and clear the CIFS_INODE_PENDING_OPLOCK_BREAK bit.
Any subsequent attempt to write to this file hangs waiting for the
CIFS_INODE_PENDING_OPLOCK_BREAK bit to be cleared.

We fix this by ensuring that we also clear the bit
CIFS_INODE_PENDING_OPLOCK_BREAK when we remove the oplock break handler
from the workqueue.

The bug was found by Red Hat QA while testing using ltp's fsstress
command.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 96b7e9b..74f1287 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -366,6 +366,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	struct cifsLockInfo *li, *tmp;
 	struct cifs_fid fid;
 	struct cifs_pending_open open;
+	bool oplock_break_cancelled;
 
 	spin_lock(&cifs_file_list_lock);
 	if (--cifs_file->count > 0) {
@@ -397,7 +398,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	}
 	spin_unlock(&cifs_file_list_lock);
 
-	cancel_work_sync(&cifs_file->oplock_break);
+	oplock_break_cancelled = cancel_work_sync(&cifs_file->oplock_break);
 
 	if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
 		struct TCP_Server_Info *server = tcon->ses->server;
@@ -409,6 +410,9 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 		_free_xid(xid);
 	}
 
+	if (oplock_break_cancelled)
+		cifs_done_oplock_break(cifsi);
+
 	cifs_del_pending_open(&open);
 
 	/*
-- 
2.1.0
