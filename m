From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 7/8 v2] cifs: move unix extension call to cifs_query_symlink()
Date: Wed, 27 Nov 2013 13:27:12 +0000
Message-ID: <1385558832-7954-1-git-send-email-sprabhu@redhat.com>
References: <1385399395-19217-1-git-send-email-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385399395-19217-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Unix extensions rigth now are only applicable to smb1 operations.
Move the check and subsequent unix extension call to the smb1
specific call to query_symlink() ie. cifs_query_symlink().

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/link.c    |  5 +----
 fs/cifs/smb1ops.c | 20 ++++++++++++++------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index ee5ae46..67d9243 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -516,10 +516,7 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
 		rc = query_mf_symlink(xid, tcon, cifs_sb, full_path,
 				      &target_path);
 
-	if ((rc != 0) && cap_unix(tcon->ses))
-		rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, &target_path,
-					     cifs_sb->local_nls);
-	else if (rc != 0 && server->ops->query_symlink)
+	if (rc != 0 && server->ops->query_symlink)
 		rc = server->ops->query_symlink(xid, tcon, full_path,
 						&target_path, cifs_sb);
 
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 1470ec4..988fddb7 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -918,23 +918,31 @@ cifs_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 
 	cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
 
+	/* Check for unix extensions */
+	if (cap_unix(tcon->ses)) {
+		rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, target_path,
+					     cifs_sb->local_nls);
+		goto out;
+	}
+
 	rc = CIFSSMBOpen(xid, tcon, full_path, FILE_OPEN,
 			 FILE_READ_ATTRIBUTES, OPEN_REPARSE_POINT, &netfid,
 			 &oplock, NULL, cifs_sb->local_nls,
 			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc)
-		return rc;
+		goto out;
 
 	rc = CIFSSMBQuerySymLink(xid, tcon, netfid, target_path,
 				 cifs_sb->local_nls);
-	if (rc) {
-		CIFSSMBClose(xid, tcon, netfid);
-		return rc;
-	}
+	if (rc)
+		goto out_close;
 
 	convert_delimiter(*target_path, '/');
+out_close:
 	CIFSSMBClose(xid, tcon, netfid);
-	cifs_dbg(FYI, "%s: target path: %s\n", __func__, *target_path);
+out:
+	if (!rc)
+		cifs_dbg(FYI, "%s: target path: %s\n", __func__, *target_path);
 	return rc;
 }
 
-- 
1.8.3.1
