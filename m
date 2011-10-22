From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Fix DFS handling in cifs_get_file_info
Date: Sat, 22 Oct 2011 14:19:17 +0400
Message-ID: <1319278757-17008-1-git-send-email-piastry@etersoft.ru>
Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We should call cifs_all_info_to_fattr in rc == 0 case only.

Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/inode.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 663c4e3..b84c346 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -562,7 +562,12 @@ int cifs_get_file_info(struct file *filp)
 
 	xid = GetXid();
 	rc = CIFSSMBQFileInfo(xid, tcon, cfile->netfid, &find_data);
-	if (rc == -EOPNOTSUPP || rc == -EINVAL) {
+	if (!rc)
+		cifs_all_info_to_fattr(&fattr, &find_data, cifs_sb, false);
+	else if (rc == -EREMOTE) {
+		cifs_create_dfs_fattr(&fattr, inode->i_sb);
+		rc = 0;
+	} else if (rc == -EOPNOTSUPP || rc == -EINVAL) {
 		/*
 		 * FIXME: legacy server -- fall back to path-based call?
 		 * for now, just skip revalidating and mark inode for
@@ -571,9 +576,6 @@ int cifs_get_file_info(struct file *filp)
 		rc = 0;
 		CIFS_I(inode)->time = 0;
 		goto cgfi_exit;
-	} else if (rc == -EREMOTE) {
-		cifs_create_dfs_fattr(&fattr, inode->i_sb);
-		rc = 0;
 	} else if (rc)
 		goto cgfi_exit;
 
@@ -581,7 +583,6 @@ int cifs_get_file_info(struct file *filp)
 	 * don't bother with SFU junk here -- just mark inode as needing
 	 * revalidation.
 	 */
-	cifs_all_info_to_fattr(&fattr, &find_data, cifs_sb, false);
 	fattr.cf_uniqueid = CIFS_I(inode)->uniqueid;
 	fattr.cf_flags |= CIFS_FATTR_NEED_REVAL;
 	cifs_fattr_to_inode(inode, &fattr);
-- 
1.7.1
