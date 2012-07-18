From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 07/45] CIFS: Protect i_nlink from being negative
Date: Wed, 18 Jul 2012 19:48:23 +0400
Message-ID: <1342626541-29872-8-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

that can cause warning messages.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/inode.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 7354877..88afb1a 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1110,6 +1110,15 @@ undo_setattr:
 	goto out_close;
 }
 
+/* copied from fs/nfs/dir.c with small changes */
+static void
+cifs_drop_nlink(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	if (inode->i_nlink > 0)
+		drop_nlink(inode);
+	spin_unlock(&inode->i_lock);
+}
 
 /*
  * If dentry->d_inode is null (usually meaning the cached dentry
@@ -1166,13 +1175,13 @@ retry_std_delete:
 psx_del_no_retry:
 	if (!rc) {
 		if (inode)
-			drop_nlink(inode);
+			cifs_drop_nlink(inode);
 	} else if (rc == -ENOENT) {
 		d_drop(dentry);
 	} else if (rc == -ETXTBSY) {
 		rc = cifs_rename_pending_delete(full_path, dentry, xid);
 		if (rc == 0)
-			drop_nlink(inode);
+			cifs_drop_nlink(inode);
 	} else if ((rc == -EACCES) && (dosattr == 0) && inode) {
 		attrs = kzalloc(sizeof(*attrs), GFP_KERNEL);
 		if (attrs == NULL) {
-- 
1.7.1
