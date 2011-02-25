From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Use invalidate_inode_pages2 instead of invalidate_remote_inode (try #2)
Date: Fri, 25 Feb 2011 13:21:50 +0300
Message-ID: <1298629310-4618-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Use invalidate_inode_pages2 that don't leave pages even if shrink_page_list()
has a temp ref on them. It prevents a data coherency problem on exclusive
oplocks opens.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/inode.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 589f3e3..0011e95 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1687,12 +1687,18 @@ cifs_invalidate_mapping(struct inode *inode)
 
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
+		rc = invalidate_inode_pages2(inode->i_mapping);
+		if (rc)
+			cERROR(1, "%s: could not invalidate inode %p", __func__,
+			       inode);
 	}
-	invalidate_remote_inode(inode);
+
 	cifs_fscache_reset_inode_cookie(inode);
 }
 
-- 
1.7.1
