From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] CIFS: Invalidate inode pages on the last close
Date: Tue,  2 Nov 2010 22:44:18 +0300
Message-ID: <1288727061-18759-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On strict cache mode when we close the last file handle of the inode we
should invalidate itt o prevent data coherency problem when we open it
again but it has been modified by other clients.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h |    1 +
 fs/cifs/file.c       |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index e9a393c..be7b159 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -40,6 +40,7 @@
 #define CIFS_MOUNT_FSCACHE	0x8000 /* local caching enabled */
 #define CIFS_MOUNT_MF_SYMLINKS	0x10000 /* Minshall+French Symlinks enabled */
 #define CIFS_MOUNT_MULTIUSER	0x20000 /* multiuser mount */
+#define CIFS_MOUNT_STRICT_IO	0x40000 /* strict cache mode */
 
 struct cifs_sb_info {
 	struct rb_root tlink_tree;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 71185d1..81ec50e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -264,7 +264,9 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	struct inode *inode = cifs_file->dentry->d_inode;
 	struct cifsTconInfo *tcon = tlink_tcon(cifs_file->tlink);
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsLockInfo *li, *tmp;
+	bool last_open_file = false;
 
 	spin_lock(&cifs_file_list_lock);
 	if (--cifs_file->count > 0) {
@@ -279,10 +281,14 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	if (list_empty(&cifsi->openFileList)) {
 		cFYI(1, "closing last open instance for inode %p",
 			cifs_file->dentry->d_inode);
+		last_open_file = true;
 		cifs_set_oplock_level(inode, 0);
 	}
 	spin_unlock(&cifs_file_list_lock);
 
+	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) && last_open_file)
+		invalidate_remote_inode(inode);
+
 	if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
 		int xid, rc;
 
-- 
1.7.2.3
