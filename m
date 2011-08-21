From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] CIFS: Fix ERR_PTR dereference in cifs_get_root
Date: Sun, 21 Aug 2011 19:30:15 +0400
Message-ID: <1313940615-3347-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

move it to the beginning of the loop.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 0435bb9..8b79122 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -559,6 +559,12 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 		struct inode *dir = dentry->d_inode;
 		struct dentry *child;
 
+		if (!dir) {
+			dput(dentry);
+			dentry = ERR_PTR(-ENOENT);
+			break;
+		}
+
 		/* skip separators */
 		while (*s == sep)
 			s++;
@@ -574,10 +580,6 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 		mutex_unlock(&dir->i_mutex);
 		dput(dentry);
 		dentry = child;
-		if (!dentry->d_inode) {
-			dput(dentry);
-			dentry = ERR_PTR(-ENOENT);
-		}
 	} while (!IS_ERR(dentry));
 	_FreeXid(xid);
 	kfree(full_path);
-- 
1.7.1
