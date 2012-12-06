From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Fix possible data coherency problem after oplock break to None
Date: Thu,  6 Dec 2012 22:07:53 +0400
Message-ID: <1354817274-7701-2-git-send-email-piastry@etersoft.ru>
References: <1354817274-7701-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354817274-7701-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

by using cifs_invalidate_mapping rather than invalidate_remote_inode
in cifs_oplock_break - this invalidates all inode pages and resets
fscache cookies.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 84860f1..8fb3df2 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3592,7 +3592,7 @@ void cifs_oplock_break(struct work_struct *work)
 		if (cinode->clientCanCacheRead == 0) {
 			rc = filemap_fdatawait(inode->i_mapping);
 			mapping_set_error(inode->i_mapping, rc);
-			invalidate_remote_inode(inode);
+			cifs_invalidate_mapping(inode);
 		}
 		cFYI(1, "Oplock flush inode %p rc %d", inode, rc);
 	}
-- 
1.7.10.4
