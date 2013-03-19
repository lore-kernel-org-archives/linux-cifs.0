From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3] cifs: map NT_STATUS_SHARING_VIOLATION to EBUSY instead of ETXTBSY
Date: Tue, 19 Mar 2013 12:51:04 +0000
Message-ID: <1363697464-7564-1-git-send-email-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

NT_SHARING_VIOLATION errors are mapped to ETXTBSY which is unexpected
for operations such as unlink where we can hit these errors.

The patch maps the error NT_SHARING_VIOLATION to EBUSY instead. The
patch also replaces all instances of ETXTBSY in
cifs_rename_pending_delete() with EBUSY.

The patch was a result of a user reporting a ETXTBSY error on performing
an unlink operation caused by the server returning a
NT_SHARING_VIOLATION.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/inode.c   | 10 ++++------
 fs/cifs/netmisc.c |  2 +-
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index fee2d40..b97ca5b 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1034,7 +1034,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 				   cifs_sb->mnt_cifs_flags &
 					    CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc != 0) {
-		rc = -ETXTBSY;
+		rc = -EBUSY;
 		goto undo_setattr;
 	}
 
@@ -1053,7 +1053,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 		if (rc == -ENOENT)
 			rc = 0;
 		else if (rc != 0) {
-			rc = -ETXTBSY;
+			rc = -EBUSY;
 			goto undo_rename;
 		}
 		cifsInode->delete_pending = true;
@@ -1160,15 +1160,13 @@ psx_del_no_retry:
 			cifs_drop_nlink(inode);
 	} else if (rc == -ENOENT) {
 		d_drop(dentry);
-	} else if (rc == -ETXTBSY) {
+	} else if (rc == -EBUSY) {
 		if (server->ops->rename_pending_delete) {
 			rc = server->ops->rename_pending_delete(full_path,
 								dentry, xid);
 			if (rc == 0)
 				cifs_drop_nlink(inode);
 		}
-		if (rc == -ETXTBSY)
-			rc = -EBUSY;
 	} else if ((rc == -EACCES) && (dosattr == 0) && inode) {
 		attrs = kzalloc(sizeof(*attrs), GFP_KERNEL);
 		if (attrs == NULL) {
@@ -1509,7 +1507,7 @@ cifs_do_rename(const unsigned int xid, struct dentry *from_dentry,
 	 * source. Note that cross directory moves do not work with
 	 * rename by filehandle to various Windows servers.
 	 */
-	if (rc == 0 || rc != -ETXTBSY)
+	if (rc == 0 || rc != -EBUSY)
 		goto do_rename_exit;
 
 	/* open-file renames don't work across directories */
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index a82bc51..c0b25b2 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -62,7 +62,7 @@ static const struct smb_to_posix_error mapping_table_ERRDOS[] = {
 	{ERRdiffdevice, -EXDEV},
 	{ERRnofiles, -ENOENT},
 	{ERRwriteprot, -EROFS},
-	{ERRbadshare, -ETXTBSY},
+	{ERRbadshare, -EBUSY},
 	{ERRlock, -EACCES},
 	{ERRunsup, -EINVAL},
 	{ERRnosuchshare, -ENXIO},
-- 
1.7.11.7
