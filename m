From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 17/17] CIFS: Separate protocol specific part from setlk
Date: Sat,  3 Mar 2012 12:37:18 +0300
Message-ID: <1330767438-19469-18-git-send-email-piastry@etersoft.ru>
References: <1330767438-19469-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330767438-19469-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index bbdb520..0856891 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1430,8 +1430,8 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u32 type,
 		if (rc <= 0)
 			goto out;
 
-		rc = CIFSSMBLock(xid, tcon, netfid, current->tgid, length,
-				 flock->fl_start, 0, 1, type, wait_flag, 0);
+		rc = cifs_mandatory_lock(xid, cfile, flock->fl_start, length,
+					 type, 1, 0, wait_flag);
 		if (rc) {
 			kfree(lock);
 			goto out;
-- 
1.7.1
