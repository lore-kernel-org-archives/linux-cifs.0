From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Use invalidate_inode_pages2 instead of invalidate_remote_inode
Date: Tue, 22 Feb 2011 18:09:06 +0300
Message-ID: <1298387346-9228-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We should invalidate a page even if it is locked now by someone, because
we can leave an invalid data there and then think it's uptodate according
to an oplock level (exclusive or II).

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/inode.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 8852470..1da1f26 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1691,12 +1691,15 @@ cifs_invalidate_mapping(struct inode *inode)
 
 	cifs_i->invalid_mapping = false;
 
-	/* write back any cached data */
-	if (inode->i_mapping && inode->i_mapping->nrpages != 0) {
-		rc = filemap_write_and_wait(inode->i_mapping);
-		mapping_set_error(inode->i_mapping, rc);
+	if (inode->i_mapping) {
+		/* write back any cached data */
+		if (inode->i_mapping->nrpages != 0) {
+			rc = filemap_write_and_wait(inode->i_mapping);
+			mapping_set_error(inode->i_mapping, rc);
+		}
+		invalidate_inode_pages2(inode->i_mapping);
 	}
-	invalidate_remote_inode(inode);
+
 	cifs_fscache_reset_inode_cookie(inode);
 }
 
-- 
1.7.1
