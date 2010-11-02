From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/5] CIFS: Invalidate inode pages on the last close
Date: Tue, 2 Nov 2010 12:01:17 +0300
Message-ID: <AANLkTikE-QfKh8AYe=NZtQOKPhJ_LGQ+K5xcGb6wBfbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On strict cache mode when we close the last file handle of the inode we
should invalidate this inode to prevent data coherency problem when we
open it again but it has been modified by other clients.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h |    1 +
 fs/cifs/file.c       |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 525ba59..3690c50 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -40,6 +40,7 @@
 #define CIFS_MOUNT_FSCACHE	0x8000 /* local caching enabled */
 #define CIFS_MOUNT_MF_SYMLINKS	0x10000 /* Minshall+French Symlinks enabled */
 #define CIFS_MOUNT_MULTIUSER	0x20000 /* multiuser mount */
+#define CIFS_MOUNT_STRICT_IO	0x40000 /* strict cache mode */

 struct cifs_sb_info {
 	struct radix_tree_root tlink_tree;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a566f15..3970e68 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -284,6 +284,9 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	}
 	spin_unlock(&cifs_file_list_lock);

+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
+		invalidate_remote_inode(inode);
+
 	if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
 		int xid, rc;

-- 
1.7.2.3
