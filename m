From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] CIFS: Fix error handling in cifs_push_mandatory_locks
Date: Wed, 29 Aug 2012 21:19:41 +0400
Message-ID: <1346260781-3307-1-git-send-email-pshilovsky@etersoft.ru>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e8e3d91..46717be 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -941,7 +941,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	if (!buf) {
 		mutex_unlock(&cinode->lock_mutex);
 		free_xid(xid);
-		return rc;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < 2; i++) {
-- 
1.7.1
