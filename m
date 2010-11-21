From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] CIFS: Make cifsFileInfo_put work with strict cache mode (try #2)
Date: Sun, 21 Nov 2010 22:32:17 +0300
Message-ID: <1290367937-11170-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On strict cache mode when we close the last file handle of the inode we
should set invalid_mapping flag on the inode to prevent data coherency problem
when we open it again but it has been modified by other clients.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/file.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 08bd364..aeda334 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -217,6 +217,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	struct inode *inode = cifs_file->dentry->d_inode;
 	struct cifsTconInfo *tcon = tlink_tcon(cifs_file->tlink);
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsLockInfo *li, *tmp;
 
 	spin_lock(&cifs_file_list_lock);
@@ -232,6 +233,13 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	if (list_empty(&cifsi->openFileList)) {
 		cFYI(1, "closing last open instance for inode %p",
 			cifs_file->dentry->d_inode);
+
+		/* in strict cache mode we need invalidate mapping on the last
+		   close  because it may cause a error when we open this file
+		   again and get at least level II oplock */
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
+			CIFS_I(inode)->invalid_mapping = true;
+
 		cifs_set_oplock_level(cifsi, 0);
 	}
 	spin_unlock(&cifs_file_list_lock);
-- 
1.7.3.2
