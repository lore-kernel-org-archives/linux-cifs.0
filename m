From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 4/5] CIFS: Fix lock consistensy bug in cifs_setlk
Date: Tue, 27 Nov 2012 10:50:27 +0400
Message-ID: <1353999029-3975-5-git-send-email-piastry@etersoft.ru>
References: <1353999029-3975-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353999029-3975-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If we netogiate mandatory locking style, have a read lock and try
to set a write lock we end up with a write lock in vfs cache and
no lock in cifs lock cache - that's wrong. Fix it by returning
from cifs_setlk immediately if a error occurs during setting a lock.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a18c9eb..f8fe1bd 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1449,16 +1449,18 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
 			return -ENOMEM;
 
 		rc = cifs_lock_add_if(cfile, lock, wait_flag);
-		if (rc < 0)
+		if (rc < 0) {
 			kfree(lock);
-		if (rc <= 0)
+			return rc;
+		}
+		if (!rc)
 			goto out;
 
 		rc = server->ops->mand_lock(xid, cfile, flock->fl_start, length,
 					    type, 1, 0, wait_flag);
 		if (rc) {
 			kfree(lock);
-			goto out;
+			return rc;
 		}
 
 		cifs_lock_add(cfile, lock);
-- 
1.7.10.4
